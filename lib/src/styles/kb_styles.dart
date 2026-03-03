/// Default CSS styles for knowledge base components.
///
/// These styles provide STRUCTURAL defaults only (layout, positioning).
/// Visual styling (colors, fonts, effects) comes from the stylesheet's
/// componentCss (arcaneSidebarTreeStyles for ShadCN, arcaneSidebarCodexStyles for Codex).
class KBStyles {
  const KBStyles._();

  /// Generate the complete default CSS for knowledge base components.
  static String generate() =>
      '''
$_chromeStyles
$_sidebarSections
$_sidebarDetailsMarkers
$_sidebarChevron
$_sidebarTree
$_sidebarTreeConnectors
$_sidebarLinks
$_tocSpacingStyles
$_proseLinkIndicatorStyles
$_mediaStyles
$_calloutStyles
$_markdownAlerts
$_pageNavStyles
$_cardStyles
$_columnsStyles
$_tileStyles
$_stepStyles
$_accordionStyles
$_badgeStyles
$_bannerStyles
$_panelStyles
$_frameStyles
$_updateStyles
$_tooltipStyles
$_inlineIconStyles
$_codeGroupStyles
$_fieldStyles
$_treeStyles
$_colorStyles
$_viewStyles
$_lightThemeReadability
''';

  static const String _chromeStyles = '''
.kb-page-shell {
  min-height: 100vh;
}

.kb-layout-body {
  display: flex;
  flex: 1;
  min-height: 0;
}

.kb-main-area {
  min-width: 0;
}

.kb-content-area {
  width: 100%;
}

.kb-topbar {
  position: sticky;
  top: 0;
  z-index: 50;
  width: 100%;
  border-bottom: 1px solid var(--border);
  background: color-mix(in srgb, var(--background) 94%, transparent);
  backdrop-filter: blur(10px);
}

.kb-topbar.kb-topbar-bottom {
  top: auto;
  bottom: 0;
  border-top: 1px solid var(--border);
  border-bottom: none;
}

.kb-topbar-inner {
  width: 100%;
  max-width: none;
  margin: 0;
  min-height: 3.5rem;
  padding: 0 1rem;
  display: flex;
  align-items: center;
  justify-content: flex-start;
  gap: 0.75rem;
}

.kb-topbar-left {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  min-width: 0;
  flex: 1 1 auto;
  justify-content: flex-start;
}

.kb-topbar-right {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-left: auto;
  justify-content: flex-end;
  flex: 0 0 auto;
}

.kb-topbar-brand {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  text-decoration: none;
  color: var(--foreground);
  font-weight: 600;
  font-size: 0.9375rem;
  line-height: 1;
  white-space: nowrap;
}

.kb-topbar-brand:hover {
  opacity: 0.88;
}

.kb-topbar-logo {
  width: 1.125rem;
  height: 1.125rem;
  object-fit: contain;
  border-radius: var(--radius-sm, 0.25rem);
}

.kb-topbar-nav {
  display: flex;
  align-items: center;
  gap: 0.125rem;
  margin-left: 0.375rem;
}

.kb-topbar-link {
  height: 2rem;
  padding: 0 0.625rem;
  border-radius: var(--radius-sm, 0.25rem);
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  text-decoration: none;
  color: var(--muted-foreground);
  font-size: 0.875rem;
  line-height: 1;
  transition: background 0.15s ease, color 0.15s ease;
}

.kb-topbar-link:hover {
  background: var(--accent);
  color: var(--accent-foreground);
}

.kb-topbar-link.active {
  background: var(--muted);
  color: var(--foreground);
}

.kb-topbar-github,
.kb-theme-toggle {
  width: 2.25rem;
  height: 2.25rem;
  border-radius: var(--radius-md, 0.375rem);
  border: 1px solid var(--border);
  background: var(--background);
  color: var(--muted-foreground);
  display: inline-flex;
  align-items: center;
  justify-content: center;
  text-decoration: none;
  cursor: pointer;
  transition: background 0.15s ease, color 0.15s ease, border-color 0.15s ease;
}

.kb-topbar-github:hover,
.kb-theme-toggle:hover {
  background: var(--accent);
  color: var(--accent-foreground);
}

.theme-icon-dark {
  display: none;
}

.dark .theme-icon-light,
html.dark .theme-icon-light {
  display: none;
}

.dark .theme-icon-dark,
html.dark .theme-icon-dark {
  display: block;
}

.kb-search {
  position: relative;
  width: min(25rem, 42vw);
}

.kb-search-input-wrap {
  position: relative;
}

.kb-search-input {
  width: 100%;
  height: 2.25rem;
  border-radius: var(--radius-md, 0.375rem);
  border: 1px solid var(--border);
  background: var(--background);
  color: var(--foreground);
  padding: 0 0.75rem 0 2rem;
  font-size: 0.875rem;
  outline: none;
  transition: border-color 0.15s ease, box-shadow 0.15s ease;
}

.kb-search-input::placeholder {
  color: var(--muted-foreground);
}

.kb-search-input:focus {
  border-color: var(--ring);
  box-shadow: 0 0 0 2px color-mix(in srgb, var(--ring) 30%, transparent);
}

.kb-search-icon {
  position: absolute;
  left: 0.625rem;
  top: 50%;
  transform: translateY(-50%);
  color: var(--muted-foreground);
  pointer-events: none;
  display: flex;
  align-items: center;
}

.search-results {
  display: none;
  position: absolute;
  top: calc(100% + 0.25rem);
  left: 0;
  right: 0;
  background: var(--popover);
  border: 1px solid var(--border);
  border-radius: var(--radius-md, 0.375rem);
  box-shadow: var(--shadow-lg, 0 10px 15px -3px rgba(0, 0, 0, 0.2));
  max-height: 22rem;
  overflow-y: auto;
  z-index: 70;
}

.search-results a:hover {
  background: var(--accent) !important;
}

.kb-hamburger {
  display: none;
  width: 2.25rem;
  height: 2.25rem;
  border-radius: var(--radius-md, 0.375rem);
  border: 1px solid var(--border);
  background: var(--background);
  color: var(--muted-foreground);
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: background 0.15s ease, color 0.15s ease;
}

.kb-hamburger:hover {
  background: var(--accent);
  color: var(--accent-foreground);
}

.kb-sidebar {
  position: relative;
  z-index: 30;
  flex-shrink: 0;
}

.sidebar-header {
  padding: 0.875rem;
  border-bottom: 1px solid var(--border);
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.sidebar-brand-title {
  color: var(--foreground);
  font-size: 0.925rem;
  font-weight: 600;
  line-height: 1.25;
}

.sidebar-brand-subtitle {
  color: var(--muted-foreground);
  font-size: 0.78rem;
  margin-top: 0.25rem;
}

.sidebar-controls {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

.sidebar-search {
  width: 100%;
  min-width: 0;
}

@media (max-width: 1280px) {
  .kb-search {
    width: min(20rem, 35vw);
  }
}

@media (max-width: 1024px) {
  .kb-topbar-nav {
    display: none;
  }

  .kb-search {
    width: min(18rem, 52vw);
  }
}

@media (max-width: 900px) {
  .kb-hamburger {
    display: inline-flex;
  }

  .kb-search {
    display: none;
  }

  .kb-sidebar {
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    width: min(22rem, 92vw);
    max-width: 92vw;
    transform: translateX(-100%);
    transition: transform 0.2s ease;
    box-shadow: var(--shadow-xl, 0 20px 25px -5px rgba(0, 0, 0, 0.2));
    background: var(--card);
  }

  .kb-sidebar > div {
    width: 100% !important;
    height: 100vh !important;
    max-height: 100vh !important;
    top: 0 !important;
    position: relative !important;
    background: var(--card) !important;
  }

  .kb-sidebar.open {
    transform: translateX(0);
  }
}
''';

