/// SVG icons used in JavaScript for dynamic DOM manipulation.
class KBIcons {
  /// Copy icon (Lucide copy)
  static const String copy = '''
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect width="14" height="14" x="8" y="8" rx="2" ry="2"></rect><path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"></path></svg>''';

  /// Check icon for copied state (Lucide check)
  static const String check = '''
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 9 17l-5-5"></path></svg>''';
}

/// Configuration constants for scripts.
class KBScriptConfig {
  static const int maxSearchResults = 10;
  static const int minSearchQueryLength = 2;
  static const int copyFeedbackTimeout = 2000;
  static const String defaultThemeMode = 'dark';
}

/// Generates client-side JavaScript for the knowledge base.
class KBScripts {
  final String basePath;

  const KBScripts({this.basePath = ''});

  /// Generate the complete knowledge base scripts.
  String generate() {
    return '''
(function() {
  function initializeKnowledgeBaseGlobalScripts() {
    if (window.__kbGlobalInitialized) return;
    window.__kbGlobalInitialized = true;
    ${_themeUtilities()}
    ${_themeToggleHandler()}
    ${_searchFunctionality()}
    ${_sidebarCollapse()}
    ${_softNavigation()}
  }

  function initializeKnowledgeBasePageScripts() {
    ${_codeBlockCopyButtons()}
    ${_syntaxHighlighting()}
    ${_mediaEmbeds()}
    ${_tocScrollTracking()}
    ${_backToTop()}
    ${_ratingFunctionality()}
  }

  window.__kbInitializePage = initializeKnowledgeBasePageScripts;
  window.__kbInitializeAll = function() {
    initializeKnowledgeBaseGlobalScripts();
    initializeKnowledgeBasePageScripts();
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', window.__kbInitializeAll);
  } else {
    window.__kbInitializeAll();
  }
})();
''';
  }

  /// Generate theme initialization script (runs before body).
  String generateThemeInit() {
    return '''
(function() {
  var mode = localStorage.getItem('arcane-theme-mode') || '${KBScriptConfig.defaultThemeMode}';
  window.arcaneThemeMode = mode;
  document.documentElement.classList.remove('dark', 'light');
  document.documentElement.classList.add(mode === 'dark' ? 'dark' : 'light');

  function applyRootTheme() {
    var root = document.getElementById('arcane-root');
    if (!root) return false;
    root.classList.remove('dark', 'light');
    root.classList.add(mode === 'dark' ? 'dark' : 'light');
    return true;
  }

  if (!applyRootTheme() && typeof MutationObserver !== 'undefined') {
    var observer = new MutationObserver(function() {
      if (applyRootTheme()) {
        observer.disconnect();
      }
    });
    observer.observe(document.documentElement, { childList: true, subtree: true });
  }
})();
''';
  }

  static String _themeUtilities() =>
      '''
// ===== THEME UTILITIES =====
function getCurrentMode() {
  return localStorage.getItem('arcane-theme-mode') || '${KBScriptConfig.defaultThemeMode}';
}
function updateClasses() {
  var mode = getCurrentMode();
  var isDark = mode === 'dark';
  // Update html element for CSS variables to reach document scrollbar
  document.documentElement.classList.remove('dark', 'light');
  document.documentElement.classList.add(isDark ? 'dark' : 'light');
  // Update arcane-root for component styling
  var root = document.getElementById('arcane-root');
  if (root) {
    root.classList.remove('dark', 'light');
    root.classList.add(isDark ? 'dark' : 'light');
  }
}
function setMode(mode) {
  localStorage.setItem('arcane-theme-mode', mode);
  updateClasses();
  updateModeToggleIcon(mode);
}
function updateModeToggleIcon(mode) {
  var themeToggle = document.getElementById('theme-toggle');
  if (!themeToggle) return;
  var lightIcon = themeToggle.querySelector('.theme-icon-light');
  var darkIcon = themeToggle.querySelector('.theme-icon-dark');
  if (lightIcon && darkIcon) {
    lightIcon.style.display = mode === 'dark' ? 'block' : 'none';
    darkIcon.style.display = mode === 'dark' ? 'none' : 'block';
  }
}
updateClasses();
updateModeToggleIcon(getCurrentMode());
''';

  static String _themeToggleHandler() => '''
// ===== THEME TOGGLE =====
var themeToggle = document.getElementById('theme-toggle');
if (themeToggle) {
  themeToggle.addEventListener('click', function(e) {
    var currentMode = getCurrentMode();
    var newMode = currentMode === 'dark' ? 'light' : 'dark';
    setMode(newMode);
  });
}
''';

