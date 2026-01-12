/// The entrypoint for the **server** app (static generation).
library;

import 'package:jaspr/server.dart';
import 'package:arcane_inkwell/arcane_inkwell.dart' hide runApp;

import 'main.server.options.dart';

void main() async {
  Jaspr.initializeApp(options: defaultServerOptions);

  runApp(
    await KnowledgeBaseApp.create(
      config: const SiteConfig(
        name: 'Example Docs',
        description: 'Arcane Inkwell demo site',
        contentDirectory: 'content',
        githubUrl: 'https://github.com/ArcaneArts/arcane_inkwell',
        showEditLink: true,
        editBranch: 'main',
        headerLinks: [
          NavLink(label: 'Docs', href: '/'),
          NavLink(
              label: 'GitHub',
              href: 'https://github.com/ArcaneArts/arcane_inkwell',
              external: true),
        ],
        footerText: 'Built with Arcane Inkwell',
        sidebarFooter: 'v1.0.0',
        sidebarFooterUrl: 'https://github.com/ArcaneArts/arcane_inkwell/releases',
      ),
      // Single line theming - swap themes by changing this line:
      stylesheet: const CodexStylesheet(theme: CodexTheme.purple),
      // stylesheet: const ShadcnStylesheet(theme: ShadcnTheme.midnight),
    ),
  );
}
