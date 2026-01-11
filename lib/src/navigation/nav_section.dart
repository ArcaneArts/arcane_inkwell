import 'nav_item.dart';

/// Represents a navigation section (folder of pages).
class NavSection {
  /// The display title for the section.
  final String title;

  /// The URL path prefix for this section.
  final String path;

  /// Optional icon name (Lucide icon).
  final String? icon;

  /// Sort order (lower = first).
  final int order;

  /// Whether this section is collapsed by default.
  final bool collapsed;

  /// Child navigation items.
  final List<NavItem> items;

  /// Nested child sections.
  final List<NavSection> sections;

  const NavSection({
    required this.title,
    required this.path,
    this.icon,
    this.order = 999,
    this.collapsed = true,
    this.items = const [],
    this.sections = const [],
  });

  /// Create from section config data (JSON5 or YAML).
  factory NavSection.fromConfig({
    required String path,
    required Map<String, dynamic> config,
    required String fallbackTitle,
    List<NavItem> items = const [],
    List<NavSection> sections = const [],
  }) {
    return NavSection(
      title: config['title'] as String? ?? fallbackTitle,
      path: path,
      icon: config['icon'] as String?,
      order: config['order'] as int? ?? 999,
      collapsed: config['collapsed'] as bool? ?? true,
      items: items,
      sections: sections,
    );
  }

  /// Create from _section.yaml data.
  /// @deprecated Use [fromConfig] instead.
  factory NavSection.fromYaml({
    required String path,
    required Map<String, dynamic> yaml,
    required String fallbackTitle,
    List<NavItem> items = const [],
    List<NavSection> sections = const [],
  }) {
    return NavSection.fromConfig(
      path: path,
      config: yaml,
      fallbackTitle: fallbackTitle,
      items: items,
      sections: sections,
    );
  }

  /// Create from folder name without _section.yaml.
  factory NavSection.fromFolderName({
    required String path,
    required String folderName,
    List<NavItem> items = const [],
    List<NavSection> sections = const [],
  }) {
    return NavSection(
      title: NavItem.filenameToTitle(folderName),
      path: path,
      items: items,
      sections: sections,
    );
  }

  /// Get all items sorted by order, then alphabetically.
  List<NavItem> get sortedItems {
    final sorted = List<NavItem>.from(items);
    sorted.sort((a, b) {
      final orderCompare = a.order.compareTo(b.order);
      if (orderCompare != 0) return orderCompare;
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
    return sorted;
  }

  /// Get all sections sorted by order, then alphabetically.
  List<NavSection> get sortedSections {
    final sorted = List<NavSection>.from(sections);
    sorted.sort((a, b) {
      final orderCompare = a.order.compareTo(b.order);
      if (orderCompare != 0) return orderCompare;
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
    return sorted;
  }

  /// Get visible items (not hidden or draft).
  List<NavItem> get visibleItems =>
      sortedItems.where((item) => !item.hidden && !item.draft).toList();

  /// Check if this section should be expanded for a given path.
  bool shouldExpandFor(String currentPath) {
    if (currentPath.startsWith(path)) return true;
    for (final item in items) {
      if (item.path == currentPath) return true;
    }
    for (final section in sections) {
      if (section.shouldExpandFor(currentPath)) return true;
    }
    return false;
  }

  @override
  String toString() =>
      'NavSection(title: $title, path: $path, items: ${items.length}, sections: ${sections.length})';
}
