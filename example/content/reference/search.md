---
title: Search
description: Built-in search functionality
icon: search
order: 5
tags:
  - features
  - search
  - navigation
---

Arcane Inkwell includes a built-in client-side search that indexes your documentation for fast, instant results.

## Features

- **Instant Search** - Results appear as you type
- **Keyboard Navigation** - Use `Cmd/Ctrl + K` to focus search
- **Category Labels** - Results are grouped by section
- **Full-Text Indexing** - Searches titles, descriptions, and content excerpts

## Usage

### Mouse/Touch

1. Click the search input in the sidebar
2. Type your search query (minimum 2 characters)
3. Click a result to navigate

### Keyboard

| Shortcut | Action |
|----------|--------|
| `Cmd/Ctrl + K` | Focus search input |
| `Escape` | Clear search and close results |
| `Enter` | Navigate to first result |

## Configuration

### Enable/Disable Search

```dart
SiteConfig(
  name: 'My Docs',
  searchEnabled: true,  // default: true
)
```

When disabled, the search input is hidden from the sidebar.

## How It Works

### Indexing

Search indexes are built from the navigation manifest, which includes:

1. **Page titles** - Primary search target
2. **Descriptions** - From frontmatter
3. **Content excerpts** - First ~500 characters of content (stripped of markdown)
4. **Tags** - All tags from frontmatter

### Search Algorithm

The search performs case-insensitive substring matching on:
- Titles
- Descriptions
- Excerpts

Results are displayed with their section path for context.

### Filtering

The search automatically excludes:
- Hidden pages (`hidden: true`)
- Draft pages (`draft: true`)

## Search Results

Results display:
- **Title** - Page title
- **Section** - Parent section path
- **Match highlighting** - Matched text is highlighted

Maximum 10 results are shown to keep the interface clean.

## Limitations

- **Client-side only** - No server requests, works offline
- **No fuzzy matching** - Searches for exact substrings
- **No weighting** - All matches treated equally
- **English only** - No language-specific tokenization

## Customization

Currently, search behavior is not customizable beyond enabling/disabling. Future versions may include:
- Custom search weighting
- Fuzzy matching options
- External search integration

## Best Practices

### Improve Searchability

1. **Use descriptive titles** - Clear, keyword-rich titles
2. **Add descriptions** - Frontmatter descriptions are indexed
3. **Use tags** - Tags help categorize and find content
4. **Write clear first paragraphs** - Excerpts are indexed

### Example

```yaml
---
title: Authentication with JWT Tokens
description: Complete guide to implementing JWT-based authentication
tags:
  - security
  - jwt
  - authentication
  - tokens
---

This guide explains how to implement JSON Web Token (JWT)
authentication in your application...
```

This page will match searches for:
- "authentication"
- "jwt"
- "tokens"
- "security"
- "json web token"
