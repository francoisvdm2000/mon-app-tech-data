import 'package:flutter/material.dart';

import '../../../app/ui/widgets.dart';
import 'patch_models.dart';
import 'patch_store.dart';

class PatchDmxPage extends StatefulWidget {
  const PatchDmxPage({super.key});

  @override
  State<PatchDmxPage> createState() => _PatchDmxPageState();
}

class _PatchDmxPageState extends State<PatchDmxPage> {
  int _selectedUniverse = 1;

  @override
  void initState() {
    super.initState();
    _syncSelectedUniverse();
    patchStore.addListener(_syncSelectedUniverse);
  }

  @override
  void dispose() {
    patchStore.removeListener(_syncSelectedUniverse);
    super.dispose();
  }

  void _syncSelectedUniverse() {
    final universes = patchStore.universesInUse;
    if (universes.isEmpty) {
      if (_selectedUniverse != 1) {
        setState(() => _selectedUniverse = 1);
      }
      return;
    }

    if (!universes.contains(_selectedUniverse)) {
      setState(() => _selectedUniverse = universes.first);
    }
  }

  Future<void> _editEntry(PatchEntry entry) async {
    final modeCtrl = TextEditingController(text: entry.dmxModeName);
    final channelsCtrl = TextEditingController(text: entry.channelCount.toString());

    final res = await showDialog<_EditResult>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111111),
          title: const Text('Modifier le patch', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(entry.fixtureName, style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 12),
              TextField(
                controller: modeCtrl,
                decoration: const InputDecoration(
                  labelText: 'Mode DMX (libellé)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: channelsCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [numFormatter],
                decoration: const InputDecoration(
                  labelText: 'Nombre de canaux (unité : canaux DMX)',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Astuce : saisis le nombre de canaux du mode constructeur (ex : 26).',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final ch = int.tryParse(channelsCtrl.text.trim());
                if (ch == null || ch < 1 || ch > 512) {
                  Navigator.pop(ctx, const _EditResult(error: 'Nombre de canaux invalide.'));
                  return;
                }
                final modeName = modeCtrl.text.trim().isEmpty
                    ? entry.dmxModeName
                    : modeCtrl.text.trim();

                Navigator.pop(ctx, _EditResult(modeName: modeName, channels: ch));
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );

    if (!mounted || res == null) return;

    if (res.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.error!)));
      return;
    }

    final updated = entry.copyWith(
      dmxModeName: res.modeName,
      channelCount: res.channels,
    );

    final ok = patchStore.updateById(entry.id, updated);
    if (ok == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible : conflit DMX ou valeurs invalides.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: patchStore,
      builder: (context, _) {
        final universes = patchStore.universesInUse;
        final currentUniverse = universes.contains(_selectedUniverse)
            ? _selectedUniverse
            : (universes.isEmpty ? 1 : universes.first);

        final entries = patchStore.entriesForUniverse(currentUniverse);
        final occupied = patchStore.occupiedCountForUniverse(currentUniverse);
        final conflicts = patchStore.conflictsInUniverse(currentUniverse);

        return Scaffold(
          appBar: AppBar(title: const Text('Patch DMX')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              SectionCard(
                title: 'Résumé',
                icon: Icons.info_outline,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const Text('Univers DMX : ', style: TextStyle(color: Colors.white70)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            initialValue: currentUniverse,
                            items: (universes.isEmpty ? <int>[1] : universes)
                                .map((u) => DropdownMenuItem(
                                      value: u,
                                      child: Text('Univers $u'),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              if (v == null) return;
                              setState(() => _selectedUniverse = v);
                            },
                            decoration: const InputDecoration(
                              labelText: 'Univers sélectionné',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Projecteurs : ${entries.length}', style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 6),
                    Text('Canaux occupés : $occupied / 512', style: const TextStyle(color: Colors.white70)),
                    if (conflicts.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text('Conflits détectés : ${conflicts.length}', style: const TextStyle(color: Colors.redAccent)),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SectionCard(
                title: 'Patch',
                icon: Icons.tune,
                child: entries.isEmpty
                    ? const Text('Aucune entrée dans cet univers.', style: TextStyle(color: Colors.white70))
                    : Column(
                        children: entries.map((e) => _entryTile(e)).toList(),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _entryTile(PatchEntry e) {
    final hasConflict = patchStore.conflictsFor(e, ignoreId: e.id).isNotEmpty;

    return InkWell(
      onTap: () => _editEntry(e),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white.withAlpha(24)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              hasConflict ? Icons.error_outline : Icons.lightbulb_outline,
              color: hasConflict ? Colors.redAccent : Colors.white70,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    e.fixtureName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text('Mode DMX : ${e.dmxModeName}', style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 2),
                  Text(
                    'Adresse : ${e.startAddress} → ${e.endAddress} (unité : canaux DMX)',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  if (hasConflict)
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Text('Conflit DMX', style: TextStyle(color: Colors.redAccent)),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.edit, color: Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _EditResult {
  final String modeName;
  final int channels;
  final String? error;

  const _EditResult({
    this.modeName = '',
    this.channels = 1,
    this.error,
  });
}