  /// Sidebar section and summary STRUCTURAL styles only
  static const String _sidebarSections = '''
/* ============================================
   SIDEBAR SECTIONS & SUMMARIES - Structure Only
   Visual styling provided by stylesheet componentCss
   ============================================ */
.sidebar-section {
  margin-bottom: 0.5rem;
}

.sidebar-section-header {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.25rem 0.5rem;
}

.sidebar-details {
  width: 100%;
}

.sidebar-summary {
  display: flex;
  align-items: center;
  gap: 0.625rem;
  padding: 0.625rem 0.75rem;
  cursor: pointer;
  list-style: none !important;
}
''';

  /// Aggressively hide browser default disclosure markers
  static const String _sidebarDetailsMarkers = '''
/* ============================================
   HIDE DEFAULT DISCLOSURE MARKERS
   ============================================ */
.sidebar-summary::-webkit-details-marker,
.sidebar-summary::marker,
.sidebar-details > summary::-webkit-details-marker,
.sidebar-details > summary::marker {
  display: none !important;
  content: '' !important;
  list-style: none !important;
}

details.sidebar-details {
  list-style: none !important;
}

details.sidebar-details > summary {
  list-style: none !important;
}

details > summary {
  list-style: none !important;
}

details > summary::marker,
details > summary::-webkit-details-marker {
  display: none !important;
}
''';

  /// Chevron indicator STRUCTURAL styling
  static const String _sidebarChevron = '''
/* ============================================
   CHEVRON INDICATOR - Structure Only
   ============================================ */
.sidebar-chevron {
  margin-left: auto;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.2s ease, opacity 0.2s ease;
  transform: rotate(-90deg);
}

/* Hide CSS-based chevron from arcaneSidebarTreeStyles - we use an actual icon */
.sidebar-chevron::before {
  display: none !important;
}

.sidebar-details[open] > .sidebar-summary .sidebar-chevron {
  transform: rotate(0deg);
}
''';

  /// Sidebar tree STRUCTURAL layout
  static const String _sidebarTree = '''
/* ============================================
   SIDEBAR TREE STRUCTURE - Layout Only
   ============================================ */
.sidebar-tree {
  padding-left: 1rem;
  display: flex;
  flex-direction: column;
  position: relative;
  margin-left: 0.5rem;
}

.sidebar-tree .sidebar-tree {
  margin-left: 0;
  padding-left: 0.75rem;
}

.sidebar-tree .sidebar-section {
  margin-bottom: 0;
  margin-top: 3px;
}

.sidebar-tree .sidebar-section:first-child {
  margin-top: 0;
}

/* Extend tree-item vertical lines to bridge the 3px gap before sections */
.sidebar-tree > .sidebar-tree-item:not(:last-child)::after {
  bottom: -3px;
}

.sidebar-tree .sidebar-details {
  margin-left: 0;
}

.sidebar-tree .sidebar-summary {
  padding: 0.375rem 0.5rem;
}
''';

