import 'package:flutter/material.dart';

import '../../../app/ui/widgets.dart';

class PatchManualPage extends StatelessWidget {
  const PatchManualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patch manuel'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: const [
          SectionCard(
            title: 'Fonction désactivée',
            icon: Icons.lock_outline,
            child: Text(
              'Le patch manuel est désactivé pour le mode chantier.\n'
              'Utilise uniquement l’import MVR et la vue patch.',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
