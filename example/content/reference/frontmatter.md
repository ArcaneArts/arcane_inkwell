---
title: Frontmatter Reference
description: Page-level frontmatter options recognized by Arcane Inkwell
icon: file-text
order: 2
tags:
  - configuration
  - reference
  - markdown
author: Arcane Arts
date: 2026-03-03
---

Frontmatter is YAML metadata at the top of markdown files.

## Basic Example

```yaml
---
layout: kb
title: Installation
description: Install and run Arcane Inkwell
icon: rocket
order: 1
---
```

## Full Example

```yaml
---
layout: kb
title: Authentication Guide
description: Complete guide to implementing authentication
icon: shield
order: 5
hidden: false
draft: false
pageNav: true
tags:
  - security
  - authentication
author: Jane Developer
date: 2026-03-03
component: AuthDemo
---
```

## Supported Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `layout` | `String` | none | Use `kb` for the Arcane Inkwell layout |
| `title` | `String?` | filename-derived title | Page title |
| `description` | `String?` | `null` | Page summary/meta description |
| `icon` | `String?` | `null` | Icon name, SVG URL, or raw SVG markup |
| `order` | `int` | `999` | Sort order within section |
| `hidden` | `bool` | `false` | Hide from navigation but keep URL accessible |
| `draft` | `bool` | `false` | Hide from nav and mark page as draft |
| `tags` | `List<String>` | `[]` | Tags for metadata/search-index enrichment |
| `author` | `String?` | `null` | Author shown in metadata row |
| `date` | `String?` | `null` | Date shown in metadata row |
| `component` | `String?` | `null` | DemoBuilder component key |
| `pageNav` | `bool` or `'true'/'false'` | inherits `SiteConfig.pageNavEnabled` | Per-page footer prev/next override |

## Generated Data Fields

These are added by runtime extensions/layout processing:

| Field | Source | Description |
|-------|--------|-------------|
| `readingTime` | `ReadingTimeExtension` | Estimated read time in minutes |
| `wordCount` | `ReadingTimeExtension` | Parsed word count |
| `toc` | `TableOfContentsExtension` | Table of contents structure |
| `lastModified` | NavBuilder file stat | Last modified timestamp (ISO-8601) |

## Visibility Flags

### `hidden: true`

- Hidden from sidebar/nav manifests.
- Still directly routable if URL is known.

### `draft: true`

- Hidden from navigation.
- Marked with draft badge where applicable.
- Excluded from search index generation and sitemap utilities when those utilities are used.

## Ordering

Sort behavior:

1. `order` ascending.
2. `title` alphabetical for ties.

## Filename Title Fallback

When `title` is missing, title is derived from filename.

| Filename | Generated Title |
|----------|-----------------|
| `getting-started.md` | `Getting Started` |
| `api_reference.md` | `Api Reference` |
| `quick-start.md` | `Quick Start` |

## Notes

- Keep `tags` as a YAML list for reliable parsing.
- `previous`/`next` frontmatter links are not currently consumed by the default `KBPageNav`; navigation order is derived from manifest ordering.

