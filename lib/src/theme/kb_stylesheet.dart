import 'package:arcane_jaspr/arcane_jaspr.dart';

/// Knowledge base stylesheet wrapper.
///
/// Simply wraps an ArcaneStylesheet and adds minimal layout dimensions.
class KBStylesheet extends ArcaneStylesheet {
  final ArcaneStylesheet base;

  const KBStylesheet({ArcaneStylesheet? base})
      : base = base ?? const ShadcnStylesheet();

  @override
  String get id => 'kb-${base.id}';

  @override
  String get name => 'KB ${base.name}';

  @override
  ComponentRenderers get renderers => base.renderers;

  @override
  ThemeSeed get lightSeed => base.lightSeed;

  @override
  ThemeSeed get darkSeed => base.darkSeed;

  @override
  FontConfig get fonts => base.fonts;

  @override
  RadiusConfig get radius => base.radius;

  @override
  List<String> get externalCssUrls => base.externalCssUrls;

  @override
  String get fontFaces => base.fontFaces;

  @override
  String get componentCss => base.componentCss;

  @override
  String get baseCss {
    return '''
${base.baseCss}

/* KB Layout Dimensions */
:root {
  --kb-sidebar-width: 280px;
  --kb-toc-width: 240px;
  --kb-header-height: 64px;
  --kb-content-max-width: 800px;
}

/* KB Layout Structure */
#kb-root {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.kb-layout {
  display: flex;
  flex: 1;
}

.kb-sidebar {
  position: fixed;
  top: var(--kb-header-height);
  left: 0;
  width: var(--kb-sidebar-width);
  height: calc(100vh - var(--kb-header-height));
  overflow-y: auto;
  padding: 1rem 0;
  z-index: 40;
}

.kb-header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: var(--kb-header-height);
  display: flex;
  align-items: center;
  padding: 0 1.5rem;
  z-index: 50;
}

.kb-main {
  flex: 1;
  margin-left: var(--kb-sidebar-width);
  margin-top: var(--kb-header-height);
  padding: 2rem;
  min-height: calc(100vh - var(--kb-header-height));
}

.kb-content-wrapper {
  display: flex;
  gap: 2rem;
  max-width: calc(var(--kb-content-max-width) + var(--kb-toc-width) + 2rem);
  margin: 0 auto;
}

.kb-content {
  flex: 1;
  max-width: var(--kb-content-max-width);
  min-width: 0;
}

.kb-toc {
  position: sticky;
  top: calc(var(--kb-header-height) + 2rem);
  width: var(--kb-toc-width);
  max-height: fit-content;
  overflow-y: auto;
  padding: 1rem;
  flex-shrink: 0;
  align-self: flex-start;
}

.kb-footer {
  margin-left: var(--kb-sidebar-width);
  padding: 2rem;
  text-align: center;
}

/* Mobile */
@media (max-width: 1024px) {
  .kb-toc { display: none; }
}

@media (max-width: 768px) {
  :root { --kb-sidebar-width: 0px; }
  .kb-sidebar { transform: translateX(-100%); width: 280px; }
  .kb-sidebar.open { transform: translateX(0); }
  .kb-main { margin-left: 0; padding: 1.5rem; }
  .kb-footer { margin-left: 0; }
}

/* Back to top button */
.kb-back-to-top {
  transition: opacity 0.2s ease, transform 0.2s ease;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}
.kb-back-to-top:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}
.kb-back-to-top.visible {
  opacity: 1 !important;
  pointer-events: auto !important;
}

/* Edit link hover */
.kb-edit-link a:hover {
  color: var(--arcane-primary) !important;
}

/* Mobile hamburger button */
.kb-hamburger {
  display: none;
  padding: 0.5rem;
  cursor: pointer;
  border-radius: var(--arcane-radius-sm);
}
.kb-hamburger:hover {
  background: var(--arcane-surface);
}
@media (max-width: 768px) {
  .kb-hamburger { display: flex; }
}

/* Callout/Admonition blocks */
.kb-callout {
  margin: 1rem 0;
  padding: 1rem;
  border-radius: var(--arcane-radius-md);
  border-left: 4px solid;
}
.kb-callout-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-weight: 600;
  margin-bottom: 0.5rem;
}
.kb-callout-icon {
  display: flex;
  align-items: center;
}
.kb-callout-content {
  font-size: 0.875rem;
  line-height: 1.6;
}

/* Note - Blue */
.kb-callout-note {
  background: rgba(59, 130, 246, 0.1);
  border-color: #3b82f6;
}
.kb-callout-note .kb-callout-title { color: #3b82f6; }

/* Tip - Green */
.kb-callout-tip {
  background: rgba(34, 197, 94, 0.1);
  border-color: #22c55e;
}
.kb-callout-tip .kb-callout-title { color: #22c55e; }

/* Important - Purple */
.kb-callout-important {
  background: rgba(168, 85, 247, 0.1);
  border-color: #a855f7;
}
.kb-callout-important .kb-callout-title { color: #a855f7; }

/* Warning - Yellow/Orange */
.kb-callout-warning {
  background: rgba(234, 179, 8, 0.1);
  border-color: #eab308;
}
.kb-callout-warning .kb-callout-title { color: #eab308; }

/* Caution - Red */
.kb-callout-caution {
  background: rgba(239, 68, 68, 0.1);
  border-color: #ef4444;
}
.kb-callout-caution .kb-callout-title { color: #ef4444; }

/* Search results dropdown */
.kb-search-results {
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);
}
.kb-search-results.visible {
  display: flex !important;
}
.kb-search-result {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  padding: 0.75rem 1rem;
  text-decoration: none;
  border-bottom: 1px solid var(--border);
  transition: background 0.15s ease;
}
.kb-search-result:last-child {
  border-bottom: none;
}
.kb-search-result:hover {
  background: var(--muted);
}
.kb-search-result-title {
  font-weight: 500;
  color: var(--foreground);
}
.kb-search-result-path {
  font-size: 0.75rem;
  color: var(--muted-foreground);
}

/* ============================================
   TABLE OF CONTENTS - Tree Line Style
   Clean continuous trunk with L-connectors
   ============================================ */
.toc-content ul {
  list-style: none;
  padding-left: 1rem;
  margin: 0;
  position: relative;
}

/* Vertical trunk line - drawn on the ul container */
.toc-content ul::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0.75rem; /* Start from first item center */
  bottom: 0.75rem; /* End at last item center */
  width: 1px;
  background: var(--border);
}

/* Single item - no trunk needed */
.toc-content ul:has(> li:only-child)::before {
  display: none;
}

/* All list items */
.toc-content li {
  position: relative;
}

/* Horizontal branch from trunk to content */
.toc-content li::before {
  content: '';
  position: absolute;
  left: -1rem;
  top: 0.75rem; /* Align with link center */
  width: 0.75rem;
  height: 1px;
  background: var(--border);
}

/* Single item gets a simple dot indicator instead of branch */
.toc-content li:only-child::before {
  width: 4px;
  height: 4px;
  border-radius: 50%;
  top: calc(0.75rem - 2px);
  left: calc(-1rem - 2px);
}

/* Link styling - fixed height for consistent tree alignment */
.toc-content a {
  color: var(--muted-foreground);
  text-decoration: none;
  font-size: 13px;
  display: block;
  padding: 4px 8px;
  min-height: 1.5rem;
  line-height: 1.5rem;
  border-radius: var(--radius-sm);
  transition: all var(--transition-fast);
}

.toc-content a:hover {
  color: var(--foreground);
  background: var(--muted);
}

/* Active TOC link */
.toc-content a.toc-active {
  color: var(--primary);
  font-weight: 600;
  background: var(--accent);
  border-left: 2px solid var(--primary);
  padding-left: 6px;
}

/* Nested lists - lighter lines */
.toc-content ul ul::before,
.toc-content ul ul li::before {
  background: color-mix(in srgb, var(--border) 60%, transparent);
}

.toc-content ul ul ul::before,
.toc-content ul ul ul li::before {
  background: color-mix(in srgb, var(--border) 40%, transparent);
}

/* ============================================
   SIDEBAR NAVIGATION - Tree Lines
   Supports leaves (links) and folders (disclosures)
   ============================================ */
.sidebar-tree-nav {
  position: relative;
}

/* Container for items with tree lines */
.sidebar-tree-items {
  position: relative;
  padding-left: 1.25rem;
  margin-left: 0.25rem;
}

/* Vertical trunk line on container - connects all siblings */
.sidebar-tree-items::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 1px;
  background: var(--border);
}

/* Trim trunk at first and last items */
.sidebar-tree-items > .sidebar-tree-item:first-child::after {
  content: '';
  position: absolute;
  left: -1.25rem;
  top: 0;
  height: 1rem;
  width: 1px;
  background: var(--background);
}

.sidebar-tree-items > .sidebar-tree-item:last-child::after {
  content: '';
  position: absolute;
  left: -1.25rem;
  bottom: 0;
  top: 1rem;
  width: 1px;
  background: var(--background);
}

/* Single item - hide trunk completely */
.sidebar-tree-items:has(> .sidebar-tree-item:only-child)::before {
  display: none;
}

.sidebar-tree-items > .sidebar-tree-item:only-child::after {
  display: none;
}

/* Each nav item in tree */
.sidebar-tree-item {
  position: relative;
}

/* ---- LEAF ITEMS (links) ---- */
.sidebar-tree-leaf::before {
  content: '';
  position: absolute;
  left: -1.25rem;
  top: 1rem;
  width: 1rem;
  height: 1px;
  background: var(--border);
}

/* Single leaf gets a dot */
.sidebar-tree-leaf:only-child::before {
  width: 5px;
  height: 5px;
  border-radius: 50%;
  top: calc(1rem - 2.5px);
  left: calc(-0.75rem - 2.5px);
}

/* ---- FOLDER ITEMS (disclosures with children) ---- */
.sidebar-tree-folder {
  position: relative;
}

/* Horizontal branch to folder header */
.sidebar-tree-folder::before {
  content: '';
  position: absolute;
  left: -1.25rem;
  top: 0.875rem; /* Align with disclosure summary */
  width: 0.75rem;
  height: 1px;
  background: var(--border);
}

/* Folder corner piece - connects horizontal to vertical */
.sidebar-tree-folder > details > .sidebar-tree-items::before {
  /* This is the nested trunk - already handled */
}

/* When folder is only child, show elbow connector instead of dot */
.sidebar-tree-folder:only-child::before {
  width: 0.5rem;
  height: 1px;
  border-radius: 0;
  top: 0.875rem;
  left: -0.75rem;
}

/* Vertical connector from folder header down to its children */
.sidebar-tree-folder > details {
  position: relative;
}

.sidebar-tree-folder > details::before {
  content: '';
  position: absolute;
  left: -0.5rem;
  top: 1.25rem;
  bottom: 0.5rem;
  width: 1px;
  background: var(--border);
}

/* Hide folder vertical connector when closed */
.sidebar-tree-folder > details:not([open])::before {
  display: none;
}

/* ---- NESTED DEPTH STYLING ---- */
/* Nested items get lighter colors */
.sidebar-tree-items .sidebar-tree-items::before {
  background: color-mix(in srgb, var(--border) 60%, transparent);
}

.sidebar-tree-items .sidebar-tree-items .sidebar-tree-item::before {
  background: color-mix(in srgb, var(--border) 60%, transparent);
}

.sidebar-tree-items .sidebar-tree-items .sidebar-tree-item::after {
  background: var(--background);
}

/* Even deeper nesting */
.sidebar-tree-items .sidebar-tree-items .sidebar-tree-items::before {
  background: color-mix(in srgb, var(--border) 40%, transparent);
}

.sidebar-tree-items .sidebar-tree-items .sidebar-tree-items .sidebar-tree-item::before {
  background: color-mix(in srgb, var(--border) 40%, transparent);
}

/* No tree lines variant */
.sidebar-tree-items.no-tree-lines::before,
.sidebar-tree-items.no-tree-lines .sidebar-tree-item::before,
.sidebar-tree-items.no-tree-lines .sidebar-tree-item::after,
.sidebar-tree-items.no-tree-lines .sidebar-tree-folder > details::before {
  display: none;
}

/* Sidebar hover */
aside a:hover {
  background: var(--muted) !important;
}

/* ============================================
   PROSE CONTENT STYLES
   ============================================ */
.prose {
  max-width: 65ch;
  color: var(--foreground);
}

.prose h1, .prose h2, .prose h3,
.prose h4, .prose h5, .prose h6 {
  color: var(--foreground);
  font-weight: 600;
  line-height: 1.25;
  margin-top: 2rem;
  margin-bottom: 1rem;
}

.prose h1 { font-size: 2.25rem; margin-top: 0; }
.prose h2 {
  font-size: 1.5rem;
  border-bottom: 1px solid var(--border);
  padding-bottom: 0.5rem;
}
.prose h3 { font-size: 1.25rem; }
.prose h4 { font-size: 1rem; }

.prose p {
  color: var(--muted-foreground);
  margin-bottom: 1rem;
}

.prose li {
  color: var(--muted-foreground);
  margin-bottom: 0.25rem;
}

.prose a {
  color: var(--primary);
  text-decoration: none;
  transition: color var(--transition-fast);
}

.prose a:hover {
  color: var(--primary);
  text-decoration: underline;
  opacity: 0.8;
}

.prose strong, .prose b {
  color: var(--foreground);
  font-weight: 600;
}

.prose em {
  font-style: italic;
}

.prose ul, .prose ol {
  margin-bottom: 1rem;
  padding-left: 1.5rem;
}

.prose li::marker {
  color: var(--muted-foreground);
}

.prose blockquote {
  border-left: 4px solid var(--border);
  padding-left: 1rem;
  margin: 1rem 0;
  font-style: italic;
  color: var(--muted-foreground);
}

.prose pre {
  background-color: oklch(0.97 0 0);
  border: 1px solid var(--border);
  border-radius: 8px;
  padding: 16px 20px;
  overflow-x: auto;
  margin: 1.5rem 0;
  position: relative;
}

/* Dark mode code blocks */
.dark .prose pre {
  background-color: oklch(0.145 0 0);
}

.prose code {
  font-family: var(--font-mono);
  font-size: 13px;
  line-height: 1.7;
  color: #c9d1d9;
}

/* Light mode code text */
:not(.dark) .prose code {
  color: #24292f;
}

/* Vibrant syntax highlighting - Dark mode (GitHub Dark inspired) */
.dark .prose pre code {
  color: #c9d1d9;
}

.dark .prose .hljs-keyword,
.dark .prose .hljs-selector-tag,
.dark .prose .hljs-literal,
.dark .prose .hljs-section,
.dark .prose .hljs-link {
  color: #ff7b72;
}

.dark .prose .hljs-string,
.dark .prose .hljs-attr {
  color: #a5d6ff;
}

.dark .prose .hljs-number,
.dark .prose .hljs-type {
  color: #79c0ff;
}

.dark .prose .hljs-function,
.dark .prose .hljs-title {
  color: #d2a8ff;
}

.dark .prose .hljs-comment {
  color: #8b949e;
  font-style: italic;
}

.dark .prose .hljs-variable,
.dark .prose .hljs-params {
  color: #ffa657;
}

.dark .prose .hljs-class,
.dark .prose .hljs-built_in {
  color: #7ee787;
}

/* Vibrant syntax highlighting - Light mode (GitHub Light inspired) */
.prose pre code {
  color: #24292f;
}

.prose .hljs-keyword,
.prose .hljs-selector-tag,
.prose .hljs-literal,
.prose .hljs-section,
.prose .hljs-link {
  color: #cf222e;
}

.prose .hljs-string,
.prose .hljs-attr {
  color: #0a3069;
}

.prose .hljs-number,
.prose .hljs-type {
  color: #0550ae;
}

.prose .hljs-function,
.prose .hljs-title {
  color: #8250df;
}

.prose .hljs-comment {
  color: #6e7781;
  font-style: italic;
}

.prose .hljs-variable,
.prose .hljs-params {
  color: #953800;
}

.prose .hljs-class,
.prose .hljs-built_in {
  color: #116329;
}

/* Inline code - Light mode (default) */
.prose :not(pre) > code {
  background-color: rgba(175, 184, 193, 0.3);
  color: #1f2328;
  padding: 2px 6px;
  border-radius: 4px;
  font-size: 0.875em;
  font-weight: 500;
}

/* Inline code - Dark mode */
.dark .prose :not(pre) > code {
  background-color: rgba(110, 118, 129, 0.4);
  color: #e6edf3;
}

.prose hr {
  border: none;
  border-top: 1px solid var(--border);
  margin: 2rem 0;
}

.prose table {
  width: 100%;
  border-collapse: collapse;
  margin: 1rem 0;
}

.prose th, .prose td {
  border: 1px solid var(--border);
  padding: 0.75rem;
  text-align: left;
}

.prose th {
  background-color: var(--muted);
  color: var(--foreground);
  font-weight: 600;
}

.prose td {
  color: var(--muted-foreground);
}

.prose img {
  max-width: 100%;
  height: auto;
  border-radius: var(--radius-md);
}

/* Code block copy button */
.kb-code-wrapper {
  position: relative;
}

.kb-copy-button {
  position: absolute;
  top: 12px;
  right: 12px;
  padding: 6px 10px;
  background: var(--muted);
  border: 1px solid var(--border);
  border-radius: var(--radius-sm);
  color: var(--muted-foreground);
  font-size: 12px;
  cursor: pointer;
  opacity: 0;
  transition: all 0.15s ease;
}

.kb-code-wrapper:hover .kb-copy-button {
  opacity: 0.8;
}

.kb-copy-button:hover {
  opacity: 1 !important;
  background: var(--accent);
  color: var(--foreground);
}

.kb-copy-button.copied {
  color: var(--success, #22c55e);
  opacity: 1 !important;
}

/* Header controls */
#theme-toggle:hover {
  background: var(--muted);
  border-color: var(--border);
}

#theme-toggle:active {
  transform: scale(0.98);
}

/* Animations */
@keyframes arcane-spin {
  to { transform: rotate(360deg); }
}

@keyframes arcane-shimmer {
  0% { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}

@keyframes arcane-dropdown-fade {
  from { opacity: 0; transform: translateY(-4px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes arcane-tooltip-fade {
  0% { opacity: 0; transform: translateX(-50%) translateY(-4px) scale(0.95); }
  100% { opacity: 1; transform: translateX(-50%) translateY(-8px) scale(1); }
}
''';
  }
}
