import 'package:arcane_jaspr/arcane_jaspr.dart' hide TableOfContents;

import '../config/site_config.dart';
import '../navigation/nav_item.dart';
import '../navigation/nav_section.dart';
import '../navigation/nav_builder.dart';

/// The sidebar navigation component for knowledge base pages.
/// Matches the arcane_jaspr_codex pattern.
class KBSidebar extends StatelessComponent {
  final SiteConfig config;
  final NavManifest manifest;
  final String currentPath;

  const KBSidebar({
    required this.config,
    required this.manifest,
    required this.currentPath,
  });

  @override
  Component build(BuildContext context) {
    return ArcaneScrollRail(
      width: '280px',
      topOffset: '0px',
      showBorder: true,
      padding: '0',
      scrollPersistenceId: 'kb-sidebar',
      children: [
        // Header section with branding and controls
        _buildHeader(),

        // Main navigation with tree view
        nav(
          classes: 'sidebar-nav',
          styles: const Styles(raw: {
            'padding': '0.75rem',
            'display': 'flex',
            'flex-direction': 'column',
            'gap': '0.5rem',
          }),
          [
            // Root-level items first (always visible, no section)
            if (manifest.visibleItems.isNotEmpty)
              _buildFixedSection(
                'Pages',
                ArcaneIcon.fileText(size: IconSize.sm),
                manifest.visibleItems.map((NavItem item) => _buildNavItem(item)).toList(),
              ),

            // Then sections
            for (final NavSection section in manifest.sortedSections)
              _buildCollapsibleSection(section),
          ],
        ),
      ],
    );
  }

  /// Build the sidebar header with branding and controls
  Component _buildHeader() {
    return div(
      classes: 'sidebar-header',
      [
        // Brand section
        div(
          classes: 'sidebar-brand',
          [
            a(
              href: config.fullPath('/'),
              styles: const Styles(raw: {'text-decoration': 'none'}),
              [
                div(classes: 'sidebar-brand-title', [Component.text(config.name)]),
                if (config.description != null)
                  div(classes: 'sidebar-brand-subtitle', [Component.text(config.description!)]),
              ],
            ),
          ],
        ),

        // Search and theme toggle row
        div(
          classes: 'sidebar-controls',
          [
            // Search input
            if (config.searchEnabled)
              div(
                classes: 'sidebar-search',
                [
                  input(
                    id: 'kb-search',
                    attributes: const {
                      'type': 'text',
                      'placeholder': 'Search...',
                      'autocomplete': 'off',
                    },
                  ),
                  div(classes: 'search-icon', [ArcaneIcon.search(size: IconSize.sm)]),
                  // Search results dropdown
                  div(id: 'search-results', classes: 'search-results', []),
                ],
              ),
            // Theme toggle button
            if (config.themeToggleEnabled)
              button(
                id: 'theme-toggle',
                classes: 'sidebar-theme-toggle',
                attributes: const {'type': 'button', 'aria-label': 'Toggle theme'},
                [
                  span(classes: 'theme-icon-light', [ArcaneIcon.sun(size: IconSize.sm)]),
                  span(classes: 'theme-icon-dark', [ArcaneIcon.moon(size: IconSize.sm)]),
                ],
              ),
          ],
        ),
      ],
    );
  }

  /// Build a fixed section that's always expanded (no toggle)
  Component _buildFixedSection(String title, Component icon, List<Component> items) {
    return div(
      classes: 'sidebar-section',
      [
        // Section header
        div(
          classes: 'sidebar-section-header',
          [
            icon,
            span([Component.text(title)]),
          ],
        ),
        // Tree items container
        div(
          classes: 'sidebar-tree',
          [
            for (final Component item in items) item,
          ],
        ),
      ],
    );
  }

