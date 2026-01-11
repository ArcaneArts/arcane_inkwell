import 'package:arcane_jaspr/arcane_jaspr.dart' hide TableOfContents;

import '../config/site_config.dart';
import '../navigation/nav_item.dart';

/// Breadcrumbs navigation component using ArcaneBreadcrumbs.
class KBBreadcrumbs extends StatelessComponent {
  final SiteConfig config;
  final String currentPath;

  const KBBreadcrumbs({
    required this.config,
    required this.currentPath,
  });

  @override
  Component build(BuildContext context) {
    final List<BreadcrumbItem> items = _buildItems();

    if (items.isEmpty) {
      return const ArcaneDiv(children: []);
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

  List<BreadcrumbItem> _buildItems() {
    if (currentPath == '/' || currentPath.isEmpty) {
      return <BreadcrumbItem>[];
    }

    final List<BreadcrumbItem> items = <BreadcrumbItem>[
      BreadcrumbItem(label: 'Home', href: config.fullPath('/')),
    ];

    final List<String> segments = currentPath
        .split('/')
        .where((String s) => s.isNotEmpty)
        .toList();

    String pathSoFar = '';
    for (int i = 0; i < segments.length; i++) {
      pathSoFar += '/${segments[i]}';
      final bool isLast = i == segments.length - 1;

      items.add(BreadcrumbItem(
        label: NavItem.filenameToTitle(segments[i]),
        href: isLast ? null : config.fullPath(pathSoFar),
      ));
    }

    return items;
  }
}