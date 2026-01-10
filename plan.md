# Arcane Jaspr MD - Implementation Plan

A standalone Jaspr package that transforms a directory of Markdown files into a fully-featured, beautifully designed knowledgebase website.

## Vision

Turn any GitHub repository with markdown files into a production-ready documentation/knowledgebase site with:
- Auto-generated navigation from folder structure
- Beautiful theming out of the box
- Search functionality
- Responsive design
- Dark/light mode
- Code syntax highlighting
- Table of contents per page

## Package Architecture

```
arcane_jaspr_md/
├── lib/
│   ├── arcane_jaspr_md.dart          # Main barrel export
│   ├── src/
│   │   ├── app/
│   │   │   └── knowledge_base_app.dart    # Main app component
│   │   ├── config/
│   │   │   ├── site_config.dart           # Site configuration class
│   │   │   └── nav_config.dart            # Navigation configuration
│   │   ├── layout/
│   │   │   ├── kb_layout.dart             # Main layout wrapper
│   │   │   ├── kb_header.dart             # Header with search & theme toggle
│   │   │   ├── kb_sidebar.dart            # Auto-generated sidebar navigation
│   │   │   ├── kb_footer.dart             # Optional footer
│   │   │   └── kb_toc.dart                # Table of contents component
│   │   ├── page/
│   │   │   ├── kb_page.dart               # Page wrapper for markdown content
│   │   │   └── kb_home.dart               # Home page component
│   │   ├── navigation/
│   │   │   ├── nav_builder.dart           # Builds nav from file structure
│   │   │   ├── nav_item.dart              # Navigation item model
│   │   │   └── nav_section.dart           # Collapsible nav section
│   │   ├── theme/
│   │   │   ├── kb_theme.dart              # Theme configuration
│   │   │   ├── kb_stylesheet.dart         # CSS stylesheet
│   │   │   └── kb_colors.dart             # Color palette
│   │   ├── scripts/
│   │   │   └── kb_scripts.dart            # JS for search, theme, code copy
│   │   └── utils/
│   │       ├── frontmatter.dart           # YAML frontmatter parser
│   │       ├── slug.dart                  # URL slug utilities
│   │       └── markdown_extensions.dart   # Custom markdown extensions
│   └── builder/
│       └── nav_manifest_builder.dart      # Build-time nav manifest generator
├── example/
│   ├── content/                           # Example markdown content
│   │   ├── index.md
│   │   ├── getting-started/
│   │   │   ├── _section.yaml              # Section metadata
│   │   │   ├── installation.md
│   │   │   └── quick-start.md
│   │   └── guides/
│   │       ├── _section.yaml
│   │       └── advanced-usage.md
│   ├── lib/
│   │   ├── main.server.dart
│   │   └── main.client.dart
│   └── pubspec.yaml
├── pubspec.yaml
├── CHANGELOG.md
└── README.md
```

## Core Features

### 1. Auto-Generated Navigation

Unlike the codex (hardcoded navigation), this package will:

- **Scan directory structure** at build time
- **Generate navigation manifest** from folder hierarchy
- **Support `_section.yaml`** files for section metadata:
  ```yaml
  title: Getting Started
  icon: rocket          # Lucide icon name
  order: 1              # Sort order
  collapsed: false      # Default expanded/collapsed
  ```
- **Support frontmatter ordering** in markdown files:
  ```yaml
  ---
  title: Installation
  order: 1
  ---
  ```
- **Fallback to alphabetical** if no order specified
- **Convert filenames to titles** (kebab-case to Title Case)

### 2. Site Configuration

```dart
KnowledgeBaseApp(
  config: SiteConfig(
    name: 'My Documentation',
    description: 'Documentation for my project',
    logo: 'assets/logo.svg',           // Optional
    githubUrl: 'https://github.com/...',
    baseUrl: '/docs',                   // For subdirectory hosting
    theme: KBTheme.dark,                // dark, light, or system
    primaryColor: Color(0xFF6366F1),    // Accent color
    contentDirectory: 'content/',       // Markdown source
    homeRoute: '/',                     // Home page route
    searchEnabled: true,
    tocEnabled: true,
  ),
)
```

### 3. Markdown Frontmatter

```yaml
---
title: Page Title                    # Required
description: Brief description       # For meta tags & search
order: 1                             # Sort order in nav
icon: file-text                      # Lucide icon name
hidden: false                        # Hide from nav but accessible
tags: [guide, tutorial]              # For search/filtering
---
```

