import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/html.dart' show ArcaneDiv;

class KBTagList extends StatelessWidget {
  final List<String> tags;
  final KBTagSize size;
  final bool showIcon;

  const KBTagList({
    required this.tags,
    this.size = KBTagSize.sm,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) => ArcaneDiv(
    classes: <String>['kb-tag-list kb-tag-list-${size.name}'],
    children: <Widget>[
      for (String tag in tags)
        KBTag(label: tag, size: size, showIcon: showIcon),
    ],
  );
}

class KBTag extends StatelessWidget {
  final String label;
  final KBTagSize size;
  final bool showIcon;

  const KBTag({
    required this.label,
    this.size = KBTagSize.sm,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) => ArcaneDiv(
    classes: <String>['kb-tag kb-tag-${size.name}'],
    children: <Widget>[
      if (showIcon) ArcaneIcon.tag(size: _iconSize),
      Text(label),
    ],
  );

  IconSize get _iconSize => switch (size) {
    KBTagSize.xs => IconSize.xs,
    KBTagSize.sm => IconSize.xs,
    KBTagSize.md => IconSize.sm,
  };
}

enum KBTagSize { xs, sm, md }
