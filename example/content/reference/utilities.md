---
title: Utilities
description: Reference for sitemap, search-index, and changelog utilities
icon: wrench
order: 10
tags:
  - reference
  - utilities
  - changelog
  - sitemap
---

Arcane Lexicon exports utility classes that you can wire into your build or release workflow.

## SitemapGenerator

`SitemapGenerator` builds XML from the current navigation manifest.

```dart
final NavBuilder navBuilder = NavBuilder(contentDir: config.contentDirectory);
final NavManifest manifest = await navBuilder.build();

final SitemapGenerator generator = SitemapGenerator(
  config: config,
  manifest: manifest,
  siteUrl: 'https://docs.example.com',
);

final String xml = generator.generate();
await File('web/sitemap.xml').writeAsString(xml);
```

## SearchIndexGenerator

`SearchIndexGenerator` creates `search-index.json` style payloads from the manifest.

```dart
final NavBuilder navBuilder = NavBuilder(contentDir: config.contentDirectory);
final NavManifest manifest = await navBuilder.build();

final SearchIndexGenerator generator = SearchIndexGenerator(
  config: config,
  manifest: manifest,
);

final String json = generator.generate(pretty: true);
await File('web/search-index.json').writeAsString(json);
```

Generated entries include:

- `title`
- `path`
- `category`
- `description` (when present)
- `keywords`
- `excerpt` (when present)
- `icon` (when present)

## ChangelogParser

`ChangelogParser` reads Keep a Changelog style markdown and returns structured versions.

```dart
final String changelog = await File('CHANGELOG.md').readAsString();
final ChangelogParser parser = ChangelogParser();
final List<ChangelogVersion> versions = parser.parse(changelog);
```

Use parsed versions with the exported `KBChangelog` component:

```dart
KBChangelog(
  versions: versions,
  maxVersions: 5,
  githubUrl: config.githubUrl,
)
```

## Notes

- Utilities skip hidden/draft pages when generating sitemap/search data.
- Utilities are opt-in; they are not auto-wired unless your app/build flow calls them.
