/// A package for creating beautiful knowledge base websites from markdown files.
///
/// Arcane Jaspr MD transforms a directory of markdown files into a fully-featured
/// documentation site with auto-generated navigation, search, theming, and more.
///
/// ## Quick Start
///
/// Create a full knowledge base site:
/// ```dart
/// import 'package:arcane_jaspr_md/arcane_jaspr_md.dart' hide runApp;
///
/// void main() async {
///   Jaspr.initializeApp(options: defaultServerOptions);
///   runApp(
///     await KnowledgeBaseApp.create(
///       config: const SiteConfig(
///         name: 'My Docs',
///         contentDirectory: 'content',
///       ),
///     ),
///   );
/// }
/// ```
library arcane_jaspr_md;

// Re-export jaspr and arcane_jaspr for convenience (hide conflicts)
export 'package:jaspr/jaspr.dart';
export 'package:jaspr_content/jaspr_content.dart' hide TableOfContents;
export 'package:arcane_jaspr/arcane_jaspr.dart' hide TableOfContents;

// Configuration
export 'src/config/site_config.dart';

// Navigation
export 'src/navigation/nav_item.dart';
export 'src/navigation/nav_section.dart';
export 'src/navigation/nav_builder.dart';

// Layout components
export 'src/layout/kb_layout.dart';
export 'src/layout/kb_header.dart';
export 'src/layout/kb_sidebar.dart';
export 'src/layout/kb_footer.dart';
export 'src/layout/kb_breadcrumbs.dart';
export 'src/layout/kb_toc.dart';
export 'src/layout/kb_page_nav.dart';

// Theme
export 'src/theme/kb_stylesheet.dart';

// Scripts
export 'src/scripts/kb_scripts.dart';

// Main app
export 'src/app/knowledge_base_app.dart';
