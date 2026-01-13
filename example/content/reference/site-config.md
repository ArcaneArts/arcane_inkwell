---
title: SiteConfig Reference
description: Complete reference for all SiteConfig options
icon: settings
order: 1
tags:
  - configuration
  - reference
---

`SiteConfig` is the main configuration object for your documentation site. Pass it to `KnowledgeBaseApp.create()` to configure your site.

## Basic Example

```dart
SiteConfig(
  name: 'My Docs',
  description: 'Documentation for My Project',
  contentDirectory: 'content',
  githubUrl: 'https://github.com/myorg/myproject',
)
```

## Full Example

```dart
SiteConfig(
  // Required
  name: 'My Docs',

  // Site metadata
  description: 'Documentation for My Project',
  logo: '/assets/logo.svg',

  // Content settings
  contentDirectory: 'content',
  baseUrl: '/docs',  // For subdirectory hosting
  homeRoute: '/',

  // GitHub integration
  githubUrl: 'https://github.com/myorg/myproject',
  editBranch: 'main',
  showEditLink: true,

  // Feature toggles
  searchEnabled: true,
  tocEnabled: true,
  themeToggleEnabled: true,
  defaultTheme: KBThemeMode.dark,
  primaryColor: '#6366f1',

  // Navigation
  headerLinks: [
    NavLink(label: 'Docs', href: '/'),
    NavLink(label: 'GitHub', href: 'https://github.com/...', external: true),
  ],
  socialLinks: [
    SocialLink.github('https://github.com/myorg'),
    SocialLink.discord('https://discord.gg/...'),
  ],

  // Footer
  footerText: 'Built with Arcane Inkwell',
  copyright: '2024 My Company',
  sidebarFooter: 'v1.0.0',
  sidebarFooterUrl: 'https://github.com/myorg/myproject/releases',
)
```

## All Options

### Required

| Option | Type | Description |
|--------|------|-------------|
| `name` | `String` | The site name displayed in the sidebar header |

### Site Metadata

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `description` | `String?` | `null` | Brief site description for meta tags |
| `logo` | `String?` | `null` | Path to logo image (displayed in header) |

### Content Settings

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `contentDirectory` | `String` | `'content'` | Directory containing markdown files |
| `baseUrl` | `String` | `''` | Base URL for subdirectory hosting (e.g., `/docs`) |
| `homeRoute` | `String` | `'/'` | Route for the home page |

### GitHub Integration

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `githubUrl` | `String?` | `null` | GitHub repository URL (enables GitHub link and edit links) |
| `editBranch` | `String` | `'main'` | Git branch for "Edit this page" links |
| `showEditLink` | `bool` | `true` | Whether to show "Edit this page" links |

> [!NOTE]
> When `githubUrl` is set, edit links are automatically generated in the format:
> `{githubUrl}/edit/{editBranch}/{contentDirectory}/{pagePath}.md`

### Feature Toggles

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `searchEnabled` | `bool` | `true` | Enable/disable search functionality |
| `tocEnabled` | `bool` | `true` | Enable/disable table of contents on pages |
| `themeToggleEnabled` | `bool` | `true` | Show/hide the theme toggle button |
| `defaultTheme` | `KBThemeMode` | `.dark` | Default theme mode |
| `primaryColor` | `String?` | `null` | Custom primary accent color (CSS color value) |

### KBThemeMode Values

```dart
enum KBThemeMode {
  dark,    // Dark theme
  light,   // Light theme
  system,  // Follow system preference
}
```

### Navigation

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `headerLinks` | `List<NavLink>` | `[]` | Navigation links for the header |
| `socialLinks` | `List<SocialLink>` | `[]` | Social media links |

#### NavLink

```dart
NavLink(
  label: 'Docs',           // Display text
  href: '/',               // Link URL
  external: false,         // Opens in new tab if true
)
```

#### SocialLink

```dart
// Custom social link
SocialLink(
  name: 'Twitter',
  url: 'https://twitter.com/...',
  icon: 'twitter',  // Lucide icon name
)

// Built-in presets
SocialLink.github('https://github.com/...')
SocialLink.twitter('https://twitter.com/...')
SocialLink.discord('https://discord.gg/...')
SocialLink.youtube('https://youtube.com/...')
```

### Footer

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `footerText` | `String?` | `null` | Custom footer text |
| `copyright` | `String?` | `null` | Copyright text for footer |
| `sidebarFooter` | `String?` | `null` | Text at bottom of sidebar (e.g., version) |
| `sidebarFooterUrl` | `String?` | `null` | URL for sidebar footer (e.g., releases page) |

## Subdirectory Hosting

When hosting your docs at a subdirectory (e.g., `example.com/docs`), set `baseUrl`:

```dart
SiteConfig(
  name: 'My Docs',
  baseUrl: '/docs',
)
```

Then build with the base URL defined:

```bash
jaspr build --define=BASE_URL=/docs
```

## Helper Methods

### `fullPath(String path)`

Returns the full URL path including the base URL:

```dart
config.fullPath('/guide')  // Returns '/docs/guide' if baseUrl is '/docs'
```

### `editUrl(String pagePath)`

Generates the GitHub edit URL for a page:

```dart
config.editUrl('/guide/installation')
// Returns 'https://github.com/.../edit/main/content/guide/installation.md'
```

Returns `null` if `githubUrl` is not set or `showEditLink` is `false`.
