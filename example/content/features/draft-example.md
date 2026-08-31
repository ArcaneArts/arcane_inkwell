---
title: Draft Page Example
description: This page is a draft and demonstrates the draft feature
icon: pencil
order: 99
draft: true
tags:
  - draft
  - wip
author: Arcane Arts
---

# Draft Page Example

This page is marked as a draft using `draft: true` in the frontmatter.

## How Draft Mode Works

1. **Routes**: Draft pages are not added to the generated route table.
2. **Navigation**: Draft pages are excluded from sidebar, page, and related navigation.
3. **Indexes**: Draft pages are excluded from search and sitemap output.

## When to Use Drafts

Draft mode is useful for:

- Work-in-progress documentation
- Pages that aren't ready for public consumption
- Testing new content before publishing

## Frontmatter

To mark a page as a draft, add this to your frontmatter:

```yaml
---
title: My Draft Page
draft: true
---
```

To publish this page, remove the `draft: true` line or set it to `false`.
