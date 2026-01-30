// lib/pages/lumiere/fixtures/fixture_repository.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'fixture_models.dart';

class FixtureRepository {
  static const _assetPath = 'assets/lumiere/fixtures.json';

  Future<FixtureCatalog> loadCatalog() async {
    final jsonString = await rootBundle.loadString(_assetPath);
    final data = json.decode(jsonString) as Map<String, dynamic>;
    return FixtureCatalog.fromJson(data);
  }
}
