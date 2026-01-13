---
title: Sitemap Generation
description: Automatic XML sitemap generation for SEO
icon: globe
order: 3
tags:
  - seo
  - sitemap
  - deployment
---

Arcane Inkwell automatically generates an XML sitemap for search engine optimization.

## How It Works

During the build process, a `sitemap.xml` file is generated at the root of your site containing all visible pages.

## Features

### Automatic Generation

The sitemap is built from the navigation manifest, ensuring it stays in sync with your content.

### Visibility Filtering

The sitemap automatically excludes:
- Hidden pages (`hidden: true` in frontmatter)
- Draft pages (`draft: true` in frontmatter)

### Priority Calculation

Page priority is calculated based on URL depth:

| Depth | Path Example | Priority |
|-------|--------------|----------|
| 0 | `/` (home) | 1.0 |
| 1 | `/guide` | 0.8 |
| 2 | `/guide/basics` | 0.6 |
| 3 | `/guide/basics/install` | 0.4 |
| 4+ | `/guide/basics/sub/page` | 0.3 |

### Change Frequency

All pages are marked with `<changefreq>weekly</changefreq>` by default.

## Sitemap Format

The generated sitemap follows the standard XML sitemap protocol:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://example.com/</loc>
    <priority>1.0</priority>
    <changefreq>weekly</changefreq>
  </url>
  <url>
    <loc>https://example.com/guide</loc>
    <priority>0.8</priority>
    <changefreq>weekly</changefreq>
  </url>
  <!-- ... more URLs -->
</urlset>
```

## Usage

### Accessing the Sitemap

After building, the sitemap is available at:
```
https://your-docs-site.com/sitemap.xml
```

### Submitting to Search Engines

Submit your sitemap to search engines for faster indexing:

1. **Google Search Console**: Add your sitemap URL in the Sitemaps section
2. **Bing Webmaster Tools**: Submit via the Sitemaps feature
3. **robots.txt**: Add a sitemap directive:

```
Sitemap: https://your-docs-site.com/sitemap.xml
```

## Base URL Configuration

If hosting at a subdirectory, ensure `baseUrl` is configured:

```dart
SiteConfig(
  name: 'My Docs',
  baseUrl: '/docs',
)
```

The sitemap URLs will include the base path.
