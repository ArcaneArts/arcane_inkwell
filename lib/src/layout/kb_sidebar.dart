import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/web.dart'
    show RawText, Styles, a, button, div, nav, span;
import 'package:arcane_lexicon/src/config/site_config.dart';
import 'package:arcane_lexicon/src/icons/kb_icon.dart';
import 'package:arcane_lexicon/src/navigation/nav_builder.dart';
import 'package:arcane_lexicon/src/navigation/nav_item.dart';
import 'package:arcane_lexicon/src/navigation/nav_section.dart';

/// The sidebar navigation component for knowledge base pages.
/// Matches the arcane_jaspr_neon pattern.
class KBSidebar extends StatelessWidget {
  final SiteConfig config;
  final NavManifest manifest;
  final String currentPath;
  final bool showBranding;
  final bool showSearch;
  final bool showThemeToggle;
  final List<KBStylesheetOption> stylesheetOptions;
  final String activeStylesheetId;
  final String activePaletteId;
  final String railTopOffset;

  const KBSidebar({
    required this.config,
    required this.manifest,
    required this.currentPath,
    this.showBranding = true,
    this.showSearch = true,
    this.showThemeToggle = true,
    this.stylesheetOptions = const <KBStylesheetOption>[],
    this.activeStylesheetId = '',
    this.activePaletteId = '',
    this.railTopOffset = '0px',
  });

  @override
  Widget build(BuildContext context) {
    bool showStylesheetSwitcher =
        config.stylesheetSwitcherEnabled && stylesheetOptions.length > 1;
    bool showPaletteSwitcher =
        config.paletteSwitcherEnabled && _activePalettes().length > 1;
    bool showHeader =
        showBranding ||
        showSearch ||
        showThemeToggle ||
        showStylesheetSwitcher ||
        showPaletteSwitcher;

    return div(
      classes: 'kb-sidebar',
      styles: Styles(
        raw: <String, String>{
          '--kb-sidebar-width': config.sidebarWidth,
          '--kb-sidebar-rail-top': railTopOffset,
        },
      ),
      [
        div(classes: 'kb-sidebar-panel', [
          if (showHeader) _buildHeader(),
          if (showHeader) const div(classes: 'kb-section-divider', []),
          nav(
            classes: 'sidebar-nav',
            styles: const Styles(
              raw: {
                'padding': '0.75rem',
                'display': 'flex',
                'flex-direction': 'column',
                'gap': '0.5rem',
              },
            ),
            [
              if (manifest.visibleItems.isNotEmpty)
                _buildFixedSection(
                  'Pages',
                  KBIcon.build('file-text', classes: 'sidebar-icon'),
                  manifest.visibleItems
                      .map((NavItem item) => _buildNavItem(item))
                      .toList(),
                ),
              for (NavSection section in manifest.visibleSections)
                _buildCollapsibleSection(section, depth: 0),
            ],
          ),
        ]),
      ],
    );
  }

