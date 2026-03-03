---
title: Configuration
description: Configure Arcane Inkwell site behavior
icon: settings
order: 2
tags:
  - configuration
  - getting-started
author: Arcane Arts
date: 2026-03-03
---

Arcane Inkwell configuration is split across:

1. `SiteConfig` (global behavior)
2. `_section.json5` / `_section.yaml` (folder sections)
3. page frontmatter (page-level metadata and overrides)

## SiteConfig

```dart
SiteConfig(
  name: 'My Docs',
  contentDirectory: 'content',
  githubUrl: 'https://github.com/your/repo',
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

See [SiteConfig Reference](/reference/site-config) for full option coverage.

## Section Config

`_section.json5` example:

```json5
{
  "title": "Getting Started",
  "icon": "rocket",
  "order": 1,
  "collapsed": false,
  "ignore": false
}
```

See [Section Configuration](/reference/section-config).

## Page Frontmatter

```yaml
---
layout: kb
title: My Page
description: Description text
icon: file-text
order: 1
tags:
  - getting-started
author: Arcane Arts
date: 2026-03-03
pageNav: true
component: ExampleDemo
---
```

See [Frontmatter Reference](/reference/frontmatter).

## Theme Selection

```dart
KnowledgeBaseApp.create(
  config: config,
  stylesheet: const ShadcnStylesheet(theme: ShadcnTheme.midnight),
  // or
  // stylesheet: const CodexStylesheet(theme: CodexTheme.blue),
)
```

## Directory Shape

```text
content/
  index.md
  guide/
    _section.json5
    index.md
    basics/
      _section.json5
      installation.md
      configuration.md
    advanced/
      _section.json5
      sitemap.md
  reference/
    _section.json5
    site-config.md
    components.md
```

