import 'package:arcane_jaspr/arcane_jaspr.dart' hide TableOfContents;
import 'package:jaspr_content/jaspr_content.dart';

/// Table of contents component.
class KBToc extends StatelessComponent {
  final TableOfContents toc;

  const KBToc({required this.toc});

  @override
  Component build(BuildContext context) {
    return ArcaneDiv(
      classes: 'kb-toc',
      styles: const ArcaneStyleData(
        position: Position.sticky,
        top: '80px',
        widthCustom: '240px',
        maxHeight: 'calc(100vh - 100px)',
        overflowY: OverflowAxis.auto,
        padding: PaddingPreset.lg,
      ),
      children: [
        const ArcaneDiv(
          classes: 'kb-toc-title',
          styles: ArcaneStyleData(
            fontWeight: FontWeight.w600,
            fontSize: FontSize.sm,
            textColor: TextColor.primary,
            margin: MarginPreset.bottomMd,
          ),
          children: [ArcaneText('On this page')],
        ),
        // Wrap in toc-content for scroll tracking
        ArcaneDiv(
          classes: 'toc-content sidebar-tree-nav',
          children: [toc.build()],
        ),
      ],
    );
  }
}

/// Simple TOC builder for when jaspr_content TOC is not available.
class SimpleTocBuilder {
  /// Build a TOC component from a list of headings.
  static Component build(List<TocHeading> headings) {
    return ArcaneDiv(
      classes: 'kb-toc-list sidebar-tree-items',
      styles: const ArcaneStyleData(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.xs,
      ),
      children: headings
          .map((TocHeading heading) => ArcaneDiv(
                classes: 'kb-toc-item sidebar-tree-item depth-${heading.depth}',
                styles: ArcaneStyleData(
                  paddingStringCustom: '0 0 0 16px',
                  marginStringCustom: heading.depth > 2 ? '0 0 0 16px' : null,
                ),
                children: [
                  ArcaneLink(
                    href: '#${heading.id}',
                    classes: 'kb-toc-link',
                    styles: const ArcaneStyleData(
                      textColor: TextColor.mutedForeground,
                      fontSize: FontSize.sm,
                      textDecoration: TextDecoration.none,
                    ),
                    child: ArcaneText(heading.text),
                  ),
                ],
              ))
          .toList(),
    );
  }
}

/// Represents a heading for the table of contents.
class TocHeading {
  final String id;
  final String text;
  final int depth;

  const TocHeading({
    required this.id,
    required this.text,
    required this.depth,
  });
}