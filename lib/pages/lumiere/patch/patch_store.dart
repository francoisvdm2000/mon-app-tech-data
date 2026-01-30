import 'package:flutter/foundation.dart';
import 'patch_models.dart';

final PatchStore patchStore = PatchStore._();

class PatchStore extends ChangeNotifier {
  PatchStore._();

  final List<PatchEntry> _entries = <PatchEntry>[];

  bool _isReadOnly = false;

  bool get isReadOnly => _isReadOnly;

  /// Charge une référence de patch (snapshot) — typiquement depuis un MVR.
  /// En lecture seule : aucune modification possible par l’utilisateur.
  void loadReference(List<PatchEntry> entries) {
    _entries
      ..clear()
      ..addAll(entries);
    _isReadOnly = true;
    notifyListeners();
  }

  /// Efface la référence chargée (revient à un patch vide).
  void clearReference() {
    _entries.clear();
    _isReadOnly = false;
    notifyListeners();
  }

  // ===================== COMPAT (ancienne API) =====================

  int _activeUniverse = 1;

  int get activeUniverse => _activeUniverse;

  set activeUniverse(int v) {
    final next = v < 1 ? 1 : v;
    if (next == _activeUniverse) return;
    _activeUniverse = next;
    notifyListeners();
  }

  Set<int> occupiedChannelsForActiveUniverse() =>
      occupiedChannelsForUniverse(_activeUniverse);

  List<int> occupiedChannelsListForActiveUniverse() {
    final list = occupiedChannelsForActiveUniverse().toList()..sort();
    return list;
  }

  List<int> occupiedChannelsListForUniverse(int universe) {
    final list = occupiedChannelsForUniverse(universe).toList()..sort();
    return list;
  }

  int occupiedCountForActiveUniverse() =>
      occupiedCountForUniverse(_activeUniverse);

  List<PatchEntry> entriesForActiveUniverse() =>
      entriesForUniverse(_activeUniverse);

  List<PatchConflict> conflictsForActiveUniverse() =>
      conflictsInUniverse(_activeUniverse);

  void clearAll() => clear();

  // ===================== API actuelle =====================

  List<PatchEntry> get entries => List.unmodifiable(_entries);

  List<int> get universesInUse {
    final set = <int>{};
    for (final e in _entries) {
      set.add(e.universe);
    }
    final list = set.toList()..sort();
    return list;
  }

  List<PatchEntry> entriesForUniverse(int universe) {
    final list = _entries.where((e) => e.universe == universe).toList();
    list.sort((a, b) => a.startAddress.compareTo(b.startAddress));
    return list;
  }

  /// Entrées qui occupent un canal donné (utile pour popup dans la grille).
  List<PatchEntry> entriesOccupyingChannel(int universe, int address) {
    if (universe < 1) return const [];
    if (address < 1 || address > 512) return const [];
    final list = <PatchEntry>[];
    for (final e in _entries) {
      if (e.universe != universe) continue;
      if (address >= e.startAddress && address <= e.endAddress) {
        list.add(e);
      }
    }
    list.sort((a, b) => a.startAddress.compareTo(b.startAddress));
    return list;
  }

  /// Canaux en conflit dans un univers (plus d'une entrée occupe le même canal).
  Set<int> conflictChannelsForUniverse(int universe) {
    final map = <int, int>{}; // address -> count
    for (final e in _entries) {
      if (e.universe != universe) continue;
      for (int ch = e.startAddress; ch <= e.endAddress; ch++) {
        map[ch] = (map[ch] ?? 0) + 1;
      }
    }

    final conflicts = <int>{};
    map.forEach((addr, count) {
      if (count > 1) conflicts.add(addr);
    });
    return conflicts;
  }

  /// Entrée principale (la première) qui occupe un canal donné.
  PatchEntry? firstEntryOccupyingChannel(int universe, int address) {
    final list = entriesOccupyingChannel(universe, address);
    return list.isEmpty ? null : list.first;
  }

  // ---------- Validation (utile pour conflits affichés) ----------

