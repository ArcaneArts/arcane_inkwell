import 'package:arcane_jaspr/arcane_jaspr.dart';

/// Callback type for handling rating submissions.
///
/// Parameters:
/// - [pagePath]: The URL path of the rated page
/// - [isHelpful]: true for thumbs up, false for thumbs down
///
/// Return a Future that completes when the rating is saved.
typedef RatingCallback = Future<void> Function(String pagePath, bool isHelpful);

/// Configuration for the rating system.
///
/// Example Firebase implementation:
/// ```dart
/// final ratingConfig = RatingConfig(
///   enabled: true,
///   onRate: (pagePath, isHelpful) async {
///     // Convert page path to a valid Firebase document ID
///     final docId = pagePath.replaceAll('/', '_');
///
///     // Increment the appropriate counter
///     final field = isHelpful ? 'helpful' : 'notHelpful';
///     await FirebaseFirestore.instance
///       .collection('pageRatings')
///       .doc(docId)
///       .set({
///         field: FieldValue.increment(1),
///         'lastUpdated': FieldValue.serverTimestamp(),
///       }, SetOptions(merge: true));
///   },
///   // Optional: Load existing counts
///   onLoadCounts: (pagePath) async {
///     final docId = pagePath.replaceAll('/', '_');
///     final doc = await FirebaseFirestore.instance
///       .collection('pageRatings')
///       .doc(docId)
///       .get();
///     if (doc.exists) {
///       return RatingCounts(
///         helpful: doc.data()?['helpful'] ?? 0,
///         notHelpful: doc.data()?['notHelpful'] ?? 0,
///       );
///     }
///     return null;
///   },
/// );
/// ```
class RatingConfig {
  /// Whether the rating system is enabled.
  final bool enabled;

  /// Callback invoked when user submits a rating.
  final RatingCallback? onRate;

  /// Optional callback to load existing rating counts for a page.
  final Future<RatingCounts?> Function(String pagePath)? onLoadCounts;

  /// Text shown above the rating buttons.
  final String promptText;

  /// Text shown for the helpful button.
  final String helpfulText;

  /// Text shown for the not helpful button.
  final String notHelpfulText;

  /// Text shown after user submits a rating.
  final String thankYouText;

  const RatingConfig({
    this.enabled = true,
    this.onRate,
    this.onLoadCounts,
    this.promptText = 'Was this page helpful?',
    this.helpfulText = 'Yes',
    this.notHelpfulText = 'No',
    this.thankYouText = 'Thanks for your feedback!',
  });
}

/// Holds the count of helpful and not helpful ratings.
class RatingCounts {
  final int helpful;
  final int notHelpful;

  const RatingCounts({
    required this.helpful,
    required this.notHelpful,
  });
}

/// Page rating component with thumbs up/down buttons.
///
/// This component provides a wireframe for collecting page feedback.
/// Integrate with Firebase or any backend by providing a [RatingConfig]
/// with the appropriate callbacks.
///
/// ## Usage
///
/// Add the rating component to your page layout:
///
/// ```dart
/// KBRating(
///   pagePath: '/guide/installation',
///   config: RatingConfig(
///     onRate: (path, isHelpful) async {
///       // Save to Firebase/backend
///     },
///   ),
/// )
/// ```
///
/// ## Firebase Firestore Schema
///
/// Recommended collection structure:
///
/// ```
/// pageRatings/
///   _guide_installation/
///     helpful: 42
///     notHelpful: 3
///     lastUpdated: Timestamp
///   _features_code-blocks/
///     helpful: 15
///     notHelpful: 1
///     lastUpdated: Timestamp
/// ```
///
/// ## Client-Side JavaScript Integration
///
/// For static sites, you can implement rating via JavaScript:
///
/// ```javascript
/// // In your custom scripts
/// async function submitRating(pagePath, isHelpful) {
///   const docId = pagePath.replace(/\//g, '_');
///   const field = isHelpful ? 'helpful' : 'notHelpful';
///
///   await firebase.firestore()
///     .collection('pageRatings')
///     .doc(docId)
///     .set({
///       [field]: firebase.firestore.FieldValue.increment(1),
///       lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
///     }, { merge: true });
/// }
///
/// // Attach to rating buttons
/// document.querySelectorAll('.kb-rating-btn').forEach(btn => {
///   btn.addEventListener('click', async () => {
///     const isHelpful = btn.dataset.helpful === 'true';
///     const pagePath = btn.dataset.path;
///     await submitRating(pagePath, isHelpful);
///     // Show thank you message
///     btn.closest('.kb-rating').classList.add('kb-rating-submitted');
///   });
/// });
/// ```
class KBRating extends StatelessComponent {
  /// The URL path of the current page.
  final String pagePath;

