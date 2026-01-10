/// Generates JavaScript for knowledge base interactivity.
class KBScripts {
  final String basePath;

  const KBScripts({this.basePath = ''});

  /// Generate all JavaScript for the knowledge base.
  String generate() {
    return '''
(function() {
  'use strict';

  // Theme utilities
  const ThemeManager = {
    storageKey: 'kb-theme-mode',

    init() {
      const savedTheme = localStorage.getItem(this.storageKey);
      const root = document.getElementById('kb-root');
      if (!root) return;

      if (savedTheme) {
        root.classList.remove('dark', 'light');
        root.classList.add(savedTheme);
      }

      this.updateToggleIcon();
    },

    toggle() {
      const root = document.getElementById('kb-root');
      if (!root) return;

      const isDark = root.classList.contains('dark');
      root.classList.remove('dark', 'light');
      root.classList.add(isDark ? 'light' : 'dark');
      localStorage.setItem(this.storageKey, isDark ? 'light' : 'dark');
      this.updateToggleIcon();
    },

    updateToggleIcon() {
      const root = document.getElementById('kb-root');
      const toggle = document.querySelector('.kb-theme-toggle');
      if (!root || !toggle) return;

      const isDark = root.classList.contains('dark');
      const sunIcon = '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="4"/><path d="M12 2v2"/><path d="M12 20v2"/><path d="m4.93 4.93 1.41 1.41"/><path d="m17.66 17.66 1.41 1.41"/><path d="M2 12h2"/><path d="M20 12h2"/><path d="m6.34 17.66-1.41 1.41"/><path d="m19.07 4.93-1.41 1.41"/></svg>';
      const moonIcon = '<svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"/></svg>';

      toggle.innerHTML = isDark ? sunIcon : moonIcon;
    }
  };

  // Search functionality
  const SearchManager = {
    index: [],
    minQueryLength: 2,
    maxResults: 10,

    init() {
      this.buildIndex();
      this.setupEventListeners();
    },

    buildIndex() {
      const navItems = document.querySelectorAll('.kb-nav-item');
      this.index = [];

      navItems.forEach(item => {
        const title = item.textContent.trim();
        const path = item.getAttribute('href');
        const section = item.closest('.kb-nav-section');
        const sectionTitle = section ?
          section.querySelector('.kb-nav-section-header span')?.textContent.trim() : '';

        if (title && path) {
          this.index.push({
            title,
            path,
            section: sectionTitle || '',
            searchText: (title + ' ' + sectionTitle).toLowerCase()
          });
        }
      });
    },

    search(query) {
      if (!query || query.length < this.minQueryLength) return [];

      const q = query.toLowerCase();
      const results = this.index.filter(item =>
        item.searchText.includes(q)
      );

      // Sort by relevance (title match first)
      results.sort((a, b) => {
        const aTitle = a.title.toLowerCase().includes(q);
        const bTitle = b.title.toLowerCase().includes(q);
        if (aTitle && !bTitle) return -1;
        if (!aTitle && bTitle) return 1;
        return 0;
      });

      return results.slice(0, this.maxResults);
    },

    setupEventListeners() {
      const input = document.querySelector('.kb-search-input');
      const results = document.querySelector('.kb-search-results');

      if (!input || !results) return;

      input.addEventListener('input', (e) => {
        const query = e.target.value;
        const matches = this.search(query);
        this.renderResults(matches, results);
      });

      input.addEventListener('focus', () => {
        const query = input.value;
        if (query.length >= this.minQueryLength) {
          results.classList.add('visible');
        }
      });

      // Close results on click outside
      document.addEventListener('click', (e) => {
        if (!e.target.closest('.kb-search')) {
          results.classList.remove('visible');
        }
      });

      // Keyboard shortcut (Cmd/Ctrl + K)
      document.addEventListener('keydown', (e) => {
        if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
          e.preventDefault();
          input.focus();
          input.select();
        }

        // Escape to close
        if (e.key === 'Escape') {
          results.classList.remove('visible');
          input.blur();
        }
      });
    },

    renderResults(matches, container) {
      if (matches.length === 0) {
        container.classList.remove('visible');
        return;
      }

      const basePath = '${basePath.isEmpty ? '' : basePath}';

      container.innerHTML = matches.map(item => {
        const fullPath = basePath + item.path;
        return \`
          <a href="\${fullPath}" class="kb-search-result">
            <div class="kb-search-result-title">\${this.escapeHtml(item.title)}</div>
            <div class="kb-search-result-path">\${item.section ? item.section + ' / ' : ''}\${item.path}</div>
          </a>
        \`;
      }).join('');

      container.classList.add('visible');
    },

    escapeHtml(text) {
      const div = document.createElement('div');
      div.textContent = text;
      return div.innerHTML;
    }
  };

  // Code block copy functionality
  const CodeCopyManager = {
    init() {
      const codeBlocks = document.querySelectorAll('.kb-prose pre');

      codeBlocks.forEach(block => {
        const wrapper = document.createElement('div');
        wrapper.className = 'kb-code-wrapper';
        block.parentNode.insertBefore(wrapper, block);
        wrapper.appendChild(block);

        const button = document.createElement('button');
        button.className = 'kb-copy-button';
        button.textContent = 'Copy';
        button.addEventListener('click', () => this.copyCode(block, button));
        wrapper.appendChild(button);
      });
    },

    async copyCode(block, button) {
      const code = block.querySelector('code');
      const text = code ? code.textContent : block.textContent;

      try {
        await navigator.clipboard.writeText(text);
        button.textContent = 'Copied!';
        button.classList.add('copied');

        setTimeout(() => {
          button.textContent = 'Copy';
          button.classList.remove('copied');
        }, 2000);
      } catch (err) {
        // Fallback for older browsers
        const textarea = document.createElement('textarea');
        textarea.value = text;
        textarea.style.position = 'fixed';
        textarea.style.opacity = '0';
        document.body.appendChild(textarea);
        textarea.select();
        document.execCommand('copy');
        document.body.removeChild(textarea);

        button.textContent = 'Copied!';
        button.classList.add('copied');

        setTimeout(() => {
          button.textContent = 'Copy';
          button.classList.remove('copied');
        }, 2000);
      }
    }
  };

  // Sidebar toggle (mobile)
  const SidebarManager = {
    init() {
      const toggle = document.querySelector('.kb-sidebar-toggle');
      const sidebar = document.querySelector('.kb-sidebar');

      if (!toggle || !sidebar) return;

      toggle.addEventListener('click', () => {
        sidebar.classList.toggle('open');
      });

      // Close on link click (mobile)
      sidebar.querySelectorAll('a').forEach(link => {
        link.addEventListener('click', () => {
          if (window.innerWidth <= 768) {
            sidebar.classList.remove('open');
          }
        });
      });
    }
  };

  // Navigation section collapse
  const NavCollapseManager = {
    storageKey: 'kb-nav-collapsed',

    init() {
      const sections = document.querySelectorAll('.kb-nav-section');
      const stored = this.getStoredState();

      sections.forEach(section => {
        const header = section.querySelector('.kb-nav-section-header');
        const path = section.dataset.path;

        if (!header) return;

        // Restore collapsed state
        if (stored[path] === true) {
          section.classList.add('collapsed');
        } else if (stored[path] === false) {
          section.classList.remove('collapsed');
        }

        header.addEventListener('click', () => {
          section.classList.toggle('collapsed');
          this.saveState(path, section.classList.contains('collapsed'));
        });
      });
    },

    getStoredState() {
      try {
        const stored = localStorage.getItem(this.storageKey);
        return stored ? JSON.parse(stored) : {};
      } catch {
        return {};
      }
    },

    saveState(path, collapsed) {
      try {
        const state = this.getStoredState();
        state[path] = collapsed;
        localStorage.setItem(this.storageKey, JSON.stringify(state));
      } catch {
        // Ignore storage errors
      }
    }
  };

  // TOC active link tracking
  const TocManager = {
    init() {
      const tocContainer = document.querySelector('.toc-content');
      if (!tocContainer) return;

      const tocLinks = tocContainer.querySelectorAll('a');
      const headings = [];

      // Build array of headings that match TOC links
      tocLinks.forEach(link => {
        const href = link.getAttribute('href');
        if (href && href.startsWith('#')) {
          const id = href.slice(1);
          const heading = document.getElementById(id);
          if (heading) {
            headings.push({ id: id, element: heading, link: link });
          }
        }
      });

      if (headings.length === 0) return;

      // Track active heading
      let currentActive = null;

      function updateActiveLink(activeId) {
        if (currentActive === activeId) return;
        currentActive = activeId;

        tocLinks.forEach(link => {
          const href = link.getAttribute('href');
          const isActive = href === '#' + activeId;
          link.classList.toggle('toc-active', isActive);
        });
      }

      // Use Intersection Observer for efficient scroll tracking
      const observerOptions = {
        root: null,
        rootMargin: '-80px 0px -70% 0px',
        threshold: 0
      };

      const observer = new IntersectionObserver(entries => {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            updateActiveLink(entry.target.id);
          }
        });
      }, observerOptions);

      headings.forEach(h => {
        observer.observe(h.element);
      });

      // Also handle scroll to top - activate first heading
      window.addEventListener('scroll', () => {
        if (window.scrollY < 100 && headings.length > 0) {
          updateActiveLink(headings[0].id);
        }
      });

      // Initialize - activate first heading if at top
      if (window.scrollY < 100 && headings.length > 0) {
        updateActiveLink(headings[0].id);
      }
    }
  };

  // Syntax highlighting
  const HighlightManager = {
    init() {
      if (typeof hljs !== 'undefined') {
        document.querySelectorAll('.kb-prose pre code').forEach(block => {
          hljs.highlightElement(block);
        });
      }
    }
  };

  // Initialize all managers on DOMContentLoaded
  document.addEventListener('DOMContentLoaded', () => {
    ThemeManager.init();
    SearchManager.init();
    CodeCopyManager.init();
    SidebarManager.init();
    NavCollapseManager.init();
    TocManager.init();
    HighlightManager.init();
  });

  // Expose theme toggle globally
  window.kbToggleTheme = () => ThemeManager.toggle();
})();
''';
  }

  /// Generate theme initialization script (runs before body).
  String generateThemeInit() {
    return '''
(function() {
  const theme = localStorage.getItem('kb-theme-mode') || 'dark';
  document.documentElement.className = theme;
})();
''';
  }
}
