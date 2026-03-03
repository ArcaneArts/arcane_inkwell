# Arcane Inkwell

Transform markdown directories into documentation sites with Jaspr + Arcane stylesheets.

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
      stylesheet: const ShadcnStylesheet(theme: ShadcnTheme.charcoal),
    ),
  );
}
```

## What Ships by Default

- Generated nav from markdown folders/files.
- Sidebar + top/bottom navigation bar modes.
- Breadcrumbs and footer prev/next navigation.
- GitHub-style callout syntax with optional title.
- Media embed syntax (`@[youtube]`, `@[video]`, `@[image]`, etc.).
- Highlight.js code blocks with copy buttons.
- Reading time + metadata row.
- Optional build-time `web/search-index.json` generation.

## Default Rich Markdown Components

Registered through `KBRichMarkdownComponents.defaults()`:

- `CardGroup`, `Card`
- `Columns`, `Column`
- `Tiles`, `Tile`
- `Steps`, `Step`
- `AccordionGroup`, `Accordion`, `Expandable`
- `Badge`, `Banner`, `Panel`, `Frame`, `Update`
- `Tooltip`, `Icon`, `CodeGroup`
- `FieldGroup`, `ParamField`, `ResponseField`
- `Tree`, `Tree.Folder`, `Tree.File`
- `Color`, `Color.Item`
- `View`
- `Note`, `Tip`, `Warning`, `Info`, `Check`, `Caution`, `Important`
- `Tabs`, `TabItem`

## Page Frontmatter

```yaml
---
layout: kb
title: Installation
description: How to install
icon: download
order: 1
tags:
  - setup
author: Arcane Arts
date: 2026-03-03
pageNav: true
component: ExampleDemo
draft: false
hidden: false
---
```

## SiteConfig

```dart
SiteConfig(
  name: 'Site Name',
  contentDirectory: 'content',
  githubUrl: 'https://github.com/...',
  searchEnabled: true,
  tocEnabled: true,
  themeToggleEnabled: true,
  pageNavEnabled: true,
  navigationBarEnabled: true,
  navigationBarPosition: KBNavigationBarPosition.top,
  sidebarWidth: '280px',
  sidebarTreeIndent: '10px',
)
```

## Build

```bash
jaspr serve
jaspr build
jaspr build --define=BASE_URL=/docs
```

## Package Docs Coverage

Implementation-matching docs and showcases live in:

- `example/content/reference` (API + behavior reference)
- `example/content/features` (visual showcase pages)
- `example/content/guide` (workflow-oriented setup and utility usage)

## Installation

```yaml
dependencies:
  arcane_inkwell:
    git:
      url: https://github.com/ArcaneArts/arcane_inkwell
```

## License

GPL-3.0