  /// Tree connector lines STRUCTURAL positioning
  /// Note: .sidebar-tree-item connectors are handled by the stylesheet's
  /// arcaneSidebarTreeStyles. This only handles .sidebar-section (folders).
  static const String _sidebarTreeConnectors = '''
/* ============================================
   TREE CONNECTOR LINES (folders only) - Structure
   Colors provided by stylesheet componentCss
   ============================================ */
.sidebar-tree > .sidebar-section {
  position: relative;
}

/* Vertical line from this section to next */
.sidebar-tree > .sidebar-section::after {
  content: '';
  position: absolute;
  left: -0.75rem;
  top: 0;
  bottom: 0;
  width: 1px;
  pointer-events: none;
}

/* Last section: vertical line only goes to summary level (L-shape) */
.sidebar-tree > .sidebar-section:last-child::after {
  bottom: auto;
  height: 0.875rem;
}

/* Horizontal connector line at summary level */
.sidebar-tree > .sidebar-section::before {
  content: '';
  position: absolute;
  left: -0.75rem;
  top: 0.875rem;
  width: 0.5rem;
  height: 1px;
  pointer-events: none;
}

/* Single section: no vertical line needed */
.sidebar-tree > .sidebar-section:first-child:last-child::after {
  display: none;
}

/* Extend lines to bridge margin gaps */
.sidebar-tree > .sidebar-section:not(:last-child)::after {
  bottom: -3px;
}
''';

  /// Sidebar link STRUCTURAL styling
  static const String _sidebarLinks = '''
/* ============================================
   SIDEBAR LINKS - Structure Only
   Visual styling provided by stylesheet componentCss
   ============================================ */
.sidebar-link {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.375rem 0.5rem;
  text-decoration: none;
}
''';

  static const String _tocSpacingStyles = '''
.toc-content a {
  margin-left: 0.125rem;
  padding: 0.5rem 0.75rem 0.5rem 0.625rem !important;
  font-size: 0.8125rem;
  line-height: 1.3;
}

.toc-content ul ul a {
  padding: 0.5rem 0.75rem 0.5rem 0.625rem !important;
  font-size: 0.8125rem;
  line-height: 1.3;
}

[class*="codex-"] .toc-content a,
.codex .toc-content a {
  margin: 0.125rem 0;
  padding: 0.5rem 0.75rem 0.5rem 0.625rem !important;
  font-size: 0.8125rem;
  line-height: 1.3;
}
''';

  static const String _proseLinkIndicatorStyles = '''
.prose p a[href]:not([href^="#"])::after,
.prose li a[href]:not([href^="#"])::after,
.prose blockquote a[href]:not([href^="#"])::after,
.prose td a[href]:not([href^="#"])::after,
.prose th a[href]:not([href^="#"])::after {
  display: inline-block;
  margin-left: 0.18em;
  font-size: 0.62em;
  line-height: 1;
  vertical-align: super;
  opacity: 0.8;
}

.prose p a[href^="http://"]::after,
.prose p a[href^="https://"]::after,
.prose p a[href^="//"]::after,
.prose p a[href^="mailto:"]::after,
.prose li a[href^="http://"]::after,
.prose li a[href^="https://"]::after,
.prose li a[href^="//"]::after,
.prose li a[href^="mailto:"]::after,
.prose blockquote a[href^="http://"]::after,
.prose blockquote a[href^="https://"]::after,
.prose blockquote a[href^="//"]::after,
.prose blockquote a[href^="mailto:"]::after,
.prose td a[href^="http://"]::after,
.prose td a[href^="https://"]::after,
.prose td a[href^="//"]::after,
.prose td a[href^="mailto:"]::after,
.prose th a[href^="http://"]::after,
.prose th a[href^="https://"]::after,
.prose th a[href^="//"]::after,
.prose th a[href^="mailto:"]::after {
  content: '↗';
}

.prose p a[href^="/"]::after,
.prose p a[href^="./"]::after,
.prose p a[href^="../"]::after,
.prose li a[href^="/"]::after,
.prose li a[href^="./"]::after,
.prose li a[href^="../"]::after,
.prose blockquote a[href^="/"]::after,
.prose blockquote a[href^="./"]::after,
.prose blockquote a[href^="../"]::after,
.prose td a[href^="/"]::after,
.prose td a[href^="./"]::after,
.prose td a[href^="../"]::after,
.prose th a[href^="/"]::after,
.prose th a[href^="./"]::after,
.prose th a[href^="../"]::after {
  content: '↪';
}
''';

