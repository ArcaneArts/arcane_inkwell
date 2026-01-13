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
    String result = content;

    // Transform @[type attrs](src) syntax
    final RegExp mediaPattern = RegExp(
      r'@\[(\w+)([^\]]*)\]\(([^)]+)\)',
      multiLine: true,
    );

    result = result.replaceAllMapped(mediaPattern, (match) {
      final String type = match.group(1)!.toLowerCase();
      final String attrs = match.group(2)?.trim() ?? '';
      final String src = match.group(3)!.trim();

      return switch (type) {
        'youtube' => _buildYouTube(src, attrs),
        'video' => _buildVideo(src, attrs),
        'image' || 'img' => _buildImage(src, attrs),
        'gif' => _buildGif(src, attrs),
        'apng' => _buildApng(src, attrs),
        'twitter' || 'x' => _buildTwitter(src, attrs),
        'iframe' => _buildIframe(src, attrs),
        _ => match.group(0)!, // Return original if unknown type
      };
    });

    return result;
  }

  /// Extract YouTube video ID from various URL formats
  String _extractYouTubeId(String src) {
    // Already just an ID
    if (!src.contains('/') && !src.contains('.')) {
      return src;
    }

    // youtube.com/watch?v=ID
    final RegExp watchPattern = RegExp(r'[?&]v=([a-zA-Z0-9_-]{11})');
    final Match? watchMatch = watchPattern.firstMatch(src);
    if (watchMatch != null) {
      return watchMatch.group(1)!;
    }

    // youtu.be/ID
    final RegExp shortPattern = RegExp(r'youtu\.be/([a-zA-Z0-9_-]{11})');
    final Match? shortMatch = shortPattern.firstMatch(src);
    if (shortMatch != null) {
      return shortMatch.group(1)!;
    }

    // youtube.com/embed/ID
    final RegExp embedPattern = RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]{11})');
    final Match? embedMatch = embedPattern.firstMatch(src);
    if (embedMatch != null) {
      return embedMatch.group(1)!;
    }

    // Fallback: return as-is
    return src;
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

    // Build URL parameters
    final List<String> params = <String>[];
    if (attrMap.containsKey('autoplay')) params.add('autoplay=1');
    if (attrMap.containsKey('loop')) params.add('loop=1&playlist=$videoId');
    if (attrMap.containsKey('muted')) params.add('mute=1');
    if (attrMap.containsKey('start')) params.add('start=${attrMap['start']}');
    if (attrMap.containsKey('end')) params.add('end=${attrMap['end']}');

    final String urlParams = params.isNotEmpty ? '?${params.join('&')}' : '';
    final String title = attrMap['title'] ?? 'YouTube video player';

    return '''

<div class="kb-media kb-media-video kb-media-youtube">
  <iframe
    src="https://www.youtube.com/embed/$videoId$urlParams"
    title="$title"
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
  <video ${videoAttrs.join(' ')}$posterAttr>
    <source src="$src" type="$mimeType">
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
  <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
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
