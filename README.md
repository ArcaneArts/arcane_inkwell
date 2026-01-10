# Arcane Jaspr MD

Transform markdown directories into documentation websites. Built on Jaspr and arcane_jaspr.

## Features

- Auto-generated navigation from folder structure
- JSON5 configuration with comment support
- Dark/light theme with ShadCN styling
- Table of contents generation
- Code syntax highlighting with copy button
- Responsive images with sizing options
- External link indicators
- Folder ignore capability
- Breadcrumb navigation
- Client-side search
- Previous/next page navigation
- Subpages grid for section index pages

## Installation

```yaml
dependencies:
  arcane_jaspr_md:
    git:
      url: https://github.com/ArcaneArts/arcane_jaspr_md
```

## Usage

### Standalone Knowledge Base

Create a documentation site from markdown files:

```dart
// lib/main.server.dart
import 'package:jaspr/server.dart';
import 'package:arcane_jaspr_md/arcane_jaspr_md.dart' hide runApp;
import 'main.server.options.dart';

void main() async {
  Jaspr.initializeApp(options: defaultServerOptions);

  runApp(
    await KnowledgeBaseApp.create(
      config: const SiteConfig(
        name: 'My Docs',
        description: 'Documentation for my project',
        contentDirectory: 'content',
        githubUrl: 'https://github.com/user/repo',
        headerLinks: [
          NavLink(label: 'Docs', href: '/'),
          NavLink(label: 'GitHub', href: 'https://github.com/user/repo', external: true),
        ],
      ),
    ),
  );
}
```

## Content Structure

```
content/
├── index.md                 # Homepage (/)
├── _section.json5           # Root config (optional)
├── getting-started/
│   ├── _section.json5       # Section config
│   ├── index.md             # /getting-started
│   ├── installation.md      # /getting-started/installation
│   └── quickstart.md        # /getting-started/quickstart
├── api/
│   ├── _section.json5
│   ├── overview.md
│   └── endpoints/
│       ├── _section.json5
│       └── users.md
└── _internal/               # Ignored folder
    ├── _section.json5       # { "ignore": true }
    └── drafts.md
```

## Section Configuration

Create `_section.json5` (preferred) or `_section.yaml` in any folder:

```json5
{
  // Section title in sidebar
  "title": "Getting Started",

  // Lucide icon name
  "icon": "rocket",

  // Sort order (lower = first)
  "order": 1,

  // Collapsed by default
  "collapsed": false,

  // Set to true to exclude from navigation
  "ignore": false
}
```

JSON5 supports comments (`//` and `/* */`), trailing commas, and unquoted keys.

## Page Frontmatter

Each markdown file can have YAML frontmatter:

```markdown
---
title: Installation Guide
description: How to install the package
icon: download
order: 1
hidden: false
tags:
  - setup
  - installation
---

# Installation Guide

Content here...
```

### Frontmatter Fields

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `title` | string | filename | Page title |
| `description` | string | - | Page description |
| `icon` | string | - | Lucide icon name |
| `order` | int | 999 | Sort order |
| `hidden` | bool | false | Hide from navigation |
| `tags` | list | [] | Tags for search/filtering |

## Configuration Options

```dart
SiteConfig(
  // Required
  name: 'Site Name',
  contentDirectory: 'content',

  // Optional
  description: 'Site description',
  baseUrl: '/docs',              // For subdirectory hosting
  githubUrl: 'https://github.com/...',
  defaultTheme: KBThemeMode.dark,
  showThemeToggle: true,
  showToc: true,
  showBreadcrumbs: true,
  headerLinks: [...],
  footerText: 'Built with arcane_jaspr_md',
  copyright: '2025 Company Name',
  sidebarFooter: 'v1.0.0',       // Always visible at sidebar bottom
  sidebarFooterUrl: 'https://...', // Optional link
)
```

## Icons

Sidebar icons use Lucide icon names. Common icons:

- Documents: `file-text`, `book`, `scroll`, `notebook`
- Navigation: `rocket`, `home`, `compass`, `map`
- Infrastructure: `server`, `database`, `cloud`, `cpu`
- Security: `shield`, `lock`, `key`, `fingerprint`
- Settings: `settings`, `wrench`, `terminal`, `code`
- Users: `user`, `users`, `user-plus`
- Status: `activity`, `gauge`, `clock`

Full list at [lucide.dev/icons](https://lucide.dev/icons)

## Images

Images are responsive by default. Use alt text modifiers for sizing and alignment:

```markdown
<!-- Basic responsive image -->
![Screenshot](./images/screenshot.png)

<!-- Size modifiers -->
![small - Logo](./images/logo.png)
![medium - Diagram](./images/diagram.png)
![full-width - Banner](./images/banner.png)

<!-- Alignment modifiers -->
![left - Profile](./images/profile.png)
![right - Icon](./images/icon.png)
![center - Chart](./images/chart.png)

<!-- Style modifiers -->
![shadow - Card](./images/card.png)
![border - Frame](./images/frame.png)
![square - Avatar](./images/avatar.png)

<!-- Combine modifiers -->
![small shadow center - Preview](./images/preview.png)
```

### Image Modifiers

| Modifier | Effect |
|----------|--------|
| `small` | Max width 300px |
| `medium` | Max width 500px |
| `full-width` | Stretch to container width |
| `left` | Float left with text wrap |
| `right` | Float right with text wrap |
| `center` | Center align (default) |
| `shadow` | Add drop shadow |
| `border` | Add subtle border |
| `square` | Remove border radius |

## Links

Standard markdown links work as expected:

```markdown
<!-- Internal links -->
[Getting Started](/getting-started)
[Installation Guide](/getting-started/installation)

<!-- External links (auto-detected, show icon) -->
[GitHub](https://github.com/user/repo)
[Documentation](https://docs.example.com)

<!-- Reference-style links -->
[Read the docs][docs]

[docs]: https://docs.example.com
```

External links automatically display an icon indicator.

## Page Navigation

Every page automatically shows:

- **Previous/Next links**: Navigate sequentially through documentation pages based on sidebar order
- **Subpages grid**: Section index pages display child pages and subsections as clickable cards

The navigation follows the same order as the sidebar, respecting `order` values in frontmatter and section configs.

## Build Commands

```bash
# Development server
cd example && jaspr serve

# Production build
cd example && jaspr build

# Build for subdirectory (e.g., GitHub Pages)
cd example && jaspr build --define=BASE_URL=/my-docs
```

## Theming

The knowledge base uses arcane_jaspr's ShadCN stylesheet with automatic dark/light mode.

Custom styling can be added by extending `KBStylesheet`:

```dart
class CustomStylesheet extends KBStylesheet {
  const CustomStylesheet();

  @override
  String get baseCss {
    return '''
${super.baseCss}

/* Custom styles */
.kb-sidebar {
  background: var(--arcane-surface);
}
''';
  }
}
```

## License

MIT
