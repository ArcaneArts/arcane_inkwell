import '../config/site_config.dart';
import '../navigation/nav_item.dart';
import '../navigation/nav_section.dart';
import '../navigation/nav_builder.dart';

/// Generates an XML sitemap from the navigation manifest.
class SitemapGenerator {
  final SiteConfig config;
  final NavManifest manifest;
  final String? siteUrl;

  const SitemapGenerator({
    required this.config,
    required this.manifest,
    this.siteUrl,
  });

  /// Generate the sitemap XML content.
  ///
  /// Returns the complete sitemap.xml content as a string.
  /// The caller is responsible for writing this to a file.
  String generate() {
    final StringBuffer buffer = StringBuffer();

    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln(
        '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">');

    final String baseUrl = siteUrl ?? '';

    // Add all pages from manifest
    _addItems(manifest.items, buffer, baseUrl);
    _addSections(manifest.sections, buffer, baseUrl);

    buffer.writeln('</urlset>');

    return buffer.toString();
  }

  void _addItems(List<NavItem> items, StringBuffer buffer, String baseUrl) {
    for (final NavItem item in items) {
      // Skip hidden and draft pages
      if (item.hidden || item.draft) continue;

      final String fullUrl = '$baseUrl${config.fullPath(item.path)}';
      buffer.writeln('  <url>');
      buffer.writeln('    <loc>${_escapeXml(fullUrl)}</loc>');
      // Default priority based on path depth
      final double priority = _calculatePriority(item.path);
      buffer.writeln('    <priority>$priority</priority>');
      buffer.writeln('    <changefreq>weekly</changefreq>');
      buffer.writeln('  </url>');
    }
  }

  void _addSections(
      List<NavSection> sections, StringBuffer buffer, String baseUrl) {
    for (final NavSection section in sections) {
      // Add section index if it has one (check for index item or add section path)
      final bool hasIndex =
          section.items.any((item) => item.path == section.path);
      if (!hasIndex) {
        // Add section path as a page
        final String fullUrl = '$baseUrl${config.fullPath(section.path)}';
        buffer.writeln('  <url>');
        buffer.writeln('    <loc>${_escapeXml(fullUrl)}</loc>');
        final double priority = _calculatePriority(section.path);
        buffer.writeln('    <priority>$priority</priority>');
        buffer.writeln('    <changefreq>weekly</changefreq>');
        buffer.writeln('  </url>');
      }

      // Add items in this section
      _addItems(section.items, buffer, baseUrl);

      // Recurse into nested sections
      _addSections(section.sections, buffer, baseUrl);
    }
  }

  double _calculatePriority(String path) {
    if (path == '/' || path.isEmpty) return 1.0;

    final int depth = path.split('/').where((s) => s.isNotEmpty).length;

    return switch (depth) {
      1 => 0.8,
      2 => 0.6,
      3 => 0.4,
      _ => 0.3,
    };
  }

  String _escapeXml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }
}
