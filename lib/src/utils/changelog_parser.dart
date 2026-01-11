/// A parsed changelog entry representing a version.
class ChangelogVersion {
  final String version;
  final String? date;
  final Map<String, List<String>> sections;

  const ChangelogVersion({
    required this.version,
    this.date,
    required this.sections,
  });

  /// Get entries for a specific section (e.g., 'Added', 'Changed', 'Fixed').
  List<String> operator [](String section) => sections[section] ?? const [];

  /// Check if this version has any entries.
  bool get isEmpty =>
      sections.isEmpty || sections.values.every((l) => l.isEmpty);

  /// Check if this version has any entries.
  bool get isNotEmpty => !isEmpty;

  /// Get all section names that have entries.
  Iterable<String> get sectionNames =>
      sections.keys.where((k) => sections[k]!.isNotEmpty);
}

/// Parses CHANGELOG.md files following Keep a Changelog format.
///
/// See: https://keepachangelog.com/
class ChangelogParser {
  const ChangelogParser();

  /// Parse a CHANGELOG.md file content.
  ///
  /// Returns a list of versions with their sections and entries.
  List<ChangelogVersion> parse(String content) {
    final List<ChangelogVersion> versions = [];

    // Split by version headers (## [version] or ## version)
    final RegExp versionPattern = RegExp(
      r'^##\s+\[?([^\]\s]+)\]?(?:\s*-\s*(.+))?$',
      multiLine: true,
    );

    final List<RegExpMatch> matches =
        versionPattern.allMatches(content).toList();

    for (int i = 0; i < matches.length; i++) {
      final RegExpMatch match = matches[i];
      final String version = match.group(1)!;
      final String? date = match.group(2)?.trim();

      // Get content between this version and the next (or end of file)
      final int startIndex = match.end;
      final int endIndex =
          i + 1 < matches.length ? matches[i + 1].start : content.length;
      final String versionContent = content.substring(startIndex, endIndex);

      // Parse sections within this version
      final Map<String, List<String>> sections = _parseSections(versionContent);

      versions.add(ChangelogVersion(
        version: version,
        date: date,
        sections: sections,
      ));
    }

    return versions;
  }

  Map<String, List<String>> _parseSections(String content) {
    final Map<String, List<String>> sections = {};

    // Match section headers (### Added, ### Changed, etc.)
    final RegExp sectionPattern = RegExp(
      r'^###\s+(.+)$',
      multiLine: true,
    );

    final List<RegExpMatch> matches =
        sectionPattern.allMatches(content).toList();

    for (int i = 0; i < matches.length; i++) {
      final RegExpMatch match = matches[i];
      final String sectionName = match.group(1)!.trim();

      // Get content between this section and the next (or end)
      final int startIndex = match.end;
      final int endIndex =
          i + 1 < matches.length ? matches[i + 1].start : content.length;
      final String sectionContent = content.substring(startIndex, endIndex);

      // Parse list items
      final List<String> items = _parseItems(sectionContent);

      if (items.isNotEmpty) {
        sections[sectionName] = items;
      }
    }

    return sections;
  }

  List<String> _parseItems(String content) {
    final List<String> items = [];

    // Match list items (- or *)
    final RegExp itemPattern = RegExp(r'^[\-\*]\s+(.+)$', multiLine: true);

    for (final RegExpMatch match in itemPattern.allMatches(content)) {
      final String item = match.group(1)!.trim();
      if (item.isNotEmpty) {
        items.add(item);
      }
    }

    return items;
  }
}

/// Standard changelog section names.
class ChangelogSections {
  static const String added = 'Added';
  static const String changed = 'Changed';
  static const String deprecated = 'Deprecated';
  static const String removed = 'Removed';
  static const String fixed = 'Fixed';
  static const String security = 'Security';

  /// All standard section names.
  static const List<String> all = [
    added,
    changed,
    deprecated,
    removed,
    fixed,
    security,
  ];
}
