import 'package:jaspr_content/jaspr_content.dart';

/// A PageExtension that transforms media syntax into embedded content.
///
/// Supports:
/// - YouTube videos: `@[youtube](VIDEO_ID)` or `@[youtube](https://youtube.com/watch?v=VIDEO_ID)`
/// - Local videos: `@[video](path/to/video.mp4)`
/// - Video with poster: `@[video poster="thumb.jpg"](video.mp4)`
/// - Responsive images with caption: `@[image caption="Description"](image.png)`
/// - GIFs/APNGs: `@[gif](animation.gif)` or `@[apng](animation.png)`
/// - Twitter/X embeds: `@[twitter](TWEET_ID)` or `@[x](TWEET_ID)`
/// - Generic iframe: `@[iframe](https://example.com/embed)`
///
/// Example markdown:
/// ```markdown
/// @[youtube](dQw4w9WgXcQ)
///
/// @[video autoplay loop muted](demo.mp4)
///
/// @[image caption="Screenshot of the dashboard"](screenshot.png)
/// ```
class MediaExtension implements PageExtension {
  const MediaExtension();

  @override
  Future<List<Node>> apply(Page page, List<Node> nodes) async {
    final String content = page.content;

    // Process the content to transform media syntax
    final String processedContent = _transformMedia(content);

    if (processedContent != content) {
      page.apply(content: processedContent);
    }

    return nodes;
  }

  String _transformMedia(String content) {
    final RegExp fencedCodePattern = RegExp(
      r'(```[\s\S]*?```|~~~[\s\S]*?~~~)',
      multiLine: true,
    );

    StringBuffer result = StringBuffer();
    int cursor = 0;
    for (Match match in fencedCodePattern.allMatches(content)) {
      String segment = content.substring(cursor, match.start);
      result.write(_transformMediaInSegment(segment));
      result.write(match.group(0)!);
      cursor = match.end;
    }
    result.write(_transformMediaInSegment(content.substring(cursor)));
    return result.toString();
  }

  String _transformMediaInSegment(String segment) {
    final RegExp mediaPattern = RegExp(
      r'@\[([a-zA-Z0-9_-]+)([^\]]*)\]\(([^)]+)\)',
      multiLine: true,
    );

    String transformed = segment.replaceAllMapped(mediaPattern, (match) {
      final String type = match.group(1)!.toLowerCase();
      final String attrs = match.group(2)?.trim() ?? '';
      final String src = match.group(3)!.trim();
      return _buildEmbed(type, attrs, src, fallback: match.group(0)!);
    });

    final RegExp shorthandPattern = RegExp(
      r'(^|[\s>])@([a-zA-Z][a-zA-Z0-9_-]*)(?:\[([^\]]*)\])?\(([^)]+)\)',
      multiLine: true,
    );

    transformed = transformed.replaceAllMapped(shorthandPattern, (match) {
      final String prefix = match.group(1) ?? '';
      final String type = (match.group(2) ?? '').toLowerCase();
      final String attrs = match.group(3)?.trim() ?? '';
      final String src = (match.group(4) ?? '').trim();
      final String rendered = _buildEmbed(type, attrs, src, fallback: '');
      if (rendered.isEmpty) {
        return match.group(0)!;
      }
      return '$prefix$rendered';
    });

    return transformed;
  }

  String _buildEmbed(
    String type,
    String attrs,
    String src, {
    required String fallback,
  }) {
    return switch (type) {
      'youtube' => _buildYouTube(src, attrs),
      'video' => _buildVideo(src, attrs),
      'image' || 'img' => _buildImage(src, attrs),
      'gif' => _buildGif(src, attrs),
      'apng' => _buildApng(src, attrs),
      'twitter' || 'x' => _buildTwitter(src, attrs),
      'iframe' => _buildIframe(src, attrs),
      _ => fallback,
    };
  }