  /// Media embed styles (video, images, iframes)
  static const String _mediaStyles = '''
/* ============================================
   MEDIA EMBEDS - Responsive containers
   ============================================ */

/* Base media container */
.kb-media {
  margin: 1.5rem 0;
  width: 100%;
}

/* Video containers (YouTube, Vimeo, Loom, local) */
.kb-media-video {
  position: relative;
  padding-bottom: 56.25%; /* 16:9 aspect ratio */
  height: 0;
  overflow: hidden;
  border-radius: var(--radius-md, 0.5rem);
  background: var(--muted, #1a1a1a);
}

.kb-media-video iframe,
.kb-media-video video {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  border: none;
  border-radius: var(--radius-md, 0.5rem);
}

/* Local video figure */
figure.kb-media-video {
  padding-bottom: 0;
  height: auto;
}

figure.kb-media-video video {
  position: relative;
  max-width: 100%;
  height: auto;
}

/* Image containers */
.kb-media-image,
.kb-media-gif,
.kb-media-apng {
  text-align: center;
}

.kb-media-image img,
.kb-media-gif img,
.kb-media-apng img {
  max-width: 100%;
  height: auto;
  border-radius: var(--radius-md, 0.5rem);
  background: var(--muted, #1a1a1a);
}

/* Caption styling */
.kb-media-caption {
  margin-top: 0.75rem;
  font-size: 0.875rem;
  color: var(--muted-foreground, #888);
  text-align: center;
  font-style: italic;
}

/* Twitter/X embed */
.kb-media-twitter {
  display: flex;
  justify-content: center;
}

.kb-media-twitter blockquote {
  margin: 0 !important;
}

/* Generic iframe container */
.kb-media-iframe {
  border-radius: var(--radius-md, 0.5rem);
  overflow: hidden;
  background: var(--muted, #1a1a1a);
}

.kb-media-iframe iframe {
  display: block;
  border: none;
}

/* GIF/APNG indicator badge */
.kb-media-gif::before,
.kb-media-apng::before {
  content: attr(data-type);
  position: absolute;
  top: 0.5rem;
  left: 0.5rem;
  padding: 0.125rem 0.5rem;
  font-size: 0.625rem;
  font-weight: 600;
  text-transform: uppercase;
  background: rgba(0, 0, 0, 0.6);
  color: white;
  border-radius: var(--radius-sm, 0.25rem);
  pointer-events: none;
}

.kb-media-gif,
.kb-media-apng {
  position: relative;
  display: inline-block;
}

/* Hover effects */
.kb-media-image img:hover,
.kb-media-gif img:hover,
.kb-media-apng img:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

/* Dark mode adjustments */
.dark .kb-media-video {
  background: #0a0a0a;
}

.dark .kb-media-image img,
.dark .kb-media-gif img,
.dark .kb-media-apng img {
  background: #0a0a0a;
}
''';

  static const String _calloutStyles = '''
.kb-callout,
.markdown-alert {
  --kb-callout-accent: var(--info, #3b82f6);
  position: relative;
  margin: 1.5rem 0;
  padding: 1rem;
  border-radius: var(--radius-md, 8px);
  border: 1px solid color-mix(in srgb, var(--kb-callout-accent) 30%, transparent);
  background: color-mix(in srgb, var(--kb-callout-accent) 10%, transparent);
  transition: border-color 0.15s ease, background 0.15s ease, box-shadow 0.15s ease;
}

.kb-callout-title,
.markdown-alert-title {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-weight: 500;
  font-size: 0.875rem;
  line-height: 1;
  margin-bottom: 0.5rem;
  color: var(--foreground);
}

.kb-callout-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: var(--kb-callout-accent);
  flex-shrink: 0;
}

.kb-callout-icon svg {
  width: 16px;
  height: 16px;
}

.kb-callout-icon i {
  width: 16px !important;
  height: 16px !important;
  font-size: 16px !important;
}

.markdown-alert-title svg,
.markdown-alert-title i {
  width: 16px;
  height: 16px;
  color: var(--kb-callout-accent);
  fill: currentColor;
  stroke: currentColor;
  flex-shrink: 0;
}

.markdown-alert-title p {
  margin: 0;
}

.kb-callout-content,
.markdown-alert p {
  font-size: 0.875rem;
  line-height: 1.625;
  color: var(--muted-foreground);
  margin: 0;
}

.kb-callout-content br {
  display: block;
  content: '';
  margin-top: 0.5rem;
}

.kb-callout-note,
.markdown-alert-note {
  --kb-callout-accent: var(--info, #3b82f6);
}

.kb-callout-tip,
.markdown-alert-tip {
  --kb-callout-accent: var(--success, #22c55e);
}

.kb-callout-important,
.markdown-alert-important {
  --kb-callout-accent: var(--primary, #8b5cf6);
}

.kb-callout-warning,
.markdown-alert-warning {
  --kb-callout-accent: var(--warning, #f59e0b);
}

.kb-callout-caution,
.markdown-alert-caution {
  --kb-callout-accent: var(--destructive, #ef4444);
}

#arcane-root[class*="codex-"] .kb-callout,
#arcane-root[class*="codex-"] .markdown-alert {
  border-color: var(--kb-callout-accent);
  background: color-mix(in srgb, var(--kb-callout-accent) 10%, var(--card));
  border-radius: var(--arcane-radius-md, var(--radius-md, 8px));
  box-shadow: 0 10px 24px rgba(0, 0, 0, 0.28);
}
''';

  /// Markdown alert styles (GitHub-style callouts from jaspr_content)
  static const String _markdownAlerts = '''
.markdown-alert p + p {
  margin-top: 0.5rem;
}

.markdown-alert > :last-child {
  margin-bottom: 0;
}
''';

  static const String _pageNavStyles = '''
.kb-page-nav {
  margin-top: 2.25rem;
  padding-top: 1.25rem;
  border-top: 1px solid var(--border);
}

.kb-page-nav-link {
  background: var(--card);
  transition: border-color 0.15s ease, background 0.15s ease, transform 0.15s ease;
}

.kb-page-nav-link:hover {
  background: color-mix(in srgb, var(--card) 80%, var(--accent));
  border-color: color-mix(in srgb, var(--border) 40%, var(--primary));
  transform: translateY(-1px);
}

.kb-page-nav-link .arcane-icon {
  color: var(--muted-foreground);
}

@media (max-width: 900px) {
  .kb-page-nav {
    display: grid !important;
    grid-template-columns: 1fr;
  }
}
''';

