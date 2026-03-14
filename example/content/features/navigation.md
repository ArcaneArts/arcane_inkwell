---
title: Navigation
description: Sidebar, top/bottom nav bar, breadcrumbs, and page navigation
icon: compass
order: 1
tags:
  - navigation
  - organization
author: Arcane Arts
date: 2026-03-03
---

Arcane Lexicon navigation is generated from the content tree and section configs.

## Sidebar Navigation

- Built from folders/files in `contentDirectory`.
- Controlled with `_section.json5` or `_section.yaml`.
- Supports section collapse memory via localStorage.
- Supports Lucide icon names, SVG URLs, and raw SVG markup in section/page icons.

## Top/Bottom Navigation Bar

Global top bar behavior:

```dart
SiteConfig(
  name: 'My Docs',
  navigationBarEnabled: true,
  navigationBarPosition: KBNavigationBarPosition.top, // or bottom
)
```

Includes:
- Brand/home link
- Header links
- Search (when enabled)
- Theme toggle (when enabled)
- GitHub link (when configured)

## Breadcrumbs

Breadcrumbs are generated from the current URL path and rendered above page content.

## Footer Prev/Next Navigation

`KBPageNav` is rendered by default and follows manifest order of visible pages.

Global toggle:

```dart
SiteConfig(
  name: 'My Docs',
  pageNavEnabled: true,
)
```

Per-page override:

```yaml
---
layout: kb
pageNav: false
---
```

## TOC Panel

Right-side TOC is enabled by:

```dart
SiteConfig(
  name: 'My Docs',
  tocEnabled: true,
)
```

It tracks heading anchors and highlights the active section during scroll.