  String _searchFunctionality() =>
      '''
// ===== SEARCH FUNCTIONALITY =====
(function() {
  // Guard against multiple initializations
  if (window.__kbSearchInitialized) return;
  window.__kbSearchInitialized = true;

  var searchInput = document.getElementById('kb-search');
  var searchResults = document.getElementById('search-results');

  // Bail early if elements not found
  if (!searchInput || !searchResults) {
    console.warn('[KB Search] Search elements not found');
    return;
  }

  var searchIndex = [];
  var selectedIndex = -1;
  var currentResults = [];
  var basePath = '$basePath';

  // Build search index from sidebar navigation
  document.querySelectorAll('.sidebar-link').forEach(function(link) {
    var text = link.textContent.trim();
    var href = link.getAttribute('href');
    if (text && href) {
      var parts = href.split('/');
      var category = parts.length > 1 ? parts[1] : '';
      category = category.charAt(0).toUpperCase() + category.slice(1).replace(/-/g, ' ');
      searchIndex.push({
        title: text,
        href: href,
        category: category,
        searchText: text.toLowerCase()
      });
    }
  });

  function filterSearchResults(query) {
    return searchIndex.filter(function(item) {
      return item.searchText.includes(query);
    }).slice(0, ${KBScriptConfig.maxSearchResults});
  }

  function updateHighlight() {
    var items = searchResults.querySelectorAll('a[data-index]');
    items.forEach(function(item, i) {
      if (i === selectedIndex) {
        item.style.background = 'var(--accent)';
        // Scroll into view if needed
        item.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
      } else {
        item.style.background = 'transparent';
      }
    });
  }

  function showResults(results) {
    currentResults = results;
    selectedIndex = -1;
    if (results.length === 0) {
      searchResults.innerHTML = '<div style="padding: 12px; color: var(--muted-foreground); text-align: center;">No results found</div>';
      searchResults.style.display = 'block';
      return;
    }
    var html = results.map(function(item, index) {
      var fullHref = basePath + item.href;
      return '<a href="' + fullHref + '" data-index="' + index + '" style="display: block; padding: 10px 12px; text-decoration: none; border-bottom: 1px solid var(--border); transition: background 0.15s;">' +
        '<div style="font-weight: 500; color: var(--foreground);">' + item.title + '</div>' +
        '<div style="font-size: 12px; color: var(--muted-foreground);">' + item.category + '</div>' +
      '</a>';
    }).join('');
    searchResults.innerHTML = html;
    searchResults.style.display = 'block';

    // Attach hover handlers to new elements
    searchResults.querySelectorAll('a[data-index]').forEach(function(link) {
      link.addEventListener('mouseenter', function() {
        selectedIndex = parseInt(this.dataset.index, 10);
        updateHighlight();
      });
    });
  }

  function hideResults() {
    searchResults.style.display = 'none';
    selectedIndex = -1;
    currentResults = [];
  }

  function isResultsVisible() {
    return searchResults.style.display === 'block';
  }

  function navigateToSelected() {
    if (selectedIndex >= 0 && selectedIndex < currentResults.length) {
      var href = basePath + currentResults[selectedIndex].href;
      if (window.__kbNavigateTo) {
        window.__kbNavigateTo(href);
      } else {
        window.location.href = href;
      }
    }
  }

  // Input handler
  searchInput.addEventListener('input', function() {
    var query = this.value.toLowerCase().trim();
    if (query.length < ${KBScriptConfig.minSearchQueryLength}) {
      hideResults();
      return;
    }
    showResults(filterSearchResults(query));
  });

  // Focus handler
  searchInput.addEventListener('focus', function() {
    if (this.value.length >= ${KBScriptConfig.minSearchQueryLength}) {
      showResults(filterSearchResults(this.value.toLowerCase().trim()));
    }
  });

  // Blur handler - hide after small delay to allow click on results
  searchInput.addEventListener('blur', function() {
    setTimeout(function() {
      // Only hide if focus didn't move to search results
      if (!searchResults.contains(document.activeElement)) {
        hideResults();
      }
    }, 150);
  });

  // Keyboard navigation on the input element
  searchInput.addEventListener('keydown', function(e) {
    var key = e.key;

    if (key === 'Escape') {
      e.preventDefault();
      e.stopPropagation();
      hideResults();
      this.blur();
      return;
    }

    if (!isResultsVisible()) return;

    if (key === 'ArrowDown') {
      e.preventDefault();
      e.stopPropagation();
      if (currentResults.length > 0) {
        selectedIndex = Math.min(selectedIndex + 1, currentResults.length - 1);
        updateHighlight();
      }
    } else if (key === 'ArrowUp') {
      e.preventDefault();
      e.stopPropagation();
      if (currentResults.length > 0) {
        selectedIndex = Math.max(selectedIndex - 1, -1);
        updateHighlight();
      }
    } else if (key === 'Enter') {
      e.preventDefault();
      e.stopPropagation();
      if (selectedIndex >= 0) {
        navigateToSelected();
      } else if (currentResults.length > 0) {
        // Navigate to first result if none selected
        selectedIndex = 0;
        navigateToSelected();
      }
    }
  }, true); // Capture phase

  // Click-outside handler using capture phase
  document.addEventListener('click', function(e) {
    var target = e.target;
    var clickedInsideSearch = searchInput === target || searchInput.contains(target);
    var clickedInsideResults = searchResults === target || searchResults.contains(target);

    if (!clickedInsideSearch && !clickedInsideResults && isResultsVisible()) {
      hideResults();
      searchInput.blur();
    }
  }, true); // Capture phase - runs before other handlers

  // Global keyboard handler using capture phase
  document.addEventListener('keydown', function(e) {
    var key = e.key;

    // ESC to close (fallback if input doesn't have focus)
    if (key === 'Escape' && isResultsVisible()) {
      e.preventDefault();
      e.stopPropagation();
      hideResults();
      searchInput.blur();
      return;
    }

    // Ctrl+K / Cmd+K to open search
    if ((e.metaKey || e.ctrlKey) && key === 'k') {
      e.preventDefault();
      e.stopPropagation();
      searchInput.focus();
      searchInput.select();
    }
  }, true); // Capture phase - runs before other handlers

  console.log('[KB Search] Initialized with ' + searchIndex.length + ' items');
})();
''';

