import 'package:jaspr_content/jaspr_content.dart';

/// A PageExtension that transforms GitHub-style alert syntax into styled callout blocks.
///
/// Supports the following alert types:
/// - `> [!NOTE]` - Informational note
/// - `> [!TIP]` - Helpful tip
/// - `> [!IMPORTANT]` - Important information
/// - `> [!WARNING]` - Warning message
/// - `> [!CAUTION]` - Caution/danger message
///
/// Example markdown:
/// ```markdown
/// > [!NOTE]
/// > This is a note callout.
/// > It can span multiple lines.
/// ```
class CalloutExtension implements PageExtension {
  const CalloutExtension();

  @override
  Future<List<Node>> apply(Page page, List<Node> nodes) async {
    final String content = page.content;

    // Process the content to transform callout syntax
    final String processedContent = _transformCallouts(content);

    if (processedContent != content) {
      page.apply(content: processedContent);
    }

    return nodes;
  }

  String _transformCallouts(String content) {
    // Pattern to match GitHub-style alerts: > [!TYPE]\n> content...
    final RegExp calloutPattern = RegExp(
      r'^(>[ ]?\[!(NOTE|TIP|IMPORTANT|WARNING|CAUTION)\])\n((?:>[ ]?.*\n?)+)',
      multiLine: true,
      caseSensitive: false,
    );

    return content.replaceAllMapped(calloutPattern, (match) {
      final String type = match.group(2)!.toLowerCase();
      String calloutContent = match.group(3)!;

      // Remove the leading '> ' from each line
      calloutContent = calloutContent
          .split('\n')
          .map((line) {
            if (line.startsWith('> ')) {
              return line.substring(2);
            } else if (line.startsWith('>')) {
              return line.substring(1);
            }
            return line;
          })
          .join('\n')
          .trim();

      // Escape any HTML in the content
      calloutContent = calloutContent
          .replaceAll('&', '&amp;')
          .replaceAll('<', '&lt;')
          .replaceAll('>', '&gt;');

      // Convert newlines to <br> for proper display
      calloutContent = calloutContent.replaceAll('\n', '<br>');

      // Get icon and title for the callout type
      final (String icon, String title) = _getCalloutMeta(type);

      // Return the HTML callout block
      return '''

<div class="kb-callout kb-callout-$type">
  <div class="kb-callout-title">
    <span class="kb-callout-icon">$icon</span>
    <span>$title</span>
  </div>
  <div class="kb-callout-content">$calloutContent</div>
</div>

''';
    });
  }

  (String icon, String title) _getCalloutMeta(String type) {
    return switch (type) {
      'note' => (
          '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg>',
          'Note'
        ),
      'tip' => (
          '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 14c.2-1 .7-1.7 1.5-2.5 1-.9 1.5-2.2 1.5-3.5A6 6 0 0 0 6 8c0 1 .2 2.2 1.5 3.5.7.7 1.3 1.5 1.5 2.5"/><path d="M9 18h6"/><path d="M10 22h4"/></svg>',
          'Tip'
        ),
      'important' => (
          '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>',
          'Important'
        ),
      'warning' => (
          '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>',
          'Warning'
        ),
      'caution' => (
          '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="m4.9 4.9 14.2 14.2"/></svg>',
          'Caution'
        ),
      _ => (
          '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/></svg>',
          'Note'
        ),
    };
  }
}
