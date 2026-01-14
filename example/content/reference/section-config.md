---
title: Section Configuration
description: Configure folders with _section.json5 or _section.yaml
icon: folder
order: 3
tags:
  - configuration
  - reference
  - navigation
author: Arcane Arts
date: 2025-01-11
---

Section configuration files control how folders appear in the sidebar navigation. Place a `_section.json5` or `_section.yaml` file in any content folder to customize its appearance.

## File Formats

Arcane Inkwell supports two configuration formats:

### JSON5 (Recommended)

JSON5 supports comments and trailing commas, making it ideal for configuration:

```json5
{
  // This is a comment
  "title": "Getting Started",
  "icon": "rocket",
  "order": 1,
  "collapsed": false,
}
```

### YAML

Standard YAML format:

```yaml
title: Getting Started
icon: rocket
order: 1
collapsed: false
```

> [!TIP]
> JSON5 is preferred because it supports comments, which are helpful for documenting configuration choices.

## Priority

If both `_section.json5` and `_section.yaml` exist in the same folder, JSON5 takes priority.

## All Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `title` | `String` | Folder name | Display title in sidebar |
| `icon` | `String?` | `null` | Icon name, SVG path, or raw SVG (see [Icons Reference](/reference/icons)) |
| `order` | `int` | `999` | Sort order (lower = first) |
| `collapsed` | `bool` | `true` | Whether section is collapsed by default |
| `ignore` | `bool` | `false` | Exclude this folder from navigation entirely |

## Examples

### Basic Section

```json5
{
  "title": "Guide",
  "icon": "book",
  "order": 1
}
```

### Expanded by Default

```json5
{
  "title": "Getting Started",
  "icon": "rocket",
  "order": 1,
  "collapsed": false  // Always show children
}
```

### Ignored Folder

Use `ignore` to exclude a folder and all its contents from navigation:

```json5
{
  "ignore": true
}
```

This is useful for:
- Draft content not ready for publication
- Internal documentation
- Template files

### Nested Sections

Sections can be nested infinitely. Each subfolder can have its own configuration:

```
content/
  guide/
    _section.json5       # Guide section config
    basics/
      _section.json5     # Basics subsection config
      installation.md
      configuration.md
    advanced/
      _section.json5     # Advanced subsection config
      customization.md
```

## YAML Examples

### Basic

```yaml
title: API Reference
icon: code
order: 2
```

### With Comments (using #)

```yaml
# This section contains API documentation
title: API Reference
icon: code
order: 2
collapsed: true  # Collapsed by default
```

## Fallback Behavior

If no section config file exists:

1. The folder name is converted to a title (e.g., `getting-started` becomes "Getting Started")
2. No icon is displayed
3. Order defaults to `999` (appears after ordered sections)
4. Section is collapsed by default

## Section Ordering

Sections are sorted by:
1. `order` field (ascending)
2. Title (alphabetical) if order is equal

Example structure:

```
content/
  guide/
    _section.json5    # order: 1
  features/
    _section.json5    # order: 2
  reference/
    _section.json5    # order: 3
  examples/           # no config, order: 999
```

## Index Pages

An `index.md` file in a section folder becomes the section's index page:

```
content/
  guide/
    _section.json5
    index.md          # Accessed at /guide
    installation.md   # Accessed at /guide/installation
```

The index page inherits the section path (e.g., `/guide`), while other pages get the section path plus their filename.

## Auto-Expansion

Sections automatically expand when:
1. The current page is within the section
2. `collapsed: false` is set in the config

This ensures users can always see their current location in the navigation tree.
