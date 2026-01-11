import 'package:arcane_jaspr/arcane_jaspr.dart' hide TableOfContents;

import '../config/site_config.dart';
import '../navigation/nav_item.dart';
import '../navigation/nav_section.dart';
import '../navigation/nav_builder.dart';

/// The sidebar navigation component using Arcane components.
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
      topOffset: '64px',
      showBorder: true,
      padding: '0',
      scrollPersistenceId: 'kb-sidebar',
      children: [
        // Header with site name
        ArcaneDiv(
          styles: const ArcaneStyleData(
            padding: PaddingPreset.md,
            borderBottom: BorderPreset.subtle,
          ),
          children: [
            ArcaneLink(
              href: config.fullPath('/'),
              styles: const ArcaneStyleData(
                textDecoration: TextDecoration.none,
              ),
              child: ArcaneDiv(
                styles: const ArcaneStyleData(
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.lg,
                  textColor: TextColor.primary,
                ),
                children: [ArcaneText(config.name)],
              ),
            ),
            if (config.description != null)
              ArcaneDiv(
                styles: const ArcaneStyleData(
                  fontSize: FontSize.sm,
                  textColor: TextColor.mutedForeground,
                  margin: MarginPreset.topXs,
                ),
                children: [ArcaneText(config.description!)],
              ),
          ],
        ),

        // Navigation
        ArcaneNav(
          styles: const ArcaneStyleData(
            padding: PaddingPreset.sm,
          ),
          children: [
            // Root-level items first (always visible, no section)
            if (manifest.visibleItems.isNotEmpty)
              _buildFixedSection(
                'Pages',
                ArcaneIcon.fileText(size: IconSize.sm),
                manifest.visibleItems.map((item) => _buildNavItem(item)).toList(),
              ),

            // Then sections
            ...manifest.sortedSections.map((section) => _buildSection(section)),
          ],
        ),

        // Sidebar footer (always at bottom)
        if (config.sidebarFooter != null)
          ArcaneDiv(
            classes: 'kb-sidebar-footer',
            styles: const ArcaneStyleData(
              margin: MarginPreset.topLg,
              padding: PaddingPreset.md,
              borderTop: BorderPreset.subtle,
              textColor: TextColor.mutedForeground,
              fontSize: FontSize.sm,
            ),
            children: [
              if (config.sidebarFooterUrl != null)
                config.sidebarFooterUrl!.startsWith('http')
                    ? ArcaneLink.external(
                        href: config.sidebarFooterUrl!,
                        child: ArcaneText(config.sidebarFooter!),
                      )
                    : ArcaneLink(
                        href: config.sidebarFooterUrl!,
                        child: ArcaneText(config.sidebarFooter!),
                      )
              else
                ArcaneText(config.sidebarFooter!),
            ],
          ),
      ],
    );
  }

  /// Build a fixed section that's always expanded (no toggle)
  Component _buildFixedSection(
      String title, Component icon, List<Component> items) {
    return ArcaneDiv(
      classes: 'sidebar-tree-nav',
      styles: const ArcaneStyleData(
        margin: MarginPreset.bottomMd,
      ),
      children: [
        // Section header
        ArcaneDiv(
          styles: const ArcaneStyleData(
            display: Display.flex,
            gap: Gap.sm,
            crossAxisAlignment: CrossAxisAlignment.center,
            fontSize: FontSize.xs,
            fontWeight: FontWeight.w500,
            padding: PaddingPreset.horizontalSm,
            margin: MarginPreset.bottomXs,
            textColor: TextColor.mutedForeground,
          ),
          children: [
            icon,
            ArcaneText(title),
          ],
        ),
        // Items with tree lines
        div(classes: 'sidebar-tree-items', [
          for (final item in items) div(classes: 'sidebar-tree-item sidebar-tree-leaf', [item]),
        ]),
      ],
    );
  }

  /// Build a collapsible section using ArcaneDisclosure
  Component _buildSection(NavSection section) {
    final bool shouldExpand =
        section.shouldExpandFor(currentPath) || !section.collapsed;

    return ArcaneDisclosure.minimal(
      open: shouldExpand,
      showTreeLines: false, // We use custom tree lines CSS
      summary: ArcaneRow(
        gapSize: Gap.sm,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (section.icon != null) _buildIcon(section.icon!),
          ArcaneDiv(
            styles: const ArcaneStyleData(
              fontSize: FontSize.xs,
              fontWeight: FontWeight.w500,
              textColor: TextColor.mutedForeground,
            ),
            children: [ArcaneText(section.title)],
          ),
        ],
      ),
      // Items with tree structure
      child: div(
        classes: 'sidebar-tree-items',
        attributes: {'data-path': section.path},
        [
          // Items in this section
          for (final item in section.visibleItems)
            div(classes: 'sidebar-tree-item sidebar-tree-leaf', [_buildNavItem(item)]),

          // Nested sections (folders)
          for (final nested in section.sortedSections)
            div(classes: 'sidebar-tree-item sidebar-tree-folder', [_buildSection(nested)]),
        ],
      ),
    );
  }

  /// Build a navigation item that links to a page
  Component _buildNavItem(NavItem item) {
    final bool isActive = _isActive(item.path);
    final String fullPath = config.fullPath(item.path);

    return ArcaneLink(
      href: fullPath,
      styles: ArcaneStyleData(
        display: Display.flex,
        gap: Gap.sm,
        fontSize: FontSize.sm,
        borderRadius: Radius.md,
        transition: Transition.allFast,
        crossAxisAlignment: CrossAxisAlignment.center,
        textDecoration: TextDecoration.none,
        padding: PaddingPreset.buttonSm,
        // Active state: accent color text with muted background
        textColor: isActive ? TextColor.accent : TextColor.mutedForeground,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        background: isActive ? Background.muted : Background.transparent,
        borderLeft: isActive ? BorderPreset.accentThick : null,
      ),
      child: ArcaneRow(
        gapSize: Gap.sm,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (item.icon != null) _buildIcon(item.icon!),
          ArcaneSpan(child: ArcaneText(item.title)),
        ],
      ),
    );
  }

  /// Map icon name strings to ArcaneIcon components.
  Component _buildIcon(String iconName) {
    // Map common icon names to ArcaneIcon methods
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
      'globe-2' => ArcaneIcon.globe(size: IconSize.sm),
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
      'fingerprint' => ArcaneIcon.scan(size: IconSize.sm),
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
      'code-2' => ArcaneIcon.code(size: IconSize.sm),
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
      'bar-chart-2' => ArcaneIcon.chartBar(size: IconSize.sm),
      'bar-chart-3' => ArcaneIcon.chartBar(size: IconSize.sm),
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

      // Arrows & Navigation
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
      'edit-2' => ArcaneIcon.pencil(size: IconSize.sm),
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
      'circle-help' => ArcaneIcon.help(size: IconSize.sm),

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
    // Exact match or with trailing slash
    return currentPath == path ||
        currentPath == '$path/' ||
        (path != '/' && currentPath.startsWith('$path/'));
  }
}
