import 'package:flutter/foundation.dart';

@immutable
class PatchEntry {
  final String id;

  /// Nom lisible (issu du catalogue ou du MVR)
  final String fixtureName;

  /// Libellé explicite (ex: "Mode 26 canaux")
  final String dmxModeName;

  /// Nombre de canaux occupés (>=1)
  final int channelCount;

  /// Univers DMX (>=1)
  final int universe;

  /// Adresse DMX de départ (1..512)
  final int startAddress;

  const PatchEntry({
    required this.id,
    required this.fixtureName,
    required this.dmxModeName,
    required this.channelCount,
    required this.universe,
    required this.startAddress,
  });

  int get endAddress => startAddress + channelCount - 1;

  bool get isValidBasics =>
      universe >= 1 &&
      startAddress >= 1 &&
      startAddress <= 512 &&
      channelCount >= 1 &&
      endAddress <= 512;

  PatchEntry copyWith({
    String? id,
    String? fixtureName,
    String? dmxModeName,
    int? channelCount,
    int? universe,
    int? startAddress,
  }) {
    return PatchEntry(
      id: id ?? this.id,
      fixtureName: fixtureName ?? this.fixtureName,
      dmxModeName: dmxModeName ?? this.dmxModeName,
      channelCount: channelCount ?? this.channelCount,
      universe: universe ?? this.universe,
      startAddress: startAddress ?? this.startAddress,
    );
  }
}

enum PatchConflictType { overlap }

@immutable
class PatchConflict {
  final PatchEntry a;
  final PatchEntry b;
  final PatchConflictType type;

  const PatchConflict(
    this.a,
    this.b, {
    this.type = PatchConflictType.overlap,
  });

  /// Compat ancienne API (certaines pages appellent conflict.existing)
  PatchEntry get existing => b;

  String get message =>
      'Conflit univers ${a.universe} : '
      '${a.startAddress}–${a.endAddress} chevauche '
      '${b.startAddress}–${b.endAddress}';
}

enum PatchIssueCode {
  invalidUniverse,
  invalidStartAddress,
  invalidChannelCount,
  rangeExceedsUniverse,
}

@immutable
class PatchIssue {
  final PatchIssueCode code;
  final String message;

  const PatchIssue(this.code, this.message);
}

@immutable
class PatchValidationResult {
  final List<PatchIssue> issues;
  final List<PatchConflict> conflicts;

  const PatchValidationResult({
    required this.issues,
    required this.conflicts,
  });

  bool get isValid => issues.isEmpty && conflicts.isEmpty;
}

/// Parsing et mapping DMX utilisés par l'import MVR + UI.
class DmxAddressParser {
  static const int _maxAddress = 512;

  /// Parse des formats courants :
  /// - "1.100"
  /// - "1/100"
  /// - "U1 A100"
  /// - "Universe 1 Address 100"
  /// - "100" => address dans l'univers par défaut (1)
  static ({int universe, int address})? tryParse(
    String raw, {
    int defaultUniverse = 1,
  }) {
    final s = raw.trim();
    if (s.isEmpty) return null;

    // Format simple "u.a" ou "u/a"
    final dot = RegExp(r'^\s*(\d+)\s*[./]\s*(\d+)\s*$');
    final mDot = dot.firstMatch(s);
    if (mDot != null) {
      final u = int.tryParse(mDot.group(1) ?? '');
      final a = int.tryParse(mDot.group(2) ?? '');
      if (_isValid(u, a)) return (universe: u!, address: a!);
      return null;
    }

   // Format texte "U1 A100" / "Universe 1 Address 100"
final words = RegExp(
  r'\bU(?:niverse)?\s*(\d+)\b.*\bA(?:ddress)?\s*(\d+)\b',
  caseSensitive: false,
);
final mWords = words.firstMatch(s);
if (mWords != null) {
  final u = int.tryParse(mWords.group(1) ?? '');
  final a = int.tryParse(mWords.group(2) ?? '');
  if (_isValid(u, a)) return (universe: u!, address: a!);
  return null;
}


    // Fallback : nombre seul = address
    final onlyNumber = int.tryParse(s);
    if (onlyNumber != null) {
      final u = defaultUniverse;
      final a = onlyNumber;
      if (_isValid(u, a)) return (universe: u, address: a);
    }

    return null;
  }

  static bool _isValid(int? universe, int? address) {
    if (universe == null || address == null) return false;
    if (universe < 1) return false;
    if (address < 1 || address > _maxAddress) return false;
    return true;
  }
}

class DmxAddressMapping {
  static const int channelsPerUniverse = 512;

  /// Convertit une "absolute address" (1..∞) en (universe, address).
  /// Convention : 1..512 => universe 1, 513..1024 => universe 2, etc.
  static ({int universe, int address})? fromAbsolute(int absoluteAddress) {
    if (absoluteAddress < 1) return null;
    final zeroBased = absoluteAddress - 1;
    final universe = (zeroBased ~/ channelsPerUniverse) + 1;
    final address = (zeroBased % channelsPerUniverse) + 1;
    return (universe: universe, address: address);
  }

  /// Convertit (universe, address) en absolute address.
  static int toAbsolute({required int universe, required int address}) {
    return ((universe - 1) * channelsPerUniverse) + address;
  }
}
