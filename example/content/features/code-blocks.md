---
title: Code Blocks
description: Syntax highlighting for multiple languages
icon: code
order: 3
tags:
  - code
  - syntax-highlighting
author: Arcane Arts
---

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
  arcane_jaspr_md:
    git:
      url: https://github.com/ArcaneArts/arcane_jaspr_md
```

## Bash

```bash
cd example && jaspr serve
```