  String _softNavigation() =>
      '''
(function() {
  if (window.__kbSoftNavigationInitialized) return;
  window.__kbSoftNavigationInitialized = true;

  var basePath = '$basePath';
  var normalizedBasePath = basePath || '';
  if (normalizedBasePath.length > 1 && normalizedBasePath.endsWith('/')) {
    normalizedBasePath = normalizedBasePath.substring(0, normalizedBasePath.length - 1);
  }
  if (normalizedBasePath === '/') {
    normalizedBasePath = '';
  }
  var requestToken = 0;
  var homePath = normalizePath(normalizedBasePath || '/');

  function normalizePath(path) {
    if (!path) return '/';
    if (path.length > 1 && path.endsWith('/')) {
      return path.substring(0, path.length - 1);
    }
    return path;
  }

  function shouldHandleSoftNav(link) {
    if (!link || !link.closest) return false;
    if (link.getAttribute('data-kb-hard-nav') === 'true') return false;
    if (!link.closest('.kb-page-shell')) return false;
    return true;
  }

  function isNavigableUrl(url) {
    if (url.origin !== window.location.origin) return false;
    if (url.protocol !== 'http:' && url.protocol !== 'https:') return false;
    if (normalizedBasePath &&
        url.pathname !== normalizedBasePath &&
        url.pathname.indexOf(normalizedBasePath + '/') !== 0) {
      return false;
    }
    return true;
  }

  function updateSidebarActive(pathname) {
    var targetPath = normalizePath(pathname);
    document.querySelectorAll('.sidebar-link').forEach(function(link) {
      try {
        var linkUrl = new URL(link.href, window.location.origin);
        var linkPath = normalizePath(linkUrl.pathname);
        link.classList.toggle('active', linkPath === targetPath);
      } catch (_) {}
    });
  }

  function updateTopBarActive(pathname) {
    var targetPath = normalizePath(pathname);
    document.querySelectorAll('.kb-topbar-link').forEach(function(link) {
      if (link.getAttribute('target') === '_blank') return;
      try {
        var linkUrl = new URL(link.href, window.location.origin);
        var linkPath = normalizePath(linkUrl.pathname);
        var isRootLink = linkPath === homePath;
        var isActive = isRootLink
            ? targetPath === linkPath
            : targetPath === linkPath || targetPath.indexOf(linkPath + '/') === 0;
        link.classList.toggle('active', isActive);
      } catch (_) {}
    });
  }

  function replaceSidebarNavigation(nextDocument) {
    var nextSidebarNav = nextDocument.querySelector('.kb-sidebar .sidebar-nav');
    var currentSidebarNav = document.querySelector('.kb-sidebar .sidebar-nav');
    if (nextSidebarNav && currentSidebarNav) {
      currentSidebarNav.replaceWith(nextSidebarNav);
      if (window.__kbApplySidebarCollapseState) {
        window.__kbApplySidebarCollapseState();
      }
    }
  }

  function navigateTo(href, pushHistory) {
    var destination = new URL(href, window.location.origin);
    if (!isNavigableUrl(destination)) {
      window.location.assign(destination.href);
      return;
    }

    var current = new URL(window.location.href);
    var destinationPath = normalizePath(destination.pathname);
    var currentPath = normalizePath(current.pathname);

    if (destinationPath === currentPath && destination.search === current.search) {
      if (destination.hash && destination.hash !== current.hash) {
        var hashTarget = document.getElementById(destination.hash.substring(1));
        if (hashTarget) {
          hashTarget.scrollIntoView();
        } else {
          window.location.hash = destination.hash;
        }
      }
      return;
    }

    var token = ++requestToken;
    fetch(destination.href, { credentials: 'same-origin' })
      .then(function(response) {
        if (!response.ok) throw new Error('navigation_failed');
        return response.text();
      })
      .then(function(html) {
        if (token !== requestToken) return;

        var parser = new DOMParser();
        var nextDocument = parser.parseFromString(html, 'text/html');
        var nextMainArea = nextDocument.querySelector('.kb-main-area');
        var currentMainArea = document.querySelector('.kb-main-area');

        if (!nextMainArea || !currentMainArea) {
          window.location.assign(destination.href);
          return;
        }

        currentMainArea.replaceWith(nextMainArea);
        replaceSidebarNavigation(nextDocument);
        updateSidebarActive(destination.pathname);
        updateTopBarActive(destination.pathname);

        if (nextDocument.title) {
          document.title = nextDocument.title;
        }

        var nextDescription = nextDocument.querySelector('meta[name="description"]');
        var currentDescription = document.querySelector('meta[name="description"]');
        if (nextDescription && currentDescription) {
          currentDescription.setAttribute(
            'content',
            nextDescription.getAttribute('content') || '',
          );
        } else if (nextDescription && !currentDescription) {
          document.head.appendChild(nextDescription.cloneNode(true));
        }

        if (pushHistory) {
          history.pushState({ href: destination.href }, '', destination.href);
        }

        if (!destination.hash) {
          window.scrollTo({ top: 0, behavior: 'auto' });
        } else {
          var anchorTarget = document.getElementById(destination.hash.substring(1));
          if (anchorTarget) {
            anchorTarget.scrollIntoView();
          } else {
            window.location.hash = destination.hash;
          }
        }

        if (window.__kbInitializePage) {
          window.__kbInitializePage();
        }
      })
      .catch(function() {
        window.location.assign(destination.href);
      });
  }

  window.__kbNavigateTo = function(href) {
    navigateTo(href, true);
  };

  document.addEventListener('click', function(e) {
    if (e.defaultPrevented) return;
    if (e.button !== 0) return;
    if (e.metaKey || e.ctrlKey || e.shiftKey || e.altKey) return;

    var target = e.target;
    if (!target || !target.closest) return;

    var link = target.closest('a[href]');
    if (!link) return;
    if (!shouldHandleSoftNav(link)) return;
    if (link.hasAttribute('download')) return;

    var targetAttr = link.getAttribute('target');
    if (targetAttr && targetAttr !== '_self') return;

    var href = link.getAttribute('href');
    if (!href || href.startsWith('#') || href.startsWith('javascript:')) return;

    var destination = new URL(href, window.location.origin);
    if (!isNavigableUrl(destination)) return;

    e.preventDefault();
    navigateTo(destination.href, true);
  }, true);

  window.addEventListener('popstate', function() {
    navigateTo(window.location.href, false);
  });
})();
''';