  /// Extract YouTube video ID from various URL formats
  String _extractYouTubeId(String src) {
    String normalized = src.trim();

    // Already just an ID
    if (!normalized.contains('/') && !normalized.contains('.')) {
      return normalized;
    }

    Uri? uri = Uri.tryParse(normalized);
    if (uri != null && uri.host.isNotEmpty) {
      String host = uri.host.toLowerCase();
      if (host == 'youtu.be' && uri.pathSegments.isNotEmpty) {
        String shortId = uri.pathSegments.first.trim();
        if (shortId.isNotEmpty) {
          return shortId;
        }
      }
      if (host.contains('youtube.com') ||
          host.contains('youtube-nocookie.com')) {
        String queryId = uri.queryParameters['v']?.trim() ?? '';
        if (queryId.isNotEmpty) {
          return queryId;
        }
        if (uri.pathSegments.length >= 2 &&
            (uri.pathSegments.first == 'embed' ||
                uri.pathSegments.first == 'shorts' ||
                uri.pathSegments.first == 'live')) {
          String pathId = uri.pathSegments[1].trim();
          if (pathId.isNotEmpty) {
            return pathId;
          }
        }
      }
    }

    // youtube.com/watch?v=ID
    final RegExp watchPattern = RegExp(r'[?&]v=([a-zA-Z0-9_-]{11})');
    final Match? watchMatch = watchPattern.firstMatch(normalized);
    if (watchMatch != null) {
      return watchMatch.group(1)!;
    }

    // youtu.be/ID
    final RegExp shortPattern = RegExp(r'youtu\.be/([a-zA-Z0-9_-]{11})');
    final Match? shortMatch = shortPattern.firstMatch(normalized);
    if (shortMatch != null) {
      return shortMatch.group(1)!;
    }

    // youtube.com/embed/ID
    final RegExp embedPattern = RegExp(
      r'youtube\.com/embed/([a-zA-Z0-9_-]{11})',
    );
    final Match? embedMatch = embedPattern.firstMatch(normalized);
    if (embedMatch != null) {
      return embedMatch.group(1)!;
    }

    // youtube.com/shorts/ID
    final RegExp shortsPattern = RegExp(
      r'youtube\.com/shorts/([a-zA-Z0-9_-]{11})',
    );
    final Match? shortsMatch = shortsPattern.firstMatch(normalized);
    if (shortsMatch != null) {
      return shortsMatch.group(1)!;
    }

    // Fallback: return as-is
    return normalized;
  }

  /// Parse attributes string into a map
  Map<String, String> _parseAttrs(String attrs) {
    final Map<String, String> result = <String, String>{};

    // Match key="value" or key='value' or standalone flags
    final RegExp attrPattern = RegExp(r'''(\w+)(?:=["']([^"']*)["'])?''');

    for (final Match match in attrPattern.allMatches(attrs)) {
      final String key = match.group(1)!;
      final String value = match.group(2) ?? 'true';
      result[key] = value;
    }

    return result;
  }

  String _buildYouTube(String src, String attrs) {
    final String videoId = _extractYouTubeId(src);
    final Map<String, String> attrMap = _parseAttrs(attrs);

    final List<String> params = <String>[];
    if (attrMap.containsKey('autoplay')) params.add('autoplay=1');
    if (attrMap.containsKey('loop')) params.add('loop=1&playlist=$videoId');
    if (attrMap.containsKey('muted')) params.add('mute=1');
    if (attrMap.containsKey('start')) params.add('start=${attrMap['start']}');
    if (attrMap.containsKey('end')) params.add('end=${attrMap['end']}');

    params.add('playsinline=1');
    params.add('modestbranding=1');
    params.add('rel=0');
    final String urlParams = params.isNotEmpty ? '?${params.join('&')}' : '';
    final String title = attrMap['title'] ?? 'YouTube video player';
    final String primaryUrl = 'https://www.youtube.com/embed/$videoId$urlParams';
    final String fallbackUrl =
        'https://www.youtube-nocookie.com/embed/$videoId$urlParams';
    final String watchUrl = 'https://www.youtube.com/watch?v=$videoId';

    return '''

<div class="kb-media kb-media-video kb-media-youtube">
  <iframe
    src="$primaryUrl"
    data-kb-src="$primaryUrl"
    data-kb-fallback-src="$fallbackUrl"
    data-kb-watch-url="$watchUrl"
    title="$title"
    loading="eager"
    frameborder="0"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    referrerpolicy="strict-origin-when-cross-origin"
    allowfullscreen>
  </iframe>
</div>

''';
  }

