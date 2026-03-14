---
title: Sitemap Utility
description: Generate sitemap XML with SitemapGenerator
icon: globe
order: 3
tags:
  - seo
  - sitemap
  - deployment
---

Arcane Lexicon exports `SitemapGenerator` for sitemap XML generation.

## Current Behavior

- `KnowledgeBaseApp` currently auto-generates `web/search-index.json` (when enabled).
- `sitemap.xml` generation is available as a utility and can be wired into your build workflow.

## Generating a Sitemap

```dart
import 'dart:io';
import 'package:arcane_lexicon/arcane_lexicon.dart';

Future<void> generateSitemap() async {
  SiteConfig config = const SiteConfig(
    name: 'My Docs',
    contentDirectory: 'content',
    baseUrl: '/docs',
  );

  NavBuilder navBuilder = NavBuilder(
    contentDirectory: config.contentDirectory,
    baseUrl: config.baseUrl,
  );

  NavManifest manifest = await navBuilder.build();

  SitemapGenerator generator = SitemapGenerator(
    config: config,
    manifest: manifest,
    siteUrl: 'https://example.com',
  );

  String xml = generator.generate();
  await File('web/sitemap.xml').writeAsString(xml);
}
```

## Output Rules

- Hidden pages (`hidden: true`) are excluded.
- Draft pages (`draft: true`) are excluded.
- Priority is depth-based:
  - `/` -> `1.0`
  - depth 1 -> `0.8`
  - depth 2 -> `0.6`
  - depth 3 -> `0.4`
  - depth 4+ -> `0.3`
- Change frequency is `weekly`.

## Subpath Hosting

If you host docs at a subpath, keep `baseUrl` consistent with deployment (`/docs`, `/help`, etc.) so generated locations match production URLs.

