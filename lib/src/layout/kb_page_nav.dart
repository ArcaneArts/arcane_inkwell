import 'package:arcane_jaspr/arcane_jaspr.dart' hide TableOfContents;

import '../config/site_config.dart';
import '../navigation/nav_item.dart';
import '../navigation/nav_section.dart';
import '../navigation/nav_builder.dart';

/// Navigation item with title and path for prev/next links.
class PageNavLink {
  final String title;
  final String path;

  const PageNavLink({required this.title, required this.path});
}

/// Page navigation component showing previous and next articles.
class KBPageNav extends StatelessComponent {
  final SiteConfig config;
  final NavManifest manifest;
  final String currentPath;

  const KBPageNav({
    required this.config,
    required this.manifest,
    required this.currentPath,
  });

  @override
  Component build(BuildContext context) {
    // Get flat list of all pages
    final List<PageNavLink> allPages = _flattenPages();
    if (allPages.isEmpty) return const ArcaneDiv(children: []);

    // Find current page index
    final int currentIndex = allPages.indexWhere(
      (PageNavLink p) =>
          p.path == currentPath ||
          p.path == '$currentPath/' ||
          '${p.path}/' == currentPath,
    );

    if (currentIndex == -1) return const ArcaneDiv(children: []);

    // Get prev/next
    final PageNavLink? prevPage =
        currentIndex > 0 ? allPages[currentIndex - 1] : null;
    final PageNavLink? nextPage =
        currentIndex < allPages.length - 1 ? allPages[currentIndex + 1] : null;

    if (prevPage == null && nextPage == null) {
      return const ArcaneDiv(children: []);
    }

    return ArcaneDiv(
      classes: 'kb-page-nav',
      styles: const ArcaneStyleData(
        display: Display.flex,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        gap: Gap.lg,
        margin: MarginPreset.topXl,
        padding: PaddingPreset.topLg,
        borderTop: BorderPreset.subtle,
      ),
      children: [
        // Previous link
        if (prevPage != null)
          ArcaneLink(
            href: config.fullPath(prevPage.path),
            classes: 'kb-page-nav-link kb-page-nav-prev',
            styles: const ArcaneStyleData(
              display: Display.flex,
              flexDirection: FlexDirection.column,
              gap: Gap.xs,
              padding: PaddingPreset.md,
              border: BorderPreset.subtle,
              borderRadius: Radius.md,
              flex: FlexPreset.expand,
              textDecoration: TextDecoration.none,
            ),
            child: ArcaneColumn(
              gapSize: Gap.xs,
              children: [
                ArcaneRow(
                  gapSize: Gap.xs,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ArcaneIcon.arrowLeft(size: IconSize.sm),
                    ArcaneDiv(
                      styles: const ArcaneStyleData(
                        fontSize: FontSize.sm,
                        textColor: TextColor.mutedForeground,
                      ),
                      children: [ArcaneText('Previous')],
                    ),
                  ],
                ),
                ArcaneDiv(
                  styles: const ArcaneStyleData(
                    fontWeight: FontWeight.w500,
                    textColor: TextColor.primary,
                  ),
                  children: [ArcaneText(prevPage.title)],
                ),
              ],
            ),
          )
        else
          const ArcaneDiv(
            classes: 'kb-page-nav-spacer',
            styles: ArcaneStyleData(flex: FlexPreset.expand),
            children: [],
          ),

        // Next link
        if (nextPage != null)
          ArcaneLink(
            href: config.fullPath(nextPage.path),
            classes: 'kb-page-nav-link kb-page-nav-next',
            styles: const ArcaneStyleData(
              display: Display.flex,
              flexDirection: FlexDirection.column,
              crossAxisAlignment: CrossAxisAlignment.end,
              gap: Gap.xs,
              padding: PaddingPreset.md,
              border: BorderPreset.subtle,
              borderRadius: Radius.md,
              flex: FlexPreset.expand,
              textAlign: TextAlign.right,
              textDecoration: TextDecoration.none,
            ),
            child: ArcaneColumn(
              gapSize: Gap.xs,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ArcaneRow(
                  gapSize: Gap.xs,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ArcaneDiv(
                      styles: const ArcaneStyleData(
                        fontSize: FontSize.sm,
                        textColor: TextColor.mutedForeground,
                      ),
                      children: [ArcaneText('Next')],
                    ),
                    ArcaneIcon.arrowRight(size: IconSize.sm),
                  ],
                ),
                ArcaneDiv(
                  styles: const ArcaneStyleData(
                    fontWeight: FontWeight.w500,
                    textColor: TextColor.primary,
                  ),
                  children: [ArcaneText(nextPage.title)],
                ),
              ],
            ),
          )
        else
          const ArcaneDiv(
            classes: 'kb-page-nav-spacer',
            styles: ArcaneStyleData(flex: FlexPreset.expand),
            children: [],
          ),
      ],
    );
  }

  /// Flatten the navigation manifest into an ordered list of pages.
  List<PageNavLink> _flattenPages() {
    final List<PageNavLink> pages = [];

    // Add root items
    for (final NavItem item in manifest.sortedItems) {
      if (!item.hidden) {
        pages.add(PageNavLink(title: item.title, path: item.path));
      }
    }

    // Add sections recursively
    for (final NavSection section in manifest.sortedSections) {
      _flattenSection(section, pages);
    }

    return pages;
  }

  void _flattenSection(NavSection section, List<PageNavLink> pages) {
    // Add items in this section
    for (final NavItem item in section.sortedItems) {
      if (!item.hidden) {
        pages.add(PageNavLink(title: item.title, path: item.path));
      }
    }

    // Add nested sections
    for (final NavSection nested in section.sortedSections) {
      _flattenSection(nested, pages);
    }
  }
}

