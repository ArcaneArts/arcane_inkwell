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
import 'kb_toc.dart';
import 'kb_page_nav.dart';

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
      yield link(rel: 'preconnect', href: 'https://fonts.googleapis.com');
      yield link(
        rel: 'preconnect',
        href: 'https://fonts.gstatic.com',
        attributes: const {'crossorigin': ''},
      );
      for (final String url in stylesheet.externalCssUrls) {
        yield link(rel: 'stylesheet', href: url);
      }
    }

    // Highlight.js for syntax highlighting
    yield const link(
      rel: 'stylesheet',
      href:
          'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css',
    );
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
    final String currentPath = page.url;
    final Map<String, dynamic> pageData = page.data.page;
    final String? pageTitle = pageData['title'] as String?;
    final String? pageDescription = pageData['description'] as String?;
    final TableOfContents? toc = page.data['toc'] as TableOfContents?;

    // Determine theme class based on config
    final String themeClass =
        config.defaultTheme == KBThemeMode.light ? '' : 'dark';

    return ArcaneThemeProvider(
      stylesheet: stylesheet,
      brightness: config.defaultTheme == KBThemeMode.light
          ? Brightness.light
          : Brightness.dark,
      child: ArcaneDiv(
        id: 'kb-root',
        classes: themeClass,
        styles: const ArcaneStyleData(
          minHeight: '100vh',
          background: Background.background,
          textColor: TextColor.primary,
          fontFamily: FontFamily.sans,
        ),
        children: [
          // Header
          KBHeader(config: config),

          // Main layout
          ArcaneDiv(
            classes: 'kb-layout',
            styles: const ArcaneStyleData(
              display: Display.flex,
              flexGrow: 1,
            ),
            children: [
              // Sidebar
              KBSidebar(
                config: config,
                manifest: manifest,
                currentPath: currentPath,
              ),

              // Main content
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
                      ArcaneDiv(
                        classes: 'kb-content',
                        styles: const ArcaneStyleData(
                          flex: FlexPreset.expand,
                          minWidth: '0',
                        ),
                        children: [
                          // Breadcrumbs
                          KBBreadcrumbs(
                            config: config,
                            currentPath: currentPath,
                          ),

                          // Page header
                          if (pageTitle != null || pageDescription != null)
                            ArcaneDiv(
                              classes: 'kb-page-header',
                              styles: const ArcaneStyleData(
                                margin: MarginPreset.bottomLg,
                              ),
                              children: [
                                if (pageTitle != null)
                                  ArcaneDiv(
                                    styles: const ArcaneStyleData(
                                      fontSize: FontSize.xl3,
                                      fontWeight: FontWeight.bold,
                                      textColor: TextColor.primary,
                                      margin: MarginPreset.bottomMd,
                                    ),
                                    children: [ArcaneText(pageTitle)],
                                  ),
                                if (pageDescription != null)
                                  ArcaneDiv(
                                    styles: const ArcaneStyleData(
                                      fontSize: FontSize.lg,
                                      textColor: TextColor.mutedForeground,
                                    ),
                                    children: [ArcaneText(pageDescription)],
                                  ),
                              ],
                            ),

                          // Subpages (for section index pages)
                          KBSubpages(
                            config: config,
                            manifest: manifest,
                            currentPath: currentPath,
                          ),

                          // Markdown content
                          div(classes: 'prose', [child]),

                          // Previous/Next navigation
                          KBPageNav(
                            config: config,
                            manifest: manifest,
                            currentPath: currentPath,
                          ),
                        ],
                      ),

                      // Table of contents
                      if (config.tocEnabled && toc != null) KBToc(toc: toc),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Footer
          if (config.footerText != null || config.copyright != null)
            KBFooter(config: config),

          // Scripts
          script(content: scripts.generate()),

          // Component interactivity scripts from arcane_jaspr
          const ArcaneScriptsComponent(),
        ],
      ),
    );
  }
}
