import 'package:arcane_jaspr/arcane_jaspr.dart' hide TableOfContents, ReadingTimeExtension;
import 'package:jaspr_content/jaspr_content.dart';

import '../config/site_config.dart';
import '../navigation/nav_builder.dart';
import '../layout/kb_layout.dart';
import '../scripts/kb_scripts.dart';
import '../extensions/reading_time_extension.dart';
import '../extensions/callout_extension.dart';

export '../layout/kb_layout.dart' show DemoBuilder;

/// Configuration for creating a knowledge base application.
///
/// Use this class with Jaspr.initializeApp() to create a documentation site
/// from a directory of markdown files.
///
/// Example usage with 1-line theming:
/// ```dart
/// import 'package:arcane_inkwell/arcane_inkwell.dart' hide runApp;
///
/// void main() async {
///   Jaspr.initializeApp(options: defaultServerOptions);
///   runApp(
///     await KnowledgeBaseApp.create(
///       config: const SiteConfig(
///         name: 'My Docs',
///         contentDirectory: 'content',
///       ),
///       // Single line theming - swap themes by changing this line:
///       stylesheet: const ShadcnStylesheet(theme: ShadcnTheme.charcoal),
///     ),
///   );
/// }
/// ```
class KnowledgeBaseApp {
  /// Create a ContentApp configured for the knowledge base.
  ///
  /// This method builds the navigation manifest from the content directory
  /// and returns a ContentApp ready to be passed to Jaspr.initializeApp().
  ///
  /// The optional [demoBuilder] callback is called for each page that has a
  /// `component` field in its frontmatter. Return a Component to render as
  /// a live demo above the page content, or null to skip.
  static Future<ContentApp> create({
    required SiteConfig config,
    required ArcaneStylesheet stylesheet,
    List<PageExtension>? extensions,
    DemoBuilder? demoBuilder,
  }) async {
    // Build navigation manifest from content directory
    final NavBuilder navBuilder = NavBuilder(
      contentDirectory: config.contentDirectory,
      baseUrl: config.baseUrl,
    );
    final NavManifest manifest = await navBuilder.build();

    // Create scripts
    final KBScripts scripts = KBScripts(basePath: config.baseUrl);

    // Create layout
    final KBLayout layout = KBLayout(
      config: config,
      manifest: manifest,
      stylesheet: stylesheet,
      scripts: scripts,
      demoBuilder: demoBuilder,
    );

    // Default extensions for markdown processing
    final List<PageExtension> defaultExtensions = <PageExtension>[
      const CalloutExtension(),
      HeadingAnchorsExtension(),
      const TableOfContentsExtension(),
      const ReadingTimeExtension(),
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
    required ArcaneStylesheet stylesheet,
    List<PageExtension>? extensions,
    DemoBuilder? demoBuilder,
  }) {
    // Create scripts
    final KBScripts scripts = KBScripts(basePath: config.baseUrl);

    // Create layout
    final KBLayout layout = KBLayout(
      config: config,
      manifest: manifest,
      stylesheet: stylesheet,
      scripts: scripts,
      demoBuilder: demoBuilder,
    );

    // Default extensions for markdown processing
    final List<PageExtension> defaultExtensions = <PageExtension>[
      const CalloutExtension(),
      HeadingAnchorsExtension(),
      const TableOfContentsExtension(),
      const ReadingTimeExtension(),
    ];

    return ContentApp(
      directory: config.contentDirectory,
      parsers: [const MarkdownParser()],
      layouts: [layout],
      extensions: [...defaultExtensions, ...?extensions],
    );
  }
}
