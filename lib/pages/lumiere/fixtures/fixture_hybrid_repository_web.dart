import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Fetch Web robuste (sans dart:html) => 0 warning analyzer.
Future<String> fetchTextWeb(String url) async {
  final resp = await web.window.fetch(url.toJS).toDart;

  final status = resp.status;
  if (status != 200) {
    throw Exception('HTTP $status');
  }

  final text = await resp.text().toDart;
  final s = text.toDart;
  if (s.trim().isEmpty) {
    throw Exception('Réponse vide');
  }
  return s;
}
