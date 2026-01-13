import 'package:arcane_jaspr/arcane_jaspr.dart' hide TableOfContents;
import 'package:jaspr_content/jaspr_content.dart';

import '../config/site_config.dart';
import '../navigation/nav_builder.dart';
import '../navigation/nav_item.dart';
import '../navigation/nav_section.dart';
import '../scripts/kb_scripts.dart';
import '../styles/kb_styles.dart';
import 'kb_rating.dart';
import 'kb_sidebar.dart';

/// Callback type for building demo components.
///
/// The callback receives the component type from frontmatter and returns
/// a Component to render as the live demo, or null if no demo is available.
typedef DemoBuilder = Component? Function(String componentType);

/// The main layout wrapper for knowledge base pages.
/// Matches the arcane_jaspr_codex pattern with single-line theming.
class KBLayout extends PageLayoutBase {
  final SiteConfig config;
  final NavManifest manifest;
  final ArcaneStylesheet stylesheet;
  final KBScripts scripts;
  final DemoBuilder? demoBuilder;

  KBLayout({
    required this.config,
    required this.manifest,
    required this.stylesheet,
    KBScripts? scripts,
    this.demoBuilder,
  }) : scripts = scripts ?? KBScripts(basePath: config.baseUrl);

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

    // Viewport and theme color
    yield const meta(name: 'viewport', content: 'width=device-width, initial-scale=1');
    yield const meta(name: 'theme-color', content: '#09090b');

    // Favicons
    yield link(rel: 'icon', type: 'image/x-icon', href: '$assetPrefix/assets/favicon.ico');
    yield link(rel: 'icon', type: 'image/png', href: '$assetPrefix/assets/icon-32.png', attributes: const {'sizes': '32x32'});
    yield link(rel: 'icon', type: 'image/png', href: '$assetPrefix/assets/icon-16.png', attributes: const {'sizes': '16x16'});

    // Inject stylesheet base CSS (contains all CSS variables and base styles)
    yield Component.element(
      tag: 'style',
      attributes: const {'id': 'arcane-theme-vars'},
      children: [RawText(stylesheet.baseCss)],
    );

    // Inject default KB component styles (base structural styles)
    // Injected BEFORE componentCss so stylesheet overrides can take precedence
    yield Component.element(
      tag: 'style',
      attributes: const {'id': 'arcane-kb-styles'},
      children: [RawText(KBStyles.generate())],
    );

    // Inject stylesheet component CSS (contains sidebar styles, tree lines, etc.)
    // Comes after KB styles so stylesheet-specific overrides (like Codex) take precedence
    yield Component.element(
      tag: 'style',
      attributes: const {'id': 'arcane-component-styles'},
      children: [RawText(stylesheet.componentCss)],
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

    // Load custom styles.css after theme variables
    yield link(rel: 'stylesheet', href: '$assetPrefix/styles.css');

    // Highlight.js for syntax highlighting
    yield const link(
      rel: 'stylesheet',
      href: 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css',
    );
    yield const script(
      attributes: {
        'src': 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js',
      },
    );
    yield const script(
      attributes: {
        'src': 'https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/languages/dart.min.js',
      },
    );

    // Theme initialization script
    yield script(content: scripts.generateThemeInit());
  }

  @override
  Component buildBody(Page page, Component child) {
    final Map<String, dynamic> pageData = page.data.page;

    // Extract tags from frontmatter
    List<String> tags = <String>[];
    final dynamic rawTags = pageData['tags'];
    if (rawTags is List) {
      tags = rawTags.map((dynamic t) => t.toString()).toList();
    } else if (rawTags is String) {
      tags = rawTags.split(',').map((String t) => t.trim()).toList();
    }

    // Extract reading time
    final int? readingTime = pageData['readingTime'] as int?;

    // Extract author
    final String? author = pageData['author'] as String?;

    // Extract date
    final String? date = pageData['date'] as String?;

    // Extract component type for demo injection
    final String? componentType = pageData['component'] as String?;

    // Find the NavItem for this page to get lastModified
    final NavItem? navItem = _findNavItem(page.url);
    final String? lastModified = navItem?.lastModified;

    return ThemedKBPage(
      config: config,
      manifest: manifest,
      stylesheet: stylesheet,
      scripts: scripts,
      currentPath: page.url,
      title: pageData['title'] as String?,
      description: pageData['description'] as String?,
      toc: page.data['toc'] as TableOfContents?,
      tags: tags,
      readingTime: readingTime,
      author: author,
      date: date,
      lastModified: lastModified,
      componentType: componentType,
      demoBuilder: demoBuilder,
      content: child,
    );
  }

