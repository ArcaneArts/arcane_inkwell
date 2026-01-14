import 'dart:convert';

import '../config/site_config.dart';
import '../navigation/nav_item.dart';
import '../navigation/nav_section.dart';
import '../navigation/nav_builder.dart';

/// A single entry in the search index.
class SearchIndexEntry {
  /// Display title for the search result.
  final String title;

  /// URL path (relative to site root).
  final String path;

  /// Category/section name for grouping results.
  final String category;

  /// Optional description from frontmatter.
  final String? description;

  /// Tags/keywords for search matching.
  final List<String> keywords;

  /// Content excerpt for full-text search.
  final String? excerpt;

  /// Optional icon name.
  final String? icon;

  const SearchIndexEntry({
    required this.title,
    required this.path,
    required this.category,
    this.description,
    this.keywords = const [],
    this.excerpt,
    this.icon,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'path': path,
        'category': category,
        if (description != null) 'description': description,
        if (keywords.isNotEmpty) 'keywords': keywords,
        if (excerpt != null) 'excerpt': excerpt,
        if (icon != null) 'icon': icon,
      };
}

/// Generates a search index JSON file from the navigation manifest.
///
/// The search index is a flat list of all pages with their metadata,
/// optimized for client-side searching.
class SearchIndexGenerator {
  final SiteConfig config;
  final NavManifest manifest;

  const SearchIndexGenerator({
    required this.config,
    required this.manifest,
  });

  /// Generate the search index as a list of entries.
  List<SearchIndexEntry> generateEntries() {
    final List<SearchIndexEntry> entries = [];

    // Add root-level items
    for (final item in manifest.items) {
      if (item.hidden || item.draft) continue;
      entries.add(_itemToEntry(item, 'General'));
    }

    // Add items from sections
    _addSectionEntries(manifest.sections, entries);

    return entries;
  }

  void _addSectionEntries(
    List<NavSection> sections,
    List<SearchIndexEntry> entries,
  ) {
    for (final section in sections) {
      // Add items in this section
      for (final item in section.items) {
        if (item.hidden || item.draft) continue;
        entries.add(_itemToEntry(item, section.title));
      }

      // Recurse into nested sections
      _addSectionEntries(section.sections, entries);
    }
  }

  SearchIndexEntry _itemToEntry(NavItem item, String category) {
    // Build keywords from tags and path segments
    final List<String> keywords = [
      ...item.tags,
      // Add path segments as keywords (e.g., "minecraft" from "/game-servers/minecraft")
      ...item.path
          .split('/')
          .where((s) => s.isNotEmpty && s.length > 2)
          .map((s) => s.replaceAll('-', ' ')),
    ];

    return SearchIndexEntry(
      title: item.title,
      path: item.path,
      category: category,
      description: item.description,
      keywords: keywords.toSet().toList(), // Remove duplicates
      excerpt: item.excerpt,
      icon: item.icon,
    );
  }

  /// Generate the search index as a JSON string.
  ///
  /// Returns minified JSON by default. Set [pretty] to true for
  /// human-readable formatting.
  String generate({bool pretty = false}) {
    final entries = generateEntries();
    final data = {
      'version': 1,
      'generated': DateTime.now().toUtc().toIso8601String(),
      'count': entries.length,
      'entries': entries.map((e) => e.toJson()).toList(),
    };

    if (pretty) {
      return const JsonEncoder.withIndent('  ').convert(data);
    }
    return jsonEncode(data);
  }
}
