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

1. **Navigation**: Draft pages are hidden from the sidebar navigation
2. **Direct Access**: You can still access draft pages directly via their URL
3. **Draft Banner**: A banner appears at the top indicating the page is a draft

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

When you're ready to publish, simply remove the `draft: true` line or set it to `false`.
