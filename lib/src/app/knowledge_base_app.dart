import 'package:jaspr_content/jaspr_content.dart';
import '../config/site_config.dart';
import '../navigation/nav_builder.dart';
import '../layout/kb_layout.dart';
import '../theme/kb_stylesheet.dart';
import '../scripts/kb_scripts.dart';

/// Configuration for creating a knowledge base application.
///
/// Use this class with Jaspr.initializeApp() to create a documentation site
/// from a directory of markdown files.
class KnowledgeBaseApp {
  /// Create a ContentApp configured for the knowledge base.
  ///
  /// This method builds the navigation manifest from the content directory
  /// and returns a ContentApp ready to be passed to Jaspr.initializeApp().
  static Future<ContentApp> create({
    required SiteConfig config,
    KBStylesheet? stylesheet,
    List<PageExtension>? extensions,
  }) async {
    // Build navigation manifest from content directory
    final NavBuilder navBuilder = NavBuilder(
      contentDirectory: config.contentDirectory,
      baseUrl: config.baseUrl,
    );
    final NavManifest manifest = await navBuilder.build();

    // Create stylesheet
    final KBStylesheet style = stylesheet ?? const KBStylesheet();

    // Create scripts
    final KBScripts scripts = KBScripts(basePath: config.baseUrl);

    // Create layout
    final KBLayout layout = KBLayout(
      config: config,
      manifest: manifest,
      stylesheet: style,
      scripts: scripts,
    );

    // Default extensions for markdown processing
    final List<PageExtension> defaultExtensions = <PageExtension>[
      HeadingAnchorsExtension(),
      const TableOfContentsExtension(),
    ];

    return ContentApp(
      directory: config.contentDirectory,
      parsers: [const MarkdownParser()],
      layouts: [layout],
      extensions: [...defaultExtensions, ...?extensions],
    );
  }

  /// Create a synchronous ContentApp when the manifest is pre-built.
  ///
  /// Use this when you've already built the navigation manifest at build time.
  static ContentApp createSync({
    required SiteConfig config,
    required NavManifest manifest,
    KBStylesheet? stylesheet,
    List<PageExtension>? extensions,
  }) {
    // Create stylesheet
    final KBStylesheet style = stylesheet ?? const KBStylesheet();

    // Create scripts
    final KBScripts scripts = KBScripts(basePath: config.baseUrl);

    // Create layout
    final KBLayout layout = KBLayout(
      config: config,
      manifest: manifest,
      stylesheet: style,
      scripts: scripts,
    );

    // Default extensions for markdown processing
    final List<PageExtension> defaultExtensions = <PageExtension>[
      HeadingAnchorsExtension(),
      const TableOfContentsExtension(),
    ];

    return ContentApp(
      directory: config.contentDirectory,
      parsers: [const MarkdownParser()],
      layouts: [layout],
      extensions: [...defaultExtensions, ...?extensions],
    );
  }
}