  static const String _cardStyles = '''
.kb-card-group {
  --kb-card-cols: 3;
  display: grid;
  grid-template-columns: repeat(var(--kb-card-cols), minmax(0, 1fr));
  gap: 0.9rem;
  margin: 1.5rem 0;
}

.kb-card {
  display: flex;
  flex-direction: column;
  gap: 0.65rem;
  min-height: 100%;
  padding: 1rem;
  border-radius: var(--radius-lg, 0.75rem);
  border: 1px solid var(--border);
  background: var(--card);
  text-decoration: none;
  color: inherit;
  transition: transform 0.16s ease, border-color 0.16s ease, box-shadow 0.16s ease, background 0.16s ease;
}

.kb-card:hover {
  transform: translateY(-2px);
  border-color: color-mix(in srgb, var(--border) 40%, var(--primary));
  background: color-mix(in srgb, var(--card) 86%, var(--accent));
  box-shadow: 0 12px 30px -20px color-mix(in srgb, var(--primary) 35%, transparent);
}

.kb-card-top {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
}

.kb-card-leading {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 1.85rem;
  height: 1.85rem;
  border-radius: 0.5rem;
  background: color-mix(in srgb, var(--muted) 75%, transparent);
  color: var(--foreground);
}

.kb-card-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.kb-card-indicator {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: var(--muted-foreground);
}

.kb-card-title {
  font-size: 0.98rem;
  line-height: 1.3;
  font-weight: 600;
  color: var(--foreground);
}

.kb-card-body {
  font-size: 0.9rem;
  line-height: 1.5;
  color: var(--muted-foreground);
}

.kb-card-body p {
  margin: 0;
}

.kb-card-body p + p {
  margin-top: 0.5rem;
}

.kb-card-internal .kb-card-indicator {
  color: color-mix(in srgb, var(--muted-foreground) 80%, var(--foreground));
}

.kb-card-external .kb-card-indicator {
  color: color-mix(in srgb, var(--primary) 45%, var(--foreground));
}

@media (max-width: 1200px) {
  .kb-card-group {
    grid-template-columns: repeat(min(2, var(--kb-card-cols)), minmax(0, 1fr));
  }
}

@media (max-width: 700px) {
  .kb-card-group {
    grid-template-columns: 1fr;
  }
}
''';

  static const String _columnsStyles = '''
.kb-columns {
  --kb-columns: 2;
  display: grid;
  grid-template-columns: repeat(var(--kb-columns), minmax(0, 1fr));
  gap: 0.9rem;
  margin: 1.5rem 0;
}

.kb-column {
  min-width: 0;
}

.kb-column > :first-child {
  margin-top: 0;
}

.kb-column > :last-child {
  margin-bottom: 0;
}

@media (max-width: 900px) {
  .kb-columns {
    grid-template-columns: 1fr;
  }
}
''';

  static const String _tileStyles = '''
.kb-tiles {
  --kb-tile-cols: 3;
  display: grid;
  grid-template-columns: repeat(var(--kb-tile-cols), minmax(0, 1fr));
  gap: 0.8rem;
  margin: 1.25rem 0 1.5rem;
}

.kb-tile {
  border-radius: var(--radius-lg, 0.75rem);
  border: 1px solid var(--border);
  background: var(--card);
  color: inherit;
}

.kb-tile-content {
  padding: 0.85rem 0.95rem;
}

.kb-tile-link {
  text-decoration: none;
  display: block;
  transition: transform 0.16s ease, border-color 0.16s ease, box-shadow 0.16s ease, background 0.16s ease;
}

.kb-tile-link:hover {
  transform: translateY(-2px);
  border-color: color-mix(in srgb, var(--border) 40%, var(--primary));
  background: color-mix(in srgb, var(--card) 86%, var(--accent));
  box-shadow: 0 10px 24px -18px color-mix(in srgb, var(--primary) 34%, transparent);
}

.kb-tile-top {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 0.65rem;
}

.kb-tile-icon {
  width: 1.7rem;
  height: 1.7rem;
  border-radius: 0.45rem;
  background: color-mix(in srgb, var(--muted) 78%, transparent);
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.kb-tile-indicator {
  color: var(--muted-foreground);
  display: inline-flex;
  align-items: center;
}

.kb-tile-title {
  font-size: 0.94rem;
  line-height: 1.3;
  font-weight: 600;
  color: var(--foreground);
  margin-bottom: 0.35rem;
}

.kb-tile-body {
  font-size: 0.86rem;
  line-height: 1.5;
  color: var(--muted-foreground);
}

.kb-tile-body p {
  margin: 0;
}

.kb-tile-body p + p {
  margin-top: 0.45rem;
}

.kb-tile-external .kb-tile-indicator {
  color: color-mix(in srgb, var(--primary) 45%, var(--foreground));
}

@media (max-width: 1100px) {
  .kb-tiles {
    grid-template-columns: repeat(min(2, var(--kb-tile-cols)), minmax(0, 1fr));
  }
}

@media (max-width: 700px) {
  .kb-tiles {
    grid-template-columns: 1fr;
  }
}
''';

