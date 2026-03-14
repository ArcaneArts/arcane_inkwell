---
title: Arcane Lexicon
description: Transform markdown directories into documentation sites
order: 0
---

**Arcane Lexicon** transforms markdown content into a documentation site with generated navigation, rich markdown components, and one-line theming.

## Quick Start

```dart
import 'package:arcane_lexicon/arcane_lexicon.dart' hide runApp;

void main() async {
  Jaspr.initializeApp(options: defaultServerOptions);

  runApp(
    await KnowledgeBaseApp.create(
      config: const SiteConfig(
        name: 'My Docs',
        contentDirectory: 'content',
        githubUrl: 'https://github.com/your/repo',
      ),
      stylesheet: const ShadcnStylesheet(theme: ShadcnTheme.midnight),
    ),
  );
}
```

## Current Built-In Capabilities

- Auto-generated navigation from folder structure.
- Top/bottom navigation bar modes.
- Footer previous/next navigation with global and per-page toggles.
- Callout markdown + callout tag components.
- Rich markdown components (cards, steps, fields, tree, colors, tabs, and more).
- Syntax highlighting and code-copy buttons.
- Media embed extension (`@[youtube]`, `@[video]`, `@[image]`, etc.).
- Reading time and metadata row rendering.
- Optional generated `web/search-index.json` for external search integrations.

## Explore Documentation

| Section | Description |
|---------|-------------|
| [Guide](/guide) | Setup and workflow guides |
| [Features](/features) | Visual behavior and component showcases |
| [Reference](/reference) | API and implementation reference |

> [!TIP]
> Start with [Installation](/guide/basics/installation), then review [Rich Markdown Blocks](/features/rich-markdown).

