/// A package for creating beautiful knowledge base websites from markdown files.
///
/// Arcane Inkwell transforms a directory of markdown files into a fully-featured
/// documentation site with auto-generated navigation, search, theming, and more.
///
/// ## Quick Start
///
/// Create a full knowledge base site with 1-line theming:
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
library arcane_inkwell;

// Re-export jaspr and arcane_jaspr for convenience (hide conflicts)
export 'package:jaspr/jaspr.dart';
export 'package:jaspr_content/jaspr_content.dart' hide TableOfContents, TocEntry;
export 'package:arcane_jaspr/arcane_jaspr.dart' hide TableOfContents, ReadingTimeExtension;

// Configuration
export 'src/config/site_config.dart';

// Navigation
export 'src/navigation/nav_item.dart';
export 'src/navigation/nav_section.dart';
export 'src/navigation/nav_builder.dart';

// Layout components
export 'src/layout/kb_layout.dart';
export 'src/layout/kb_sidebar.dart';
export 'src/layout/kb_page_nav.dart';
export 'src/layout/kb_related_pages.dart';
export 'src/layout/kb_changelog.dart';

// Scripts
export 'src/scripts/kb_scripts.dart';

// Extensions
export 'src/extensions/reading_time_extension.dart';
export 'src/extensions/callout_extension.dart';

// Utils
export 'src/utils/sitemap_generator.dart';
export 'src/utils/changelog_parser.dart';

// Main app
export 'src/app/knowledge_base_app.dart';
