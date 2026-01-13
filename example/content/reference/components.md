---
title: Components
description: Reusable layout components for documentation pages
icon: layers
order: 7
tags:
  - reference
  - components
  - layout
---

Arcane Inkwell includes several reusable components for building documentation pages.

## KBChangelog

Displays a styled changelog timeline from CHANGELOG.md content.

### Usage

```dart
import 'package:arcane_inkwell/arcane_inkwell.dart';

// Parse changelog content
final versions = ChangelogParser.parse(changelogContent);

// Render component
KBChangelog(
  versions: versions,
  maxVersions: 5,              // Optional: limit displayed versions
  githubUrl: 'https://github.com/org/repo',  // Optional: adds release links
)
```

### Features

- **Version badges**: Each version shown with styled badge
- **Date display**: Shows release date if present
- **GitHub release links**: Automatic links to releases when `githubUrl` provided
- **Color-coded sections**: Different colors for Added, Changed, Fixed, etc.
- **Section icons**: Visual icons for each change type

### Changelog Format

Uses the [Keep a Changelog](https://keepachangelog.com/) format:

```markdown
## [1.2.0] - 2024-01-15

### Added
- New feature X
- New feature Y

### Changed
- Updated behavior of Z

### Fixed
- Bug fix for issue #123

## [1.1.0] - 2024-01-01

### Added
- Initial feature A
```

### Section Colors

| Section | Color | Icon |
|---------|-------|------|
| Added | Green | Plus |
| Changed | Blue | Pencil |
| Deprecated | Yellow | Warning |
| Removed | Red | Trash |
| Fixed | Purple | Wrench |
| Security | Orange | Shield |

## KBRelatedPages

Displays related pages based on shared tags.

### Usage

```dart
KBRelatedPages(
  config: siteConfig,
  manifest: navManifest,
  currentPath: '/guide/authentication',
  currentTags: ['security', 'authentication'],
  maxItems: 3,  // Default: 3
)
```

### Features

- **Tag-based matching**: Finds pages with shared tags
- **Relevance ranking**: More shared tags = higher ranking
- **Card layout**: Grid of clickable cards
- **Description preview**: Shows truncated page descriptions
- **Shared tag display**: Shows which tags are shared

### Automatic Integration

Related pages are automatically displayed at the bottom of pages when:
1. The current page has tags in frontmatter
2. Other pages share at least one tag

## KBSubpages

Displays child pages of the current section in a grid.

### Features

- **Grid layout**: Responsive card grid
- **Icon display**: Shows page icons
- **Description**: Page descriptions
- **Page count**: For subsections, shows number of pages

### Automatic Integration

Subpages are automatically shown on section index pages (`index.md`).

## KBPageNav

Previous/Next page navigation at the bottom of pages.

### Features

- **Sequential navigation**: Based on sidebar order
- **Respects visibility**: Skips hidden and draft pages
- **Full-width layout**: Previous on left, next on right

### Automatic Integration

Page navigation is automatically shown on all content pages.

## KBBreadcrumbs

Path-based breadcrumb navigation.

### Features

- **Auto-generated**: From URL path
- **Home link**: Always includes link to home
- **Current page**: Last segment is non-clickable
- **Chevron separator**: Visual separation between levels

### Automatic Integration

Breadcrumbs are automatically shown at the top of all content pages.

## KBToc (Table of Contents)

Sticky table of contents sidebar.

### Features

- **Auto-generated**: From page headings (H2, H3, H4)
- **Active tracking**: Highlights current section while scrolling
- **Smooth scroll**: Clicking jumps to section
- **Sticky positioning**: Stays visible while scrolling

### Configuration

```dart
SiteConfig(
  name: 'My Docs',
  tocEnabled: true,  // Default: true
)
```

### Supported Heading Levels

- H2 (`##`) - Primary sections
- H3 (`###`) - Subsections
- H4 (`####`) - Sub-subsections

> [!NOTE]
> H1 (`#`) is reserved for the page title and not included in TOC.

## KBSidebar

The main navigation sidebar component.

### Features

- **Brand section**: Site name and description
- **Search input**: Integrated search
- **Theme toggle**: Dark/light mode switch
- **Collapsible sections**: Expandable navigation tree
- **Active highlighting**: Current page highlighted
- **Scroll persistence**: Remembers scroll position

### Configuration

See [SiteConfig Reference](/reference/site-config) for sidebar options:
- `searchEnabled`
- `themeToggleEnabled`
- `sidebarFooter`
- `sidebarFooterUrl`

## DemoBuilder

Enables live component demos in documentation pages.

### Usage

1. Add `component` field to frontmatter:

```yaml
---
title: Button Component
component: ButtonDemo
---
```

2. Provide a builder function:

```dart
KnowledgeBaseApp.create(
  config: config,
  stylesheet: stylesheet,
  demoBuilder: (String componentType) {
    return switch (componentType) {
      'ButtonDemo' => const InteractiveButtonDemo(),
      'FormDemo' => const InteractiveFormDemo(),
      _ => null,
    };
  },
)
```

3. The returned component renders above the page content.

### Use Cases

- Interactive component previews
- Live code examples
- API playgrounds
- Configuration demos
