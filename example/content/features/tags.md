---
title: Tags Metadata
description: Organize pages with tags and enrich generated search index data
icon: tags
order: 7
tags:
  - tags
  - metadata
  - search
author: Arcane Arts
date: 2026-03-03
---

Tags are page metadata defined in frontmatter.

## Adding Tags

```yaml
---
title: My Page
tags:
  - getting-started
  - tutorial
  - beginner
---
```

## Where Tags Are Used

- Displayed as plain metadata/footer labels by the default layout.
- Included in generated search-index entries (`SearchIndexGenerator`).
- Available to custom components/layout logic.

## Current Default Layout Behavior

The default `KBLayout` does not auto-render `KBRelatedPages`. If you want related-page rows, use `KBRelatedPages` explicitly in a custom layout composition.

## Tag guidelines

1. Use consistent lowercase tag naming.
2. Prefer specific tags (`api-reference`) over generic tags (`api`).
3. Keep 3-6 tags per page.
4. Keep tags as a YAML list for reliable parsing.
