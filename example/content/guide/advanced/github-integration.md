---
title: GitHub Integration
description: Edit links and repository linking behavior
icon: link
order: 2
tags:
  - github
  - integration
  - configuration
---

Arcane Inkwell provides GitHub integration through `SiteConfig.githubUrl` and `SiteConfig.editBranch`.

## Edit This Page Links

When `githubUrl` is configured and `showEditLink` is `true`, pages include an edit link.

```dart
SiteConfig(
  name: 'My Docs',
  githubUrl: 'https://github.com/myorg/myproject',
  editBranch: 'main',
  showEditLink: true,
)
```

Edit URL shape:

```text
{githubUrl}/edit/{editBranch}/{contentDirectory}/{pagePath}.md
```

Example:

```text
https://github.com/acme/docs/edit/main/content/guide/basics/installation.md
```

## Repository Link in Navigation Bar

When `githubUrl` is present and the top/bottom navigation bar is enabled, the default `KBTopBar` renders a GitHub icon link.

```dart
SiteConfig(
  name: 'My Docs',
  githubUrl: 'https://github.com/myorg/myproject',
  navigationBarEnabled: true,
)
```

## Changelog Release Links

`KBChangelog` can generate release links when you pass `githubUrl`.

```dart
KBChangelog(
  versions: changelogVersions,
  githubUrl: 'https://github.com/myorg/myproject',
)
```

Release URL shape:

```text
{githubUrl}/releases/tag/v{version}
```

## Notes on Sidebar Footer Fields

`sidebarFooter` and `sidebarFooterUrl` exist on `SiteConfig`, but the default `KBLayout` path does not currently render them. Use a custom layout if you need them displayed.