  static String _codeBlockCopyButtons() =>
      '''
// ===== CODE BLOCK COPY BUTTONS =====
var copyIconSvg = '${KBIcons.copy}';
var checkIconSvg = '${KBIcons.check}';

var proseBlocks = document.querySelectorAll('.prose pre');
proseBlocks.forEach(function(pre) {
  if (pre.parentNode.classList.contains('code-block-wrapper')) return;
  if (pre.closest('.arcane-code-block')) return;

  var wrapper = document.createElement('div');
  wrapper.className = 'code-block-wrapper';
  pre.parentNode.insertBefore(wrapper, pre);
  wrapper.appendChild(pre);
  pre.style.paddingRight = '50px';

  var copyBtn = document.createElement('button');
  copyBtn.className = 'copy-code-btn';
  copyBtn.setAttribute('type', 'button');
  copyBtn.innerHTML = copyIconSvg;
  wrapper.appendChild(copyBtn);

  copyBtn.onclick = function(e) {
    e.preventDefault();
    e.stopPropagation();
    var btn = this;
    var codeEl = pre.querySelector('code') || pre;
    var text = codeEl.textContent || '';

    navigator.clipboard.writeText(text).then(function() {
      btn.innerHTML = checkIconSvg;
      btn.classList.add('copied');
      setTimeout(function() {
        btn.innerHTML = copyIconSvg;
        btn.classList.remove('copied');
      }, ${KBScriptConfig.copyFeedbackTimeout});
    }).catch(function() {
      var textarea = document.createElement('textarea');
      textarea.value = text;
      textarea.style.position = 'fixed';
      textarea.style.opacity = '0';
      document.body.appendChild(textarea);
      textarea.select();
      try {
        document.execCommand('copy');
        btn.innerHTML = checkIconSvg;
        btn.classList.add('copied');
        setTimeout(function() {
          btn.innerHTML = copyIconSvg;
          btn.classList.remove('copied');
        }, ${KBScriptConfig.copyFeedbackTimeout});
      } catch(e) {}
      document.body.removeChild(textarea);
    });
  };
});
''';

