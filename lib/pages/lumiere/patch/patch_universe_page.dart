import 'package:flutter/material.dart';

import '../../../app/ui/widgets.dart';
import 'patch_models.dart';
import 'patch_store.dart';

class PatchUniversePage extends StatefulWidget {
  const PatchUniversePage({super.key});

  @override
  State<PatchUniversePage> createState() => _PatchUniversePageState();
}

class _PatchUniversePageState extends State<PatchUniversePage> {
  int _selectedUniverse = 1;

  // Taille souhaitée des cases (la taille réelle sera limitée par l’écran)
  double _tileWanted = 26;

  // Espacement constant
  static const double _gap = 4;

  @override
  void initState() {
    super.initState();
    _syncUniverse();
    patchStore.addListener(_syncUniverse);
  }

  @override
  void dispose() {
    patchStore.removeListener(_syncUniverse);
    super.dispose();
  }

  void _syncUniverse() {
    final universes = patchStore.universesInUse;
    if (universes.isEmpty) {
      if (_selectedUniverse != 1) setState(() => _selectedUniverse = 1);
      return;
    }
    if (!universes.contains(_selectedUniverse)) {
      setState(() => _selectedUniverse = universes.first);
    }
  }

  Future<void> _confirmReset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Réinitialiser la référence ?'),
        content: const Text(
          'Cela efface le patch chargé depuis le MVR dans l’application.\n'
          'Aucune donnée du fichier n’est modifiée.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Réinitialiser'),
          ),
        ],
      ),
    );

    if (ok == true) {
      patchStore.clearReference();
    }
  }

  void _zoomOut() => setState(() => _tileWanted = (_tileWanted - 2).clamp(12, 40));
  void _zoomIn() => setState(() => _tileWanted = (_tileWanted + 2).clamp(12, 40));

  Future<void> _showChannelPopup({
    required int universe,
    required int address,
  }) async {
    final occupants = patchStore.entriesOccupyingChannel(universe, address);
    final occupied = occupants.isNotEmpty;

    final title = occupied
        ? (occupants.length > 1 ? 'Conflit' : 'Canal occupé')
        : 'Canal libre';

    final Widget content = occupied
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Univers : $universe\n'
                'Adresse : $address\n'
                'État : ${occupants.length > 1 ? 'Conflit' : 'Occupé'}',
              ),
              const SizedBox(height: 12),
              if (occupants.length > 1)
                const Text(
                  'Plusieurs machines occupent ce canal.',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              if (occupants.length > 1) const SizedBox(height: 8),
              ...occupants.take(8).map((e) => _OccupantLine(entry: e)),
              if (occupants.length > 8)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '… et ${occupants.length - 8} autre(s).',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
            ],
          )
        : Text(
            'Univers : $universe\n'
            'Adresse : $address\n'
            'État : Libre',
          );

    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.60,
          ),
          child: SingleChildScrollView(child: content),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: patchStore,
      builder: (context, _) {
        final universes = patchStore.universesInUse;

        final occupied = patchStore.occupiedChannelsForUniverse(_selectedUniverse);
        final conflictChannels = patchStore.conflictChannelsForUniverse(_selectedUniverse);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Patch'),
            actions: [
              IconButton(
                tooltip: 'Réinitialiser la référence',
                onPressed: patchStore.entries.isEmpty ? null : _confirmReset,
                icon: const Icon(Icons.restart_alt),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              SectionCard(
                title: 'Référence',
                icon: Icons.lock_outline,
                child: Text(
                  patchStore.isReadOnly
                      ? 'Lecture seule (depuis MVR)'
                      : 'Aucune référence chargée',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 12),

              SectionCard(
                title: 'Univers',
                icon: Icons.layers_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<int>(
                      initialValue: _selectedUniverse,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Univers DMX'),
                      items: (universes.isEmpty ? [1] : universes)
                          .map(
                            (u) => DropdownMenuItem(
                              value: u,
                              child: Text('Univers $u'),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _selectedUniverse = v);
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Occupés : ${occupied.length} / 512',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Conflits : ${conflictChannels.length} canal(aux)',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    const _Legend(),
                    const SizedBox(height: 8),
                    const Text(
                      'Touche une case pour afficher le détail.',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ---- ZOOM AU DESSUS DE LA GRILLE ----
              SectionCard(
                title: 'Zoom',
                icon: Icons.zoom_in,
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _zoomOut,
                        icon: const Icon(Icons.remove),
                        label: const Text('Réduire'),
                        style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all(const Color(0xFFB0B0B0)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _zoomIn,
                        icon: const Icon(Icons.add),
                        label: const Text('Agrandir'),
                        style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all(const Color(0xFFB0B0B0)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              SectionCard(
                title: 'Occupation (1 à 512)',
                icon: Icons.grid_on,
                child: _Full512Grid10Cols(
                  tileWanted: _tileWanted,
                  gap: _gap,
                  occupied: occupied,
                  conflictChannels: conflictChannels,
                  onTap: (addr) => _showChannelPopup(
                    universe: _selectedUniverse,
                    address: addr,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    Widget item(Color color, String label) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.white12),
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      );
    }

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        item(Colors.white10, 'Libre'),
        item(Colors.greenAccent.withValues(alpha: 0.85), 'Occupé'),
        item(Colors.redAccent.withValues(alpha: 0.9), 'Conflit'),
      ],
    );
  }
}

class _OccupantLine extends StatelessWidget {
  final PatchEntry entry;

  const _OccupantLine({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '• ${entry.fixtureName}\n'
        '  ${entry.dmxModeName} — ${entry.channelCount} canal(aux)\n'
        '  ${entry.startAddress} → ${entry.endAddress}',
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}

/// Grille 10 colonnes (cases grandes), responsive, sans overflow.
/// Affiche un avertissement si le zoom est limité par l’écran.
class _Full512Grid10Cols extends StatelessWidget {
  final double tileWanted;
  final double gap;
  final Set<int> occupied;
  final Set<int> conflictChannels;
  final void Function(int address) onTap;

  const _Full512Grid10Cols({
    required this.tileWanted,
    required this.gap,
    required this.occupied,
    required this.conflictChannels,
    required this.onTap,
  });

  static const int columns = 10;

  @override
  Widget build(BuildContext context) {
    final rowCount = (512 / columns).ceil();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth;

          // Label compact
          const labelWidth = 44.0;
          const labelGap = 8.0;

          final gridWidth =
              (availableWidth - labelWidth - labelGap).clamp(0.0, double.infinity);

          // Taille max possible pour tenir, arrondi inférieur => anti-overflow
          final raw = (gridWidth - (gap * (columns - 1))) / columns;
          final computed = raw.isFinite ? raw : 12.0;
          final possible = computed.floorToDouble().clamp(12.0, 1000.0);

          final tileSize = possible.clamp(12.0, tileWanted);
          final isLimited = tileWanted > possible + 0.0001;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLimited)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Limité par la largeur de l’écran.',
                    style: TextStyle(
                      color: Colors.amberAccent.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rowCount,
                itemBuilder: (context, rowIndex) {
                  final startAddress = rowIndex * columns + 1;
                  final endAddress = (startAddress + columns - 1).clamp(1, 512);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: labelWidth,
                          child: Text(
                            '$startAddress–$endAddress',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: labelGap),
                        SizedBox(
                          width: gridWidth,
                          child: Row(
                            children: List.generate(columns, (i) {
                              final address = startAddress + i;

                              if (address > 512) {
                                return SizedBox(
                                  width: i == columns - 1 ? tileSize : tileSize + gap,
                                  height: tileSize,
                                );
                              }

                              final isConflict = conflictChannels.contains(address);
                              final isOcc = occupied.contains(address);

                              final Color color;
                              if (isConflict) {
                                color = Colors.redAccent.withValues(alpha: 0.9);
                              } else if (isOcc) {
                                color = Colors.greenAccent.withValues(alpha: 0.85);
                              } else {
                                color = Colors.white10;
                              }

                              return Padding(
                                padding: EdgeInsets.only(right: i == columns - 1 ? 0 : gap),
                                child: GestureDetector(
                                  onTap: () => onTap(address),
                                  child: Container(
                                    width: tileSize,
                                    height: tileSize,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: color,
                                      border: Border.all(color: Colors.white12),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
