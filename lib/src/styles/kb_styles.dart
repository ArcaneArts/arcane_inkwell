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
$_mediaStyles
$_markdownAlerts
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

  /// Markdown alert styles (GitHub-style callouts from jaspr_content)
  static const String _markdownAlerts = '''
/* ============================================
   MARKDOWN ALERTS (GitHub-style callouts)
   ============================================ */
.markdown-alert {
  position: relative;
  padding: 1rem 1rem 1rem 1.25rem;
  margin: 1.5rem 0;
  border-radius: var(--radius-lg, 12px);
  border: 1px solid var(--border);
  border-left-width: 4px;
  background: var(--card);
}

.markdown-alert-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: 600;
  font-size: 0.875rem;
  margin-bottom: 0.5rem;
  text-transform: uppercase;
  letter-spacing: 0.025em;
}

.markdown-alert p {
  font-size: 0.9375rem;
  line-height: 1.6;
  color: var(--muted-foreground);
  margin: 0;
}

.markdown-alert p + p {
  margin-top: 0.5rem;
}

/* Note - Blue */
.markdown-alert-note {
  border-left-color: #3b82f6;
  background: linear-gradient(135deg, rgba(59, 130, 246, 0.08) 0%, rgba(59, 130, 246, 0.02) 100%);
}

.markdown-alert-note .markdown-alert-title {
  color: #3b82f6;
}

.dark .markdown-alert-note {
  background: linear-gradient(135deg, rgba(59, 130, 246, 0.12) 0%, rgba(59, 130, 246, 0.04) 100%);
}

/* Tip - Green */
.markdown-alert-tip {
  border-left-color: #22c55e;
  background: linear-gradient(135deg, rgba(34, 197, 94, 0.08) 0%, rgba(34, 197, 94, 0.02) 100%);
}

.markdown-alert-tip .markdown-alert-title {
  color: #22c55e;
}

.dark .markdown-alert-tip {
  background: linear-gradient(135deg, rgba(34, 197, 94, 0.12) 0%, rgba(34, 197, 94, 0.04) 100%);
}

/* Important - Purple */
.markdown-alert-important {
  border-left-color: #a855f7;
  background: linear-gradient(135deg, rgba(168, 85, 247, 0.08) 0%, rgba(168, 85, 247, 0.02) 100%);
}

.markdown-alert-important .markdown-alert-title {
  color: #a855f7;
}

.dark .markdown-alert-important {
  background: linear-gradient(135deg, rgba(168, 85, 247, 0.12) 0%, rgba(168, 85, 247, 0.04) 100%);
}

/* Warning - Amber */
.markdown-alert-warning {
  border-left-color: #f59e0b;
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.08) 0%, rgba(245, 158, 11, 0.02) 100%);
}

.markdown-alert-warning .markdown-alert-title {
  color: #f59e0b;
}

.dark .markdown-alert-warning {
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.12) 0%, rgba(245, 158, 11, 0.04) 100%);
}

/* Caution - Red */
.markdown-alert-caution {
  border-left-color: #ef4444;
  background: linear-gradient(135deg, rgba(239, 68, 68, 0.08) 0%, rgba(239, 68, 68, 0.02) 100%);
}

.markdown-alert-caution .markdown-alert-title {
  color: #ef4444;
}

.dark .markdown-alert-caution {
  background: linear-gradient(135deg, rgba(239, 68, 68, 0.12) 0%, rgba(239, 68, 68, 0.04) 100%);
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
