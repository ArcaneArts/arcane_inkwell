/// Default CSS styles for knowledge base components.
///
/// These styles provide STRUCTURAL defaults only (layout, positioning).
/// Visual styling (colors, fonts, effects) comes from the stylesheet's
/// componentCss (arcaneSidebarTreeStyles for ShadCN, arcaneSidebarCodexStyles for Codex).
class KBStyles {
  const KBStyles._();

  /// Generate the complete default CSS for knowledge base components.
  static String generate() => '''
$_sidebarSections
$_sidebarDetailsMarkers
$_sidebarChevron
$_sidebarTree
$_sidebarTreeConnectors
$_sidebarLinks
$_mediaStyles
$_markdownAlerts
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
}
