/// The entrypoint for the **server** app (static generation).
library;

import 'package:jaspr/server.dart';
import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_md/arcane_jaspr_md.dart' hide runApp;

import 'main.server.options.dart';

void main() async {
  Jaspr.initializeApp(options: defaultServerOptions);

  runApp(
    await KnowledgeBaseApp.create(
      config: const SiteConfig(
        name: 'Example Docs',
        description: 'Arcane Jaspr MD demo site',
        contentDirectory: 'content',
        githubUrl: 'https://github.com/ArcaneArts/arcane_jaspr_md',
        headerLinks: [
          NavLink(label: 'Docs', href: '/'),
          NavLink(
              label: 'GitHub',
              href: 'https://github.com/ArcaneArts/arcane_jaspr_md',
              external: true),
        ],
        footerText: 'Built with arcane_jaspr_md',
        sidebarFooter: 'v1.0.0',
        sidebarFooterUrl: 'https://github.com/ArcaneArts/arcane_jaspr_md/releases',
      ),
      // Use ShadcnStylesheet as the base (this is also the default)
      stylesheet: const KBStylesheet(base: CodexStylesheet(accent: CodexAccent.orange)),
    ),
  );
}
