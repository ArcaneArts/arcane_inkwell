---
title: Configuration
description: Configure your documentation site
icon: settings
order: 2
---

## SiteConfig

```dart
SiteConfig(
  name: 'My Docs',
  contentDirectory: 'content',
  githubUrl: 'https://github.com/...',
  sidebarFooter: 'v1.0.0',
)
```

## Section Config

Create `_section.json5` in any folder:

```json5
{
  // Comments are supported
  "title": "Getting Started",
  "icon": "rocket",
  "order": 1,
  "collapsed": false
}
```

## Page Frontmatter

```yaml
---
title: My Page
description: Page description
icon: file-text
order: 1
hidden: false
---
```
