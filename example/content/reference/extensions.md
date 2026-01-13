---
title: Extensions
description: Markdown extensions and customization
icon: code
order: 8
tags:
  - reference
  - markdown
  - extensions
---

Arcane Inkwell includes several markdown extensions and supports custom extensions.

## Built-in Extensions

These extensions are automatically enabled:

### CalloutExtension

Transforms GitHub-style alert syntax into styled callout blocks.

**Syntax:**

```markdown
> [!NOTE]
> This is a note callout.
> It can span multiple lines.
```

**Supported Types:**

| Type | Usage | Description |
|------|-------|-------------|
| `NOTE` | `> [!NOTE]` | Informational note |
| `TIP` | `> [!TIP]` | Helpful tip |
| `IMPORTANT` | `> [!IMPORTANT]` | Important information |
| `WARNING` | `> [!WARNING]` | Warning message |
| `CAUTION` | `> [!CAUTION]` | Danger/caution message |

**Example:**

> [!NOTE]
> This is a note callout rendered by the CalloutExtension.

> [!TIP]
> Tips are great for best practices and recommendations.

> [!WARNING]
> Warnings alert users to potential issues.

### ReadingTimeExtension

Automatically calculates and displays reading time for pages.

**Features:**
- Calculates words per minute (default: 200 WPM)
- Excludes code blocks from word count
- Excludes inline code
- Removes markdown formatting before counting

**Output:**

Adds to page data:
- `readingTime` - Estimated minutes to read
- `wordCount` - Total word count

**Configuration:**

```dart
KnowledgeBaseApp.create(
  config: config,
  stylesheet: stylesheet,
  extensions: [
    const ReadingTimeExtension(wordsPerMinute: 250), // Custom WPM
  ],
)
```

### HeadingAnchorsExtension

Adds anchor IDs to headings for deep linking.

**Example:**

```markdown
## My Section

Becomes linkable as #my-section
```

### TableOfContentsExtension

Generates a table of contents from headings.

**Features:**
- Extracts H2, H3, H4 headings
- Provides nested structure
- Used by KBToc component

## Custom Extensions

Add custom extensions by passing them to `KnowledgeBaseApp.create()`:

```dart
KnowledgeBaseApp.create(
  config: config,
  stylesheet: stylesheet,
  extensions: [
    const MyCustomExtension(),
  ],
)
```

### Creating an Extension

Extensions implement the `PageExtension` interface from jaspr_content:

```dart
import 'package:jaspr_content/jaspr_content.dart';

class MyExtension implements PageExtension {
  const MyExtension();

  @override
  Future<List<Node>> apply(Page page, List<Node> nodes) async {
    // Access page content
    final String content = page.content;

    // Modify content
    final String processedContent = content.replaceAll('foo', 'bar');

    // Apply changes
    if (processedContent != content) {
      page.apply(content: processedContent);
    }

    // Or add page data
    page.apply(data: {
      'myField': 'myValue',
    });

    return nodes;
  }
}
```

### Extension Order

Extensions run in the order they're provided:

```dart
extensions: [
  const FirstExtension(),   // Runs first
  const SecondExtension(),  // Runs second
],
```

Default extensions run before custom extensions.

## Syntax Highlighting

Code blocks use Highlight.js for syntax highlighting.

**Supported Languages:**
- `dart`
- `javascript` / `js`
- `typescript` / `ts`
- `yaml`
- `json`
- `bash` / `shell`
- `html`
- `css`
- `markdown`

**Usage:**

````markdown
```dart
void main() {
  print('Hello, World!');
}
```
````

## Markdown Features

Standard markdown features supported:

### Headings

```markdown
# H1 (page title)
## H2 (section)
### H3 (subsection)
#### H4 (sub-subsection)
```

### Text Formatting

```markdown
**bold text**
*italic text*
`inline code`
~~strikethrough~~
```

### Lists

```markdown
- Unordered item
- Another item
  - Nested item

1. Ordered item
2. Another item
   1. Nested item
```

### Links

```markdown
[Link text](https://example.com)
[Internal link](/guide/installation)
```

### Images

```markdown
![Alt text](/path/to/image.png)
```

### Tables

```markdown
| Header 1 | Header 2 |
|----------|----------|
| Cell 1   | Cell 2   |
| Cell 3   | Cell 4   |
```

### Blockquotes

```markdown
> This is a blockquote.
> It can span multiple lines.
```

### Horizontal Rules

```markdown
---
```

### Code Blocks

````markdown
```language
code here
```
````

## HTML in Markdown

Raw HTML is supported in markdown content:

```markdown
<div class="custom-class">
  Custom HTML content
</div>
```

> [!CAUTION]
> HTML is not sanitized. Only use HTML in trusted content.
