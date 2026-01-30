import 'package:flutter/material.dart';

import '../app/ui/widgets.dart';

import 'lumiere/dipswitch_page.dart';
import 'lumiere/fixtures/fixture_catalog_page.dart';
import 'lumiere/photometry_page.dart';
import 'lumiere/projection_page.dart';
import 'lumiere/patch/patch_home_page.dart';

class PageLumiere extends StatelessWidget {
  const PageLumiere({super.key});

  static const double _kActionSpacing = 12;

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  Widget _actionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: SectionCard(
        title: title,
        icon: icon,
        trailing: const Icon(Icons.chevron_right, color: Colors.white70),
        child: Text(
          description,
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lumière')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _actionCard(
            context: context,
            title: 'Taille de projection',
            icon: Icons.zoom_out_map,
            description:
                'Calcul indicatif de la taille de tache selon l’angle, la distance et le diamètre.',
            onTap: () => _open(context, const ProjectionPage()),
          ),
          const SizedBox(height: _kActionSpacing),
          _actionCard(
            context: context,
            title: 'Dip-switch DMX',
            icon: Icons.settings_input_component,
            description:
                'Conversion indicative entre adresse DMX et interrupteurs, avec navigation par intervalle.',
            onTap: () => _open(context, const DipSwitchPage()),
          ),
          const SizedBox(height: _kActionSpacing),
          _actionCard(
            context: context,
            title: 'Photométrie',
            icon: Icons.brightness_high,
            description:
                'Conversions indicatives entre lux, candela et lumen, avec distance et angle.',
            onTap: () => _open(context, const PhotometryPage()),
          ),
          const SizedBox(height: _kActionSpacing),
          _actionCard(
            context: context,
            title: 'Catalogue',
            icon: Icons.list_alt,
            description:
                'Sélection par constructeur, type et produit, avec informations et manuel.',
            onTap: () => _open(context, const FixtureCatalogPage()),
          ),
          const SizedBox(height: _kActionSpacing),

          // ✅ NOUVELLE TUILE
          _actionCard(
            context: context,
            title: 'Patch DMX',
            icon: Icons.account_tree,
            description:
                'Importer un fichier MVR ou créer un patch manuellement depuis la librairie.',
            onTap: () => _open(context, const PatchHomePage()),
          ),

          const SizedBox(height: 18),
          const Text(
            'Outils indicatifs. Vérifie toujours la documentation constructeur.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
