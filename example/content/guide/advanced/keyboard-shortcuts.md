---
title: Keyboard and Interaction Shortcuts
description: Search, code copy, and interactive UI behaviors
icon: terminal
order: 1
tags:
  - features
  - shortcuts
  - accessibility
---

Arcane Lexicon includes keyboard shortcuts and interaction helpers in `KBScripts`.

## Search Shortcuts

| Shortcut | Action |
|----------|--------|
| `Cmd/Ctrl + K` | Focus search input |
| `Escape` | Close results and blur search |
| `ArrowDown` | Move selection down in results |
| `ArrowUp` | Move selection up in results |
| `Enter` | Open selected result (or first result) |

## Interactive Behaviors

### Code Block Copy Buttons

- Added automatically for `.prose pre` blocks.
- Copies code to clipboard.
- Shows a check icon for 2 seconds after copy.

### Theme Toggle

- Toggles `dark` / `light` mode.
- Persists mode in `localStorage` under `arcane-theme-mode`.

### TOC Active Tracking

- TOC highlights current heading while scrolling.
- Uses `IntersectionObserver`.

### Sidebar Collapse Memory

- Section expand/collapse state persists in localStorage.

### Mobile Sidebar Toggle

- Hamburger button toggles sidebar on smaller viewports.

