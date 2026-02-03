// lib/pages/about/about_route_args.dart
import 'package:flutter/foundation.dart';

/// Arguments de route pour ouvrir une page About directement sur un "anchor".
///
/// On garde volontairement `Object` pour être compatible avec tes enums différents :
/// - DmxAnchor
/// - ArtNetAnchor
/// - SacnAnchor
/// etc.
///
/// Chaque page cast ensuite vers SON enum local.
@immutable
class AboutRouteArgs {
  const AboutRouteArgs({
    required this.anchor,
  });

  /// Anchor à atteindre (souvent un enum de la page cible)
  final Object anchor;
}
