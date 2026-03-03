---
title: Callout Blocks
description: GitHub callout markdown and callout tag components
icon: info
order: 6
tags:
  - callouts
  - alerts
  - admonitions
author: Arcane Arts
date: 2026-03-03
---

Arcane Inkwell supports two callout authoring styles:

1. GitHub-style callout markdown (`> [!TYPE]`).
2. Rich markdown callout tags (`<Note>`, `<Warning>`, etc.).

## GitHub-Style Callouts

### Note

> [!NOTE]
> Informational content for additional context.

### Tip

> [!TIP]
> Suggestions and best-practice guidance.

### Important

> [!IMPORTANT]
> High-priority content that should not be skipped.

### Warning

> [!WARNING]
> Potentially problematic operations or caveats.

### Caution

> [!CAUTION]
> Dangerous or irreversible actions.

### Optional Title

> [!WARNING] Java 21 Required
> Arcane Inkwell tooling requires Java 21 or newer in this environment.

## Rich Callout Tags

<Note title="Tag Note">
  Tag-based callouts are component-rendered.
</Note>

<Tip title="Tag Tip">
  These use Arcane Lucide icons.
</Tip>

<Info title="Tag Info">
  Info maps to note styling.
</Info>

<Check title="Tag Check">
  Check maps to tip styling.
</Check>

<Warning title="Tag Warning">
  Warning style variant.
</Warning>

<Caution title="Tag Caution">
  Caution style variant.
</Caution>

<Important title="Tag Important">
  Important style variant.
</Important>

## Syntax

### GitHub Syntax

```markdown
> [!NOTE]
> Note body text

> [!WARNING] Optional title
> Warning body text
```

### Tag Syntax

```markdown
<Warning title="Java 21 Required">
  Warning body text
</Warning>
```
