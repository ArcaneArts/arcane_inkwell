/// Configuration for the knowledge base site.
class SiteConfig {
  /// The name of the site displayed in the header.
  final String name;

  /// A brief description of the site for meta tags.
  final String? description;

  /// Path to a logo image (optional).
  final String? logo;

  /// GitHub repository URL (optional, adds link in header).
  final String? githubUrl;

  /// Base URL for subdirectory hosting (e.g., '/docs').
  final String baseUrl;

  /// The content directory containing markdown files.
  final String contentDirectory;

  /// The route for the home page.
  final String homeRoute;

  /// Whether search functionality is enabled.
  final bool searchEnabled;

  /// Whether table of contents is enabled on pages.
  final bool tocEnabled;

  /// Whether to show the theme toggle button.
  final bool themeToggleEnabled;

  /// Default theme mode.
  final KBThemeMode defaultTheme;

  /// Primary accent color for the theme.
  final String? primaryColor;

  /// Custom footer text (optional).
  final String? footerText;

  /// Copyright text for the footer.
  final String? copyright;

  /// Navigation links for the header.
  final List<NavLink> headerLinks;

  /// Social links for the footer/header.
  final List<SocialLink> socialLinks;

  /// Optional sidebar footer text (always visible at bottom of sidebar).
  final String? sidebarFooter;

  /// Optional sidebar footer link URL.
  final String? sidebarFooterUrl;

  const SiteConfig({
    required this.name,
    this.description,
    this.logo,
    this.githubUrl,
    this.baseUrl = '',
    this.contentDirectory = 'content',
    this.homeRoute = '/',
    this.searchEnabled = true,
    this.tocEnabled = true,
    this.themeToggleEnabled = true,
    this.defaultTheme = KBThemeMode.dark,
    this.primaryColor,
    this.footerText,
    this.copyright,
    this.headerLinks = const [],
    this.socialLinks = const [],
    this.sidebarFooter,
    this.sidebarFooterUrl,
  });

  /// Get the full URL for a path, including the base URL.
  String fullPath(String path) {
    if (baseUrl.isEmpty) return path;
    if (path == '/') return baseUrl;
    return '$baseUrl$path';
  }

  /// Get the asset prefix for static assets.
  String get assetPrefix => baseUrl.isEmpty ? '' : baseUrl;
}

/// Theme mode options for the knowledge base.
enum KBThemeMode {
  dark,
  light,
  system,
}

/// A navigation link for the header.
class NavLink {
  final String label;
  final String href;
  final bool external;

  const NavLink({
    required this.label,
    required this.href,
    this.external = false,
  });
}

/// A social media link.
class SocialLink {
  final String name;
  final String url;
  final String icon;

  const SocialLink({
    required this.name,
    required this.url,
    required this.icon,
  });

  /// Common social link presets.
  static SocialLink github(String url) =>
      SocialLink(name: 'GitHub', url: url, icon: 'github');

  static SocialLink twitter(String url) =>
      SocialLink(name: 'Twitter', url: url, icon: 'twitter');

  static SocialLink discord(String url) =>
      SocialLink(name: 'Discord', url: url, icon: 'message-circle');

  static SocialLink youtube(String url) =>
      SocialLink(name: 'YouTube', url: url, icon: 'youtube');
}