  /// Rating system configuration.
  final RatingConfig config;

  /// Optional pre-loaded rating counts.
  final RatingCounts? counts;

  const KBRating({
    required this.pagePath,
    this.config = const RatingConfig(),
    this.counts,
  });

  @override
  Component build(BuildContext context) {
    if (!config.enabled) {
      return const ArcaneDiv(children: []);
    }

    return div(
      classes: 'kb-rating',
      id: 'kb-rating',
      attributes: <String, String>{
        'data-path': pagePath,
      },
      styles: const Styles(raw: {
        'margin-top': '2rem',
        'padding': '1rem',
        'border-top': '1px solid hsl(var(--border))',
      }),
      [
        // Rating prompt section (shown before voting)
        ArcaneDiv(
          classes: 'kb-rating-prompt',
          styles: const ArcaneStyleData(
            display: Display.flex,
            flexDirection: FlexDirection.column,
            crossAxisAlignment: CrossAxisAlignment.center,
            gap: Gap.md,
          ),
          children: [
            // Prompt text
            ArcaneDiv(
              styles: const ArcaneStyleData(
                fontSize: FontSize.sm,
                textColor: TextColor.mutedForeground,
                fontWeight: FontWeight.w500,
              ),
              children: [ArcaneText(config.promptText)],
            ),

            // Rating buttons
            ArcaneDiv(
              styles: const ArcaneStyleData(
                display: Display.flex,
                gap: Gap.md,
              ),
              children: [
                // Thumbs up button
                _buildRatingButton(
                  isHelpful: true,
                  label: config.helpfulText,
                  icon: ArcaneIcon.thumbsUp(size: IconSize.sm),
                  count: counts?.helpful,
                ),

                // Thumbs down button
                _buildRatingButton(
                  isHelpful: false,
                  label: config.notHelpfulText,
                  icon: ArcaneIcon.thumbsDown(size: IconSize.sm),
                  count: counts?.notHelpful,
                ),
              ],
            ),
          ],
        ),

        // Thank you message (shown after voting, initially hidden)
        ArcaneDiv(
          classes: 'kb-rating-thanks',
          styles: const ArcaneStyleData(
            display: Display.none,
            textAlign: TextAlign.center,
            fontSize: FontSize.sm,
            textColor: TextColor.mutedForeground,
          ),
          children: [
            ArcaneDiv(
              styles: const ArcaneStyleData(
                display: Display.flex,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                gap: Gap.sm,
              ),
              children: [
                ArcaneIcon.check(size: IconSize.sm),
                ArcaneText(config.thankYouText),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Component _buildRatingButton({
    required bool isHelpful,
    required String label,
    required Component icon,
    int? count,
  }) {
    return button(
      classes: 'kb-rating-btn',
      attributes: <String, String>{
        'type': 'button',
        'data-helpful': isHelpful.toString(),
        'data-path': pagePath,
        'aria-label': label,
      },
      styles: const Styles(raw: {
        'display': 'inline-flex',
        'align-items': 'center',
        'gap': '0.5rem',
        'padding': '0.5rem 1rem',
        'border': '1px solid hsl(var(--border))',
        'border-radius': '0.375rem',
        'background': 'hsl(var(--background))',
        'color': 'hsl(var(--muted-foreground))',
        'font-size': '0.875rem',
        'cursor': 'pointer',
        'transition': 'all 0.2s',
      }),
      [
        icon,
        Component.text(label),
        if (count != null)
          span(
            classes: 'kb-rating-count',
            styles: const Styles(raw: {
              'font-size': '0.75rem',
              'color': 'hsl(var(--muted-foreground))',
              'margin-left': '0.25rem',
            }),
            [Component.text('($count)')],
          ),
      ],
    );
  }
}
