import 'package:arcane_jaspr/arcane_jaspr.dart' hide TableOfContents;
import 'package:jaspr_content/jaspr_content.dart';

import '../config/site_config.dart';
import '../navigation/nav_builder.dart';
import '../theme/kb_stylesheet.dart';
import '../scripts/kb_scripts.dart';
import 'kb_header.dart';
import 'kb_sidebar.dart';
import 'kb_footer.dart';
import 'kb_breadcrumbs.dart';
import 'kb_page_nav.dart';
import 'kb_related_pages.dart';

/// The main layout wrapper for knowledge base pages.
class KBLayout extends PageLayoutBase {
  final SiteConfig config;
  final NavManifest manifest;
  final KBStylesheet stylesheet;
  final KBScripts scripts;

  KBLayout({
    required this.config,
    required this.manifest,
    KBStylesheet? stylesheet,
    KBScripts? scripts,
  })  : stylesheet = stylesheet ?? const KBStylesheet(),
        scripts = scripts ?? KBScripts(basePath: config.baseUrl);

  @override
  Pattern get name => 'kb';

  @override
  Iterable<Component> buildHead(Page page) sync* {
    yield* super.buildHead(page);

    final Map<String, dynamic> pageData = page.data.page;
    final String assetPrefix = config.assetPrefix;

    // Title
    final String title = pageData['title'] as String? ?? config.name;
    yield Component.element(
      tag: 'title',
      children: [Component.text('$title - ${config.name}')],
    );

    // Description
    final String? description =
        pageData['description'] as String? ?? config.description;
    if (description != null) {
      yield meta(name: 'description', content: description);
    }

    // Viewport
    yield const meta(
        name: 'viewport', content: 'width=device-width, initial-scale=1');

    // Theme color
    yield const meta(name: 'theme-color', content: '#0a0a0b');

    // Favicon
    yield link(
      rel: 'icon',
      type: 'image/svg+xml',
      href: '$assetPrefix/favicon.svg',
    );

    // Inject stylesheet base CSS (contains all CSS variables and base styles)
    yield Component.element(
      tag: 'style',
      attributes: const {'id': 'arcane-theme-vars'},
      children: [RawText(stylesheet.baseCss)],
    );

    // Load external CSS (Google Fonts, etc.)
    if (stylesheet.externalCssUrls.isNotEmpty) {
      yield const link(rel: 'preconnect', href: 'https://fonts.googleapis.com');
      yield const link(
        rel: 'preconnect',
        href: 'https://fonts.gstatic.com',
        attributes: {'crossorigin': ''},
      );
      for (final String url in stylesheet.externalCssUrls) {
        yield link(rel: 'stylesheet', href: url);
      }
    }

    // Highlight.js for syntax highlighting
    yield const script(
      attributes: {
        'src':
            'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js',
      },
    );
    yield const script(
      attributes: {
        'src':
            'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/languages/dart.min.js',
      },
    );

    // Theme initialization (before body renders)
    yield script(content: scripts.generateThemeInit());
  }

