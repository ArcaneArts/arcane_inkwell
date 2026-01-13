---
title: Code Blocks
description: Syntax highlighting for multiple languages
icon: code
order: 3
tags:
  - code
  - syntax-highlighting
  - markdown
author: Arcane Arts
date: 2025-01-11
---

Code blocks are automatically syntax highlighted using Highlight.js. Hover over any code block to see the **copy button** in the top-right corner.

> [!TIP]
> Click the copy icon to copy code to your clipboard. The icon changes to a checkmark for 2 seconds to confirm.

## Dart

```dart
class Example extends StatelessComponent {
  final String title;

  const Example({required this.title});

  @override
  Component build(BuildContext context) {
    return div(classes: 'example', [
      Component.text(title),
    ]);
  }
}
```

## JavaScript

```javascript
function greet(name) {
  console.log(`Hello, ${name}!`);
  return { greeting: `Hello, ${name}!` };
}
```

## YAML

```yaml
dependencies:
  arcane_inkwell:
    git:
      url: https://github.com/ArcaneArts/arcane_inkwell
```

## Bash

```bash
cd example && jaspr serve
```

## JSON

```json
{
  "name": "arcane_inkwell",
  "version": "1.0.0",
  "dependencies": {}
}
```

## Supported Languages

- Dart
- JavaScript / TypeScript
- YAML
- JSON
- Bash / Shell
- HTML
- CSS
- Markdown
