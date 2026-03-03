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
    final RegExp fencedCodePattern = RegExp(
      r'(```[\s\S]*?```|~~~[\s\S]*?~~~)',
      multiLine: true,
    );

    StringBuffer result = StringBuffer();
    int cursor = 0;
    for (Match match in fencedCodePattern.allMatches(content)) {
      String segment = content.substring(cursor, match.start);
      result.write(_transformCalloutsInSegment(segment));
      result.write(match.group(0)!);
      cursor = match.end;
    }
    result.write(_transformCalloutsInSegment(content.substring(cursor)));
    return result.toString();
  }

  String _transformCalloutsInSegment(String segment) {
    final RegExp headerPattern = RegExp(
      r'^[ \t]*>[ \t]*\[!(NOTE|TIP|IMPORTANT|WARNING|CAUTION)\](?:[ \t]+([^\r\n]+))?[ \t]*$',
      caseSensitive: false,
    );
    final RegExp quoteLinePattern = RegExp(r'^[ \t]*>[ \t]?(.*)$');
    final RegExp blockBreakPattern = RegExp(
      r'^[ \t]*(?:#{1,6}\s|[-*+]\s|\d+\.\s|```|~~~|<|>|---$|\*\*\*$|___$)',
    );
    final List<String> lines = segment.split('\n');
    final StringBuffer result = StringBuffer();
    int index = 0;

    while (index < lines.length) {
      String sourceLine = lines[index];
      String line = sourceLine.replaceFirst(RegExp(r'\r$'), '');
      Match? headerMatch = headerPattern.firstMatch(line);
      if (headerMatch == null) {
        result.write(sourceLine);
        if (index < lines.length - 1) {
          result.write('\n');
        }
        index += 1;
        continue;
      }

      String type = (headerMatch.group(1) ?? 'note').toLowerCase();
      String? customTitle = headerMatch.group(2);
      List<String> bodyLines = <String>[];
      int nextIndex = index + 1;

      while (nextIndex < lines.length) {
        String nextSourceLine = lines[nextIndex];
        String nextLine = nextSourceLine.replaceFirst(RegExp(r'\r$'), '');
        Match? quoteMatch = quoteLinePattern.firstMatch(nextLine);
        if (quoteMatch == null) {
          break;
        }
        String quotedBodyLine = quoteMatch.group(1) ?? '';
        bodyLines.add(quotedBodyLine);
        nextIndex += 1;
      }

      if (bodyLines.isEmpty) {
        int paragraphIndex = nextIndex;
        while (paragraphIndex < lines.length) {
          String paragraphSourceLine = lines[paragraphIndex];
          String paragraphLine = paragraphSourceLine.replaceFirst(
            RegExp(r'\r$'),
            '',
          );
          String paragraphTrimmed = paragraphLine.trimRight();
          if (paragraphTrimmed.trim().isEmpty) {
            break;
          }
          if (blockBreakPattern.hasMatch(paragraphTrimmed)) {
            break;
          }
          bodyLines.add(paragraphTrimmed);
          paragraphIndex += 1;
        }
        nextIndex = paragraphIndex;
      }

      String componentName = _getComponentName(type);
      String defaultTitle = _getDefaultTitle(type);
      String title = customTitle?.trim() ?? defaultTitle;
      if (title.isEmpty) {
        title = defaultTitle;
      }
      String titleAttribute = _escapeAttribute(title);
      String calloutContent = bodyLines.join('\n').trim();

      result.write('<$componentName title="$titleAttribute">\n');
      if (calloutContent.isNotEmpty) {
        result.write(calloutContent);
        result.write('\n');
      }
      result.write('</$componentName>');
      if (nextIndex < lines.length) {
        result.write('\n');
      }
      index = nextIndex;
    }

    return result.toString();
  }

  String _getComponentName(String type) {
    return switch (type) {
      'note' => 'Note',
      'tip' => 'Tip',
      'important' => 'Important',
      'warning' => 'Warning',
      'caution' => 'Caution',
      _ => 'Note',
    };
  }

  String _getDefaultTitle(String type) {
    return switch (type) {
      'note' => 'Note',
      'tip' => 'Tip',
      'important' => 'Important',
      'warning' => 'Warning',
      'caution' => 'Caution',
      _ => 'Note',
    };
  }

  String _escapeAttribute(String value) {
    return value
        .replaceAll('&', '&amp;')
        .replaceAll('"', '&quot;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');
  }
}
