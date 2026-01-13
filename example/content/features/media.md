---
title: Media Embeds
description: Images, GIFs, videos, and embedded content
icon: film
order: 8
tags:
  - media
  - video
  - images
  - embeds
author: Arcane Arts
date: 2025-01-13
---

# Media Embeds

Arcane Inkwell provides a special syntax for embedding media content. Use the `@[type](source)` syntax to embed videos, images, GIFs, and more.

## YouTube Videos

Embed YouTube videos using the video ID or full URL:

```markdown
@[youtube](dQw4w9WgXcQ)

@[youtube](https://www.youtube.com/watch?v=dQw4w9WgXcQ)

@[youtube autoplay muted](VIDEO_ID)
```

### Live Example

@[youtube](dQw4w9WgXcQ)

### With Options

You can add attributes for autoplay, loop, mute, and timestamps:

```markdown
@[youtube autoplay muted loop](VIDEO_ID)

@[youtube start="30" end="60"](VIDEO_ID)
```

## Local Videos

Embed video files from your assets:

```markdown
@[video](path/to/video.mp4)

@[video autoplay loop muted](demo.mp4)

@[video poster="thumbnail.jpg" caption="Demo video"](demo.mp4)
```

### Supported Formats

| Format | Extension | Notes |
|--------|-----------|-------|
| MP4 | `.mp4` | Most compatible |
| WebM | `.webm` | Modern browsers |
| OGG | `.ogg`, `.ogv` | Open format |
| MOV | `.mov` | QuickTime |

### Video Attributes

| Attribute | Effect |
|-----------|--------|
| `autoplay` | Start playing automatically |
| `loop` | Loop the video |
| `muted` | Mute audio (required for autoplay in most browsers) |
| `playsinline` | Play inline on mobile |
| `poster="url"` | Thumbnail image before play |
| `caption="text"` | Caption below video |

## Images with Captions

Use the image syntax for responsive images with optional captions:

```markdown
@[image caption="A beautiful sunset"](sunset.png)

@[image alt="Logo" width="200"](logo.png)
```

### Attributes

| Attribute | Effect |
|-----------|--------|
| `caption="text"` | Caption displayed below image |
| `alt="text"` | Alt text for accessibility |
| `width="value"` | Set width (px or %) |
| `height="value"` | Set height (px or %) |
| `eager` | Disable lazy loading |

## Animated GIFs

```markdown
@[gif](animation.gif)

@[gif caption="Loading animation"](loader.gif)
```

GIFs are displayed with lazy loading by default.

## Animated PNGs (APNG)

```markdown
@[apng](animation.png)

@[apng caption="Smooth animation"](demo.apng)
```

APNGs offer better quality than GIFs with transparency support.

## Twitter/X Embeds

Embed tweets using the tweet ID or URL:

```markdown
@[twitter](1215212801876090880)

@[x](https://twitter.com/elonmusk/status/1215212801876090880)

@[twitter theme="light"](TWEET_ID)
```

### Live Example

@[twitter](1215212801876090880)

### Theme Options

| Theme | Description |
|-------|-------------|
| `dark` | Dark background (default) |
| `light` | Light background |

## Generic Iframes

For other embeddable content:

```markdown
@[iframe](https://example.com/embed)

@[iframe title="Demo" width="100%" height="500"](https://example.com/embed)
```

### Iframe Attributes

| Attribute | Default | Description |
|-----------|---------|-------------|
| `title` | "Embedded content" | Accessibility title |
| `width` | "100%" | Frame width |
| `height` | "400" | Frame height |

## Syntax Reference

The general syntax is:

```
@[type attributes](source)
```

| Component | Required | Description |
|-----------|----------|-------------|
| `@` | Yes | Media marker |
| `[type]` | Yes | Media type (youtube, video, image, etc.) |
| `attributes` | No | Space-separated key="value" or flags |
| `(source)` | Yes | URL, path, or ID |

## Best Practices

1. **Use descriptive captions** for accessibility
2. **Prefer WebM over GIF** for smaller file sizes
3. **Always include alt text** for images
4. **Use lazy loading** (default) for better performance
5. **Provide poster images** for videos to improve perceived load time
6. **Keep videos short** and consider hosting on YouTube for larger files
