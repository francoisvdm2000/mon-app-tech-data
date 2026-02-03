// lib/pages/about/about_router.dart
import 'package:flutter/material.dart';

import 'about_registry.dart';
import 'about_route_args.dart';

/// Ouvre une page About en donnant pageId + anchorId.
///
/// IMPORTANT :
/// - On ne dépend PAS de paramètres de constructeurs (initialAnchorId, etc.)
/// - On passe l'ancre via RouteSettings.arguments => chaque page peut la lire.
class AboutRouter {
  static Widget buildPage(String pageId, {String? anchorId}) {
    // On construit la page via le registry (mapping central).
    final pageBuilder = AboutRegistry.pageBuilderFor(pageId);
    return pageBuilder();
  }

  static Future<void> open(BuildContext context, String pageId, {String? anchorId}) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => buildPage(pageId, anchorId: anchorId),
        settings: RouteSettings(
          // ✅ On passe l’anchor ici (les pages le lisent via ModalRoute.settings.arguments)
          arguments: AboutRouteArgs(anchor: anchorId ?? ''),
        ),
      ),
    );
  }
}
