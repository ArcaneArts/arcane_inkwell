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

## Markdown Utility Components

The default rich markdown set includes small docs/site utility components for common reference content:

- `<Kbd>` and `<Key>` for keyboard shortcuts.
- `<FilePath>` for file paths, routes, and config keys.
- `<Endpoint>` for REST or site endpoint references.
- `<ResourceGrid>` and `<Resource>` for compact related docs, downloads, and external resources.

```markdown
Use <Kbd>⌘</Kbd> + <Kbd>K</Kbd> to open search.
Edit <FilePath>content/guide/basics/configuration.md</FilePath>.
<Endpoint method="GET" path="/search-index.json" />

<ResourceGrid>
  <Resource title="Configuration" href="/guide/basics/configuration" icon="settings" label="Guide">
    Configure site-wide behavior and section metadata.
  </Resource>
  <Resource title="Search Index" href="/reference/search" icon="search" label="Reference">
    Understand generated search metadata and runtime search behavior.
  </Resource>
</ResourceGrid>
```

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
