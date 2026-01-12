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
document.addEventListener('DOMContentLoaded', function() {
  ${_themeUtilities()}
  ${_themeToggleHandler()}
  ${_searchFunctionality()}
  ${_codeBlockCopyButtons()}
  ${_syntaxHighlighting()}
  ${_tocScrollTracking()}
  ${_sidebarCollapse()}
  ${_backToTop()}
});
''';
  }

  /// Generate theme initialization script (runs before body).
  String generateThemeInit() {
    return '''
(function() {
  window.arcaneThemeMode = localStorage.getItem('arcane-theme-mode') || '${KBScriptConfig.defaultThemeMode}';
})();
''';
  }

  static String _themeUtilities() => '''
// ===== THEME UTILITIES =====
function getCurrentMode() {
  return localStorage.getItem('arcane-theme-mode') || '${KBScriptConfig.defaultThemeMode}';
}
function updateClasses() {
  var mode = getCurrentMode();
  var root = document.getElementById('arcane-root');
  if (root) {
    root.classList.remove('dark', 'light');
    root.classList.add(mode === 'dark' ? 'dark' : 'light');
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
  themeToggle.addEventListener('click', function() {
    var currentMode = getCurrentMode();
    var newMode = currentMode === 'dark' ? 'light' : 'dark';
    setMode(newMode);
  });
}
''';

  String _searchFunctionality() => '''
// ===== SEARCH FUNCTIONALITY =====
var searchInput = document.getElementById('kb-search');
var searchResults = document.getElementById('search-results');
var searchIndex = [];

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

function showResults(results) {
  if (!searchResults) return;
  if (results.length === 0) {
    searchResults.innerHTML = '<div style="padding: 12px; color: var(--muted-foreground); text-align: center;">No results found</div>';
    searchResults.style.display = 'block';
    return;
  }
  var basePath = '$basePath';
  var html = results.map(function(item) {
    var fullHref = basePath + item.href;
    return '<a href="' + fullHref + '" style="display: block; padding: 10px 12px; text-decoration: none; border-bottom: 1px solid var(--border); transition: background 0.15s;">' +
      '<div style="font-weight: 500; color: var(--foreground);">' + item.title + '</div>' +
      '<div style="font-size: 12px; color: var(--muted-foreground);">' + item.category + '</div>' +
    '</a>';
  }).join('');
  searchResults.innerHTML = html;
  searchResults.style.display = 'block';
  searchResults.querySelectorAll('a').forEach(function(link) {
    link.addEventListener('mouseenter', function() { this.style.background = 'var(--accent)'; });
    link.addEventListener('mouseleave', function() { this.style.background = 'transparent'; });
  });
}

function hideResults() {
  if (searchResults) searchResults.style.display = 'none';
}

if (searchInput) {
  searchInput.addEventListener('input', function() {
    var query = this.value.toLowerCase().trim();
    if (query.length < ${KBScriptConfig.minSearchQueryLength}) { hideResults(); return; }
    showResults(filterSearchResults(query));
  });
  searchInput.addEventListener('focus', function() {
    if (this.value.length >= ${KBScriptConfig.minSearchQueryLength}) {
      showResults(filterSearchResults(this.value.toLowerCase().trim()));
    }
  });
  document.addEventListener('click', function(e) {
    if (searchResults && !searchInput.contains(e.target) && !searchResults.contains(e.target)) hideResults();
  });
  searchInput.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') { hideResults(); this.blur(); }
  });
  document.addEventListener('keydown', function(e) {
    if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
      e.preventDefault();
      searchInput.focus();
      searchInput.select();
    }
  });
}
''';

  static String _codeBlockCopyButtons() => '''
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
if (typeof hljs !== 'undefined') {
  hljs.configure({
    ignoreUnescapedHTML: true,
    languages: ['dart', 'javascript', 'yaml', 'bash', 'json', 'html', 'css']
  });
  document.querySelectorAll('pre code').forEach(function(block) {
    if (!block.className || !block.className.includes('language-')) {
      block.classList.add('language-dart');
    }
  });
  hljs.highlightAll();
}
''';

  static String _tocScrollTracking() => '''
// ===== TOC SCROLL TRACKING =====
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

    headings.forEach(function(h) {
      observer.observe(h.element);
    });

    window.addEventListener('scroll', function() {
      if (window.scrollY < 100 && headings.length > 0) {
        updateActiveLink(headings[0].id);
      }
    });

    // Always select first item on page load
    updateActiveLink(headings[0].id);
  }
}
''';

  static String _sidebarCollapse() => '''
// ===== SIDEBAR COLLAPSE =====
document.querySelectorAll('.sidebar-details').forEach(function(details) {
  var key = 'kb-collapse-' + details.querySelector('summary span')?.textContent?.trim();
  var stored = localStorage.getItem(key);
  if (stored === 'closed') {
    details.removeAttribute('open');
  } else if (stored === 'open') {
    details.setAttribute('open', '');
  }
  details.addEventListener('toggle', function() {
    localStorage.setItem(key, details.open ? 'open' : 'closed');
  });
});

// Mobile sidebar toggle
var hamburger = document.querySelector('.kb-hamburger');
var sidebar = document.querySelector('.kb-sidebar');
if (hamburger && sidebar) {
  hamburger.addEventListener('click', function() {
    sidebar.classList.toggle('open');
  });
  sidebar.querySelectorAll('a').forEach(function(link) {
    link.addEventListener('click', function() {
      if (window.innerWidth <= 768) {
        sidebar.classList.remove('open');
      }
    });
  });
}
''';

  static String _backToTop() => '''
// ===== BACK TO TOP =====
var backToTop = document.querySelector('.kb-back-to-top');
if (backToTop) {
  window.addEventListener('scroll', function() {
    if (window.scrollY > 300) {
      backToTop.classList.add('visible');
    } else {
      backToTop.classList.remove('visible');
    }
  });
  backToTop.addEventListener('click', function() {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });
}
''';
}
