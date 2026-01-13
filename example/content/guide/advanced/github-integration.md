---
title: GitHub Integration
description: Edit links, releases, and repository integration
icon: link
order: 2
tags:
  - github
  - integration
  - configuration
---

Arcane Inkwell includes several GitHub integration features.

## Edit This Page Links

When `githubUrl` is configured, each page displays an "Edit this page" link that opens the file directly in GitHub's editor.

### Configuration

```dart
SiteConfig(
  name: 'My Docs',
  githubUrl: 'https://github.com/myorg/myproject',
  editBranch: 'main',      // Default: 'main'
  showEditLink: true,      // Default: true
)
```

### How It Works

Edit URLs are generated in the format:
```
{githubUrl}/edit/{editBranch}/{contentDirectory}/{pagePath}.md
```

For example, if your config is:
- `githubUrl`: `https://github.com/acme/docs`
- `editBranch`: `main`
- `contentDirectory`: `content`

Then the page `/guide/installation` generates:
```
https://github.com/acme/docs/edit/main/content/guide/installation.md
```

### Disabling Edit Links

To disable edit links site-wide:

```dart
SiteConfig(
  name: 'My Docs',
  githubUrl: 'https://github.com/myorg/myproject',
  showEditLink: false,
)
```

## GitHub Repository Link

When `githubUrl` is set, a GitHub link appears in the sidebar/header for easy access to your repository.

## Sidebar Footer with Releases

Link to your releases page from the sidebar footer:

```dart
SiteConfig(
  name: 'My Docs',
  sidebarFooter: 'v1.2.0',
  sidebarFooterUrl: 'https://github.com/myorg/myproject/releases',
)
```

This displays a version badge that links to your releases page.

## Changelog Integration

The `KBChangelog` component integrates with GitHub releases:

```dart
KBChangelog(
  versions: changelogVersions,
  githubUrl: 'https://github.com/myorg/myproject',
)
```

Each version in the changelog gets a "Release" link pointing to:
```
{githubUrl}/releases/tag/v{version}
```

## Social Links

Add GitHub to your social links:

```dart
SiteConfig(
  name: 'My Docs',
  socialLinks: [
    SocialLink.github('https://github.com/myorg'),
  ],
)
```
