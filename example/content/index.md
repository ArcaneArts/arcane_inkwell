---
title: Arcane Inkwell
description: Transform markdown directories into beautiful documentation sites
order: 0
---

**Arcane Inkwell** transforms your markdown files into a fully-featured documentation website. Built on [Jaspr](https://github.com/schultek/jaspr) (Dart's web framework) with one-line theming via [arcane_jaspr](https://github.com/ArcaneArts/arcane_jaspr).

## Quick Start

```dart
import 'package:arcane_inkwell/arcane_inkwell.dart' hide runApp;

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

## Features

- **Auto-generated navigation** - Sidebar built from folder structure
- **GitHub-style callouts** - Note, Tip, Warning, Important, Caution blocks
- **Syntax highlighting** - Dart, JavaScript, YAML, and more
- **Dark/light themes** - One-line theming with multiple color options
- **Search** - Built-in client-side search
- **Table of contents** - Auto-generated from headings
- **Edit links** - Direct links to edit pages on GitHub
- **Reading time** - Automatic calculation
- **Related pages** - Tag-based discovery
- **Sitemap** - SEO-optimized XML sitemap

## Explore This Documentation

| Section | Description |
|---------|-------------|
| [Guide](/guide) | Getting started tutorials |
| [Features](/features) | Visual feature demonstrations |
| [Reference](/reference) | Complete API documentation |

## Configuration Options

See the [Reference](/reference) section for comprehensive documentation:

- [SiteConfig](/reference/site-config) - Site-level options
- [Frontmatter](/reference/frontmatter) - Page metadata
- [Section Config](/reference/section-config) - Folder configuration
- [Icons](/reference/icons) - 90+ available icons
- [Theming](/reference/theming) - Stylesheets and themes

> [!TIP]
> Start with the [Installation](/guide/basics/installation) guide to add Arcane Inkwell to your project.
