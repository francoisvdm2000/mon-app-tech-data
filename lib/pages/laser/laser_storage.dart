import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LaserPreset {
  final String id;
  final String name;
  final double powerMilliwatt;
  final double divergenceMilliradian;
  final double outputDiameterMillimeter;
  final double? targetDistanceMeter;
  final DateTime createdAt;

  const LaserPreset({
    required this.id,
    required this.name,
    required this.powerMilliwatt,
    required this.divergenceMilliradian,
    required this.outputDiameterMillimeter,
    required this.createdAt,
    this.targetDistanceMeter,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'powerMilliwatt': powerMilliwatt,
        'divergenceMilliradian': divergenceMilliradian,
        'outputDiameterMillimeter': outputDiameterMillimeter,
        'targetDistanceMeter': targetDistanceMeter,
        'createdAt': createdAt.toIso8601String(),
      };

  static LaserPreset fromJson(Map<String, dynamic> json) {
    return LaserPreset(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      powerMilliwatt: (json['powerMilliwatt'] ?? 0).toDouble(),
      divergenceMilliradian: (json['divergenceMilliradian'] ?? 0).toDouble(),
      outputDiameterMillimeter: (json['outputDiameterMillimeter'] ?? 0).toDouble(),
      targetDistanceMeter: json['targetDistanceMeter'] == null ? null : (json['targetDistanceMeter']).toDouble(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? DateTime.now(),
    );
  }
}

class LaserStorage {
  static const String _key = 'laser_presets_v1';

  static Future<List<LaserPreset>> loadPresets() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.trim().isEmpty) return [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map((m) => LaserPreset.fromJson(Map<String, dynamic>.from(m)))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (_) {
      return [];
    }
  }

  static Future<void> savePreset(LaserPreset preset) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await loadPresets();

    // Remplace si même id
    final updated = [
      preset,
      ...list.where((p) => p.id != preset.id),
    ];

    await prefs.setString(_key, jsonEncode(updated.map((p) => p.toJson()).toList()));
  }

  static Future<void> deletePreset(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await loadPresets();
    final updated = list.where((p) => p.id != id).toList();
    await prefs.setString(_key, jsonEncode(updated.map((p) => p.toJson()).toList()));
  }

  static String makeId() => DateTime.now().microsecondsSinceEpoch.toString();
}
