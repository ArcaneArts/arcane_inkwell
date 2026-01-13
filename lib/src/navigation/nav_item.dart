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

  /// Whether this item is a draft (hidden from nav + shows draft badge).
  final bool draft;

  /// Optional description for search indexing.
  final String? description;

  /// Tags for filtering/search.
  final List<String> tags;

  /// Content excerpt for full-text search (first ~200 chars).
  final String? excerpt;

  /// Optional author name from frontmatter.
  final String? author;

  /// Optional date from frontmatter (e.g., publication date).
  final String? date;

  /// File last modified timestamp (ISO 8601 string).
  final String? lastModified;

  const NavItem({
    required this.title,
    required this.path,
    this.icon,
    this.order = 999,
    this.hidden = false,
    this.draft = false,
    this.description,
    this.tags = const [],
    this.excerpt,
    this.author,
    this.date,
    this.lastModified,
  });

  /// Create from frontmatter data.
  factory NavItem.fromFrontmatter({
    required String path,
    required Map<String, dynamic> frontmatter,
    required String fallbackTitle,
    String? excerpt,
    String? lastModified,
  }) {
    return NavItem(
      title: frontmatter['title'] as String? ?? fallbackTitle,
      path: path,
      icon: frontmatter['icon'] as String?,
      order: frontmatter['order'] as int? ?? 999,
      hidden: frontmatter['hidden'] as bool? ?? false,
      draft: frontmatter['draft'] as bool? ?? false,
      description: frontmatter['description'] as String?,
      tags: (frontmatter['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      excerpt: excerpt,
      author: frontmatter['author'] as String?,
      date: frontmatter['date']?.toString(),
      lastModified: lastModified,
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
