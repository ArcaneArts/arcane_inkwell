import 'package:jaspr_content/jaspr_content.dart';

class CalloutExtension implements PageExtension {
  const CalloutExtension();

  @override
  Future<List<Node>> apply(Page page, List<Node> nodes) async =>
      _transformNodes(nodes);

  List<Node> _transformNodes(List<Node> nodes) => <Node>[
    for (Node node in nodes) _transformNode(node),
  ];

  Node _transformNode(Node node) {
    if (node is! ElementNode) {
      return node;
    }

    if (node.tag == 'blockquote') {
      _CalloutTransform? callout = _calloutFromBlockquote(node);
      if (callout != null) {
        return _markdownAlertNode(callout);
      }
    }

    String? markdownAlertType = _alertTypeFromClasses(
      node.attributes['class'] ?? '',
    );
    if (markdownAlertType != null) {
      return _normalizeMarkdownAlert(node, markdownAlertType);
    }

    List<Node>? children = node.children;
    return ElementNode(
      node.tag,
      node.attributes,
      children == null ? null : _transformNodes(children),
    );
  }

  ElementNode _markdownAlertNode(_CalloutTransform callout) => ElementNode(
    'div',
    <String, String>{'class': 'markdown-alert markdown-alert-${callout.type}'},
    <Node>[
      ElementNode(
        'p',
        <String, String>{'class': 'markdown-alert-title'},
        <Node>[TextNode(callout.title)],
      ),
      ..._transformNodes(callout.children),
    ],
  );

  _CalloutTransform? _calloutFromBlockquote(ElementNode node) {
    List<Node> children = node.children ?? <Node>[];
    if (children.isEmpty) {
      return null;
    }

    Node first = children.first;
    if (first is! ElementNode || first.tag != 'p') {
      return null;
    }

    List<Node> paragraphChildren = first.children ?? <Node>[];
    if (paragraphChildren.isEmpty) {
      return null;
    }

    Node firstParagraphNode = paragraphChildren.first;
    if (firstParagraphNode is! TextNode) {
      return null;
    }

    _CalloutMarker? marker = _markerFromText(firstParagraphNode.text);
    if (marker == null) {
      return null;
    }

    String remainingText = marker.remaining.trimLeft();
    List<Node> updatedParagraphChildren = <Node>[
      if (remainingText.isNotEmpty)
        TextNode(remainingText, raw: firstParagraphNode.raw),
      ...paragraphChildren.skip(1),
    ];
    List<Node> calloutChildren = <Node>[
      if (updatedParagraphChildren.isNotEmpty)
        ElementNode(first.tag, first.attributes, updatedParagraphChildren),
      ...children.skip(1),
    ];

    return _CalloutTransform(
      type: marker.type,
      title: marker.title,
      children: calloutChildren,
    );
  }

  _CalloutMarker? _markerFromText(String text) {
    RegExp markerPattern = RegExp(
      r'^\s*\[!(NOTE|TIP|IMPORTANT|WARNING|CAUTION)\](?:[ \t]+([^\r\n]+))?(?:\r?\n)?',
      caseSensitive: false,
    );
    Match? match = markerPattern.firstMatch(text);
    if (match == null) {
      return null;
    }

    String type = (match.group(1) ?? 'note').toLowerCase();
    String defaultTitle = _defaultTitle(type);
    String title = match.group(2)?.trim() ?? defaultTitle;
    String remaining = text.substring(match.end);

    return _CalloutMarker(
      type: type,
      title: title.isEmpty ? defaultTitle : title,
      remaining: remaining,
    );
  }

  ElementNode _normalizeMarkdownAlert(ElementNode node, String type) {
    List<Node> children = node.children ?? <Node>[];
    bool hasTitle = false;
    List<Node> alertChildren = <Node>[];
    for (Node child in children) {
      if (_isMarkdownAlertTitle(child)) {
        hasTitle = true;
      }
      alertChildren.add(_transformNode(child));
    }

    return ElementNode(
      node.tag,
      <String, String>{
        ...node.attributes,
        'class': _normalizedAlertClasses(node.attributes['class'] ?? '', type),
      },
      <Node>[
        if (!hasTitle)
          ElementNode(
            'p',
            <String, String>{'class': 'markdown-alert-title'},
            <Node>[TextNode(_defaultTitle(type))],
          ),
        ...alertChildren,
      ],
    );
  }

  String _normalizedAlertClasses(String classes, String type) {
    List<String> classNames = classes
        .split(RegExp(r'\s+'))
        .where((className) => className.isNotEmpty)
        .toList();
    if (!classNames.contains('markdown-alert')) {
      classNames.insert(0, 'markdown-alert');
    }
    String typeClass = 'markdown-alert-$type';
    if (!classNames.contains(typeClass)) {
      classNames.add(typeClass);
    }
    return classNames.join(' ');
  }

  String? _alertTypeFromClasses(String classes) {
    for (String className in classes.split(RegExp(r'\s+'))) {
      if (!className.startsWith('markdown-alert-')) {
        continue;
      }
      String type = className.substring('markdown-alert-'.length);
      if (_isSupportedType(type)) {
        return type;
      }
    }
    return null;
  }

  bool _isMarkdownAlertTitle(Node node) {
    if (node is! ElementNode || node.tag != 'p') {
      return false;
    }

    String classes = node.attributes['class'] ?? '';
    return classes.split(RegExp(r'\s+')).contains('markdown-alert-title');
  }

  bool _isSupportedType(String type) => switch (type) {
    'note' || 'tip' || 'important' || 'warning' || 'caution' => true,
    _ => false,
  };

  String _defaultTitle(String type) => switch (type) {
    'note' => 'Note',
    'tip' => 'Tip',
    'important' => 'Important',
    'warning' => 'Warning',
    'caution' => 'Caution',
    _ => 'Note',
  };
}

class _CalloutMarker {
  final String type;
  final String title;
  final String remaining;

  const _CalloutMarker({
    required this.type,
    required this.title,
    required this.remaining,
  });
}

class _CalloutTransform {
  final String type;
  final String title;
  final List<Node> children;

  const _CalloutTransform({
    required this.type,
    required this.title,
    required this.children,
  });
}
