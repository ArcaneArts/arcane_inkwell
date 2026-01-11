---
title: Tags & Related Pages
description: Organize and connect content with tags
icon: tags
order: 7
tags:
  - tags
  - organization
  - navigation
author: Arcane Arts
---

# Tags & Related Pages

Tags help organize your documentation and show related content to readers.

## Adding Tags

Add tags to any page using the frontmatter:

```yaml
---
title: My Page
tags:
  - getting-started
  - tutorial
  - beginner
---
```

## Tag Display

Tags are displayed in the page header as visual badges. Readers can quickly see what topics a page covers.

## Related Pages

At the bottom of each page, a "Related Pages" section automatically appears showing other pages that share tags with the current page. This helps readers discover related content.

The related pages feature:

- Ranks pages by how many tags they share with the current page
- Shows up to 5 related pages
- Excludes the current page from results

## Search Integration

Tags are also indexed for search, so readers can find pages by searching for tag names.

## Best Practices

1. **Use consistent tag names** - stick to a set vocabulary
2. **Be specific** - use descriptive tags like "api-reference" instead of just "api"
3. **Don't over-tag** - 3-5 tags per page is usually sufficient
4. **Use lowercase with hyphens** - e.g., "getting-started" instead of "Getting Started"
