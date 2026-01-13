---
title: Callout Blocks
description: Use GitHub-style callouts for important information
icon: info
order: 6
tags:
  - callouts
  - alerts
  - admonitions
author: Arcane Arts
date: 2025-01-11
---

# Callout Blocks

Arcane Jaspr MD supports GitHub-style callout blocks (also known as admonitions or alerts). These are useful for highlighting important information.

## Note

Use notes for informational content:

> [!NOTE]
> This is an informational note. Notes are great for additional context or tips that aren't critical but are helpful to know.

## Tip

Use tips for helpful suggestions:

> [!TIP]
> Here's a helpful tip! Tips work well for best practices or recommendations that improve the user experience.

## Important

Use important callouts for critical information:

> [!IMPORTANT]
> This is important information that users should pay attention to. Don't skip this!

## Warning

Use warnings for potentially problematic situations:

> [!WARNING]
> Be careful with this operation. Warnings help users avoid common pitfalls or mistakes.

## Caution

Use caution for dangerous actions:

> [!CAUTION]
> This action cannot be undone! Caution callouts are for actions that could cause data loss or other serious consequences.

## Syntax

Callouts use the GitHub-style alert syntax:

```markdown
> [!NOTE]
> Your note content here.
> Can span multiple lines.

> [!TIP]
> Your tip content here.

> [!IMPORTANT]
> Important information here.

> [!WARNING]
> Warning message here.

> [!CAUTION]
> Caution message here.
```

The callout type (NOTE, TIP, IMPORTANT, WARNING, CAUTION) is case-insensitive.