  /// Find a NavItem by its path in the manifest.
  NavItem? _findNavItem(String path) {
    // Check root items
    for (final NavItem item in manifest.items) {
      if (_pathsMatch(item.path, path)) return item;
    }
    // Check sections recursively
    return _findNavItemInSections(manifest.sections, path);
  }

  NavItem? _findNavItemInSections(List<NavSection> sections, String path) {
    for (final NavSection section in sections) {
      for (final NavItem item in section.items) {
        if (_pathsMatch(item.path, path)) return item;
      }
      final NavItem? found = _findNavItemInSections(section.sections, path);
      if (found != null) return found;
    }
    return null;
  }

  bool _pathsMatch(String a, String b) {
    // Normalize paths for comparison
    final String normalA = a.endsWith('/') ? a.substring(0, a.length - 1) : a;
    final String normalB = b.endsWith('/') ? b.substring(0, b.length - 1) : b;
    return normalA == normalB;
  }
}

/// Documentation page wrapper with light/dark mode toggle.
class ThemedKBPage extends StatefulComponent {
  final SiteConfig config;
  final NavManifest manifest;
  final ArcaneStylesheet stylesheet;
  final KBScripts scripts;
  final String currentPath;
  final String? title;
  final String? description;
  final TableOfContents? toc;
  final List<String> tags;
  final int? readingTime;
  final String? author;
  final String? date;
  final String? lastModified;
  final String? componentType;
  final DemoBuilder? demoBuilder;
  final Component content;

  const ThemedKBPage({
    required this.config,
    required this.manifest,
    required this.stylesheet,
    required this.scripts,
    required this.currentPath,
    this.title,
    this.description,
    this.toc,
    this.tags = const <String>[],
    this.readingTime,
    this.author,
    this.date,
    this.lastModified,
    this.componentType,
    this.demoBuilder,
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

  @override
  Component build(BuildContext context) {
    // Dark mode uses .dark class (defined in stylesheet baseCss)
    final String themeClass = _isDark ? 'dark' : '';
    final String? stylesheetClass = component.stylesheet.bodyClass;
    final String rootClasses = [themeClass, stylesheetClass]
        .where((String? c) => c != null && c.isNotEmpty)
        .join(' ');

    // Wrap with ArcaneThemeProvider to enable context.renderers access
    return ArcaneThemeProvider(
      stylesheet: component.stylesheet,
      brightness: _isDark ? Brightness.dark : Brightness.light,
      child: ArcaneDiv(
        id: 'arcane-root',
        classes: rootClasses,
        styles: const ArcaneStyleData(
          minHeight: '100vh',
          background: Background.background,
          textColor: TextColor.primary,
          fontFamily: FontFamily.sans,
        ),
        children: [
          _buildPageLayout(),
          ..._buildScripts(),
        ],
      ),
    );
  }

  /// Main page layout structure
  Component _buildPageLayout() {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        display: Display.flex,
        minHeight: '100vh',
      ),
      children: [
        KBSidebar(
          config: component.config,
          manifest: component.manifest,
          currentPath: component.currentPath,
        ),
        _buildMainArea(),
      ],
    );
  }

