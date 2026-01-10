import 'package:arcane_jaspr/arcane_jaspr.dart' hide TableOfContents;

import '../config/site_config.dart';

/// The header component for the knowledge base.
class KBHeader extends StatelessComponent {
  final SiteConfig config;

  const KBHeader({required this.config});

  @override
  Component build(BuildContext context) {
    return ArcaneDiv(
      classes: 'kb-header',
      styles: const ArcaneStyleData(
        position: Position.fixed,
        top: '0',
        left: '0',
        right: '0',
        heightCustom: '64px',
        display: Display.flex,
        crossAxisAlignment: CrossAxisAlignment.center,
        padding: PaddingPreset.horizontalLg,
        background: Background.surface,
        borderBottom: BorderPreset.subtle,
        zIndexCustom: '50',
      ),
      children: [
        // Logo/site name
        ArcaneLink(
          href: config.fullPath('/'),
          styles: const ArcaneStyleData(
            display: Display.flex,
            crossAxisAlignment: CrossAxisAlignment.center,
            gap: Gap.md,
            fontWeight: FontWeight.w600,
            fontSize: FontSize.lg,
            textColor: TextColor.primary,
            textDecoration: TextDecoration.none,
          ),
          child: ArcaneRow(
            gapSize: Gap.md,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (config.logo != null) img(src: config.logo!, alt: config.name),
              ArcaneText(config.name),
            ],
          ),
        ),

        // Navigation links
        if (config.headerLinks.isNotEmpty)
          ArcaneDiv(
            styles: const ArcaneStyleData(
              display: Display.flex,
              crossAxisAlignment: CrossAxisAlignment.center,
              gap: Gap.lg,
              marginStringCustom: '0 0 0 32px',
            ),
            children: config.headerLinks
                .map((NavLink link) => link.external
                    ? ArcaneLink.external(
                        href: link.href,
                        styles: const ArcaneStyleData(
                          textColor: TextColor.onSurfaceVariant,
                          fontSize: FontSize.sm,
                          textDecoration: TextDecoration.none,
                        ),
                        child: ArcaneText(link.label),
                      )
                    : ArcaneLink(
                        href: config.fullPath(link.href),
                        styles: const ArcaneStyleData(
                          textColor: TextColor.onSurfaceVariant,
                          fontSize: FontSize.sm,
                          textDecoration: TextDecoration.none,
                        ),
                        child: ArcaneText(link.label),
                      ))
                .toList(),
          ),

        // Spacer
        const ArcaneDiv(
          styles: ArcaneStyleData(flexGrow: 1),
          children: [],
        ),

        // Actions
        ArcaneDiv(
          styles: const ArcaneStyleData(
            display: Display.flex,
            crossAxisAlignment: CrossAxisAlignment.center,
            gap: Gap.md,
          ),
          children: [
            // Search
            if (config.searchEnabled) _buildSearch(),

            // GitHub link
            if (config.githubUrl != null)
              ArcaneLink.external(
                href: config.githubUrl!,
                styles: const ArcaneStyleData(
                  display: Display.flex,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  widthCustom: '36px',
                  heightCustom: '36px',
                  textColor: TextColor.mutedForeground,
                  border: BorderPreset.subtle,
                  borderRadius: Radius.md,
                ),
                child: ArcaneIcon.github(size: IconSize.md),
              ),

            // Theme toggle
            if (config.themeToggleEnabled)
              ArcaneDiv(
                classes: 'kb-theme-toggle',
                styles: const ArcaneStyleData(
                  display: Display.flex,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  widthCustom: '36px',
                  heightCustom: '36px',
                  textColor: TextColor.mutedForeground,
                  border: BorderPreset.subtle,
                  borderRadius: Radius.md,
                  cursor: Cursor.pointer,
                ),
                children: [ArcaneIcon.sun(size: IconSize.md)],
              ),
          ],
        ),
      ],
    );
  }

  Component _buildSearch() {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        position: Position.relative,
      ),
      children: [
        ArcaneDiv(
          styles: const ArcaneStyleData(
            position: Position.absolute,
            left: '12px',
            top: '50%',
            transformCustom: 'translateY(-50%)',
            textColor: TextColor.mutedForeground,
          ),
          children: [ArcaneIcon.search(size: IconSize.sm)],
        ),
        input(
          type: InputType.text,
          attributes: {
            'placeholder': 'Search...',
            'class': 'kb-search-input',
            'style':
                'width: 240px; padding: 0.5rem 1rem 0.5rem 2.5rem; background: var(--arcane-muted); border: 1px solid var(--arcane-border); border-radius: var(--arcane-radius-md); color: var(--arcane-on-surface); font-size: 0.875rem;',
          },
        ),
      ],
    );
  }
}