  static String _syntaxHighlighting() => '''
// ===== SYNTAX HIGHLIGHTING =====
(function() {
  if (window.__kbSyntaxHighlightInitialized) return;
  window.__kbSyntaxHighlightInitialized = true;

  var maxRetries = 30;
  var retryDelayMs = 60;
  var highlightAttribute = 'data-kb-highlighted';
  var languageClasses = ['dart', 'javascript', 'yaml', 'bash', 'json', 'html', 'css'];

  function hasLanguageClass(className) {
    if (!className) return false;
    return className.split(' ').some(function(token) {
      return token === 'language-dart' ||
             token === 'language-javascript' ||
             token === 'language-yaml' ||
             token === 'language-bash' ||
             token === 'language-json' ||
             token === 'language-html' ||
             token === 'language-css' ||
             token === 'language-js' ||
             token === 'language-shell' ||
             token === 'language-sh';
    });
  }

  function normalizeLanguageClasses(block) {
    if (block.getAttribute(highlightAttribute) === '1') return;
    var className = block.className || '';
    if (!hasLanguageClass(className) &&
        className.indexOf('language-') === -1) {
      block.classList.add('language-dart');
      return;
    }
    if (!hasLanguageClass(className) && className.indexOf('language-') !== -1) {
      var classes = className.trim().split(/\\s+/);
      var languageClass = null;
      for (var i = 0; i < classes.length; i++) {
        if (classes[i].indexOf('language-') === 0) {
          languageClass = classes[i];
          break;
        }
      }
      if (!languageClass) return;
      if (languageClass === 'language-js' || languageClass === 'language-shell') {
        block.classList.remove(languageClass);
        block.classList.add(languageClass.replace('language-js', 'language-javascript'));
      }
    }
  }

  function highlight() {
    if (typeof hljs === 'undefined' || typeof hljs.highlightElement !== 'function') {
      return false;
    }

    hljs.configure({
      ignoreUnescapedHTML: true,
      languages: languageClasses,
    });

    document.querySelectorAll('pre code').forEach(function(block) {
      normalizeLanguageClasses(block);
      if (block.getAttribute(highlightAttribute) === '1') return;
      if (block.className.indexOf('hljs-') !== -1) return;
      hljs.highlightElement(block);
      block.setAttribute(highlightAttribute, '1');
    });

    return true;
  }

  function initWithRetry(retriesLeft) {
    if (highlight()) return;
    if (retriesLeft <= 0) return;
    window.setTimeout(function() {
      initWithRetry(retriesLeft - 1);
    }, retryDelayMs);
  }

  function observeDynamicCodeBlocks() {
    if (window.__kbSyntaxHighlightObserver || !window.MutationObserver) return;
    window.__kbSyntaxHighlightObserver = new MutationObserver(function() {
      highlight();
    });
    window.__kbSyntaxHighlightObserver.observe(document.documentElement, {
      childList: true,
      subtree: true,
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', function() {
      initWithRetry(maxRetries);
      observeDynamicCodeBlocks();
    });
  } else {
    initWithRetry(maxRetries);
    observeDynamicCodeBlocks();
  }
})();
''';

