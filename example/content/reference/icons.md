---
title: Icons Reference
description: All available icons for sections and pages
icon: sparkles
order: 4
tags:
  - reference
  - icons
  - ui
---

Arcane Inkwell supports three types of icons in frontmatter and section configuration:

1. **Lucide icons** - 90+ built-in icon names
2. **SVG files** - Reference external `.svg` files
3. **Raw SVG** - Inline SVG markup

## Usage

### Lucide Icons (Recommended)

Use a Lucide icon name string:

```yaml
---
title: My Page
icon: rocket
---
```

```json5
{
  "title": "Guide",
  "icon": "book"
}
```

### SVG Files

Reference an SVG file by path (relative to your site root or absolute URL):

```yaml
---
title: My Page
icon: /images/custom-icon.svg
---
```

```json5
{
  "title": "Guide",
  "icon": "/assets/icons/guide.svg"
}
```

External URLs are also supported:

```yaml
icon: https://example.com/icon.svg
```

### Raw SVG Markup

Embed SVG directly (useful for simple icons):

```yaml
icon: <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/></svg>
```

> [!NOTE]
> Raw SVG markup is rendered at 16x16 pixels and inherits the current text color via `currentColor`.

## Documents and Files

| Icon Name | Description |
|-----------|-------------|
| `file-text` | Document with text |
| `file` | Generic file |
| `book` | Closed book |
| `book-open` | Open book |
| `notebook` | Spiral notebook |
| `scroll` | Scroll document |

## Navigation and Actions

| Icon Name | Description |
|-----------|-------------|
| `rocket` | Rocket ship |
| `zap` | Lightning bolt |
| `home` | House |
| `play` | Play button |
| `compass` | Compass |
| `map` | Map |
| `navigation` | Navigation arrow |

## Server and Infrastructure

| Icon Name | Description |
|-----------|-------------|
| `server` | Server |
| `database` | Database cylinder |
| `hard-drive` | Hard drive |
| `cpu` | Processor chip |
| `cloud` | Cloud |
| `globe` | Globe |
| `network` | Network nodes |
| `wifi` | WiFi signal |
| `monitor` | Desktop monitor |
| `laptop` | Laptop computer |
| `container` | Shipping container |

## Security

| Icon Name | Description |
|-----------|-------------|
| `shield` | Shield |
| `shield-check` | Shield with checkmark |
| `shield-alert` | Shield with alert |
| `lock` | Locked padlock |
| `unlock` | Unlocked padlock |
| `key` | Key |
| `key-round` | Round key |
| `scan` | Scan/fingerprint |

## Settings and Tools

| Icon Name | Description |
|-----------|-------------|
| `settings` | Gear |
| `settings-2` | Alternative gear |
| `sliders` | Sliders (horizontal) |
| `sliders-horizontal` | Horizontal sliders |
| `wrench` | Wrench |
| `hammer` | Hammer |
| `terminal` | Terminal/command line |
| `code` | Code brackets |
| `braces` | Curly braces |
| `brackets` | Square brackets |

## Files and Folders

| Icon Name | Description |
|-----------|-------------|
| `folder` | Folder |
| `folder-open` | Open folder |
| `folder-closed` | Closed folder |
| `archive` | Archive box |
| `package` | Package |
| `box` | Box |

## Communication

| Icon Name | Description |
|-----------|-------------|
| `mail` | Envelope |
| `message-circle` | Chat bubble (round) |
| `message-square` | Chat bubble (square) |
| `headphones` | Headphones |
| `phone` | Phone |
| `bell` | Notification bell |

## Status and Monitoring

| Icon Name | Description |
|-----------|-------------|
| `activity` | Activity/heartbeat line |
| `bar-chart` | Bar chart |
| `line-chart` | Line chart |
| `pie-chart` | Pie chart |
| `gauge` | Gauge/speedometer |
| `clock` | Clock |
| `timer` | Timer |
| `refresh-cw` | Refresh (clockwise) |
| `rotate-cw` | Rotate clockwise |
| `loader` | Loading spinner |

## Money and Billing

| Icon Name | Description |
|-----------|-------------|
| `credit-card` | Credit card |
| `dollar-sign` | Dollar sign |
| `receipt` | Receipt |
| `wallet` | Wallet |
| `coins` | Coins |
| `banknote` | Banknote |

## Users

| Icon Name | Description |
|-----------|-------------|
| `user` | Single user |
| `users` | Multiple users |
| `user-plus` | Add user |
| `user-check` | Verified user |
| `user-cog` | User settings |

## Miscellaneous

| Icon Name | Description |
|-----------|-------------|
| `layers` | Stacked layers |
| `layout` | Layout grid |
| `grid` | 3x3 grid |
| `sparkles` | Sparkles |
| `star` | Star |
| `heart` | Heart |
| `flag` | Flag |
| `bookmark` | Bookmark |
| `tag` | Single tag |
| `tags` | Multiple tags |
| `info` | Information circle |

## Alerts and Information

| Icon Name | Description |
|-----------|-------------|
| `alert-triangle` | Warning triangle |
| `alert-circle` | Alert circle |
| `help-circle` | Help/question circle |
| `check` | Checkmark |
| `check-circle` | Checkmark in circle |
| `x` | X/close |
| `x-circle` | X in circle |

## Arrows and Navigation

| Icon Name | Description |
|-----------|-------------|
| `arrow-right` | Right arrow |
| `arrow-left` | Left arrow |
| `arrow-up` | Up arrow |
| `arrow-down` | Down arrow |
| `chevron-right` | Right chevron |
| `chevron-left` | Left chevron |
| `chevron-up` | Up chevron |
| `chevron-down` | Down chevron |
| `external-link` | External link |
| `link` | Link chain |

## Actions

| Icon Name | Description |
|-----------|-------------|
| `download` | Download |
| `upload` | Upload |
| `copy` | Copy |
| `clipboard` | Clipboard |
| `trash` | Trash can |
| `trash-2` | Alternative trash |
| `edit` | Edit/pencil |
| `pencil` | Pencil |
| `save` | Save/disk |
| `plus` | Plus sign |
| `minus` | Minus sign |
| `search` | Magnifying glass |
| `filter` | Filter funnel |
| `eye` | Visible eye |
| `eye-off` | Hidden eye |

## Support and Help

| Icon Name | Description |
|-----------|-------------|
| `life-buoy` | Life buoy |
| `help` | Help circle |

## Power and Control

| Icon Name | Description |
|-----------|-------------|
| `power` | Power button |
| `plug` | Electrical plug |
| `plug-zap` | Plug with power |
| `battery` | Battery |

## World and Location

| Icon Name | Description |
|-----------|-------------|
| `map-pin` | Map pin/marker |
| `building` | Building |
| `building-2` | Alternative building |

## Fallback Behavior

If an invalid icon name is used, `file-text` is displayed as the default fallback.

## Icon Styling

Icons in the sidebar are rendered at a small size (`IconSize.sm`) and inherit the current text color, ensuring they match the theme.