  PatchValidationResult validateCandidate(
    PatchEntry entry, {
    String? ignoreId,
  }) {
    final issues = <PatchIssue>[];

    if (entry.universe < 1) {
      issues.add(const PatchIssue(
        PatchIssueCode.invalidUniverse,
        'L’univers doit être supérieur ou égal à 1.',
      ));
    }

    if (entry.startAddress < 1 || entry.startAddress > 512) {
      issues.add(const PatchIssue(
        PatchIssueCode.invalidStartAddress,
        'L’adresse DMX doit être comprise entre 1 et 512.',
      ));
    }

    if (entry.channelCount < 1) {
      issues.add(const PatchIssue(
        PatchIssueCode.invalidChannelCount,
        'Le nombre de canaux doit être supérieur ou égal à 1.',
      ));
    }

    if (entry.channelCount >= 1 &&
        entry.startAddress >= 1 &&
        entry.startAddress <= 512) {
      if (entry.endAddress > 512) {
        issues.add(const PatchIssue(
          PatchIssueCode.rangeExceedsUniverse,
          'La plage de canaux dépasse 512 dans cet univers.',
        ));
      }
    }

    final conflicts = <PatchConflict>[];
    if (issues.isEmpty) {
      conflicts.addAll(conflictsFor(entry, ignoreId: ignoreId));
    }

    return PatchValidationResult(issues: issues, conflicts: conflicts);
  }

  // ---------- Mutations BLOQUÉES en lecture seule ----------

  PatchEntry? tryAdd(PatchEntry entry) {
    if (_isReadOnly) return null;
    if (!entry.isValidBasics) return null;
    if (conflictsFor(entry).isNotEmpty) return null;
    _entries.add(entry);
    notifyListeners();
    return entry;
  }

  bool removeById(String id) {
    if (_isReadOnly) return false;
    final before = _entries.length;
    _entries.removeWhere((e) => e.id == id);
    final changed = _entries.length != before;
    if (changed) notifyListeners();
    return changed;
  }

  PatchEntry? updateById(String id, PatchEntry updated) {
    if (_isReadOnly) return null;
    final idx = _entries.indexWhere((e) => e.id == id);
    if (idx < 0) return null;

    if (!updated.isValidBasics) return null;

    final conflicts = conflictsFor(updated, ignoreId: id);
    if (conflicts.isNotEmpty) return null;

    _entries[idx] = updated;
    notifyListeners();
    return updated;
  }

  void clear() {
    if (_isReadOnly) return;
    _entries.clear();
    notifyListeners();
  }

  // ---------- Conflits et occupation (lecture) ----------

  List<PatchConflict> conflictsFor(PatchEntry entry, {String? ignoreId}) {
    final conflicts = <PatchConflict>[];
    for (final other in _entries) {
      if (ignoreId != null && other.id == ignoreId) continue;
      if (other.universe != entry.universe) continue;

      final overlap = !(entry.endAddress < other.startAddress ||
          entry.startAddress > other.endAddress);
      if (overlap) {
        conflicts.add(PatchConflict(entry, other));
      }
    }
    return conflicts;
  }

  Set<int> occupiedChannelsForUniverse(int universe) {
    final occupied = <int>{};
    for (final e in _entries) {
      if (e.universe != universe) continue;
      for (int ch = e.startAddress; ch <= e.endAddress; ch++) {
        occupied.add(ch);
      }
    }
    return occupied;
  }

  int occupiedCountForUniverse(int universe) =>
      occupiedChannelsForUniverse(universe).length;

  List<PatchConflict> conflictsInUniverse(int universe) {
    final list = entriesForUniverse(universe);
    final conflicts = <PatchConflict>[];

    for (int i = 0; i < list.length; i++) {
      for (int j = i + 1; j < list.length; j++) {
        final a = list[i];
        final b = list[j];
        final overlap =
            !(a.endAddress < b.startAddress || a.startAddress > b.endAddress);
        if (overlap) conflicts.add(PatchConflict(a, b));
      }
    }

    return conflicts;
  }
}