  static String _mediaEmbeds() => '''
var mediaIframes = document.querySelectorAll('.kb-media-iframe iframe');
mediaIframes.forEach(function(frame) {
  if (!frame.getAttribute('loading')) frame.setAttribute('loading', 'lazy');
  if (!frame.getAttribute('referrerpolicy')) {
    frame.setAttribute('referrerpolicy', 'strict-origin-when-cross-origin');
  }
});

var youtubeFrames = document.querySelectorAll('.kb-media-youtube iframe');
youtubeFrames.forEach(function(frame) {
  if (frame.getAttribute('data-kb-youtube-init') === '1') return;
  frame.setAttribute('data-kb-youtube-init', '1');
  frame.setAttribute('loading', 'eager');
  if (!frame.getAttribute('referrerpolicy')) {
    frame.setAttribute('referrerpolicy', 'strict-origin-when-cross-origin');
  }

  var primarySrc = frame.getAttribute('data-kb-src') || frame.getAttribute('src') || '';
  var fallbackSrc = frame.getAttribute('data-kb-fallback-src') || '';
  var watchUrl = frame.getAttribute('data-kb-watch-url') || '';
  if (!frame.getAttribute('src') && primarySrc) {
    frame.setAttribute('src', primarySrc);
  }

  var settled = false;
  var timeoutHandle = null;
  var fallbackTried = false;

  function clearYoutubeTimeout() {
    if (timeoutHandle) {
      clearTimeout(timeoutHandle);
      timeoutHandle = null;
    }
  }

  function markReady() {
    if (settled) return;
    settled = true;
    clearYoutubeTimeout();
  }

  function scheduleTimeout() {
    clearYoutubeTimeout();
    timeoutHandle = setTimeout(onTimeout, 7000);
  }

  function showFallbackLink() {
    if (frame.getAttribute('data-kb-youtube-fallback') === '1') return;
    var fallback = document.createElement('a');
    fallback.href = watchUrl || primarySrc || fallbackSrc;
    fallback.target = '_blank';
    fallback.rel = 'noopener noreferrer';
    fallback.textContent = 'Open on YouTube';
    fallback.style.display = 'inline-flex';
    fallback.style.marginTop = '0.5rem';
    fallback.style.fontSize = '0.875rem';
    fallback.style.textDecoration = 'underline';
    var container = frame.closest('.kb-media-youtube');
    if (container) {
      container.appendChild(fallback);
      frame.setAttribute('data-kb-youtube-fallback', '1');
    }
  }

  function onTimeout() {
    if (settled) return;
    if (!fallbackTried && fallbackSrc && frame.getAttribute('src') !== fallbackSrc) {
      fallbackTried = true;
      frame.setAttribute('src', fallbackSrc);
      scheduleTimeout();
      return;
    }
    settled = true;
    showFallbackLink();
  }

  frame.addEventListener('load', markReady);
  scheduleTimeout();
});

var baseElement = document.querySelector('base[href]');
var baseHref = baseElement ? baseElement.getAttribute('href') || '/' : '/';
if (!baseHref.startsWith('/')) {
  baseHref = '/' + baseHref;
}
if (!baseHref.endsWith('/')) {
  baseHref = baseHref + '/';
}
var normalizedBase = baseHref === '/' ? '' : baseHref.replace(/\\/\$/, '');

function kbAbsoluteCandidate(path) {
  if (!normalizedBase) return path;
  if (!path.startsWith('/')) return path;
  return normalizedBase + path;
}

function kbVideoCandidates(src) {
  var value = (src || '').trim();
  if (!value) return [];
  if (/^(https?:|data:|blob:|\\/\\/)/i.test(value)) {
    return [value];
  }

  var candidates = [];
  function add(url) {
    if (!url) return;
    if (candidates.indexOf(url) === -1) candidates.push(url);
  }

  add(value);
  if (value.startsWith('/')) {
    add(kbAbsoluteCandidate(value));
  } else {
    var clean = value.replace(/^\\.\\//, '');
    add('/' + clean);
    add(kbAbsoluteCandidate('/' + clean));
    add('/assets/' + clean);
    add(kbAbsoluteCandidate('/assets/' + clean));
    add('/assets/videos/' + clean);
    add(kbAbsoluteCandidate('/assets/videos/' + clean));
    add('/videos/' + clean);
    add(kbAbsoluteCandidate('/videos/' + clean));
  }
  return candidates;
}

function kbInitLocalVideo(video) {
  if (video.getAttribute('data-kb-video-init') === '1') return;
  video.setAttribute('data-kb-video-init', '1');
  var source = video.querySelector('source');
  if (!source) return;

  var originalSrc = source.getAttribute('data-src') || source.getAttribute('src') || video.getAttribute('data-src') || '';
  var candidates = kbVideoCandidates(originalSrc);
  if (candidates.length === 0) return;

  var index = 0;
  var settled = false;

  function applyCurrent() {
    source.setAttribute('src', candidates[index]);
    video.load();
  }

  function complete() {
    settled = true;
    video.removeEventListener('error', onError);
    video.removeEventListener('loadeddata', onLoaded);
    video.removeEventListener('canplay', onLoaded);
  }

  function onLoaded() {
    if (settled) return;
    complete();
  }

  function onError() {
    if (settled) return;
    index += 1;
    if (index < candidates.length) {
      applyCurrent();
      return;
    }
    complete();
    var fallback = document.createElement('a');
    fallback.href = originalSrc;
    fallback.target = '_blank';
    fallback.rel = 'noopener noreferrer';
    fallback.textContent = 'Open video';
    fallback.style.display = 'inline-flex';
    fallback.style.marginTop = '0.5rem';
    fallback.style.fontSize = '0.875rem';
    fallback.style.textDecoration = 'underline';
    if (video.parentNode && video.parentNode.parentNode) {
      video.parentNode.parentNode.appendChild(fallback);
    }
  }

  video.addEventListener('error', onError);
  video.addEventListener('loadeddata', onLoaded);
  video.addEventListener('canplay', onLoaded);
  applyCurrent();
}

var localVideos = document.querySelectorAll('.kb-media-local video');
localVideos.forEach(kbInitLocalVideo);

var twitterContainers = document.querySelectorAll('.kb-media-twitter');
if (twitterContainers.length > 0) {
  if (!document.querySelector('script[src*="platform.twitter.com/widgets.js"]')) {
    var twitterScript = document.createElement('script');
    twitterScript.async = true;
    twitterScript.src = 'https://platform.twitter.com/widgets.js';
    twitterScript.charset = 'utf-8';
    document.body.appendChild(twitterScript);
  }

  if (window.__kbTwitterPollTimer) {
    clearInterval(window.__kbTwitterPollTimer);
    window.__kbTwitterPollTimer = null;
  }

  var tries = 0;
  window.__kbTwitterPollTimer = setInterval(function() {
    tries += 1;
    if (window.twttr && window.twttr.widgets && typeof window.twttr.widgets.load === 'function') {
      clearInterval(window.__kbTwitterPollTimer);
      window.__kbTwitterPollTimer = null;
      twitterContainers.forEach(function(container) {
        window.twttr.widgets.load(container);
      });
      return;
    }
    if (tries >= 60) {
      clearInterval(window.__kbTwitterPollTimer);
      window.__kbTwitterPollTimer = null;
      twitterContainers.forEach(function(container) {
        var link = container.querySelector('a[href*="twitter.com"], a[href*="x.com"]');
        if (!link) return;
        var href = link.getAttribute('href');
        if (!href) return;
        if (container.getAttribute('data-kb-twitter-fallback') === '1') return;
        var iframe = document.createElement('iframe');
        iframe.src = 'https://twitframe.com/show?url=' + encodeURIComponent(href);
        iframe.setAttribute('loading', 'lazy');
        iframe.setAttribute('referrerpolicy', 'strict-origin-when-cross-origin');
        iframe.style.width = '100%';
        iframe.style.minHeight = '420px';
        iframe.style.border = '0';
        iframe.style.borderRadius = '8px';
        container.innerHTML = '';
        container.appendChild(iframe);
        container.setAttribute('data-kb-twitter-fallback', '1');
      });
    }
  }, 120);
}
''';

