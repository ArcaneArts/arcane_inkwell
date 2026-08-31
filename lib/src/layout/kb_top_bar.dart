import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/web.dart'
    show RawText, a, button, div, img, nav, span;

import '../config/site_config.dart';

class KBTopBar extends StatelessWidget {
  final SiteConfig config;
  final String currentPath;
  final List<KBStylesheetOption> stylesheetOptions;
  final String activeStylesheetId;
  final String activePaletteId;
  final bool bottom;
  final bool showBranding;
  final bool autoHide;

  const KBTopBar({
    required this.config,
    required this.currentPath,
    this.stylesheetOptions = const <KBStylesheetOption>[],
    this.activeStylesheetId = '',
    this.activePaletteId = '',
    this.bottom = false,
    this.showBranding = true,
    this.autoHide = false,
  });

  @override
  Widget build(BuildContext context) {
    String positionClass = bottom ? ' kb-topbar-bottom' : '';
    bool showStylesheetSwitcher =
        config.stylesheetSwitcherEnabled && stylesheetOptions.length > 1;
    bool showPaletteSwitcher =
        config.paletteSwitcherEnabled && _activePalettes().length > 1;
    return div(
      classes: 'kb-topbar$positionClass',
      attributes: autoHide
          ? const <String, String>{'data-kb-autohide': 'true'}
          : null,
      [
        div(classes: 'kb-topbar-inner', [
          div(classes: 'kb-topbar-left', [
            button(
              classes: 'kb-hamburger',
              attributes: const <String, String>{
                'type': 'button',
                'aria-label': 'Toggle sidebar',
                'aria-expanded': 'false',
                'data-kb-sidebar-toggle': 'true',
              },
              [ArcaneIcon.panelLeft(size: IconSize.sm)],
            ),
            if (showBranding)
              a(href: config.fullPath('/'), classes: 'kb-topbar-brand', [
                if (config.logo != null)
                  img(
                    classes: 'kb-topbar-logo',
                    src: _resolveLogoPath(config.logo!),
                    alt: '',
                  )
                else
                  span(classes: 'kb-topbar-brand-icon', [
                    Widget.text(_brandInitial()),
                  ]),
                span(classes: 'kb-topbar-brand-label', [
                  Widget.text(config.name),
                ]),
              ]),
            if (config.headerLinks.isNotEmpty)
              nav(classes: 'kb-topbar-nav', [
                for (NavLink link in config.headerLinks) _buildHeaderLink(link),
              ]),
          ]),
          div(classes: 'kb-topbar-right', [
            if (config.searchEnabled) _buildSearch(),
            if (showStylesheetSwitcher || showPaletteSwitcher)
              div(classes: 'kb-style-switcher', [
                if (showStylesheetSwitcher) _buildStylesheetSelect(),
                if (showPaletteSwitcher) _buildPaletteSelect(),
              ]),
            if (config.themeToggleEnabled)
              button(
                id: 'theme-toggle',
                classes: 'kb-theme-toggle',
                attributes: const <String, String>{
                  'type': 'button',
                  'aria-label': 'Toggle theme',
                },
                [
                  span(classes: 'theme-icon-light', [
                    ArcaneIcon.sun(size: IconSize.sm),
                  ]),
                  span(classes: 'theme-icon-dark', [
                    ArcaneIcon.moon(size: IconSize.sm),
                  ]),
                ],
              ),
            if (config.githubUrl != null) _buildGithubLink(config.githubUrl!),
          ]),
        ]),
      ],
    );
  }

  Widget _buildHeaderLink(NavLink link) {
    bool isExternalLink = link.external || _isExternal(link.href);
    String href = isExternalLink ? link.href : config.fullPath(link.href);
    bool active = !isExternalLink && _isActive(link.href);
    String classes = active ? 'kb-topbar-link active' : 'kb-topbar-link';

    Map<String, String> attributes = isExternalLink
        ? const <String, String>{
            'target': '_blank',
            'rel': 'noopener noreferrer',
          }
        : const <String, String>{};

    return a(href: href, classes: classes, attributes: attributes, [
      Widget.text(link.label),
      if (isExternalLink) ArcaneIcon.externalLink(size: IconSize.xs),
    ]);
  }

