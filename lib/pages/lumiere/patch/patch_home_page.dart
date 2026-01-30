import 'package:flutter/material.dart';

import '../../../app/ui/widgets.dart';
import 'patch_mvr_import_page.dart';
import 'patch_universe_page.dart';

class PatchHomePage extends StatelessWidget {
  const PatchHomePage({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patch DMX')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _open(context, const PatchMvrImportPage()),
            child: const SectionCard(
              title: 'Importer un fichier MVR',
              icon: Icons.upload_file,
              trailing: Icon(Icons.chevron_right, color: Colors.white70),
              child: Text(
                'Charger un fichier MVR depuis l’appareil et afficher un résumé clair sous forme de tableur.',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          const SizedBox(height: 12),

          // ✅ NOUVEL ACCÈS : univers
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _open(context, const PatchUniversePage()),
            child: const SectionCard(
              title: 'Voir le patch actuel',
              icon: Icons.account_tree,
              trailing: Icon(Icons.chevron_right, color: Colors.white70),
              child: Text(
                'Afficher l’univers DMX, les canaux occupés et les projecteurs patchés.',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),

          const SizedBox(height: 18),
          const Text(
            'Import MVR : lecture indicative. Vérifie toujours le patch final.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
