# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [x.x.x]

### Changed

- Rebranded package from `arcane_jaspr_md` to `arcane_inkwell`

### Added

- Initial release of arcane_inkwell
- Auto-generated navigation from directory structure
- YAML frontmatter support for page metadata (title, description, order, icon, hidden, tags)
- Section configuration via `_section.yaml` files
- Dark and light theme support with toggle
- Client-side search with keyboard shortcut (Cmd/Ctrl+K)
- Table of contents auto-generation from headings
- Syntax highlighting with Highlight.js
- Code block copy buttons
- Responsive design with mobile sidebar
- Breadcrumb navigation
- SiteConfig for comprehensive site configuration
- KBStylesheet for CSS customization
- KBColors for theme color palettes
- Example project with sample documentation
- Edit on GitHub link with configurable branch (`editBranch`, `showEditLink` in SiteConfig)
- Back-to-top button (appears after scrolling down 300px)
- Page metadata display (author, reading time) in page headers
- Reading time extension (`ReadingTimeExtension`) auto-calculates from content
- Callout/admonition blocks with GitHub-style syntax (`> [!NOTE]`, `> [!TIP]`, `> [!WARNING]`, `> [!IMPORTANT]`, `> [!CAUTION]`)
- Mobile hamburger menu button in header
- Full-text search indexing content excerpts (not just titles)
- Content excerpts added to NavItem for search
- Tags display in page headers with visual badges
- Related pages section based on shared tags (`KBRelatedPages` component)
- Draft mode support (`draft: true` in frontmatter) with draft banner
- Draft pages hidden from navigation but accessible directly
- Sitemap generation utility (`SitemapGenerator` class)
- Changelog parser utility (`ChangelogParser` class) for Keep a Changelog format
- Changelog display component (`KBChangelog`) with styled timeline

### Changed

- Search now indexes page content excerpts for better results
- Search results show relevance-based scoring
- `visibleItems` now excludes both `hidden` and `draft` pages
- JSON5 section config now preferred over YAML (`_section.json5`)
