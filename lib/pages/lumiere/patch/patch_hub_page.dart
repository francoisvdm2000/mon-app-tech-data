import 'package:flutter/material.dart';

import '../../../app/ui/widgets.dart';
import 'patch_mvr_import_page.dart';
import 'patch_universe_page.dart';
import 'patch_store.dart';

class PatchHubPage extends StatelessWidget {
  const PatchHubPage({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: patchStore,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Patch / MVR'),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              SectionCard(
                title: 'Mode chantier',
                icon: Icons.lock_outline,
                child: const Text(
                  'Lecture seule : le MVR est chargé comme référence.\n'
                  'Aucune modification d’adresses n’est possible dans l’application.',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _open(context, const PatchMvrImportPage()),
                child: const Text('Charger / consulter un fichier MVR'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _open(context, const PatchUniversePage()),
                child: const Text('Voir la place disponible (grille DMX)'),
              ),
              const SizedBox(height: 12),
              SectionCard(
                title: 'État',
                icon: Icons.info_outline,
                child: Text(
                  patchStore.entries.isEmpty
                      ? 'Aucune référence chargée.'
                      : 'Référence chargée : ${patchStore.entries.length} entrée(s), lecture seule.',
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