/// Subpages component that shows child pages of the current page.
class KBSubpages extends StatelessComponent {
  final SiteConfig config;
  final NavManifest manifest;
  final String currentPath;

  const KBSubpages({
    required this.config,
    required this.manifest,
    required this.currentPath,
  });

  @override
  Component build(BuildContext context) {
    // Find section matching current path
    final NavSection? currentSection = _findSection(manifest.sections);
    if (currentSection == null) return const ArcaneDiv(children: []);

    final List<NavItem> subpages = currentSection.visibleItems;
    final List<NavSection> subsections = currentSection.sortedSections;

    if (subpages.isEmpty && subsections.isEmpty) {
      return const ArcaneDiv(children: []);
    }

    return ArcaneDiv(
      classes: 'kb-subpages',
      styles: const ArcaneStyleData(
        margin: MarginPreset.bottomXl,
      ),
      children: [
        ArcaneDiv(
          classes: 'kb-subpages-title',
          styles: const ArcaneStyleData(
            fontWeight: FontWeight.w600,
            fontSize: FontSize.sm,
            textColor: TextColor.mutedForeground,
            margin: MarginPreset.bottomMd,
          ),
          children: [ArcaneText('In this section')],
        ),
        ArcaneDiv(
          classes: 'kb-subpages-grid',
          styles: const ArcaneStyleData(
            display: Display.grid,
            gap: Gap.md,
          ),
          children: [
            // Child pages
            ...subpages.map((NavItem item) => ArcaneLink(
                  href: config.fullPath(item.path),
                  classes: 'kb-subpage-card',
                  styles: const ArcaneStyleData(
                    display: Display.flex,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    gap: Gap.md,
                    padding: PaddingPreset.md,
                    border: BorderPreset.subtle,
                    borderRadius: Radius.md,
                    background: Background.surface,
                    textDecoration: TextDecoration.none,
                  ),
                  child: ArcaneRow(
                    gapSize: Gap.md,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (item.icon != null)
                        ArcaneDiv(
                          styles: const ArcaneStyleData(
                            textColor: TextColor.primary,
                          ),
                          children: [_buildIcon(item.icon!)],
                        ),
                      ArcaneDiv(
                        styles: const ArcaneStyleData(
                          flex: FlexPreset.expand,
                        ),
                        children: [
                          ArcaneDiv(
                            styles: const ArcaneStyleData(
                              fontWeight: FontWeight.w500,
                              textColor: TextColor.primary,
                            ),
                            children: [ArcaneText(item.title)],
                          ),
                          if (item.description != null)
                            ArcaneDiv(
                              styles: const ArcaneStyleData(
                                fontSize: FontSize.sm,
                                textColor: TextColor.mutedForeground,
                              ),
                              children: [ArcaneText(item.description!)],
                            ),
                        ],
                      ),
                      ArcaneDiv(
                        styles: const ArcaneStyleData(
                          textColor: TextColor.mutedForeground,
                        ),
                        children: [ArcaneIcon.arrowRight(size: IconSize.sm)],
                      ),
                    ],
                  ),
                )),
            // Child sections
            ...subsections.map((NavSection section) => ArcaneLink(
                  href: config.fullPath(section.path),
                  classes: 'kb-subpage-card kb-subpage-section',
                  styles: const ArcaneStyleData(
                    display: Display.flex,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    gap: Gap.md,
                    padding: PaddingPreset.md,
                    border: BorderPreset.subtle,
                    borderRadius: Radius.md,
                    background: Background.surface,
                    textDecoration: TextDecoration.none,
                  ),
                  child: ArcaneRow(
                    gapSize: Gap.md,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (section.icon != null)
                        ArcaneDiv(
                          styles: const ArcaneStyleData(
                            textColor: TextColor.primary,
                          ),
                          children: [_buildIcon(section.icon!)],
                        ),
                      ArcaneDiv(
                        styles: const ArcaneStyleData(
                          flex: FlexPreset.expand,
                        ),
                        children: [
                          ArcaneDiv(
                            styles: const ArcaneStyleData(
                              fontWeight: FontWeight.w500,
                              textColor: TextColor.primary,
                            ),
                            children: [ArcaneText(section.title)],
                          ),
                          ArcaneDiv(
                            styles: const ArcaneStyleData(
                              fontSize: FontSize.sm,
                              textColor: TextColor.mutedForeground,
                            ),
                            children: [
                              ArcaneText('${section.items.length} pages'),
                            ],
                          ),
                        ],
                      ),
                      ArcaneDiv(
                        styles: const ArcaneStyleData(
                          textColor: TextColor.mutedForeground,
                        ),
                        children: [ArcaneIcon.chevronRight(size: IconSize.sm)],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ],
    );
  }

  NavSection? _findSection(List<NavSection> sections) {
    for (final NavSection section in sections) {
      if (section.path == currentPath ||
          section.path == '$currentPath/' ||
          '${section.path}/' == currentPath) {
        return section;
      }
      final NavSection? found = _findSection(section.sections);
      if (found != null) return found;
    }
    return null;
  }

  Component _buildIcon(String iconName) {
    return switch (iconName) {
      'rocket' => ArcaneIcon.rocket(size: IconSize.md),
      'server' => ArcaneIcon.server(size: IconSize.md),
      'database' => ArcaneIcon.database(size: IconSize.md),
      'shield' => ArcaneIcon.shield(size: IconSize.md),
      'code' => ArcaneIcon.code(size: IconSize.md),
      'terminal' => ArcaneIcon.terminal(size: IconSize.md),
      'settings' => ArcaneIcon.settings(size: IconSize.md),
      'book' => ArcaneIcon.book(size: IconSize.md),
      'file-text' => ArcaneIcon.fileText(size: IconSize.md),
      'folder' => ArcaneIcon.folder(size: IconSize.md),
      'sliders' => ArcaneIcon.slidersHorizontal(size: IconSize.md),
      'life-buoy' => ArcaneIcon.lifeBuoy(size: IconSize.md),
      _ => ArcaneIcon.fileText(size: IconSize.md),
    };
  }
}
