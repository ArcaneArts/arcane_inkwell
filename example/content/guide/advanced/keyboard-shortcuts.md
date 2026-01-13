---
title: Keyboard Shortcuts
description: Keyboard shortcuts and interactive features
icon: terminal
order: 1
tags:
  - features
  - shortcuts
  - accessibility
---

Arcane Inkwell includes keyboard shortcuts and interactive features for improved usability.

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Cmd/Ctrl + K` | Focus search input |
| `Escape` | Clear search and close results |

## Interactive Features

### Code Block Copy

Every code block includes a copy button that appears on hover.

1. Hover over any code block
2. Click the copy icon in the top-right corner
3. The icon changes to a checkmark for 2 seconds to confirm

### Theme Toggle

Click the sun/moon icon in the sidebar to toggle between light and dark modes. The theme preference is saved to localStorage.

### Table of Contents Tracking

The table of contents (right sidebar) automatically highlights the current section as you scroll through the page.

### Sidebar Collapse Memory

When you expand or collapse sections in the sidebar, your preference is remembered across page loads. Each section's state is stored in localStorage.

### Back to Top Button

After scrolling past 300 pixels, a "back to top" button appears. Click it to smoothly scroll back to the top of the page.

## Accessibility

All interactive features are designed with accessibility in mind:

- **Keyboard navigation**: All interactive elements are keyboard accessible
- **Focus management**: Search input can be focused with keyboard shortcut
- **ARIA labels**: Theme toggle includes appropriate aria-label
- **Smooth scrolling**: Uses `behavior: 'smooth'` for comfortable navigation
