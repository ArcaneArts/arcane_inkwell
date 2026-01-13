---
title: Configuration
description: Configure your documentation site
icon: settings
order: 2
tags:
  - configuration
  - getting-started
---

Arcane Inkwell is configured through three main mechanisms: site configuration, section configuration, and page frontmatter.

## SiteConfig

The main configuration object passed to `KnowledgeBaseApp.create()`:

```dart
SiteConfig(
  // Required
  name: 'My Docs',

  // Content
  contentDirectory: 'content',
  baseUrl: '',  // For subdirectory hosting

  // GitHub integration
  githubUrl: 'https://github.com/your/repo',
  editBranch: 'main',
  showEditLink: true,

  // Features
  searchEnabled: true,
  tocEnabled: true,
  themeToggleEnabled: true,
  defaultTheme: KBThemeMode.dark,

  // Navigation
  headerLinks: [
    NavLink(label: 'Docs', href: '/'),
    NavLink(label: 'GitHub', href: 'https://github.com/...', external: true),
  ],

  // Footer
  sidebarFooter: 'v1.0.0',
  sidebarFooterUrl: 'https://github.com/.../releases',
)
```

> [!TIP]
> See [SiteConfig Reference](/reference/site-config) for all available options.

## Section Config

Create `_section.json5` (preferred) or `_section.yaml` in any folder to configure that section:

```json5
{
  // JSON5 supports comments
  "title": "Getting Started",
  "icon": "rocket",
  "order": 1,
  "collapsed": false,
  "ignore": false  // Set true to exclude from navigation
}
```

Or in YAML:

```yaml
title: Getting Started
icon: rocket
order: 1
collapsed: false
```

> [!TIP]
> See [Section Config Reference](/reference/section-config) for all options.

## Page Frontmatter

Every markdown file can include YAML frontmatter:

```yaml
---
title: My Page
description: Page description for meta tags
icon: file-text
order: 1
hidden: false
draft: false
tags:
  - getting-started
  - configuration
author: Your Name
---
```

| Field | Description |
|-------|-------------|
| `title` | Display title (falls back to filename) |
| `description` | Meta description |
| `icon` | Lucide icon name |
| `order` | Sort order (lower = first) |
| `hidden` | Hide from nav but keep accessible |
| `draft` | Hidden + shows draft badge |
| `tags` | For related pages and search |

> [!TIP]
> See [Frontmatter Reference](/reference/frontmatter) for all fields.

## Theming

Single-line theme configuration:

```dart
KnowledgeBaseApp.create(
  config: config,
  // Choose a stylesheet and theme:
  stylesheet: const ShadcnStylesheet(theme: ShadcnTheme.midnight),
  // Or:
  // stylesheet: const CodexStylesheet(theme: CodexTheme.green),
)
```

### Available Themes

**ShadcnStylesheet** (clean, modern):
- `midnight`, `charcoal`, `cream`, `slate`
- `rose`, `lavender`, `mint`, `sky`, `peach`, `teal`

**CodexStylesheet** (gamer aesthetic):
- `green`, `red`, `blue`, `purple`, `cyan`, `pink`, `orange`, `rainbow`

> [!TIP]
> See [Theming Reference](/reference/theming) for details.

## Directory Structure

A typical content directory:

```
content/
  index.md                    # Home page
  guide/
    _section.json5            # Section config
    index.md                  # Section index
    basics/
      _section.json5          # Subsection config
      installation.md
      configuration.md
    advanced/
      _section.json5
      customization.md
  reference/
    _section.json5
    site-config.md
    frontmatter.md
```

## Next Steps

- Browse the [Features](/features) section to see components in action
- Check the [Reference](/reference) section for complete API documentation
