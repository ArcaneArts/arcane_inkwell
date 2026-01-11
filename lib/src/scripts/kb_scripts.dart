/// Generates JavaScript for knowledge base interactivity.
class KBScripts {
  final String basePath;

  const KBScripts({this.basePath = ''});

  /// Generate all JavaScript for the knowledge base.
  String generate() {
    return '''
(function() {
  'use strict';

  // Theme utilities (theme toggling is handled by Dart component via setState)
  const ThemeManager = {
    storageKey: 'arcane-theme-mode',

    init() {
      // Theme is now handled by the stateful component
      // This just handles localStorage persistence when the class changes
      const root = document.getElementById('arcane-root');
      if (!root) return;

      // Save current theme to localStorage when it changes
      const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
          if (mutation.attributeName === 'class') {
            const isDark = root.classList.contains('dark');
            localStorage.setItem(this.storageKey, isDark ? 'dark' : 'light');
          }
        });
      });

      observer.observe(root, { attributes: true });
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
        const excerpt = item.dataset.excerpt || '';
        const description = item.dataset.description || '';

        if (title && path) {
          this.index.push({
            title,
            path,
            section: sectionTitle || '',
            excerpt,
            description,
            searchText: (title + ' ' + sectionTitle + ' ' + excerpt + ' ' + description).toLowerCase()
          });
        }
      });
    },

    search(query) {
      if (!query || query.length < this.minQueryLength) return [];

      const q = query.toLowerCase();
      const words = q.split(/\\s+/).filter(w => w.length > 1);

      const results = this.index.filter(item => {
        // Match if any word is found
        return words.some(word => item.searchText.includes(word));
      }).map(item => {
        // Calculate relevance score
        let score = 0;
        const titleLower = item.title.toLowerCase();

        words.forEach(word => {
          if (titleLower.includes(word)) score += 10;
          if (titleLower.startsWith(word)) score += 5;
          if (item.description && item.description.toLowerCase().includes(word)) score += 3;
          if (item.excerpt && item.excerpt.toLowerCase().includes(word)) score += 1;
        });

        return { ...item, score };
      });

      // Sort by relevance score
      results.sort((a, b) => b.score - a.score);

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

  // Back to top button
  const BackToTopManager = {
    threshold: 300,

    init() {
      const button = document.querySelector('.kb-back-to-top');
      if (!button) return;

      // Show/hide based on scroll position
      window.addEventListener('scroll', () => {
        if (window.scrollY > this.threshold) {
          button.classList.add('visible');
        } else {
          button.classList.remove('visible');
        }
      });

      // Scroll to top on click
      button.addEventListener('click', () => {
        window.scrollTo({
          top: 0,
          behavior: 'smooth'
        });
      });
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
    BackToTopManager.init();
  });

})();
''';
  }

  /// Generate theme initialization script (runs before body).
  String generateThemeInit() {
    return '''
(function() {
  // Theme preference is loaded from localStorage but applied via Dart component
  window.arcaneThemeMode = localStorage.getItem('arcane-theme-mode') || 'dark';
})();
''';
  }
}