  /// Main content area
  Component _buildMainArea() {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        flexGrow: 1,
        display: Display.flex,
        flexDirection: FlexDirection.column,
        minHeight: '100vh',
      ),
      children: [
        _buildContentArea(),
      ],
    );
  }

  /// Content area with main content and TOC
  Component _buildContentArea() {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        display: Display.flex,
        gap: Gap.xl,
        padding: PaddingPreset.xl,
        maxWidth: MaxWidth.container,
        margin: MarginPreset.autoX,
        flexGrow: 1,
        raw: {'padding-top': '2rem'},
      ),
      children: [
        _buildMainContent(),
        if (component.config.tocEnabled && component.toc != null)
          _buildTableOfContents(),
      ],
    );
  }

  /// Main content section
  Component _buildMainContent() {
    final bool hasMetadata = component.tags.isNotEmpty ||
        component.readingTime != null ||
        component.author != null ||
        component.date != null ||
        component.lastModified != null;

    // Build live demo if component type is specified
    Component? demoComponent;
    if (component.componentType != null && component.demoBuilder != null) {
      demoComponent = component.demoBuilder!(component.componentType!);
    }

    return ArcaneDiv(
      styles: const ArcaneStyleData(
        flex: FlexPreset.expand,
        minWidth: '0',
      ),
      children: [
        _buildBreadcrumbs(),
        if (component.title != null) _buildTitle(),
        if (component.description != null) _buildDescription(),
        if (hasMetadata) _buildMetadata(),
        if (demoComponent != null) demoComponent,
        div(classes: 'prose', [component.content]),
        if (component.tags.isNotEmpty) _buildTagsFooter(),
        if (component.config.ratingEnabled) _buildRating(),
      ],
    );
  }

  /// Build page rating widget
  Component _buildRating() {
    return KBRating(
      pagePath: component.currentPath,
      config: RatingConfig(
        enabled: true,
        promptText: component.config.ratingPromptText,
        thankYouText: component.config.ratingThankYouText,
      ),
    );
  }

  /// Build metadata row with reading time, author, date
  Component _buildMetadata() {
    return ArcaneDiv(
      classes: 'kb-page-metadata',
      styles: const ArcaneStyleData(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        crossAxisAlignment: CrossAxisAlignment.center,
        gap: Gap.lg,
        margin: MarginPreset.bottomLg,
        padding: PaddingPreset.bottomMd,
        borderBottom: BorderPreset.subtle,
      ),
      children: [
        // Reading time
        if (component.readingTime != null)
          ArcaneDiv(
            styles: const ArcaneStyleData(
              display: Display.flex,
              crossAxisAlignment: CrossAxisAlignment.center,
              gap: Gap.xs,
              fontSize: FontSize.sm,
              textColor: TextColor.mutedForeground,
            ),
            children: [
              ArcaneIcon.clock(size: IconSize.sm),
              ArcaneText('${component.readingTime} min read'),
            ],
          ),

        // Author
        if (component.author != null)
          ArcaneDiv(
            styles: const ArcaneStyleData(
              display: Display.flex,
              crossAxisAlignment: CrossAxisAlignment.center,
              gap: Gap.xs,
              fontSize: FontSize.sm,
              textColor: TextColor.mutedForeground,
            ),
            children: [
              ArcaneIcon.user(size: IconSize.sm),
              ArcaneText(component.author!),
            ],
          ),

        // Date
        if (component.date != null)
          ArcaneDiv(
            styles: const ArcaneStyleData(
              display: Display.flex,
              crossAxisAlignment: CrossAxisAlignment.center,
              gap: Gap.xs,
              fontSize: FontSize.sm,
              textColor: TextColor.mutedForeground,
            ),
            children: [
              ArcaneIcon.calendar(size: IconSize.sm),
              ArcaneText(component.date!),
            ],
          ),

        // Last modified
        if (component.lastModified != null)
          ArcaneDiv(
            styles: const ArcaneStyleData(
              display: Display.flex,
              crossAxisAlignment: CrossAxisAlignment.center,
              gap: Gap.xs,
              fontSize: FontSize.sm,
              textColor: TextColor.mutedForeground,
            ),
            children: [
              ArcaneIcon.edit(size: IconSize.sm),
              ArcaneText('Updated ${_formatLastModified(component.lastModified!)}'),
            ],
          ),

        // Tags inline (small badges)
        if (component.tags.isNotEmpty)
          ArcaneDiv(
            styles: const ArcaneStyleData(
              display: Display.flex,
              flexWrap: FlexWrap.wrap,
              gap: Gap.xs,
            ),
            children: component.tags.map((String tag) => ArcaneDiv(
                  classes: 'kb-tag',
                  styles: const ArcaneStyleData(
                    display: Display.inlineFlex,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    gap: Gap.xs,
                    fontSize: FontSize.xs,
                    padding: PaddingPreset.xs,
                    background: Background.muted,
                    borderRadius: Radius.sm,
                    textColor: TextColor.mutedForeground,
                  ),
                  children: [
                    ArcaneIcon.tag(size: IconSize.xs),
                    ArcaneText(tag),
                  ],
                )).toList(),
          ),
      ],
    );
  }

  /// Build tags footer section
  Component _buildTagsFooter() {
    return ArcaneDiv(
      classes: 'kb-tags-footer',
      styles: const ArcaneStyleData(
        margin: MarginPreset.topXl,
        padding: PaddingPreset.topLg,
        borderTop: BorderPreset.subtle,
      ),
      children: [
        ArcaneDiv(
          styles: const ArcaneStyleData(
            fontSize: FontSize.sm,
            fontWeight: FontWeight.w600,
            textColor: TextColor.mutedForeground,
            margin: MarginPreset.bottomSm,
          ),
          children: const [ArcaneText('Tags')],
        ),
        ArcaneDiv(
          styles: const ArcaneStyleData(
            display: Display.flex,
            flexWrap: FlexWrap.wrap,
            gap: Gap.sm,
          ),
          children: component.tags.map((String tag) => ArcaneDiv(
                classes: 'kb-tag-large',
                styles: const ArcaneStyleData(
                  display: Display.inlineFlex,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  gap: Gap.xs,
                  fontSize: FontSize.sm,
                  padding: PaddingPreset.sm,
                  background: Background.surface,
                  border: BorderPreset.subtle,
                  borderRadius: Radius.md,
                  textColor: TextColor.primary,
                ),
                children: [
                  ArcaneIcon.tag(size: IconSize.sm),
                  ArcaneText(tag),
                ],
              )).toList(),
        ),
      ],
    );
  }

  /// Build breadcrumbs from current path
  Component _buildBreadcrumbs() {
    final String path = component.currentPath;
    final List<String> segments = path.split('/').where((String segment) => segment.isNotEmpty).toList();

    if (segments.isEmpty) {
      return const ArcaneDiv(children: []);
    }

    final List<BreadcrumbItem> items = <BreadcrumbItem>[];

    // Add "Home" as first item
    items.add(BreadcrumbItem(
      label: 'Home',
      href: component.config.fullPath('/'),
    ));

    // Build remaining segments
    String currentHref = '';
    for (int i = 0; i < segments.length; i++) {
      currentHref += '/${segments[i]}';
      final bool isLast = i == segments.length - 1;
      final String label = _formatSegment(segments[i]);

      items.add(BreadcrumbItem(
        label: label,
        href: isLast ? null : component.config.fullPath(currentHref),
      ));
    }

    return ArcaneDiv(
      styles: const ArcaneStyleData(
        margin: MarginPreset.bottomMd,
      ),
      children: [
        ArcaneBreadcrumbs(
          items: items,
          separator: BreadcrumbSeparator.chevron,
          size: BreadcrumbSize.sm,
        ),
      ],
    );
  }

  /// Format path segment into readable label
  String _formatSegment(String segment) {
    return segment
        .split('-')
        .map((String word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// Format ISO 8601 date to readable format (e.g., "Jan 15, 2025")
  String _formatLastModified(String isoDate) {
    try {
      final DateTime dt = DateTime.parse(isoDate);
      final List<String> months = <String>[
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }

  Component _buildTitle() {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        margin: MarginPreset.bottomLg,
        fontSize: FontSize.xl3,
        fontWeight: FontWeight.bold,
        textColor: TextColor.primary,
      ),
      children: [ArcaneText(component.title!)],
    );
  }

  Component _buildDescription() {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        margin: MarginPreset.bottomXl,
        textColor: TextColor.mutedForeground,
        fontSize: FontSize.lg,
      ),
      children: [ArcaneText(component.description!)],
    );
  }

  /// Table of contents sidebar
  Component _buildTableOfContents() {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        position: Position.sticky,
        raw: {
          'width': '220px',
          'flex-shrink': '0',
          'top': '80px',
          'align-self': 'flex-start',
          'max-height': 'calc(100vh - 100px)',
          'overflow-y': 'auto',
        },
      ),
      children: [
        ArcaneToc.custom(
          content: component.toc!.build(),
        ),
      ],
    );
  }

  /// JavaScript for static site functionality
  Iterable<Component> _buildScripts() sync* {
    yield script(content: component.scripts.generate());
    // Component interactivity scripts from arcane_jaspr
    yield const ArcaneScriptsComponent();
  }
}
