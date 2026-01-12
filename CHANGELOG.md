# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-11

### Added

- **Core Features**
  - Auto-generated navigation from directory structure
  - YAML frontmatter support (title, description, order, icon, hidden, tags, author, date, draft)
  - Section configuration via `_section.json5` or `_section.yaml`
  - Dark/light theme with toggle
  - 1-line theme configuration using arcane_jaspr stylesheets

- **Navigation**
  - Sidebar with collapsible sections and tree view
  - Breadcrumb navigation
  - Previous/next page links
  - Table of contents auto-generation
  - Full-text search with keyboard shortcut (Cmd/Ctrl+K)

- **Content**
  - Markdown rendering with syntax highlighting
  - Code block copy buttons
  - Callout/admonition blocks (NOTE, TIP, WARNING, IMPORTANT, CAUTION)
  - Reading time calculation
  - Tags with visual badges
  - Related pages based on shared tags
  - Draft mode with banner

- **Components**
  - `KnowledgeBaseApp` - Main app factory
  - `SiteConfig` - Site configuration
  - `KBLayout` - Page layout
  - `KBSidebar` - Navigation sidebar
  - `KBPageNav` - Previous/next navigation
  - `KBSubpages` - Child pages grid
  - `KBRelatedPages` - Tag-based related content
  - `KBChangelog` - Changelog display component

- **Utilities**
  - `NavBuilder` - Navigation manifest generator
  - `SitemapGenerator` - Sitemap XML generation
  - `ChangelogParser` - Keep a Changelog format parser
  - `CalloutExtension` - GitHub-style admonition blocks
  - `ReadingTimeExtension` - Reading time calculator

- **Styling**
  - ShadCN-based theming via arcane_jaspr
  - Responsive design with mobile sidebar
  - Nested folder tree visualization
  - Back-to-top button
  - Edit on GitHub links

## [x.x.x]

Reserved for future changes.
