import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:json5/json5.dart';
import 'nav_item.dart';
import 'nav_section.dart';

/// Builds navigation structure from a directory of markdown files.
class NavBuilder {
  final String contentDirectory;
  final String baseUrl;

  NavBuilder({
    required this.contentDirectory,
    this.baseUrl = '',
  });

  /// Build the complete navigation tree from the content directory.
  Future<NavManifest> build() async {
    final contentDir = Directory(contentDirectory);
    if (!await contentDir.exists()) {
      throw Exception('Content directory not found: $contentDirectory');
    }

    final rootItems = <NavItem>[];
    final rootSections = <NavSection>[];

    await _scanDirectory(
      contentDir,
      '',
      rootItems,
      rootSections,
    );

    return NavManifest(
      items: rootItems,
      sections: rootSections,
    );
  }

  Future<void> _scanDirectory(
    Directory dir,
    String pathPrefix,
    List<NavItem> items,
    List<NavSection> sections,
  ) async {
    final entities = await dir.list().toList();

    // Sort entities for consistent ordering
    entities.sort((a, b) => a.path.compareTo(b.path));

    // Check for section config (prefer JSON5 over YAML)
    final Map<String, dynamic>? sectionConfig = await _loadSectionConfig(dir.path);

    // Process files first
    for (final entity in entities) {
      if (entity is File) {
        final filename = entity.path.split('/').last;

        // Skip non-markdown files and special files
        if (!filename.endsWith('.md')) continue;
        if (filename.startsWith('_')) continue;

        // Build the path
        String pagePath;
        if (filename == 'index.md') {
          pagePath = pathPrefix.isEmpty ? '/' : pathPrefix;
        } else {
          final slug = filename.replaceAll('.md', '');
          pagePath = pathPrefix.isEmpty ? '/$slug' : '$pathPrefix/$slug';
        }

        // Parse frontmatter
        final content = await entity.readAsString();
        final frontmatter = _parseFrontmatter(content);

        final item = NavItem.fromFrontmatter(
          path: pagePath,
          frontmatter: frontmatter,
          fallbackTitle: NavItem.filenameToTitle(filename),
        );

        items.add(item);
      }
    }

    // Process subdirectories
    for (final entity in entities) {
      if (entity is Directory) {
        final folderName = entity.path.split('/').last;

        // Skip hidden directories
        if (folderName.startsWith('.')) continue;

        // Check for section config in this subdirectory first to see if ignored
        final Map<String, dynamic>? subSectionConfig =
            await _loadSectionConfig(entity.path);

        // Skip ignored folders
        if (subSectionConfig?['ignore'] == true) continue;

        final sectionPath =
            pathPrefix.isEmpty ? '/$folderName' : '$pathPrefix/$folderName';
        final sectionItems = <NavItem>[];
        final nestedSections = <NavSection>[];

        await _scanDirectory(
          entity,
          sectionPath,
          sectionItems,
          nestedSections,
        );

        // Only add section if it has content
        if (sectionItems.isNotEmpty || nestedSections.isNotEmpty) {
          final section = subSectionConfig != null
              ? NavSection.fromConfig(
                  path: sectionPath,
                  config: subSectionConfig,
                  fallbackTitle: NavItem.filenameToTitle(folderName),
                  items: sectionItems,
                  sections: nestedSections,
                )
              : NavSection.fromFolderName(
                  path: sectionPath,
                  folderName: folderName,
                  items: sectionItems,
                  sections: nestedSections,
                );

          sections.add(section);
        }
      }
    }
  }

  /// Load section configuration from _section.json5 or _section.yaml.
  /// Prefers JSON5 over YAML if both exist.
  Future<Map<String, dynamic>?> _loadSectionConfig(String dirPath) async {
    // Try JSON5 first (preferred - supports comments)
    final json5File = File('$dirPath/_section.json5');
    if (await json5File.exists()) {
      final content = await json5File.readAsString();
      try {
        final dynamic parsed = JSON5.parse(content);
        if (parsed is Map) {
          return Map<String, dynamic>.from(parsed);
        }
      } catch (e) {
        // Fall through to try YAML
      }
    }

    // Fall back to YAML
    final yamlFile = File('$dirPath/_section.yaml');
    if (await yamlFile.exists()) {
      final content = await yamlFile.readAsString();
      try {
        final dynamic parsed = loadYaml(content);
        if (parsed is YamlMap) {
          return Map<String, dynamic>.from(parsed);
        }
      } catch (e) {
        // Return null if parsing fails
      }
    }

    return null;
  }