  @override
  Component buildBody(Page page, Component child) {
    final Map<String, dynamic> pageData = page.data.page;
    final TableOfContents? toc = page.data['toc'] as TableOfContents?;

    // Return stateful themed page wrapper
    return ThemedKBPage(
      config: config,
      manifest: manifest,
      stylesheet: stylesheet,
      scripts: scripts,
      currentPath: page.url,
      pageTitle: pageData['title'] as String?,
      pageDescription: pageData['description'] as String?,
      pageAuthor: pageData['author'] as String?,
      readingTime: pageData['readingTime'] as int?,
      pageTags: (pageData['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      isDraft: pageData['draft'] as bool? ?? false,
      toc: toc,
      content: child,
    );
  }
}

/// Stateful themed page wrapper for dynamic theme toggling.
class ThemedKBPage extends StatefulComponent {
  final SiteConfig config;
  final NavManifest manifest;
  final KBStylesheet stylesheet;
  final KBScripts scripts;
  final String currentPath;
  final String? pageTitle;
  final String? pageDescription;
  final String? pageAuthor;
  final int? readingTime;
  final List<String> pageTags;
  final bool isDraft;
  final TableOfContents? toc;
  final Component content;

  const ThemedKBPage({
    required this.config,
    required this.manifest,
    required this.stylesheet,
    required this.scripts,
    required this.currentPath,
    this.pageTitle,
    this.pageDescription,
    this.pageAuthor,
    this.readingTime,
    this.pageTags = const [],
    this.isDraft = false,
    this.toc,
    required this.content,
  });

  @override
  State<ThemedKBPage> createState() => _ThemedKBPageState();
}

class _ThemedKBPageState extends State<ThemedKBPage> {
  bool _isDark = true;

  @override
  void initState() {
    super.initState();
    _isDark = component.config.defaultTheme != KBThemeMode.light;
  }

  void _toggleTheme() {
    setState(() => _isDark = !_isDark);
  }

  @override
  Component build(BuildContext context) {
    final String themeClass = _isDark ? 'dark' : '';

    return ArcaneThemeProvider(
      stylesheet: component.stylesheet,
      brightness: _isDark ? Brightness.dark : Brightness.light,
      child: ArcaneDiv(
        id: 'arcane-root',
        classes: themeClass,
        styles: const ArcaneStyleData(
          minHeight: '100vh',
          background: Background.background,
          textColor: TextColor.primary,
          fontFamily: FontFamily.sans,
        ),
        children: [
          // Header with theme toggle callback
          KBHeader(
            config: component.config,
            isDark: _isDark,
            onThemeToggle: _toggleTheme,
          ),

          // Main layout
          _buildMainLayout(),

          // Footer
          if (component.config.footerText != null ||
              component.config.copyright != null)
            KBFooter(config: component.config),

          // Back to top button
          _buildBackToTop(),

          // Scripts
          script(content: component.scripts.generate()),

          // Component interactivity scripts from arcane_jaspr
          const ArcaneScriptsComponent(),
        ],
      ),
    );
  }

  Component _buildMainLayout() {
    return ArcaneDiv(
      classes: 'kb-layout',
      styles: const ArcaneStyleData(
        display: Display.flex,
        flexGrow: 1,
      ),
      children: [
        // Sidebar
        KBSidebar(
          config: component.config,
          manifest: component.manifest,
          currentPath: component.currentPath,
        ),

        // Main content area
        ArcaneDiv(
          classes: 'kb-main',
          styles: const ArcaneStyleData(
            flexGrow: 1,
            padding: PaddingPreset.xl,
          ),
          children: [
            ArcaneDiv(
              classes: 'kb-content-wrapper',
              styles: const ArcaneStyleData(
                display: Display.flex,
                gap: Gap.xl,
                maxWidth: MaxWidth.container,
                margin: MarginPreset.autoX,
              ),
              children: [
                // Content area
                _buildContentArea(),

                // Table of contents
                if (component.config.tocEnabled && component.toc != null)
                  _buildTableOfContents(),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Component _buildContentArea() {
    return ArcaneDiv(
      classes: 'kb-content',
      styles: const ArcaneStyleData(
        flex: FlexPreset.expand,
        minWidth: '0',
      ),
      children: [
        // Breadcrumbs
        KBBreadcrumbs(
          config: component.config,
          currentPath: component.currentPath,
        ),

        // Draft banner
        if (component.isDraft) _buildDraftBanner(),

        // Page header
        if (component.pageTitle != null || component.pageDescription != null)
          _buildPageHeader(),

        // Subpages (for section index pages)
        KBSubpages(
          config: component.config,
          manifest: component.manifest,
          currentPath: component.currentPath,
        ),

        // Markdown content
        div(classes: 'prose', [component.content]),

        // Related pages (based on shared tags)
        KBRelatedPages(
          config: component.config,
          manifest: component.manifest,
          currentPath: component.currentPath,
          currentTags: component.pageTags,
        ),

        // Edit on GitHub link
        if (component.config.editUrl(component.currentPath) != null)
          _buildEditLink(),

        // Previous/Next navigation
        KBPageNav(
          config: component.config,
          manifest: component.manifest,
          currentPath: component.currentPath,
        ),
      ],
    );
  }

  Component _buildDraftBanner() {
    return ArcaneDiv(
      classes: 'kb-draft-banner',
      styles: const ArcaneStyleData(
        display: Display.flex,
        crossAxisAlignment: CrossAxisAlignment.center,
        gap: Gap.sm,
        padding: PaddingPreset.md,
        margin: MarginPreset.bottomLg,
        background: Background.muted,
        border: BorderPreset.subtle,
        borderRadius: Radius.md,
        fontSize: FontSize.sm,
      ),
      children: [
        ArcaneIcon.pencil(size: IconSize.sm),
        const ArcaneText('This page is a draft and not published yet.'),
      ],
    );
  }

  Component _buildPageHeader() {
    return ArcaneDiv(
      classes: 'kb-page-header',
      styles: const ArcaneStyleData(
        margin: MarginPreset.bottomLg,
      ),
      children: [
        if (component.pageTitle != null)
          ArcaneDiv(
            styles: const ArcaneStyleData(
              fontSize: FontSize.xl3,
              fontWeight: FontWeight.bold,
              textColor: TextColor.primary,
              margin: MarginPreset.bottomMd,
            ),
            children: [ArcaneText(component.pageTitle!)],
          ),
        if (component.pageDescription != null)
          ArcaneDiv(
            styles: const ArcaneStyleData(
              fontSize: FontSize.lg,
              textColor: TextColor.mutedForeground,
            ),
            children: [ArcaneText(component.pageDescription!)],
          ),
        // Page metadata (author, reading time)
        if (component.pageAuthor != null || component.readingTime != null)
          _buildPageMeta(),
        // Tags
        if (component.pageTags.isNotEmpty) _buildTags(),
      ],
    );
  }

  Component _buildPageMeta() {
    return ArcaneDiv(
      classes: 'kb-page-meta',
      styles: const ArcaneStyleData(
        display: Display.flex,
        crossAxisAlignment: CrossAxisAlignment.center,
        gap: Gap.md,
        margin: MarginPreset.topMd,
        fontSize: FontSize.sm,
        textColor: TextColor.mutedForeground,
      ),
      children: [
        if (component.pageAuthor != null)
          ArcaneRow(
            gapSize: Gap.xs,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ArcaneIcon.user(size: IconSize.xs),
              ArcaneText(component.pageAuthor!),
            ],
          ),
        if (component.pageAuthor != null && component.readingTime != null)
          const ArcaneText('·'),
        if (component.readingTime != null)
          ArcaneRow(
            gapSize: Gap.xs,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ArcaneIcon.clock(size: IconSize.xs),
              ArcaneText('${component.readingTime} min read'),
            ],
          ),
      ],
    );
  }

  Component _buildTags() {
    return ArcaneDiv(
      classes: 'kb-tags',
      styles: const ArcaneStyleData(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: Gap.xs,
        margin: MarginPreset.topMd,
      ),
      children: component.pageTags
          .map((String tag) => ArcaneDiv(
                classes: 'kb-tag',
                styles: const ArcaneStyleData(
                  display: Display.inlineFlex,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  gap: Gap.xs,
                  padding: PaddingPreset.sm,
                  background: Background.muted,
                  borderRadius: Radius.full,
                  fontSize: FontSize.xs,
                  textColor: TextColor.mutedForeground,
                ),
                children: [
                  ArcaneIcon.tag(size: IconSize.xs),
                  ArcaneText(tag),
                ],
              ))
          .toList(),
    );
  }

  Component _buildEditLink() {
    return ArcaneDiv(
      classes: 'kb-edit-link',
      styles: const ArcaneStyleData(
        margin: MarginPreset.topLg,
        padding: PaddingPreset.topMd,
        borderTop: BorderPreset.subtle,
      ),
      children: [
        ArcaneLink.external(
          href: component.config.editUrl(component.currentPath)!,
          styles: const ArcaneStyleData(
            display: Display.inlineFlex,
            crossAxisAlignment: CrossAxisAlignment.center,
            gap: Gap.xs,
            fontSize: FontSize.sm,
            textColor: TextColor.mutedForeground,
            textDecoration: TextDecoration.none,
          ),
          child: ArcaneRow(
            gapSize: Gap.xs,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ArcaneIcon.pencil(size: IconSize.sm),
              const ArcaneText('Edit this page on GitHub'),
              ArcaneIcon.externalLink(size: IconSize.xs),
            ],
          ),
        ),
      ],
    );
  }

  /// Table of contents sidebar using Arcane styling
  Component _buildTableOfContents() {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        widthCustom: '240px',
        flexShrink: 0,
        position: Position.sticky,
        overflow: Overflow.auto,
        top: '80px',
        alignSelf: CrossAxisAlignment.start,
        maxHeight: 'calc(100vh - 100px)',
      ),
      children: [
        ArcaneDiv(
          styles: const ArcaneStyleData(
            padding: PaddingPreset.md,
            borderRadius: Radius.lg,
            background: Background.surface,
            border: BorderPreset.subtle,
          ),
          children: [
            ArcaneDiv(
              styles: const ArcaneStyleData(
                fontSize: FontSize.xs,
                fontWeight: FontWeight.w700,
                margin: MarginPreset.bottomMd,
                textTransform: TextTransform.uppercase,
                letterSpacing: LetterSpacing.wide,
                textColor: TextColor.onSurfaceVariant,
                padding: PaddingPreset.bottomMd,
                borderBottom: BorderPreset.subtle,
              ),
              children: [const ArcaneText('On this page')],
            ),
            div(classes: 'toc-content', [component.toc!.build()]),
          ],
        ),
      ],
    );
  }

  Component _buildBackToTop() {
    return ArcaneDiv(
      classes: 'kb-back-to-top',
      styles: const ArcaneStyleData(
        position: Position.fixed,
        bottom: '24px',
        right: '24px',
        widthCustom: '40px',
        heightCustom: '40px',
        display: Display.flex,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        background: Background.surface,
        border: BorderPreset.subtle,
        borderRadius: Radius.full,
        cursor: Cursor.pointer,
        opacity: Opacity.transparent,
        pointerEvents: PointerEvents.none,
        zIndexCustom: '50',
        transition: Transition.allFast,
      ),
      children: [ArcaneIcon.arrowUp(size: IconSize.sm)],
    );
  }
}