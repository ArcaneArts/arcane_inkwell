/// Default CSS styles for knowledge base components.
///
/// These styles are injected automatically by [KBLayout] and provide
/// sensible defaults for sidebar navigation, tree connectors, and
/// theme toggle animations.
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
$_themeRevealAnimation
''';

  /// Sidebar section and summary styles
  static const String _sidebarSections = '''
/* ============================================
   SIDEBAR SECTIONS & SUMMARIES
   ============================================ */
.sidebar-section {
  margin-bottom: 0.5rem;
}

.sidebar-section-header {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.25rem 0.5rem;
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--muted-foreground);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.sidebar-details {
  width: 100%;
}

.sidebar-summary {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem;
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--muted-foreground);
  cursor: pointer;
  list-style: none !important;
  border-radius: var(--radius-sm, 4px);
  transition: background 0.15s;
  background: color-mix(in srgb, var(--muted) 30%, transparent);
  border: 1px solid color-mix(in srgb, var(--border) 50%, transparent);
}

.sidebar-summary:hover {
  background: var(--muted);
  border-color: var(--border);
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

  /// Chevron indicator styling
  static const String _sidebarChevron = '''
/* ============================================
   CHEVRON INDICATOR
   ============================================ */
.sidebar-chevron {
  margin-left: auto;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.15s;
  transform: rotate(-90deg);
}

.sidebar-chevron::after {
  display: none;
}

.sidebar-details[open] > .sidebar-summary .sidebar-chevron {
  transform: rotate(0deg);
}
''';

  /// Sidebar tree structure
  static const String _sidebarTree = '''
/* ============================================
   SIDEBAR TREE STRUCTURE
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

.sidebar-tree .sidebar-details {
  margin-left: 0;
}

.sidebar-tree .sidebar-summary {
  font-size: 0.8125rem;
  padding: 0.375rem 0.5rem;
  color: var(--muted-foreground);
  opacity: 0.9;
}

.sidebar-tree .sidebar-tree .sidebar-summary {
  opacity: 0.85;
  font-size: 0.8125rem;
}

.sidebar-tree .sidebar-tree .sidebar-tree .sidebar-summary {
  opacity: 0.8;
}
''';

  /// Tree connector lines (L-shapes and vertical lines)
  static const String _sidebarTreeConnectors = '''
/* ============================================
   TREE CONNECTOR LINES
   ============================================ */
.sidebar-tree > * {
  position: relative;
}

/* Vertical line from this item to next */
.sidebar-tree > *::after {
  content: '';
  position: absolute;
  left: -0.75rem;
  top: 0;
  bottom: 0;
  width: 1px;
  background: var(--border);
  pointer-events: none;
}

/* Last child: vertical line only goes to center (L-shape) */
.sidebar-tree > *:last-child::after {
  bottom: auto;
  height: 50%;
}

/* Horizontal connector line */
.sidebar-tree > *::before {
  content: '';
  position: absolute;
  left: -0.75rem;
  top: 50%;
  width: 0.5rem;
  height: 1px;
  background: var(--border);
  pointer-events: none;
}

/* Single item: no vertical line needed */
.sidebar-tree > *:first-child:last-child::after {
  display: none;
}

/* Sections need horizontal line at summary level */
.sidebar-tree > .sidebar-section::before {
  top: 0.875rem;
}

/* Adjust vertical line for last section */
.sidebar-tree > .sidebar-section:last-child::after {
  height: 0.875rem;
}

/* Extend lines to bridge margin gaps */
.sidebar-tree > .sidebar-section:not(:last-child)::after {
  top: 0;
  bottom: -3px;
  height: auto;
}

.sidebar-tree > *:not(:last-child)::after {
  bottom: -3px;
}
''';

  /// Sidebar link styling
  static const String _sidebarLinks = '''
/* ============================================
   SIDEBAR LINKS
   ============================================ */
.sidebar-link {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.375rem 0.5rem;
  font-size: 0.8125rem;
  color: var(--muted-foreground);
  text-decoration: none;
  border-radius: var(--radius-sm, 4px);
  transition: background 0.15s, color 0.15s;
}

.sidebar-link:hover {
  background: var(--muted);
  color: var(--foreground);
}

.sidebar-link.active {
  background: var(--accent);
  color: var(--accent-foreground);
  font-weight: 500;
}
''';

  /// Theme reveal animation for theme toggle
  static const String _themeRevealAnimation = '''
/* ============================================
   THEME REVEAL ANIMATION
   ============================================ */
.theme-reveal-overlay {
  position: fixed;
  inset: 0;
  z-index: 99999;
  pointer-events: none;
  clip-path: circle(0% at var(--reveal-x, 50%) var(--reveal-y, 50%));
}

.theme-reveal-overlay.to-light {
  background-color: #fafafa;
}

.theme-reveal-overlay.to-dark {
  background-color: #0a0a0a;
}

.theme-reveal-overlay.revealing {
  animation: theme-reveal 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

@keyframes theme-reveal {
  0% {
    clip-path: circle(0% at var(--reveal-x, 50%) var(--reveal-y, 50%));
  }
  100% {
    clip-path: circle(150% at var(--reveal-x, 50%) var(--reveal-y, 50%));
  }
}
''';
}