  static String _tocScrollTracking() => '''
// ===== TOC SCROLL TRACKING =====
if (window.__kbTocObserver) {
  window.__kbTocObserver.disconnect();
  window.__kbTocObserver = null;
}
if (window.__kbTocScrollHandler) {
  window.removeEventListener('scroll', window.__kbTocScrollHandler);
  window.__kbTocScrollHandler = null;
}

var tocContainer = document.querySelector('.toc-content');
if (tocContainer) {
  var tocLinks = tocContainer.querySelectorAll('a');
  var headings = [];

  tocLinks.forEach(function(link) {
    var href = link.getAttribute('href');
    if (href && href.startsWith('#')) {
      var id = href.slice(1);
      var heading = document.getElementById(id);
      if (heading) {
        headings.push({ id: id, element: heading, link: link });
      }
    }
  });

  if (headings.length > 0) {
    var currentActive = null;

    function updateActiveLink(activeId) {
      if (currentActive === activeId) return;
      currentActive = activeId;
      tocLinks.forEach(function(link) {
        var href = link.getAttribute('href');
        var isActive = href === '#' + activeId;
        link.classList.toggle('toc-active', isActive);
      });
    }

    var observerOptions = {
      root: null,
      rootMargin: '-80px 0px -70% 0px',
      threshold: 0
    };

    var observer = new IntersectionObserver(function(entries) {
      entries.forEach(function(entry) {
        if (entry.isIntersecting) {
          updateActiveLink(entry.target.id);
        }
      });
    }, observerOptions);
    window.__kbTocObserver = observer;

    headings.forEach(function(h) {
      observer.observe(h.element);
    });

    var scrollHandler = function() {
      if (window.scrollY < 100 && headings.length > 0) {
        updateActiveLink(headings[0].id);
      }
    };
    window.addEventListener('scroll', scrollHandler);
    window.__kbTocScrollHandler = scrollHandler;

    updateActiveLink(headings[0].id);
  }
}
''';