  /// Build a collapsible section using native details/summary
  Component _buildCollapsibleSection(NavSection section) {
    final bool shouldExpand = section.shouldExpandFor(currentPath) || !section.collapsed;

    return div(
      classes: 'sidebar-section',
      [
        Component.element(
          tag: 'details',
          classes: 'sidebar-details',
          attributes: shouldExpand ? {'open': ''} : {},
          children: [
            Component.element(
              tag: 'summary',
              classes: 'sidebar-summary',
              children: [
                if (section.icon != null) _buildIcon(section.icon!),
                span([Component.text(section.title)]),
                span(classes: 'sidebar-chevron', []),
              ],
            ),
            div(
              classes: 'sidebar-tree',
              [
                // Items in this section
                for (final NavItem item in section.visibleItems)
                  _buildNavItem(item),
                // Nested sections
                for (final NavSection nested in section.sortedSections)
                  _buildCollapsibleSection(nested),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Build a navigation item that links to a page
  Component _buildNavItem(NavItem item) {
    final String fullHref = config.fullPath(item.path);
    final bool isActive = _isActive(item.path);

    return div(
      classes: 'sidebar-tree-item',
      [
        a(
          href: fullHref,
          classes: 'sidebar-link${isActive ? ' active' : ''}',
          [
            if (item.icon != null) _buildIcon(item.icon!),
            Component.text(item.title),
          ],
        ),
      ],
    );
  }

  /// Map icon name strings to ArcaneIcon components.
  Component _buildIcon(String iconName) {
    return switch (iconName) {
      // Documents & Files
      'file-text' => ArcaneIcon.fileText(size: IconSize.sm),
      'file' => ArcaneIcon.file(size: IconSize.sm),
      'book' => ArcaneIcon.book(size: IconSize.sm),
      'book-open' => ArcaneIcon.bookOpen(size: IconSize.sm),
      'notebook' => ArcaneIcon.notebook(size: IconSize.sm),
      'scroll' => ArcaneIcon.scroll(size: IconSize.sm),

      // Navigation & Actions
      'rocket' => ArcaneIcon.rocket(size: IconSize.sm),
      'zap' => ArcaneIcon.zap(size: IconSize.sm),
      'home' => ArcaneIcon.home(size: IconSize.sm),
      'play' => ArcaneIcon.play(size: IconSize.sm),
      'compass' => ArcaneIcon.compass(size: IconSize.sm),
      'map' => ArcaneIcon.map(size: IconSize.sm),
      'navigation' => ArcaneIcon.navigation(size: IconSize.sm),

      // Server & Infrastructure
      'server' => ArcaneIcon.server(size: IconSize.sm),
      'database' => ArcaneIcon.database(size: IconSize.sm),
      'hard-drive' => ArcaneIcon.hardDrive(size: IconSize.sm),
      'cpu' => ArcaneIcon.cpu(size: IconSize.sm),
      'cloud' => ArcaneIcon.cloud(size: IconSize.sm),
      'globe' => ArcaneIcon.globe(size: IconSize.sm),
      'network' => ArcaneIcon.network(size: IconSize.sm),
      'wifi' => ArcaneIcon.wifi(size: IconSize.sm),
      'monitor' => ArcaneIcon.monitor(size: IconSize.sm),
      'laptop' => ArcaneIcon.laptop(size: IconSize.sm),
      'container' => ArcaneIcon.container(size: IconSize.sm),

      // Security
      'shield' => ArcaneIcon.shield(size: IconSize.sm),
      'shield-check' => ArcaneIcon.shieldCheck(size: IconSize.sm),
      'shield-alert' => ArcaneIcon.shieldAlert(size: IconSize.sm),
      'lock' => ArcaneIcon.lock(size: IconSize.sm),
      'unlock' => ArcaneIcon.unlock(size: IconSize.sm),
      'key' => ArcaneIcon.key(size: IconSize.sm),
      'key-round' => ArcaneIcon.keyRound(size: IconSize.sm),
      'scan' => ArcaneIcon.scan(size: IconSize.sm),

      // Settings & Tools
      'settings' => ArcaneIcon.settings(size: IconSize.sm),
      'settings-2' => ArcaneIcon.settings2(size: IconSize.sm),
      'sliders' => ArcaneIcon.slidersHorizontal(size: IconSize.sm),
      'sliders-horizontal' => ArcaneIcon.slidersHorizontal(size: IconSize.sm),
      'wrench' => ArcaneIcon.wrench(size: IconSize.sm),
      'hammer' => ArcaneIcon.hammer(size: IconSize.sm),
      'terminal' => ArcaneIcon.terminal(size: IconSize.sm),
      'code' => ArcaneIcon.code(size: IconSize.sm),
      'braces' => ArcaneIcon.braces(size: IconSize.sm),
      'brackets' => ArcaneIcon.brackets(size: IconSize.sm),

      // Files & Folders
      'folder' => ArcaneIcon.folder(size: IconSize.sm),
      'folder-open' => ArcaneIcon.folderOpen(size: IconSize.sm),
      'folder-closed' => ArcaneIcon.folderClosed(size: IconSize.sm),
      'archive' => ArcaneIcon.archive(size: IconSize.sm),
      'package' => ArcaneIcon.package(size: IconSize.sm),
      'box' => ArcaneIcon.box(size: IconSize.sm),

      // Communication
      'mail' => ArcaneIcon.mail(size: IconSize.sm),
      'message-circle' => ArcaneIcon.messageCircle(size: IconSize.sm),
      'message-square' => ArcaneIcon.messageSquare(size: IconSize.sm),
      'headphones' => ArcaneIcon.headphones(size: IconSize.sm),
      'phone' => ArcaneIcon.phone(size: IconSize.sm),
      'bell' => ArcaneIcon.bell(size: IconSize.sm),

      // Status & Monitoring
      'activity' => ArcaneIcon.activity(size: IconSize.sm),
      'bar-chart' => ArcaneIcon.chartBar(size: IconSize.sm),
      'line-chart' => ArcaneIcon.chartLine(size: IconSize.sm),
      'pie-chart' => ArcaneIcon.chartPie(size: IconSize.sm),
      'gauge' => ArcaneIcon.gauge(size: IconSize.sm),
      'clock' => ArcaneIcon.clock(size: IconSize.sm),
      'timer' => ArcaneIcon.timer(size: IconSize.sm),
      'refresh-cw' => ArcaneIcon.refreshCw(size: IconSize.sm),
      'rotate-cw' => ArcaneIcon.rotateCw(size: IconSize.sm),
      'loader' => ArcaneIcon.loader(size: IconSize.sm),

      // Money & Billing
      'credit-card' => ArcaneIcon.creditCard(size: IconSize.sm),
      'dollar-sign' => ArcaneIcon.dollarSign(size: IconSize.sm),
      'receipt' => ArcaneIcon.receipt(size: IconSize.sm),
      'wallet' => ArcaneIcon.wallet(size: IconSize.sm),
      'coins' => ArcaneIcon.coins(size: IconSize.sm),
      'banknote' => ArcaneIcon.banknote(size: IconSize.sm),

      // Users
      'user' => ArcaneIcon.user(size: IconSize.sm),
      'users' => ArcaneIcon.users(size: IconSize.sm),
      'user-plus' => ArcaneIcon.userPlus(size: IconSize.sm),
      'user-check' => ArcaneIcon.userCheck(size: IconSize.sm),
      'user-cog' => ArcaneIcon.userCog(size: IconSize.sm),

      // Misc
      'layers' => ArcaneIcon.layers(size: IconSize.sm),
      'layout' => ArcaneIcon.layoutGrid(size: IconSize.sm),
      'grid' => ArcaneIcon.grid3x3(size: IconSize.sm),
      'sparkles' => ArcaneIcon.sparkles(size: IconSize.sm),
      'star' => ArcaneIcon.star(size: IconSize.sm),
      'heart' => ArcaneIcon.heart(size: IconSize.sm),
      'flag' => ArcaneIcon.flag(size: IconSize.sm),
      'bookmark' => ArcaneIcon.bookmark(size: IconSize.sm),
      'tag' => ArcaneIcon.tag(size: IconSize.sm),
      'tags' => ArcaneIcon.tags(size: IconSize.sm),
      'info' => ArcaneIcon.info(size: IconSize.sm),

      // Alerts & Info
      'alert-triangle' => ArcaneIcon.triangleAlert(size: IconSize.sm),
      'alert-circle' => ArcaneIcon.circleAlert(size: IconSize.sm),
      'help-circle' => ArcaneIcon.help(size: IconSize.sm),
      'check' => ArcaneIcon.check(size: IconSize.sm),
      'check-circle' => ArcaneIcon.circleCheck(size: IconSize.sm),
      'x' => ArcaneIcon.x(size: IconSize.sm),
      'x-circle' => ArcaneIcon.circleX(size: IconSize.sm),

      // Arrows
      'arrow-right' => ArcaneIcon.arrowRight(size: IconSize.sm),
      'arrow-left' => ArcaneIcon.arrowLeft(size: IconSize.sm),
      'arrow-up' => ArcaneIcon.arrowUp(size: IconSize.sm),
      'arrow-down' => ArcaneIcon.arrowDown(size: IconSize.sm),
      'chevron-right' => ArcaneIcon.chevronRight(size: IconSize.sm),
      'chevron-left' => ArcaneIcon.chevronLeft(size: IconSize.sm),
      'chevron-up' => ArcaneIcon.chevronUp(size: IconSize.sm),
      'chevron-down' => ArcaneIcon.chevronDown(size: IconSize.sm),
      'external-link' => ArcaneIcon.externalLink(size: IconSize.sm),
      'link' => ArcaneIcon.link(size: IconSize.sm),

      // Actions
      'download' => ArcaneIcon.download(size: IconSize.sm),
      'upload' => ArcaneIcon.upload(size: IconSize.sm),
      'copy' => ArcaneIcon.copy(size: IconSize.sm),
      'clipboard' => ArcaneIcon.clipboard(size: IconSize.sm),
      'trash' => ArcaneIcon.trash(size: IconSize.sm),
      'trash-2' => ArcaneIcon.trash2(size: IconSize.sm),
      'edit' => ArcaneIcon.edit(size: IconSize.sm),
      'pencil' => ArcaneIcon.pencil(size: IconSize.sm),
      'save' => ArcaneIcon.save(size: IconSize.sm),
      'plus' => ArcaneIcon.plus(size: IconSize.sm),
      'minus' => ArcaneIcon.minus(size: IconSize.sm),
      'search' => ArcaneIcon.search(size: IconSize.sm),
      'filter' => ArcaneIcon.filter(size: IconSize.sm),
      'eye' => ArcaneIcon.eye(size: IconSize.sm),
      'eye-off' => ArcaneIcon.eyeOff(size: IconSize.sm),

      // Support & Help
      'life-buoy' => ArcaneIcon.lifeBuoy(size: IconSize.sm),
      'help' => ArcaneIcon.help(size: IconSize.sm),

      // Power & Control
      'power' => ArcaneIcon.power(size: IconSize.sm),
      'plug' => ArcaneIcon.plug(size: IconSize.sm),
      'plug-zap' => ArcaneIcon.plugZap(size: IconSize.sm),
      'battery' => ArcaneIcon.battery(size: IconSize.sm),

      // World & Location
      'map-pin' => ArcaneIcon.mapPin(size: IconSize.sm),
      'building' => ArcaneIcon.building(size: IconSize.sm),
      'building-2' => ArcaneIcon.building2(size: IconSize.sm),

      // Default fallback
      _ => ArcaneIcon.fileText(size: IconSize.sm),
    };
  }

  bool _isActive(String path) {
    return currentPath == path ||
        currentPath == '$path/' ||
        (path != '/' && currentPath.startsWith('$path/'));
  }
}
