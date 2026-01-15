# Arcane Inkwell

Transform markdown into documentation sites. Built on [Jaspr](https://github.com/schultek/jaspr) and [arcane_jaspr](https://github.com/ArcaneArts/arcane_jaspr).

**[Live Demo](https://arcanearts.github.io/arcane_inkwell/)** | **[GitHub](https://github.com/ArcaneArts/arcane_inkwell)**

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
      ),
      // Single line theming - swap themes instantly:
      stylesheet: const ShadcnStylesheet(theme: ShadcnTheme.charcoal),
    ),
  );
}
```

## Features

| Category | Capabilities |
|----------|--------------|
| **Navigation** | Auto-generated sidebar, breadcrumbs, prev/next links, TOC |
| **Content** | Markdown, code highlighting, copy button, callouts, tables |
| **Metadata** | Tags, reading time, author, date, draft mode |
| **Search** | Full-text search with content indexing |
| **Theming** | 1-line theme swap, dark/light toggle, ShadCN styling |
| **Structure** | Nested folders, section configs, icons, ordering |

## Content Structure

```
content/
├── index.md                 # Homepage
├── getting-started/
│   ├── _section.json5       # { "title": "Getting Started", "icon": "rocket" }
│   ├── index.md
│   └── installation.md
└── api/
    └── endpoints/
        └── users.md
```

## Page Frontmatter

```yaml
---
title: Installation
description: How to install
icon: download
order: 1
tags: [setup, install]
author: John Doe
date: 2025-01-01
draft: false
hidden: false
---
```

## Section Config (`_section.json5`)

```json5
{
  "title": "Getting Started",
  "icon": "rocket",
  "order": 1,
  "collapsed": false,
  "ignore": false
}
```

## Callouts

```markdown
> [!NOTE]
> Informational callout

> [!TIP]
> Helpful tip

> [!WARNING]
> Warning message

> [!CAUTION]
> Danger alert
```

## Site Configuration

```dart
SiteConfig(
  name: 'Site Name',
  description: 'Site description',
  contentDirectory: 'content',
  baseUrl: '/docs',                    // Subdirectory hosting
  githubUrl: 'https://github.com/...',
  showEditLink: true,
  defaultTheme: KBThemeMode.dark,
  searchEnabled: true,
  tocEnabled: true,
  themeToggleEnabled: true,
  headerLinks: [NavLink(label: 'GitHub', href: '...', external: true)],
  footerText: 'Built with Arcane Inkwell',
)
```

## Build

```bash
jaspr serve              # Development
jaspr build              # Production
jaspr build --define=BASE_URL=/docs  # Subdirectory
```

## Installation

```yaml
dependencies:
  arcane_inkwell:
    git:
      url: https://github.com/ArcaneArts/arcane_inkwell
```

## Related Projects

| Project | Path | Description |
|---------|------|-------------|
| **QualityNode Web** | `/Users/brianfopiano/Developer/RemoteGit/QualityNodeLLC/QualityNode-web` | Main Arcane Jaspr website |
| **QualityNode Knowledgebase** | `/Users/brianfopiano/Developer/RemoteGit/QualityNodeLLC/Qualitynode-Knowledgebase` | Arcane Inkwell documentation site |
| **arcane_jaspr** | `/Users/brianfopiano/Developer/RemoteGit/ArcaneArts/arcane_jaspr` | Jaspr UI library for all apps |
| **arcane_inkwell** | `/Users/brianfopiano/Developer/RemoteGit/ArcaneArts/arcane_inkwell` | Library that generates sites from markdown |

## License

GPL-3.0
