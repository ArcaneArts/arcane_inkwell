import 'package:arcane_jaspr/arcane_jaspr.dart' hide TableOfContents;

import '../config/site_config.dart';
import '../navigation/nav_item.dart';
import '../navigation/nav_section.dart';
import '../navigation/nav_builder.dart';

/// Component that displays related pages based on shared tags.
class KBRelatedPages extends StatelessComponent {
  final SiteConfig config;
  final NavManifest manifest;
  final String currentPath;
  final List<String> currentTags;
  final int maxItems;

  const KBRelatedPages({
    required this.config,
    required this.manifest,
    required this.currentPath,
    required this.currentTags,
    this.maxItems = 3,
  });

  @override
  Component build(BuildContext context) {
    if (currentTags.isEmpty) return const ArcaneDiv(children: []);

    // Find all pages with at least one shared tag
    final List<_RelatedPage> relatedPages = _findRelatedPages();

    if (relatedPages.isEmpty) return const ArcaneDiv(children: []);

    return ArcaneDiv(
      classes: 'kb-related-pages',
      styles: const ArcaneStyleData(
        margin: MarginPreset.topXl,
        padding: PaddingPreset.topLg,
        borderTop: BorderPreset.subtle,
      ),
      children: [
        const ArcaneDiv(
          styles: ArcaneStyleData(
            fontWeight: FontWeight.w600,
            fontSize: FontSize.sm,
            textColor: TextColor.mutedForeground,
            margin: MarginPreset.bottomMd,
          ),
          children: [ArcaneText('Related Pages')],
        ),
        ArcaneDiv(
          classes: 'kb-related-grid',
          styles: const ArcaneStyleData(
            display: Display.grid,
            gap: Gap.md,
          ),
          children: relatedPages
              .take(maxItems)
              .map((_RelatedPage page) => _buildRelatedCard(page))
              .toList(),
        ),
      ],
    );
  }

  List<_RelatedPage> _findRelatedPages() {
    final List<_RelatedPage> results = [];
    final Set<String> currentTagSet = currentTags.toSet();

    // Collect all pages from manifest
    void collectFromItems(List<NavItem> items, String section) {
      for (final NavItem item in items) {
        if (item.path == currentPath) continue;
        if (item.hidden) continue;
        if (item.tags.isEmpty) continue;

        final Set<String> itemTagSet = item.tags.toSet();
        final Set<String> sharedTags = currentTagSet.intersection(itemTagSet);

        if (sharedTags.isNotEmpty) {
          results.add(_RelatedPage(
            title: item.title,
            path: item.path,
            description: item.description,
            sharedTags: sharedTags.toList(),
            relevance: sharedTags.length,
            section: section,
          ));
        }
      }
    }

    void collectFromSections(List<NavSection> sections, String parentSection) {
      for (final NavSection section in sections) {
        final String sectionPath = parentSection.isEmpty
            ? section.title
            : '$parentSection / ${section.title}';
        collectFromItems(section.items, sectionPath);
        collectFromSections(section.sections, sectionPath);
      }
    }

    // Collect from root items and sections
    collectFromItems(manifest.items, '');
    collectFromSections(manifest.sections, '');

    // Sort by relevance (most shared tags first)
    results.sort((a, b) => b.relevance.compareTo(a.relevance));

    return results;
  }

  Component _buildRelatedCard(_RelatedPage page) {
    return ArcaneLink(
      href: config.fullPath(page.path),
      classes: 'kb-related-card',
      styles: const ArcaneStyleData(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.xs,
        padding: PaddingPreset.md,
        background: Background.surface,
        border: BorderPreset.subtle,
        borderRadius: Radius.md,
        textDecoration: TextDecoration.none,
      ),
      child: ArcaneColumn(
        gapSize: Gap.xs,
        children: [
          ArcaneDiv(
            styles: const ArcaneStyleData(
              fontWeight: FontWeight.w500,
              textColor: TextColor.primary,
            ),
            children: [ArcaneText(page.title)],
          ),
          if (page.description != null)
            ArcaneDiv(
              styles: const ArcaneStyleData(
                fontSize: FontSize.sm,
                textColor: TextColor.mutedForeground,
              ),
              children: [
                ArcaneText(page.description!.length > 100
                    ? '${page.description!.substring(0, 100)}...'
                    : page.description!),
              ],
            ),
          ArcaneDiv(
            styles: const ArcaneStyleData(
              display: Display.flex,
              flexWrap: FlexWrap.wrap,
              gap: Gap.xs,
              margin: MarginPreset.topXs,
            ),
            children: page.sharedTags
                .map((String tag) => ArcaneDiv(
                      styles: const ArcaneStyleData(
                        fontSize: FontSize.xs,
                        padding: PaddingPreset.xs,
                        background: Background.muted,
                        borderRadius: Radius.sm,
                        textColor: TextColor.mutedForeground,
                      ),
                      children: [ArcaneText(tag)],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _RelatedPage {
  final String title;
  final String path;
  final String? description;
  final List<String> sharedTags;
  final int relevance;
  final String section;

  const _RelatedPage({
    required this.title,
    required this.path,
    this.description,
    required this.sharedTags,
    required this.relevance,
    required this.section,
  });
}