  static const String _stepStyles = '''
.kb-steps {
  position: relative;
  margin: 1.5rem 0;
  display: flex;
  flex-direction: column;
  gap: 0.9rem;
  counter-reset: kb-step-counter;
}

.kb-step {
  position: relative;
  display: grid;
  grid-template-columns: 2.4rem minmax(0, 1fr);
  gap: 0.75rem;
}

.kb-step:not(:last-child)::after {
  content: '';
  position: absolute;
  left: 1.05rem;
  top: 2.35rem;
  bottom: -0.9rem;
  width: 1px;
  background: color-mix(in srgb, var(--border) 65%, var(--primary) 35%);
  pointer-events: none;
}

.kb-step-marker {
  width: 2.1rem;
  height: 2.1rem;
  border-radius: 9999px;
  border: 1px solid color-mix(in srgb, var(--border) 45%, var(--primary));
  background: color-mix(in srgb, var(--card) 70%, var(--accent));
  color: var(--foreground);
  font-size: 0.9rem;
  font-weight: 700;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  margin-top: 0.15rem;
  font-size: 0;
}

.kb-step-marker::before {
  counter-increment: kb-step-counter;
  content: counter(kb-step-counter);
  font-size: 0.9rem;
  line-height: 1;
}

.kb-step-main {
  position: relative;
  border: 1px solid var(--border);
  border-radius: var(--radius-lg, 0.75rem);
  background: var(--card);
  padding: 0.85rem 1rem;
}

.kb-step-title {
  font-size: 0.96rem;
  line-height: 1.3;
  font-weight: 600;
  color: var(--foreground);
  margin-bottom: 0.45rem;
}

.kb-step-body {
  color: var(--muted-foreground);
  font-size: 0.9rem;
  line-height: 1.55;
}

.kb-step-body p {
  margin: 0;
}

.kb-step-body p + p {
  margin-top: 0.5rem;
}

@media (max-width: 700px) {
  .kb-step {
    grid-template-columns: 1fr;
    gap: 0.5rem;
  }

  .kb-step-marker {
    width: 1.95rem;
    height: 1.95rem;
  }

  .kb-step:not(:last-child)::after {
    display: none;
  }
}
''';

  static const String _accordionStyles = '''
.kb-accordion-group {
  display: flex;
  flex-direction: column;
  gap: 0.65rem;
  margin: 1.5rem 0;
}

.kb-accordion {
  border: 1px solid var(--border);
  border-radius: var(--radius-lg, 0.75rem);
  background: var(--card);
  overflow: hidden;
}

.kb-accordion-summary {
  list-style: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.75rem;
  padding: 0.85rem 1rem;
}

.kb-accordion-summary::-webkit-details-marker {
  display: none;
}

.kb-accordion-title {
  font-size: 0.95rem;
  line-height: 1.35;
  font-weight: 600;
  color: var(--foreground);
}

.kb-accordion-chevron {
  color: var(--muted-foreground);
  transition: transform 0.16s ease;
}

.kb-accordion[open] .kb-accordion-chevron {
  transform: rotate(180deg);
}

.kb-accordion-content {
  padding: 0 1rem 1rem;
  color: var(--muted-foreground);
  font-size: 0.9rem;
  line-height: 1.55;
}
''';

  static const String _badgeStyles = '''
.kb-badge {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 9999px;
  border: 1px solid var(--border);
  background: var(--muted);
  color: var(--foreground);
  font-size: 0.72rem;
  line-height: 1;
  font-weight: 600;
  letter-spacing: 0.02em;
  text-transform: uppercase;
  padding: 0.35rem 0.55rem;
}

.kb-badge-default {
  background: color-mix(in srgb, var(--muted) 82%, transparent);
}

.kb-badge-info {
  border-color: color-mix(in srgb, #3b82f6 38%, var(--border));
  color: #3b82f6;
}

.kb-badge-success {
  border-color: color-mix(in srgb, #22c55e 38%, var(--border));
  color: #22c55e;
}

.kb-badge-warning {
  border-color: color-mix(in srgb, #f59e0b 38%, var(--border));
  color: #f59e0b;
}

.kb-badge-danger {
  border-color: color-mix(in srgb, #ef4444 38%, var(--border));
  color: #ef4444;
}
''';

  static const String _bannerStyles = '''
.kb-banner {
  margin: 1.25rem 0;
  border-radius: var(--radius-lg, 0.75rem);
  border: 1px solid var(--border);
  background: var(--card);
  color: inherit;
  text-decoration: none;
  display: block;
}

.kb-banner-inner {
  display: grid;
  grid-template-columns: minmax(0, 1fr) auto;
  gap: 0.5rem 0.75rem;
  padding: 0.8rem 0.95rem;
}

.kb-banner-leading {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  min-width: 0;
}

.kb-banner-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: var(--foreground);
}

.kb-banner-title {
  font-size: 0.91rem;
  line-height: 1.25;
  font-weight: 700;
  color: var(--foreground);
}

.kb-banner-body {
  grid-column: 1 / 2;
  font-size: 0.88rem;
  color: var(--muted-foreground);
}

.kb-banner-body p {
  margin: 0;
}

.kb-banner-indicator {
  grid-row: 1 / 3;
  grid-column: 2 / 3;
  align-self: center;
  color: var(--muted-foreground);
  display: inline-flex;
}

.kb-banner-info {
  border-color: color-mix(in srgb, #3b82f6 30%, var(--border));
}

.kb-banner-success {
  border-color: color-mix(in srgb, #22c55e 30%, var(--border));
}

.kb-banner-warning {
  border-color: color-mix(in srgb, #f59e0b 30%, var(--border));
}

.kb-banner-danger {
  border-color: color-mix(in srgb, #ef4444 30%, var(--border));
}

a.kb-banner:hover {
  background: color-mix(in srgb, var(--card) 86%, var(--accent));
}
''';

