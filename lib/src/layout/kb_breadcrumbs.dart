import 'package:arcane_jaspr/arcane_jaspr.dart' hide TableOfContents;

import '../config/site_config.dart';
import '../navigation/nav_item.dart';

/// Breadcrumbs navigation component.
class KBBreadcrumbs extends StatelessComponent {
  final SiteConfig config;
  final String currentPath;

  const KBBreadcrumbs({
    required this.config,
    required this.currentPath,
  });

  @override
  Component build(BuildContext context) {
    final List<_Crumb> crumbs = _buildCrumbs();

    if (crumbs.isEmpty) {
      return const ArcaneDiv(children: []);
    }

    final List<Component> children = <Component>[];
    for (int i = 0; i < crumbs.length; i++) {
      if (i > 0) {
        children.add(ArcaneDiv(
          classes: 'kb-breadcrumbs-separator',
          styles: const ArcaneStyleData(
            textColor: TextColor.mutedForeground,
            paddingStringCustom: '0 4px',
          ),
          children: [ArcaneText('/')],
        ));
      }
      if (i < crumbs.length - 1) {
        children.add(ArcaneLink(
          href: crumbs[i].path,
          styles: const ArcaneStyleData(
            textColor: TextColor.mutedForeground,
            textDecoration: TextDecoration.none,
          ),
          child: ArcaneText(crumbs[i].title),
        ));
      } else {
        children.add(ArcaneDiv(
          styles: const ArcaneStyleData(
            textColor: TextColor.primary,
          ),
          children: [ArcaneText(crumbs[i].title)],
        ));
      }
    }

    return ArcaneDiv(
      classes: 'kb-breadcrumbs',
      styles: const ArcaneStyleData(
        display: Display.flex,
        crossAxisAlignment: CrossAxisAlignment.center,
        fontSize: FontSize.sm,
        margin: MarginPreset.bottomMd,
      ),
      children: children,
    );
  }

  List<_Crumb> _buildCrumbs() {
    if (currentPath == '/' || currentPath.isEmpty) {
      return <_Crumb>[];
    }

    final List<_Crumb> crumbs = <_Crumb>[
      _Crumb(title: 'Home', path: config.fullPath('/')),
    ];

    final List<String> segments = currentPath
        .split('/')
        .where((String s) => s.isNotEmpty)
        .toList();

    String pathSoFar = '';
    for (int i = 0; i < segments.length; i++) {
      pathSoFar += '/${segments[i]}';
      final bool isLast = i == segments.length - 1;

      crumbs.add(_Crumb(
        title: NavItem.filenameToTitle(segments[i]),
        path: isLast ? '' : config.fullPath(pathSoFar),
      ));
    }

    return crumbs;
  }
}

class _Crumb {
  final String title;
  final String path;

  const _Crumb({required this.title, required this.path});
}
