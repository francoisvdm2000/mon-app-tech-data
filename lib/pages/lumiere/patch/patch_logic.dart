import 'patch_models.dart';

class PatchLogic {
  static const int maxAddress = 512;

  static bool isValidRange(int startAddress, int channelCount) {
    if (startAddress < 1) return false;
    if (channelCount < 1) return false;
    final end = startAddress + channelCount - 1;
    return end <= maxAddress;
  }

  static List<PatchIssue> validateBasics({
    required int universe,
    required int startAddress,
    required int channelCount,
  }) {
    final issues = <PatchIssue>[];

    if (universe < 1) {
      issues.add(const PatchIssue(
        PatchIssueCode.invalidUniverse,
        'L’univers doit être supérieur ou égal à 1.',
      ));
    }
    if (startAddress < 1 || startAddress > maxAddress) {
      issues.add(const PatchIssue(
        PatchIssueCode.invalidStartAddress,
        'L’adresse DMX doit être comprise entre 1 et 512.',
      ));
    }
    if (channelCount < 1) {
      issues.add(const PatchIssue(
        PatchIssueCode.invalidChannelCount,
        'Le nombre de canaux doit être supérieur ou égal à 1.',
      ));
    }

    if (issues.isEmpty) {
      final end = startAddress + channelCount - 1;
      if (end > maxAddress) {
        issues.add(const PatchIssue(
          PatchIssueCode.rangeExceedsUniverse,
          'La plage de canaux dépasse 512 dans cet univers.',
        ));
      }
    }

    return issues;
  }

  static bool overlaps(PatchEntry a, PatchEntry b) {
    if (a.universe != b.universe) return false;
    return !(a.endAddress < b.startAddress || a.startAddress > b.endAddress);
  }

  static List<PatchEntry> findOverlaps(
    List<PatchEntry> entries,
    PatchEntry incoming,
  ) {
    return entries.where((e) => overlaps(e, incoming)).toList();
  }

  static List<int> occupiedChannelsForUniverse(
    List<PatchEntry> entries,
    int universe,
  ) {
    final occupied = <int>{};
    for (final e in entries) {
      if (e.universe != universe) continue;
      final start = e.startAddress;
      final end = e.endAddress;
      for (int ch = start; ch <= end; ch++) {
        occupied.add(ch);
      }
    }
    final list = occupied.toList()..sort();
    return list;
  }

  static List<int> freeRangesStarts(
    List<PatchEntry> entries,
    int universe,
    int channelCount,
  ) {
    final occupied = List<bool>.filled(maxAddress + 1, false); // 0 ignoré
    for (final e in entries) {
      if (e.universe != universe) continue;
      for (int ch = e.startAddress; ch <= e.endAddress; ch++) {
        if (ch >= 1 && ch <= maxAddress) occupied[ch] = true;
      }
    }

    final starts = <int>[];
    for (int start = 1; start <= maxAddress; start++) {
      final end = start + channelCount - 1;
      if (end > maxAddress) break;

      bool ok = true;
      for (int ch = start; ch <= end; ch++) {
        if (occupied[ch]) {
          ok = false;
          break;
        }
      }
      if (ok) starts.add(start);
    }
    return starts;
  }

  /// DMX absolute -> (universe, address)
  static ({int universe, int address})? mapAbsoluteAddress(int absoluteAddress) {
    return DmxAddressMapping.fromAbsolute(absoluteAddress);
  }

  /// Parse "1.100" etc.
  static ({int universe, int address})? parseDmx(
    String raw, {
    int defaultUniverse = 1,
  }) {
    return DmxAddressParser.tryParse(raw, defaultUniverse: defaultUniverse);
  }
}
