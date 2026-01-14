---
title: Frontmatter Reference
description: All page-level frontmatter options for markdown files
icon: file-text
order: 2
tags:
  - configuration
  - reference
  - markdown
author: Arcane Arts
date: 2025-01-11
---

Frontmatter is YAML metadata at the top of your markdown files. It controls how pages appear in navigation and how they're rendered.

## Basic Example

```yaml
---
title: Getting Started
description: Learn how to install and configure Arcane Inkwell
icon: rocket
order: 1
---
```

## Full Example

```yaml
---
title: Authentication Guide
description: Complete guide to implementing authentication
icon: shield
order: 5
hidden: false
draft: false
tags:
  - security
  - authentication
  - guide
author: Jane Developer
date: 2024-01-15
component: AuthDemo
---
```

## All Options

### Page Metadata

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `title` | `String` | Filename | Display title for the page |
| `description` | `String?` | `null` | Page description (shown below title, used in meta tags) |
| `icon` | `String` | `null` | Icon name, SVG path, or raw SVG (see [Icons Reference](/reference/icons)) |
| `order` | `int` | `999` | Sort order within section (lower = first) |

### Visibility

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `hidden` | `bool` | `false` | Hide from navigation (page still accessible via URL) |
| `draft` | `bool` | `false` | Mark as draft (hidden from nav + shows draft badge) |

> [!TIP]
> Use `hidden: true` for pages you want to link to directly but not show in navigation.
> Use `draft: true` for work-in-progress pages that show a "Draft" indicator.

### Categorization

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `tags` | `List<String>` | `[]` | Tags for categorization and related pages |
| `author` | `String?` | `null` | Author name (displayed in page metadata) |
| `date` | `String?` | `null` | Publication date (displayed in page metadata) |

### Advanced

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `component` | `String?` | `null` | Component name for DemoBuilder integration |

## Auto-Generated Fields

These fields are automatically added by extensions and available in templates:

| Field | Source | Description |
|-------|--------|-------------|
| `readingTime` | `ReadingTimeExtension` | Estimated reading time in minutes |
| `wordCount` | `ReadingTimeExtension` | Total word count |
| `toc` | `TableOfContentsExtension` | Table of contents from headings |
| `lastModified` | File system | File's last modified timestamp (automatic) |

> [!NOTE]
> The `lastModified` date is automatically tracked from the file system. This shows when the markdown file was last edited, separate from any `date` field you set manually.

## Title Fallback

If no `title` is specified in frontmatter, the filename is converted to a title:

| Filename | Generated Title |
|----------|-----------------|
| `getting-started.md` | Getting Started |
| `api_reference.md` | Api Reference |
| `README.md` | Readme |
| `index.md` | Index |

## Tags System

Tags enable several features:

### 1. Visual Badges

Tags are displayed as badges on pages:

```yaml
tags:
  - security
  - authentication
```

### 2. Related Pages

Pages with shared tags appear in the "Related Pages" section. The more tags pages share, the higher their relevance ranking.

### 3. Search Integration

Tags are indexed for search, making it easier to find related content.

## Draft Pages

Draft pages are useful for work-in-progress documentation:

```yaml
---
title: New Feature
draft: true
---
```

Draft pages:
- Are hidden from navigation
- Show a "Draft" badge when accessed directly
- Can still be accessed via direct URL
- Are excluded from sitemap generation

## Hidden Pages

Hidden pages remain accessible but don't appear in navigation:

```yaml
---
title: Secret Page
hidden: true
---
```

Use cases:
- Landing pages linked from external sources
- Pages that should only be accessed via direct links
- Archived content you don't want prominently displayed

## Ordering

Pages within a section are sorted by:
1. `order` field (ascending, lower numbers first)
2. Title (alphabetical) if order is equal

```yaml
# Shows first
---
title: Introduction
order: 1
---

# Shows second
---
title: Installation
order: 2
---

# Shows last (default order: 999)
---
title: Advanced Topics
---
```

## Component Integration

The `component` field enables live component demos:

```yaml
---
title: Button Component
component: ButtonDemo
---
```

When a `DemoBuilder` is provided to `KnowledgeBaseApp.create()`, it receives the component name and can return a Component to render above the page content.

```dart
KnowledgeBaseApp.create(
  config: config,
  stylesheet: stylesheet,
  demoBuilder: (String componentType) {
    return switch (componentType) {
      'ButtonDemo' => const MyButtonDemo(),
      _ => null,
    };
  },
)
```
