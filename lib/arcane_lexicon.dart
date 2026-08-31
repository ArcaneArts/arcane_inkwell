/// Creates knowledge base websites from markdown files.
///
/// Arcane Lexicon transforms a directory of markdown files into a fully-featured
/// documentation site with auto-generated navigation, search, theming, and more.
///
/// ## Quick Start
///
/// Create a full knowledge base site with 1-line theming:
/// ```dart
/// import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
/// import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
/// import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
/// import 'package:arcane_lexicon/arcane_lexicon.dart' hide runApp;
///
/// const ArcaneStylesheet shadcnStylesheet = ShadcnStylesheet(
///   theme: ShadcnTheme.charcoal,
/// );
/// const ArcaneStylesheet neonStylesheet = NeonStylesheet(
///   theme: NeonTheme.green,
/// );
/// const ArcaneStylesheet neubrutalismStylesheet = NeubrutalismStylesheet(
///   theme: NeubrutalismTheme.yellow,
/// );
/// const ArcaneStylesheet selectedStylesheet = shadcnStylesheet;
///
/// void main() async {
///   Jaspr.initializeApp();
///   runApp(
///     await KnowledgeBaseApp.create(
///       config: const SiteConfig(
///         name: 'My Docs',
///         contentDirectory: 'content',
///       ),
///       stylesheet: selectedStylesheet,
///     ),
///   );
/// }
/// ```
library;

// Re-export jaspr and arcane_jaspr for convenience (hide conflicts)
export 'package:jaspr/jaspr.dart' hide State, Text;
export 'package:jaspr_content/jaspr_content.dart'
    hide TableOfContents, TocEntry;
export 'package:arcane_jaspr/arcane_jaspr.dart' hide ReadingTimeExtension;

// Configuration
export 'src/config/site_config.dart';

// Navigation
export 'src/navigation/nav_item.dart';
export 'src/navigation/nav_section.dart';
export 'src/navigation/nav_builder.dart';

// Layout components
export 'src/layout/kb_layout.dart';
export 'src/layout/kb_renderers.dart';
export 'src/layout/kb_sidebar.dart';
export 'src/layout/kb_top_bar.dart';
export 'src/layout/kb_page_nav.dart';
export 'src/layout/kb_related_pages.dart';
export 'src/layout/kb_changelog.dart';
export 'src/layout/kb_rating.dart';
export 'src/components/kb_tags.dart';
export 'src/components/rich_markdown_components.dart';

// Scripts
export 'src/scripts/kb_scripts.dart';

// Styles
export 'src/styles/kb_styles.dart';

// Extensions
export 'src/extensions/reading_time_extension.dart';
export 'src/extensions/callout_extension.dart';
export 'src/extensions/media_extension.dart';

// Utils
export 'src/utils/sitemap_generator.dart';
export 'src/utils/search_index_generator.dart';
export 'src/utils/changelog_parser.dart';

// Main app
export 'src/app/knowledge_base_app.dart';
