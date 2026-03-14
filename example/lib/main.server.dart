/// The entrypoint for the **server** app (static generation).
library;

import 'package:jaspr/server.dart';
import 'package:arcane_lexicon/arcane_lexicon.dart' hide runApp;

import 'main.server.options.dart';

void main() async {
  Jaspr.initializeApp(options: defaultServerOptions);

  runApp(
    await KnowledgeBaseApp.create(
      config: const SiteConfig(
        name: 'Example Docs',
        description: 'Arcane Lexicon demo site',
        contentDirectory: 'content',
        githubUrl: 'https://github.com/ArcaneArts/arcane_lexicon',
        showEditLink: true,
        editBranch: 'main',
        navigationBarEnabled: true,
        navigationBarPosition: KBNavigationBarPosition.top,
        headerLinks: [
          NavLink(label: 'Docs', href: '/'),
          NavLink(
            label: 'GitHub',
            href: 'https://github.com/ArcaneArts/arcane_lexicon',
            external: true,
          ),
        ],
        footerText: 'Built with Arcane Lexicon',
        sidebarFooter: 'v1.0.0',
        sidebarFooterUrl:
            'https://github.com/ArcaneArts/arcane_lexicon/releases',
      ),
      // Single line theming - swap themes by changing this line:
      // stylesheet: const CodexStylesheet(theme: CodexTheme.blue),
      stylesheet: const ShadcnStylesheet(theme: ShadcnTheme.midnight),
    ),
  );
}
