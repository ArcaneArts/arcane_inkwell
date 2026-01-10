/// Represents a single navigation item (page link).
class NavItem {
  /// The display title for the nav item.
  final String title;

  /// The URL path for this item.
  final String path;

  /// Optional icon name (Lucide icon).
  final String? icon;

  /// Sort order (lower = first).
  final int order;

  /// Whether this item is hidden from navigation.
  final bool hidden;

  /// Optional description for search indexing.
  final String? description;

  /// Tags for filtering/search.
  final List<String> tags;

  const NavItem({
    required this.title,
    required this.path,
    this.icon,
    this.order = 999,
    this.hidden = false,
    this.description,
    this.tags = const [],
  });

  /// Create from frontmatter data.
  factory NavItem.fromFrontmatter({
    required String path,
    required Map<String, dynamic> frontmatter,
    required String fallbackTitle,
  }) {
    return NavItem(
      title: frontmatter['title'] as String? ?? fallbackTitle,
      path: path,
      icon: frontmatter['icon'] as String?,
      order: frontmatter['order'] as int? ?? 999,
      hidden: frontmatter['hidden'] as bool? ?? false,
      description: frontmatter['description'] as String?,
      tags: (frontmatter['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  /// Convert filename to readable title.
  static String filenameToTitle(String filename) {
    // Remove .md extension
    String name = filename.replaceAll('.md', '');

    // Convert kebab-case or snake_case to Title Case
    return name
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  @override
  String toString() => 'NavItem(title: $title, path: $path, order: $order)';
}