### 4. Theme System

- Dark and light modes with toggle
- CSS variable-based theming
- Customizable accent color
- Typography optimized for reading
- Code block styling with syntax highlighting

### 5. Search

- Client-side search (no server needed)
- Indexes page titles, descriptions, and content
- Keyboard shortcut (Cmd/Ctrl + K)
- Fuzzy matching support

### 6. Responsive Design

- Mobile-friendly sidebar (drawer on mobile)
- Responsive typography
- Touch-friendly navigation

## Implementation Tasks

### Phase 1: Package Foundation
- [ ] Create pubspec.yaml with dependencies
- [ ] Create main barrel export
- [ ] Create SiteConfig class
- [ ] Create basic KnowledgeBaseApp component

### Phase 2: Navigation System
- [ ] Create NavItem model class
- [ ] Create NavSection model class
- [ ] Create NavBuilder to parse directory structure
- [ ] Create nav_manifest_builder for build-time generation
- [ ] Create _section.yaml support

### Phase 3: Layout Components
- [ ] Create KBLayout (main wrapper)
- [ ] Create KBHeader (search, theme toggle, logo)
- [ ] Create KBSidebar (auto-generated navigation)
- [ ] Create KBFooter (optional)
- [ ] Create KBToc (table of contents)

### Phase 4: Page Components
- [ ] Create KBPage (markdown content wrapper)
- [ ] Create KBHome (home/landing page)
- [ ] Create breadcrumbs component

### Phase 5: Theme & Styling
- [ ] Create KBTheme configuration
- [ ] Create KBStylesheet with CSS variables
- [ ] Create color palette system
- [ ] Add responsive breakpoints

### Phase 6: Scripts & Interactivity
- [ ] Create theme toggle script
- [ ] Create search functionality
- [ ] Create code copy buttons
- [ ] Create syntax highlighting integration

### Phase 7: Example & Documentation
- [ ] Create example project
- [ ] Create example markdown content
- [ ] Create README with usage instructions
- [ ] Create CHANGELOG

## Dependencies

```yaml
dependencies:
  jaspr: ^0.18.0
  jaspr_content: ^0.2.0
  arcane_jaspr:
    path: ../arcane_jaspr
  yaml: ^3.1.2

dev_dependencies:
  build_runner: ^2.4.0
  jaspr_builder: ^0.18.0
```

## Usage Example

```dart
// lib/main.server.dart
import 'package:arcane_jaspr_md/arcane_jaspr_md.dart';

void main() {
  Jaspr.initializeApp(
    KnowledgeBaseApp(
      config: SiteConfig(
        name: 'My Docs',
        contentDirectory: 'content/',
        githubUrl: 'https://github.com/myorg/myrepo',
      ),
    ),
  );
}
```

## File Structure Convention

```
content/
├── index.md                    # Home page (required)
├── _section.yaml               # Root section config (optional)
├── getting-started/
│   ├── _section.yaml           # Section: title, icon, order
│   ├── installation.md         # Page with frontmatter
│   └── quick-start.md
├── api/
│   ├── _section.yaml
│   ├── authentication.md
│   └── endpoints.md
└── guides/
    ├── _section.yaml
    └── deployment.md
```

## Navigation Generation Algorithm

1. Scan content directory recursively
2. For each directory:
   - Read `_section.yaml` if exists, else infer from folder name
   - Create NavSection with title, icon, order
3. For each `.md` file:
   - Parse frontmatter for title, order, icon, hidden
   - Create NavItem linked to route
4. Sort sections and items by order, then alphabetically
5. Build hierarchical navigation tree
6. Generate manifest for client-side use

## Key Differences from Codex

| Aspect | Codex | arcane_jaspr_md |
|--------|-------|-----------------|
| Navigation | Hardcoded in Dart | Auto-generated from files |
| Component demos | Built-in demo system | Not included (pure docs) |
| Configuration | Minimal | Full SiteConfig class |
| Reusability | Specific to arcane_jaspr | Generic for any project |
| Section metadata | None | _section.yaml support |
| Ordering | Manual in code | Frontmatter + yaml |

## Success Criteria

1. User can point package at any markdown folder
2. Navigation is automatically built from structure
3. Site looks professional out of the box
4. Works on static hosting (GitHub Pages, Netlify, etc.)
5. Minimal configuration required to get started
6. Full customization available when needed