  static const String _panelStyles = '''
.kb-panel {
  border: 1px solid var(--border);
  border-radius: var(--radius-lg, 0.75rem);
  background: color-mix(in srgb, var(--card) 88%, transparent);
  margin: 1.5rem 0;
  padding: 0.95rem 1rem;
}

.kb-panel-title {
  display: inline-flex;
  align-items: center;
  gap: 0.45rem;
  font-size: 0.9rem;
  font-weight: 700;
  line-height: 1.2;
  color: var(--foreground);
  margin-bottom: 0.6rem;
}

.kb-panel-icon {
  display: inline-flex;
  align-items: center;
  color: var(--muted-foreground);
}

.kb-panel-content {
  font-size: 0.9rem;
  line-height: 1.55;
  color: var(--muted-foreground);
}
''';

  static const String _frameStyles = '''
.kb-frame {
  margin: 1.5rem 0;
  border: 1px solid var(--border);
  border-radius: var(--radius-lg, 0.75rem);
  background: var(--card);
  overflow: hidden;
}

.kb-frame-label {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid var(--border);
  background: color-mix(in srgb, var(--muted) 70%, transparent);
  color: var(--muted-foreground);
  font-size: 0.72rem;
  letter-spacing: 0.03em;
  text-transform: uppercase;
  font-weight: 700;
  padding: 0.35rem 0.65rem;
}

.kb-frame-body {
  padding: 0.9rem 1rem;
}

.kb-frame-caption {
  border-top: 1px solid var(--border);
  color: var(--muted-foreground);
  font-size: 0.82rem;
  line-height: 1.45;
  padding: 0.55rem 1rem 0.65rem;
}
''';

  static const String _updateStyles = '''
.kb-update {
  margin: 1.5rem 0;
  border: 1px solid var(--border);
  border-radius: var(--radius-lg, 0.75rem);
  background: var(--card);
  padding: 0.85rem 0.95rem;
}

.kb-update-head {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
}

.kb-update-icon {
  color: var(--muted-foreground);
  display: inline-flex;
}

.kb-update-label {
  color: var(--foreground);
  font-size: 0.88rem;
  font-weight: 700;
  line-height: 1.2;
}

.kb-update-date {
  margin-left: auto;
  color: var(--muted-foreground);
  font-size: 0.78rem;
}

.kb-update-body {
  color: var(--muted-foreground);
  font-size: 0.88rem;
  line-height: 1.55;
}
''';

  static const String _tooltipStyles = '''
.kb-tooltip {
  display: inline-flex;
  align-items: center;
  line-height: 1;
}

.kb-tooltip-ready {
  border-bottom: 1px dashed color-mix(in srgb, var(--muted-foreground) 60%, transparent);
  cursor: help;
}
''';

  static const String _inlineIconStyles = '''
.kb-inline-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  vertical-align: middle;
}
''';

  static const String _codeGroupStyles = '''
.kb-code-group {
  border: 1px solid var(--border);
  border-radius: var(--radius-lg, 0.75rem);
  background: var(--card);
  margin: 1.5rem 0;
  overflow: hidden;
}

.kb-code-group-title {
  border-bottom: 1px solid var(--border);
  background: color-mix(in srgb, var(--muted) 72%, transparent);
  font-size: 0.78rem;
  line-height: 1;
  letter-spacing: 0.03em;
  text-transform: uppercase;
  color: var(--muted-foreground);
  font-weight: 700;
  padding: 0.5rem 0.7rem;
}

.kb-code-group-body {
  padding: 0;
}

.kb-code-group-body pre {
  border-radius: 0 !important;
  margin: 0;
}

.kb-code-group-body pre + pre {
  border-top: 1px solid var(--border);
}
''';

  static const String _fieldStyles = '''
.kb-field-group {
  margin: 1.5rem 0;
  display: flex;
  flex-direction: column;
  gap: 0.7rem;
}

.kb-field {
  border: 1px solid var(--border);
  border-radius: var(--radius-lg, 0.75rem);
  background: var(--card);
  padding: 0.75rem 0.85rem;
}

.kb-field-head {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 0.35rem 0.45rem;
}

.kb-field-name {
  font-size: 0.89rem;
  font-weight: 700;
  color: var(--foreground);
}

.kb-field-type {
  border-radius: 9999px;
  border: 1px solid color-mix(in srgb, var(--border) 70%, transparent);
  background: color-mix(in srgb, var(--muted) 70%, transparent);
  color: var(--muted-foreground);
  font-size: 0.74rem;
  line-height: 1;
  padding: 0.25rem 0.45rem;
}

.kb-field-badge {
  border-radius: 9999px;
  border: 1px solid color-mix(in srgb, var(--border) 70%, transparent);
  font-size: 0.72rem;
  line-height: 1;
  padding: 0.22rem 0.42rem;
  text-transform: uppercase;
  letter-spacing: 0.02em;
  font-weight: 700;
}

.kb-field-location {
  color: color-mix(in srgb, var(--primary) 70%, var(--foreground));
  border-color: color-mix(in srgb, var(--primary) 30%, var(--border));
}

.kb-field-required {
  color: #ef4444;
  border-color: color-mix(in srgb, #ef4444 30%, var(--border));
}

.kb-field-body {
  margin-top: 0.5rem;
  color: var(--muted-foreground);
  font-size: 0.87rem;
  line-height: 1.55;
}
''';