  static String _sidebarCollapse() => '''
// ===== SIDEBAR COLLAPSE =====
function getCollapseStorageKey(details) {
  var summarySpan = details.querySelector('summary span');
  if (!summarySpan || !summarySpan.textContent) return null;
  var label = summarySpan.textContent.trim();
  if (!label) return null;
  return 'kb-collapse-' + label;
}

window.__kbApplySidebarCollapseState = function() {
  document.querySelectorAll('.sidebar-details').forEach(function(details) {
    var key = getCollapseStorageKey(details);
    if (!key) return;
    var stored = localStorage.getItem(key);
    if (stored === 'closed') {
      details.removeAttribute('open');
    } else if (stored === 'open') {
      details.setAttribute('open', '');
    }
  });
};

if (!window.__kbSidebarInitialized) {
  window.__kbSidebarInitialized = true;

  document.addEventListener('toggle', function(e) {
    var details = e.target;
    if (!details || !details.classList || !details.classList.contains('sidebar-details')) {
      return;
    }
    var key = getCollapseStorageKey(details);
    if (!key) return;
    localStorage.setItem(key, details.open ? 'open' : 'closed');
  }, true);

  var hamburger = document.querySelector('.kb-hamburger');
  var sidebar = document.querySelector('.kb-sidebar');
  if (hamburger && sidebar) {
    hamburger.addEventListener('click', function() {
      sidebar.classList.toggle('open');
    });
    sidebar.addEventListener('click', function(e) {
      var target = e.target;
      if (!target || !target.closest) return;
      if (!target.closest('a')) return;
      if (window.innerWidth <= 768) {
        sidebar.classList.remove('open');
      }
    });
  }
}

window.__kbApplySidebarCollapseState();
''';

  static String _backToTop() => '''
// ===== BACK TO TOP =====
if (window.__kbBackToTopScrollHandler) {
  window.removeEventListener('scroll', window.__kbBackToTopScrollHandler);
  window.__kbBackToTopScrollHandler = null;
}
if (window.__kbBackToTopClickHandler && window.__kbBackToTopElement) {
  window.__kbBackToTopElement.removeEventListener('click', window.__kbBackToTopClickHandler);
  window.__kbBackToTopClickHandler = null;
  window.__kbBackToTopElement = null;
}

var backToTop = document.querySelector('.kb-back-to-top');
if (backToTop) {
  var scrollHandler = function() {
    if (window.scrollY > 300) {
      backToTop.classList.add('visible');
    } else {
      backToTop.classList.remove('visible');
    }
  };
  var clickHandler = function() {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };
  window.addEventListener('scroll', scrollHandler);
  backToTop.addEventListener('click', clickHandler);
  window.__kbBackToTopScrollHandler = scrollHandler;
  window.__kbBackToTopClickHandler = clickHandler;
  window.__kbBackToTopElement = backToTop;
}
''';

  static String _ratingFunctionality() => '''
// ===== PAGE RATING =====
var ratingContainer = document.querySelector('.kb-rating');
if (ratingContainer) {
  var ratingButtons = ratingContainer.querySelectorAll('.kb-rating-btn');
  var promptSection = ratingContainer.querySelector('.kb-rating-prompt');
  var thanksSection = ratingContainer.querySelector('.kb-rating-thanks');
  var pagePath = ratingContainer.dataset.path;

  // Check if user already rated this page
  var ratedKey = 'kb-rated-' + pagePath;
  if (localStorage.getItem(ratedKey)) {
    if (promptSection) promptSection.style.display = 'none';
    if (thanksSection) thanksSection.style.display = 'block';
  }

  ratingButtons.forEach(function(btn) {
    // Hover effects
    btn.addEventListener('mouseenter', function() {
      this.style.borderColor = 'hsl(var(--primary))';
      this.style.color = 'hsl(var(--foreground))';
    });
    btn.addEventListener('mouseleave', function() {
      this.style.borderColor = 'hsl(var(--border))';
      this.style.color = 'hsl(var(--muted-foreground))';
    });

    // Click handler
    btn.addEventListener('click', function() {
      var isHelpful = this.dataset.helpful === 'true';
      var path = this.dataset.path;

      // Mark as rated in localStorage to prevent duplicate votes
      localStorage.setItem(ratedKey, isHelpful ? 'helpful' : 'not-helpful');

      // Show thank you message
      if (promptSection) promptSection.style.display = 'none';
      if (thanksSection) thanksSection.style.display = 'block';

      // Dispatch custom event for Firebase integration
      // Your Firebase code can listen for this event:
      //
      // document.addEventListener('kb-rating', function(e) {
      //   var pagePath = e.detail.path;
      //   var isHelpful = e.detail.helpful;
      //   var docId = pagePath.replace(/\\//g, '_');
      //   var field = isHelpful ? 'helpful' : 'notHelpful';
      //
      //   firebase.firestore()
      //     .collection('pageRatings')
      //     .doc(docId)
      //     .set({
      //       [field]: firebase.firestore.FieldValue.increment(1),
      //       lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
      //     }, { merge: true });
      // });

      document.dispatchEvent(new CustomEvent('kb-rating', {
        detail: {
          path: path,
          helpful: isHelpful
        }
      }));

      console.log('Rating submitted:', { path: path, helpful: isHelpful });
    });
  });
}
''';
}
