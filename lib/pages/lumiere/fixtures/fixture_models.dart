import 'dart:convert';

class FixtureCatalog {
  final int version;
  final DateTime updatedAt;
  final List<Manufacturer> manufacturers;

  const FixtureCatalog({
    required this.version,
    required this.updatedAt,
    required this.manufacturers,
  });

  factory FixtureCatalog.fromJson(Map<String, dynamic> json) {
    final version = _asInt(json['version'], fallback: 1);

    final updatedRaw = json['updatedAt'];
    final updatedAt = _asDateTime(updatedRaw) ?? DateTime.now();

    final manufacturersJson = json['manufacturers'];
    final manufacturers = <Manufacturer>[];
    if (manufacturersJson is List) {
      for (final m in manufacturersJson) {
        if (m is Map<String, dynamic>) {
          manufacturers.add(Manufacturer.fromJson(m));
        }
      }
    }

    return FixtureCatalog(
      version: version,
      updatedAt: updatedAt,
      manufacturers: manufacturers,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'version': version,
        'updatedAt': updatedAt.toIso8601String(),
        'manufacturers': manufacturers.map((m) => m.toJson()).toList(),
      };

  @override
  String toString() => jsonEncode(toJson());
}

class Manufacturer {
  final String name;
  final List<Product> products;

  const Manufacturer({
    required this.name,
    required this.products,
  });

  factory Manufacturer.fromJson(Map<String, dynamic> json) {
    final name = (json['name'] ?? '').toString();

    final productsJson = json['products'];
    final products = <Product>[];
    if (productsJson is List) {
      for (final p in productsJson) {
        if (p is Map<String, dynamic>) {
          products.add(Product.fromJson(p));
        }
      }
    }

    return Manufacturer(
      name: name,
      products: products,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'products': products.map((p) => p.toJson()).toList(),
      };
}

class Product {
  final String type;
  final String name;

  /// Si modes non vide, on utilise mode.dmxChannels.
  final List<DmxMode> modes;

  /// Optionnel : certains produits peuvent avoir une valeur unique.
  final int? dmxChannels;

  /// IMPORTANT: double? (et pas "as double")
  final double? weightKilogram;

  final int? powerWatt;
  final int? luminousFluxLumen;

  final String? manualUrl;
  final String? dmxChartUrl;

  const Product({
    required this.type,
    required this.name,
    required this.modes,
    required this.dmxChannels,
    required this.weightKilogram,
    required this.powerWatt,
    required this.luminousFluxLumen,
    required this.manualUrl,
    required this.dmxChartUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final type = (json['type'] ?? '').toString();
    final name = (json['name'] ?? '').toString();

    final modesJson = json['modes'];
    final modes = <DmxMode>[];
    if (modesJson is List) {
      for (final m in modesJson) {
        if (m is Map<String, dynamic>) {
          modes.add(DmxMode.fromJson(m));
        }
      }
    }

    return Product(
      type: type,
      name: name,
      modes: modes,
      dmxChannels: _asIntNullable(json['dmxChannels']),
      weightKilogram: _asDoubleNullable(json['weightKilogram']),
      powerWatt: _asIntNullable(json['powerWatt']),
      luminousFluxLumen: _asIntNullable(json['luminousFluxLumen']),
      manualUrl: _asStringNullable(json['manualUrl']),
      dmxChartUrl: _asStringNullable(json['dmxChartUrl']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': type,
        'name': name,
        'modes': modes.map((m) => m.toJson()).toList(),
        if (dmxChannels != null) 'dmxChannels': dmxChannels,
        if (weightKilogram != null) 'weightKilogram': weightKilogram,
        if (powerWatt != null) 'powerWatt': powerWatt,
        if (luminousFluxLumen != null) 'luminousFluxLumen': luminousFluxLumen,
        if (manualUrl != null) 'manualUrl': manualUrl,
        if (dmxChartUrl != null) 'dmxChartUrl': dmxChartUrl,
      };

  String displayInt(int? value, String unit) {
    if (value == null || value <= 0) return 'Non renseigné';
    return '$value $unit';
  }

  String displayDouble(double? value, String unit) {
    if (value == null || value <= 0) return 'Non renseigné';
    // Affichage propre: 1 décimale si besoin
    final s = (value % 1 == 0) ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
    return '$s $unit';
  }
}

class DmxMode {
  final String name;
  final int dmxChannels;

  const DmxMode({
    required this.name,
    required this.dmxChannels,
  });

  factory DmxMode.fromJson(Map<String, dynamic> json) {
    return DmxMode(
      name: (json['name'] ?? '').toString(),
      dmxChannels: _asInt(json['dmxChannels'], fallback: 1),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'dmxChannels': dmxChannels,
      };
}

/// --------------------
/// Helpers robustes
/// --------------------

String? _asStringNullable(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty ? null : s;
}

int _asInt(dynamic v, {required int fallback}) {
  if (v == null) return fallback;
  if (v is int) return v;
  if (v is num) return v.toInt();
  final s = v.toString().trim();
  final parsed = int.tryParse(s);
  if (parsed != null) return parsed;
  final parsedNum = num.tryParse(s.replaceAll(',', '.'));
  return parsedNum?.toInt() ?? fallback;
}

int? _asIntNullable(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  final s = v.toString().trim();
  if (s.isEmpty) return null;
  final parsed = int.tryParse(s);
  if (parsed != null) return parsed;
  final parsedNum = num.tryParse(s.replaceAll(',', '.'));
  return parsedNum?.toInt();
}

double? _asDoubleNullable(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is num) return v.toDouble();
  final s = v.toString().trim();
  if (s.isEmpty) return null;
  final parsedNum = num.tryParse(s.replaceAll(',', '.'));
  return parsedNum?.toDouble();
}

DateTime? _asDateTime(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  final s = v.toString().trim();
  if (s.isEmpty) return null;
  return DateTime.tryParse(s);
}
