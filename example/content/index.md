---
title: Arcane Jaspr MD
description: Transform markdown into documentation sites
order: 0
---

This example demonstrates all visual features of **arcane_jaspr_md**.

## What You'll See

Navigate through the sections to explore:

- **Subpages Grid** - Visit [Features](/features) to see child pages displayed as cards
- **Previous/Next Navigation** - Every page shows sequential navigation at the bottom
- **Sidebar Navigation** - Collapsible sections with icons
- **Sidebar Footer** - Version link pinned at bottom
- **Table of Contents** - Auto-generated from headings (see right panel)
- **Breadcrumbs** - Visit nested pages to see the path
- **Code Highlighting** - Syntax-colored code blocks
- **External Links** - [GitHub](https://github.com) shows an indicator icon

## Code Example

```dart
runApp(
  await KnowledgeBaseApp.create(
    config: const SiteConfig(
      name: 'My Docs',
      contentDirectory: 'content',
    ),
  ),
);
```

> Start exploring by clicking **Features** in the sidebar.
