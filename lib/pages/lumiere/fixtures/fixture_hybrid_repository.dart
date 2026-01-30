import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'fixture_models.dart';
import 'fixture_repository.dart';

// Import uniquement Web (implémentation fetch)
// Sur mobile, ce fichier n’est pas utilisé.
import 'fixture_hybrid_repository_web.dart' if (dart.library.io) 'fixture_hybrid_repository_web_noop.dart';

class FixtureHybridRepository {
  static const _cacheKey = 'fixture_catalog_cache_v12';

  static const String _remoteUrl =
      'https://raw.githubusercontent.com/francoisvdm2000/mon-app-tech-data/main/fixtures.json';

  final FixtureRepository _localRepository = FixtureRepository();

  /// remote | cache | assets | remote_error
  String lastSource = 'unknown';
  String lastError = '';

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }

  Future<FixtureCatalog> loadInitialFast() async {
    lastError = '';

    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString(_cacheKey);
      if (cached != null && cached.trim().isNotEmpty) {
        final decoded = json.decode(cached);
        if (decoded is Map<String, dynamic>) {
          lastSource = 'cache';
          return FixtureCatalog.fromJson(decoded);
        }
      }
    } catch (_) {
      // ignore
    }

    lastSource = 'assets';
    return _localRepository.loadCatalog();
  }

  Future<FixtureCatalog?> refreshRemote() async {
    lastError = '';

    try {
      final body = kIsWeb ? await fetchTextWeb(_remoteUrl) : await _fetchTextIo(_remoteUrl);

      final decoded = json.decode(body);
      if (decoded is! Map<String, dynamic>) {
        lastSource = 'remote_error';
        lastError = 'JSON invalide';
        return null;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, body);

      lastSource = 'remote';
      lastError = '';
      return FixtureCatalog.fromJson(decoded);
    } catch (e) {
      lastSource = 'remote_error';
      lastError = e.toString();
      return null;
    }
  }

  Future<String> _fetchTextIo(String url) async {
    final res = await http.get(
      Uri.parse(url),
      headers: const {'Cache-Control': 'no-cache'},
    );
    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}');
    }
    return res.body;
  }
}