  /// Parse YAML frontmatter from markdown content.
  Map<String, dynamic> _parseFrontmatter(String content) {
    final frontmatterRegex = RegExp(r'^---\s*\n([\s\S]*?)\n---', multiLine: true);
    final match = frontmatterRegex.firstMatch(content);

    if (match == null) return {};

    try {
      final yamlContent = match.group(1);
      if (yamlContent == null || yamlContent.trim().isEmpty) return {};

      final yaml = loadYaml(yamlContent);
      if (yaml is YamlMap) {
        return Map<String, dynamic>.from(yaml);
      }
      return {};
    } catch (e) {
      return {};
    }
  }
}

/// The complete navigation manifest.
class NavManifest {
  /// Root-level navigation items.
  final List<NavItem> items;

  /// Root-level navigation sections.
  final List<NavSection> sections;

  const NavManifest({
    required this.items,
    required this.sections,
  });

  /// Get all items sorted by order.
  List<NavItem> get sortedItems {
    final sorted = List<NavItem>.from(items);
    sorted.sort((a, b) {
      final orderCompare = a.order.compareTo(b.order);
      if (orderCompare != 0) return orderCompare;
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
    return sorted;
  }

  /// Get all sections sorted by order.
  List<NavSection> get sortedSections {
    final sorted = List<NavSection>.from(sections);
    sorted.sort((a, b) {
      final orderCompare = a.order.compareTo(b.order);
      if (orderCompare != 0) return orderCompare;
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
    return sorted;
  }

  /// Get visible root items.
  List<NavItem> get visibleItems =>
      sortedItems.where((item) => !item.hidden).toList();

  /// Convert to JSON for client-side use.
  Map<String, dynamic> toJson() {
    return {
      'items': items.map(_itemToJson).toList(),
      'sections': sections.map(_sectionToJson).toList(),
    };
  }

  Map<String, dynamic> _itemToJson(NavItem item) {
    return {
      'title': item.title,
      'path': item.path,
      'icon': item.icon,
      'order': item.order,
      'hidden': item.hidden,
      'description': item.description,
      'tags': item.tags,
    };
  }

  Map<String, dynamic> _sectionToJson(NavSection section) {
    return {
      'title': section.title,
      'path': section.path,
      'icon': section.icon,
      'order': section.order,
      'collapsed': section.collapsed,
      'items': section.items.map(_itemToJson).toList(),
      'sections': section.sections.map(_sectionToJson).toList(),
    };
  }

  /// Create from JSON.
  factory NavManifest.fromJson(Map<String, dynamic> json) {
    return NavManifest(
      items: (json['items'] as List<dynamic>)
          .map((e) => _itemFromJson(e as Map<String, dynamic>))
          .toList(),
      sections: (json['sections'] as List<dynamic>)
          .map((e) => _sectionFromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static NavItem _itemFromJson(Map<String, dynamic> json) {
    return NavItem(
      title: json['title'] as String,
      path: json['path'] as String,
      icon: json['icon'] as String?,
      order: json['order'] as int? ?? 999,
      hidden: json['hidden'] as bool? ?? false,
      description: json['description'] as String?,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  static NavSection _sectionFromJson(Map<String, dynamic> json) {
    return NavSection(
      title: json['title'] as String,
      path: json['path'] as String,
      icon: json['icon'] as String?,
      order: json['order'] as int? ?? 999,
      collapsed: json['collapsed'] as bool? ?? true,
      items: (json['items'] as List<dynamic>)
          .map((e) => _itemFromJson(e as Map<String, dynamic>))
          .toList(),
      sections: (json['sections'] as List<dynamic>)
          .map((e) => _sectionFromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Get total page count.
  int get totalPages {
    int count = items.length;
    for (final section in sections) {
      count += _countSectionPages(section);
    }
    return count;
  }

  int _countSectionPages(NavSection section) {
    int count = section.items.length;
    for (final nested in section.sections) {
      count += _countSectionPages(nested);
    }
    return count;
  }
}