  Widget _buildGithubLink(String githubUrl) {
    return a(
      href: githubUrl,
      classes: 'kb-topbar-github',
      attributes: const <String, String>{
        'target': '_blank',
        'rel': 'noopener noreferrer',
        'aria-label': 'GitHub',
      },
      [ArcaneIcon.github(size: IconSize.sm)],
    );
  }

  Widget _buildSearch() {
    return const RawText('''
<div class="kb-search" data-kb-search="true">
  <div class="kb-search-input-wrap">
    <input class="kb-search-input" type="text" placeholder="Search docs..." autocomplete="off" aria-label="Search documentation" aria-autocomplete="list" aria-expanded="false" role="combobox" data-kb-search-input="true">
    <div class="kb-search-icon">
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><path d="m21 21-4.3-4.3"></path></svg>
    </div>
  </div>
  <div class="search-results" role="listbox" aria-label="Search results" data-kb-search-results="true" hidden></div>
</div>
''');
  }

  Widget _buildStylesheetSelect() {
    return Widget.element(
      tag: 'select',
      classes: 'kb-stylesheet-select',
      attributes: const <String, String>{
        'aria-label': 'Select stylesheet',
        'data-kb-stylesheet-select': 'true',
      },
      children: [
        for (KBStylesheetOption option in stylesheetOptions)
          Widget.element(
            tag: 'option',
            attributes: <String, String>{
              'value': option.id,
              if (option.id == activeStylesheetId) 'selected': 'selected',
            },
            children: [Widget.text(option.label)],
          ),
      ],
    );
  }

  Widget _buildPaletteSelect() {
    List<KBPaletteOption> palettes = _activePalettes();
    return Widget.element(
      tag: 'select',
      classes: 'kb-palette-select',
      attributes: const <String, String>{
        'aria-label': 'Select palette',
        'data-kb-palette-select': 'true',
      },
      children: [
        for (KBPaletteOption palette in palettes)
          Widget.element(
            tag: 'option',
            attributes: <String, String>{
              'value': palette.id,
              if (palette.id == activePaletteId) 'selected': 'selected',
            },
            children: [Widget.text(palette.label)],
          ),
      ],
    );
  }

  List<KBPaletteOption> _activePalettes() {
    for (KBStylesheetOption option in stylesheetOptions) {
      if (option.id == activeStylesheetId) {
        return option.palettes;
      }
    }
    return const <KBPaletteOption>[];
  }

  bool _isActive(String href) {
    String cleanHref = _normalizePath(_removeBasePrefix(href));
    String cleanCurrent = _normalizePath(currentPath);
    if (cleanHref == '/') {
      return cleanCurrent == '/';
    }
    return cleanCurrent == cleanHref || cleanCurrent.startsWith('$cleanHref/');
  }

  String _removeBasePrefix(String path) {
    if (config.baseUrl.isEmpty) {
      return path;
    }
    if (!path.startsWith(config.baseUrl)) {
      return path;
    }
    String stripped = path.substring(config.baseUrl.length);
    if (stripped.isEmpty) {
      return '/';
    }
    return stripped.startsWith('/') ? stripped : '/$stripped';
  }

  String _normalizePath(String path) {
    if (path.isEmpty) {
      return '/';
    }
    String normalized = path;
    if (!normalized.startsWith('/')) {
      normalized = '/$normalized';
    }
    if (normalized.length > 1 && normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    return normalized;
  }

  bool _isExternal(String href) {
    return href.startsWith('http://') ||
        href.startsWith('https://') ||
        href.startsWith('mailto:') ||
        href.startsWith('//');
  }

  String _resolveLogoPath(String value) {
    if (value.startsWith('http://') ||
        value.startsWith('https://') ||
        value.startsWith('//')) {
      return value;
    }
    if (value.startsWith('/')) {
      return config.fullPath(value);
    }
    if (config.assetPrefix.isEmpty) {
      return value;
    }
    return '${config.assetPrefix}/$value';
  }

  String _brandInitial() {
    List<String> parts = config.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .toList();
    String value = parts.isEmpty ? config.name.trim() : parts.last;
    if (value.isEmpty) {
      return '';
    }
    return value[0].toUpperCase();
  }
}
