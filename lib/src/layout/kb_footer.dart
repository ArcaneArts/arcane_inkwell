import 'package:arcane_jaspr/arcane_jaspr.dart' hide TableOfContents;

import '../config/site_config.dart';

/// Footer component for the knowledge base.
class KBFooter extends StatelessComponent {
  final SiteConfig config;

  const KBFooter({required this.config});

  @override
  Component build(BuildContext context) {
    return ArcaneDiv(
      classes: 'kb-footer',
      styles: const ArcaneStyleData(
        marginStringCustom: '0 0 0 280px',
        padding: PaddingPreset.xl,
        borderTop: BorderPreset.subtle,
        textColor: TextColor.mutedForeground,
        fontSize: FontSize.sm,
        textAlign: TextAlign.center,
      ),
      children: [
        if (config.footerText != null)
          ArcaneDiv(
            styles: const ArcaneStyleData(margin: MarginPreset.bottomSm),
            children: [ArcaneText(config.footerText!)],
          ),
        if (config.copyright != null)
          ArcaneDiv(
            styles: const ArcaneStyleData(margin: MarginPreset.bottomSm),
            children: [ArcaneText(config.copyright!)],
          ),
        if (config.socialLinks.isNotEmpty)
          ArcaneDiv(
            classes: 'kb-footer-social',
            styles: const ArcaneStyleData(
              display: Display.flex,
              mainAxisAlignment: MainAxisAlignment.center,
              gap: Gap.md,
              margin: MarginPreset.topMd,
            ),
            children: config.socialLinks
                .map((SocialLink link) => ArcaneLink.external(
                      href: link.url,
                      child: ArcaneText(link.name),
                    ))
                .toList(),
          ),
      ],
    );
  }
}
