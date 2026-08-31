import 'dart:io';

import 'package:test/test.dart';

void main() {
  group('published writing policy', () {
    final Directory repository = Directory.current;
    final List<File> proseFiles = <File>[
      File('${repository.path}/README.md'),
      File('${repository.path}/CHANGELOG.md'),
      File('${repository.path}/pubspec.yaml'),
      ..._filesUnder(Directory('${repository.path}/example/content')),
      ..._filesUnder(Directory('${repository.path}/example/lib')),
      ..._filesUnder(Directory('${repository.path}/lib')),
    ];
    final List<File> leakFiles = <File>[...proseFiles];

    test('contains no AI citation or tracking fingerprints', () {
      final RegExp leakPattern = RegExp(
        r'citeturn\d+|contentReference\[oaicite|oai_citation|'
        r'\[attached_file:\d+\]|grok_card|'
        r'utm_source=(?:chatgpt\.com|copilot\.com|openai|claude\.ai|perplexity\.ai)|'
        r'referrer=grok\.com',
        caseSensitive: false,
      );

      expect(_matches(leakFiles, leakPattern), isEmpty);
    });

    test('contains no high-confidence P0 or P1 stock phrases', () {
      final RegExp stockPhrasePattern = RegExp(
        r'\b(?:as of my last update|i hope this helps|great question|'
        r'feel free to reach out|let me know if you need anything else|'
        r'experts believe|studies show|research suggests|industry leaders agree|'
        r"let's (?:dive in|explore|take a look|break (?:this )?down|examine)|"
        r"in today's|in an era where|it's worth noting(?: that)?|"
        r'at the end of the day|the future looks bright|only time will tell|'
        r'could potentially|may eventually|might ultimately|'
        r'whether you(?: are|\x27re)\b.{0,80}\bor\b|'
        r'delve(?:s|d|ing)?|tapestry|testament to|game[- ]chang(?:er|ing)|'
        r'cutting-edge|at its core|best practices|comprehensive|showcases?)\b',
        caseSensitive: false,
      );

      expect(_matches(proseFiles, stockPhrasePattern), isEmpty);
    });
  });
}

List<File> _filesUnder(Directory directory) {
  if (!directory.existsSync()) return <File>[];
  return directory
      .listSync(recursive: true, followLinks: false)
      .whereType<File>()
      .where(
        (File file) => <String>[
          '.dart',
          '.json5',
          '.md',
        ].any((String extension) => file.path.endsWith(extension)),
      )
      .toList()
    ..sort((File first, File second) => first.path.compareTo(second.path));
}

List<String> _matches(List<File> files, RegExp pattern) {
  final List<String> matches = <String>[];
  for (final File file in files) {
    final String source = file.readAsStringSync();
    final String searchable = file.path.endsWith('.md')
        ? _maskProtectedMarkdown(source)
        : source;
    for (final RegExpMatch match in pattern.allMatches(searchable)) {
      final int line = searchable.substring(0, match.start).split('\n').length;
      matches.add('${file.path}:$line: ${match.group(0)}');
    }
  }
  return matches;
}

String _maskProtectedMarkdown(String source) {
  final List<String> lines = source.split('\n');
  bool inFrontmatter = lines.isNotEmpty && lines.first.trim() == '---';
  bool inFence = false;
  String? fenceMarker;

  for (int index = 0; index < lines.length; index += 1) {
    final String trimmed = lines[index].trimLeft();
    if (inFrontmatter) {
      lines[index] = '';
      if (index > 0 && trimmed.trim() == '---') inFrontmatter = false;
      continue;
    }
    if (trimmed.startsWith('```') || trimmed.startsWith('~~~')) {
      final String marker = trimmed.substring(0, 3);
      if (!inFence) {
        inFence = true;
        fenceMarker = marker;
      } else if (marker == fenceMarker) {
        inFence = false;
        fenceMarker = null;
      }
      lines[index] = '';
      continue;
    }
    if (inFence || trimmed.startsWith('|') || trimmed.startsWith('>')) {
      lines[index] = '';
      continue;
    }
    lines[index] = lines[index].replaceAll(RegExp(r'`[^`\n]+`'), '');
  }

  return lines.join('\n');
}
