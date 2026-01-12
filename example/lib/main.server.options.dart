// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:arcane_jaspr/component/collection/card_carousel.dart'
    as _card_carousel;
import 'package:arcane_jaspr/component/collection/infinite_carousel.dart'
    as _infinite_carousel;
import 'package:arcane_jaspr/component/feedback/loader.dart' as _loader;
import 'package:arcane_jaspr/component/form/field.dart' as _field;
import 'package:arcane_jaspr/component/input/formatted_input.dart'
    as _formatted_input;
import 'package:arcane_jaspr/component/input/mutable_text.dart'
    as _mutable_text;
import 'package:arcane_jaspr/component/interactive/back_to_top.dart'
    as _back_to_top;
import 'package:arcane_jaspr/component/layout/dashboard_layout.dart'
    as _dashboard_layout;
import 'package:arcane_jaspr/component/layout/logo_carousel.dart'
    as _logo_carousel;
import 'package:arcane_jaspr/component/screen/chat_screen.dart' as _chat_screen;
import 'package:arcane_jaspr/component/screen/navigation_screen.dart'
    as _navigation_screen;
import 'package:arcane_jaspr/component/screen/screen.dart' as _screen;
import 'package:arcane_jaspr/component/view/avatar.dart' as _avatar;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',

  styles: () => [
    ..._card_carousel.ArcaneCardCarousel.styles,
    ..._card_carousel.ArcaneHeroCarousel.styles,
    ..._card_carousel.ArcaneNavigableCarousel.styles,
    ..._infinite_carousel.ArcaneInfiniteCarousel.styles,
    ..._loader.ArcaneDotsLoader.styles,
    ..._loader.ArcaneLoader.styles,
    ..._loader.ArcanePulseLoader.styles,
    ..._field.ArcaneFieldStyles.styles,
    ..._formatted_input.ArcaneFormattedInput.styles,
    ..._mutable_text.ArcaneMutableText.styles,
    ..._back_to_top.ArcaneBackToTop.styles,
    ..._back_to_top.ArcaneFloatingActionButton.styles,
    ..._dashboard_layout.ArcaneDashboardUserMenu.styles,
    ..._logo_carousel.ArcaneLogoCarousel.styles,
    ..._logo_carousel.ArcaneLogoGrid.styles,
    ..._chat_screen.ArcaneChatScreen.styles,
    ..._navigation_screen.ArcaneResponsiveScaffold.styles,
    ..._screen.ArcaneScreen.styles,
    ..._avatar.ArcaneAvatarBadge.styles,
  ],
);