  /// Build the sidebar header with branding and controls
  Widget _buildHeader() {
    List<Widget> children = <Widget>[];
    bool showStylesheetSwitcher =
        config.stylesheetSwitcherEnabled && stylesheetOptions.length > 1;
    bool showPaletteSwitcher =
        config.paletteSwitcherEnabled && _activePalettes().length > 1;

    if (showBranding) {
      children.add(
        div(classes: 'sidebar-brand', [
          a(
            href: config.fullPath('/'),
            styles: const Styles(raw: {'text-decoration': 'none'}),
            [
              div(classes: 'sidebar-brand-title', [Widget.text(config.name)]),
              if (config.description != null)
                div(classes: 'sidebar-brand-subtitle', [
                  Widget.text(config.description!),
                ]),
            ],
          ),
        ]),
      );
    }

    bool hasControls =
        showSearch ||
        showThemeToggle ||
        showStylesheetSwitcher ||
        showPaletteSwitcher;
    if (hasControls) {
      children.add(
        div(classes: 'sidebar-controls', [
          if (showSearch)
            const RawText('''
<div class="sidebar-search kb-search" data-kb-search="true">
  <div class="kb-search-input-wrap">
    <input class="kb-search-input" type="text" placeholder="Search docs..." autocomplete="off" aria-label="Search documentation" aria-autocomplete="list" aria-expanded="false" role="combobox" data-kb-search-input="true">
    <div class="kb-search-icon">
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><path d="m21 21-4.3-4.3"></path></svg>
    </div>
  </div>
  <div class="search-results" role="listbox" aria-label="Search results" data-kb-search-results="true" hidden></div>
</div>
'''),
          if (showStylesheetSwitcher || showPaletteSwitcher)
            div(classes: 'kb-style-switcher', [
              if (showStylesheetSwitcher) _buildStylesheetSelect(),
              if (showPaletteSwitcher) _buildPaletteSelect(),
            ]),
          if (showThemeToggle)
            button(
              id: 'theme-toggle',
              classes: 'kb-theme-toggle',
              attributes: const {
                'type': 'button',
                'aria-label': 'Toggle theme',
              },
              [
                span(classes: 'theme-icon-light', [
                  KBIcon.build('sun', size: IconSize.sm),
                ]),
                span(classes: 'theme-icon-dark', [
                  KBIcon.build('moon', size: IconSize.sm),
                ]),
              ],
            ),
        ]),
      );
    }

    return div(classes: 'sidebar-header', children);
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

  /// Build a fixed section that's always expanded (no toggle)
  Widget _buildFixedSection(String title, Widget icon, List<Widget> items) {
    return div(classes: 'sidebar-section', [
      // Section header
      div(classes: 'sidebar-section-header', [
        icon,
        span([Widget.text(title)]),
      ]),
      // Tree items container
      div(classes: 'sidebar-tree', [for (final Widget item in items) item]),
    ]);
  }

  /// Build a collapsible section using native details/summary
  Widget _buildCollapsibleSection(NavSection section, {int depth = 0}) {
    final bool shouldExpand =
        section.shouldExpandFor(currentPath) || !section.collapsed;

    return div(classes: 'sidebar-section', [
      Widget.element(
        tag: 'details',
        classes: 'sidebar-details',
        attributes: shouldExpand ? {'open': ''} : {},
        children: [
          Widget.element(
            tag: 'summary',
            classes: 'sidebar-summary',
            styles: _treeRowStyles(depth, isFolder: true),
            children: [
              span([Widget.text(section.title)]),
              span(classes: 'sidebar-chevron', [
                KBIcon.build('chevron-down', classes: 'sidebar-chevron-icon'),
              ]),
            ],
          ),
          div(classes: 'sidebar-tree', [
            // Items in this section
            for (final NavItem item in section.visibleItems)
              _buildNavItem(item, depth: depth + 1),
            // Nested sections
            for (final NavSection nested in section.visibleSections)
              _buildCollapsibleSection(nested, depth: depth + 1),
          ]),
        ],
      ),
    ]);
  }

  /// Build a navigation item that links to a page
  Widget _buildNavItem(NavItem item, {int depth = 0}) {
    final String fullHref = config.fullPath(item.path);
    final bool isActive = _isActive(item.path);

    return div(classes: 'sidebar-tree-item', [
      a(
        href: fullHref,
        classes: 'sidebar-link${isActive ? ' active' : ''}',
        styles: _treeRowStyles(depth, isFolder: false),
        [
          if (item.icon != null) _buildIcon(item.icon!),
          Widget.text(item.title),
        ],
      ),
    ]);
  }

  Styles _treeRowStyles(int depth, {required bool isFolder}) {
    final Map<String, String> rawStyles = <String, String>{
      'padding-left': config.sidebarTreeIndent,
    };

    if (isFolder && depth > 0) {
      rawStyles['margin-left'] = '0.75rem';
    }

    return Styles(raw: rawStyles);
  }

  /// Build one navigation icon from a Lucide icon name.
  Widget _buildIcon(String iconName) =>
      KBIcon.build(iconName, classes: 'sidebar-icon');

  bool _isActive(String path) {
    // Exact match only - don't highlight parent paths
    return currentPath == path || currentPath == '$path/';
  }
}
