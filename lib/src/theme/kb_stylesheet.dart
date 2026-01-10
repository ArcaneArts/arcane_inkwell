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
''';
  }
}
