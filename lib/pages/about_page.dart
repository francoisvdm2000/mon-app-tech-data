import 'package:flutter/material.dart';

import 'about/about_dmx_page.dart';
import 'about/about_video_page.dart';
import 'about/about_electricite_page.dart';
import 'about/about_reseau_page.dart';
import 'about/about_informatique_page.dart';

class PageAbout extends StatelessWidget {
  const PageAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About / Références')),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: LayoutBuilder(
            builder: (context, c) {
              final isWide = c.maxWidth >= 900;
              final tileW = isWide ? (c.maxWidth - 12) / 2 : c.maxWidth;

              Widget sized(Widget child) => SizedBox(width: tileW, child: child);

              final tiles = <Widget>[
                sized(
                  _NavTile(
                    title: 'DMX — fonctionnement (simple & complet)',
                    subtitle:
                        'Univers, adresses, trames, câblage RS-485, terminaison, erreurs terrain.\n'
                        'Inclut schémas + checklist.',
                    icon: Icons.cable,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutDmxPage()),
                    ),
                  ),
                ),
                sized(
                  _NavTile(
                    title: 'Vidéo — SDI / NDI / IP (SRT/RTMP)',
                    subtitle:
                        'Choisir selon latence, fiabilité, câblage, réseau LAN vs WAN.\n'
                        'Tableaux + schéma.',
                    icon: Icons.connected_tv,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutVideoPage()),
                    ),
                  ),
                ),
                sized(
                  _NavTile(
                    title: 'Électrique — Schuko / P17 / puissances',
                    subtitle:
                        'Connecteurs, mono/tri, tableaux kW rapides (16A→400A), pièges terrain.',
                    icon: Icons.electrical_services,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutElectricitePage()),
                    ),
                  ),
                ),
                sized(
                  _NavTile(
                    title: 'Réseau — RJ45 / Fibre / débits & longueurs',
                    subtitle:
                        'Cat5e→Cat8, fibre OM3/OM4/OS2, LC/SC/MPO, distances typiques, bonnes pratiques show.',
                    icon: Icons.router,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutReseauPage()),
                    ),
                  ),
                ),
                sized(
                  _NavTile(
                    title: 'Informatique — USB / HDMI / DP / SATA / NVMe…',
                    subtitle: 'Débits utiles, versions, limites réelles, pièges marketing.',
                    icon: Icons.usb,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutInformatiquePage()),
                    ),
                  ),
                ),
              ];

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: tiles,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.55)),
            ],
          ),
        ),
      ),
    );
  }
}