  static const String _treeStyles = '''
.kb-tree {
  margin: 1.5rem 0;
  padding-left: 0;
  list-style: none;
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
}

.kb-tree-item {
  list-style: none;
}

.kb-tree-folder-details {
  border: 1px solid var(--border);
  border-radius: var(--radius-lg, 0.75rem);
  background: var(--card);
  overflow: hidden;
}

.kb-tree-folder-summary {
  list-style: none;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 0.4rem;
  padding: 0.55rem 0.7rem;
}

.kb-tree-folder-summary::-webkit-details-marker {
  display: none;
}

.kb-tree-folder-label {
  font-size: 0.87rem;
  line-height: 1.25;
  color: var(--foreground);
  font-weight: 600;
}

.kb-tree-folder-chevron {
  margin-left: auto;
  color: var(--muted-foreground);
  transition: transform 0.16s ease;
}

.kb-tree-folder-details[open] .kb-tree-folder-chevron {
  transform: rotate(180deg);
}

.kb-tree-branch {
  list-style: none;
  margin: 0;
  padding: 0 0.6rem 0.6rem 0.95rem;
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
}

.kb-tree-file-row {
  display: flex;
  align-items: center;
  gap: 0.38rem;
  border: 1px solid color-mix(in srgb, var(--border) 70%, transparent);
  border-radius: var(--radius-md, 0.5rem);
  background: color-mix(in srgb, var(--muted) 72%, transparent);
  padding: 0.42rem 0.55rem;
}

.kb-tree-file-label {
  font-size: 0.84rem;
  color: var(--muted-foreground);
}

.kb-tree-file-extra {
  margin-left: 1.65rem;
  margin-top: 0.35rem;
  font-size: 0.84rem;
  color: var(--muted-foreground);
}
''';

  static const String _colorStyles = '''
.kb-color-grid {
  margin: 1.5rem 0;
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 0.75rem;
}

.kb-color-item {
  border: 1px solid var(--border);
  border-radius: var(--radius-lg, 0.75rem);
  background: var(--card);
  overflow: hidden;
}

.kb-color-swatch {
  height: 3.1rem;
  border-bottom: 1px solid var(--border);
}

.kb-color-meta {
  padding: 0.6rem 0.7rem;
}

.kb-color-label {
  color: var(--foreground);
  font-size: 0.84rem;
  font-weight: 700;
  line-height: 1.2;
}

.kb-color-value {
  margin-top: 0.24rem;
  color: var(--muted-foreground);
  font-size: 0.78rem;
  line-height: 1.2;
  font-family: var(--font-mono, monospace);
}

.kb-color-extra {
  margin-top: 0.45rem;
  color: var(--muted-foreground);
  font-size: 0.82rem;
}
''';

  static const String _viewStyles = '''
.kb-view {
  border: 1px solid var(--border);
  border-radius: var(--radius-lg, 0.75rem);
  background: var(--card);
  margin: 1.5rem 0;
  overflow: hidden;
}

.kb-view-title {
  border-bottom: 1px solid var(--border);
  display: inline-flex;
  align-items: center;
  gap: 0.45rem;
  width: 100%;
  color: var(--foreground);
  font-size: 0.86rem;
  line-height: 1.2;
  font-weight: 700;
  background: color-mix(in srgb, var(--muted) 72%, transparent);
  padding: 0.6rem 0.75rem;
}

.kb-view-icon {
  color: var(--muted-foreground);
  display: inline-flex;
}

.kb-view-body {
  padding: 0.8rem 0.9rem;
}
''';

  static const String _lightThemeReadability = '''
html.light .prose p,
html.light .prose li,
html.light .prose blockquote,
#arcane-root.light .prose p,
#arcane-root.light .prose li,
#arcane-root.light .prose blockquote {
  color: var(--foreground);
}

html.light .prose li::marker,
#arcane-root.light .prose li::marker {
  color: color-mix(in srgb, var(--foreground) 70%, transparent);
}

html.light .sidebar-brand-title,
html.light .sidebar-section-header,
html.light .sidebar-summary,
html.light .sidebar-link,
html.light .sidebar-chevron,
#arcane-root.light .sidebar-brand-title,
#arcane-root.light .sidebar-section-header,
#arcane-root.light .sidebar-summary,
#arcane-root.light .sidebar-link,
#arcane-root.light .sidebar-chevron {
  color: var(--foreground);
}

html.light .toc-title,
html.light .toc-content a,
#arcane-root.light .toc-title,
#arcane-root.light .toc-content a {
  color: var(--foreground);
}

html.light .kb-topbar-brand,
html.light .kb-topbar-link,
#arcane-root.light .kb-topbar-brand,
#arcane-root.light .kb-topbar-link {
  color: var(--foreground);
}

html.light .kb-topbar-link.active,
#arcane-root.light .kb-topbar-link.active {
  color: var(--foreground);
}

html.light .kb-callout-content,
html.light .markdown-alert p,
#arcane-root.light .kb-callout-content,
#arcane-root.light .markdown-alert p {
  color: var(--foreground);
}

html.light .prose th,
html.light .prose td,
#arcane-root.light .prose th,
#arcane-root.light .prose td {
  color: var(--foreground);
}
''';
}