  String _buildVideo(String src, String attrs) {
    final Map<String, String> attrMap = _parseAttrs(attrs);

    final List<String> videoAttrs = <String>['controls'];
    if (attrMap.containsKey('autoplay')) videoAttrs.add('autoplay');
    if (attrMap.containsKey('loop')) videoAttrs.add('loop');
    if (attrMap.containsKey('muted')) videoAttrs.add('muted');
    if (attrMap.containsKey('playsinline')) videoAttrs.add('playsinline');
    if (attrMap.containsKey('preload')) {
      videoAttrs.add('preload="${attrMap['preload']}"');
    } else {
      videoAttrs.add('preload="metadata"');
    }

    String posterAttr = '';
    if (attrMap.containsKey('poster')) {
      posterAttr = ' poster="${attrMap['poster']}"';
    }

    final String caption = attrMap['caption'] ?? '';
    final String captionHtml = caption.isNotEmpty
        ? '<figcaption class="kb-media-caption">$caption</figcaption>'
        : '';

    // Determine video type from extension
    final String extension = src.split('.').last.toLowerCase();
    final String mimeType = switch (extension) {
      'mp4' => 'video/mp4',
      'webm' => 'video/webm',
      'ogg' || 'ogv' => 'video/ogg',
      'mov' => 'video/quicktime',
      _ => 'video/mp4',
    };

    return '''

<figure class="kb-media kb-media-video kb-media-local">
  <video ${videoAttrs.join(' ')}$posterAttr data-src="$src">
    <source src="$src" data-src="$src" type="$mimeType">
    Your browser does not support the video tag.
  </video>
  $captionHtml
</figure>

''';
  }

  String _buildImage(String src, String attrs) {
    final Map<String, String> attrMap = _parseAttrs(attrs);

    final String alt = attrMap['alt'] ?? attrMap['caption'] ?? '';
    final String caption = attrMap['caption'] ?? '';
    final String width = attrMap['width'] ?? '';
    final String height = attrMap['height'] ?? '';

    String sizeAttrs = '';
    if (width.isNotEmpty) sizeAttrs += ' width="$width"';
    if (height.isNotEmpty) sizeAttrs += ' height="$height"';

    final String captionHtml = caption.isNotEmpty
        ? '<figcaption class="kb-media-caption">$caption</figcaption>'
        : '';

    final String loadingAttr = attrMap.containsKey('eager') ? 'eager' : 'lazy';

    return '''

<figure class="kb-media kb-media-image">
  <img src="$src" alt="$alt" loading="$loadingAttr"$sizeAttrs>
  $captionHtml
</figure>

''';
  }

  String _buildGif(String src, String attrs) {
    final Map<String, String> attrMap = _parseAttrs(attrs);
    final String alt = attrMap['alt'] ?? attrMap['caption'] ?? 'Animated GIF';
    final String caption = attrMap['caption'] ?? '';

    final String captionHtml = caption.isNotEmpty
        ? '<figcaption class="kb-media-caption">$caption</figcaption>'
        : '';

    return '''

<figure class="kb-media kb-media-gif">
  <img src="$src" alt="$alt" loading="lazy">
  $captionHtml
</figure>

''';
  }

  String _buildApng(String src, String attrs) {
    final Map<String, String> attrMap = _parseAttrs(attrs);
    final String alt = attrMap['alt'] ?? attrMap['caption'] ?? 'Animated PNG';
    final String caption = attrMap['caption'] ?? '';

    final String captionHtml = caption.isNotEmpty
        ? '<figcaption class="kb-media-caption">$caption</figcaption>'
        : '';

    return '''

<figure class="kb-media kb-media-apng">
  <img src="$src" alt="$alt" loading="lazy">
  $captionHtml
</figure>

''';
  }

  String _buildTwitter(String src, String attrs) {
    // Extract tweet ID from URL or use directly
    String tweetId = src;
    final RegExp tweetPattern = RegExp(r'status/(\d+)');
    final Match? match = tweetPattern.firstMatch(src);
    if (match != null) {
      tweetId = match.group(1)!;
    }

    final Map<String, String> attrMap = _parseAttrs(attrs);
    final String theme = attrMap['theme'] ?? 'dark';

    return '''

<div class="kb-media kb-media-twitter">
  <blockquote class="twitter-tweet" data-theme="$theme">
    <a href="https://twitter.com/x/status/$tweetId">Loading tweet...</a>
  </blockquote>
</div>

''';
  }

  String _buildIframe(String src, String attrs) {
    final Map<String, String> attrMap = _parseAttrs(attrs);
    final String title = attrMap['title'] ?? 'Embedded content';
    final String width = attrMap['width'] ?? '100%';
    final String height = attrMap['height'] ?? '400';

    return '''

<div class="kb-media kb-media-iframe">
  <iframe
    src="$src"
    title="$title"
    width="$width"
    height="$height"
    frameborder="0"
    allowfullscreen>
  </iframe>
</div>

''';
  }
}
