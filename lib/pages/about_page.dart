import 'package:flutter/material.dart';

import 'about/about_dmx_page.dart';
import 'about/about_artnet_page.dart';
import 'about/about_sacn_page.dart';
import 'about/about_ip_basics_page.dart';
import 'about/about_network_page.dart';
import 'about/about_video_page.dart';
import 'about/about_electricite_page.dart';
import 'about/about_informatique_page.dart';
import 'about/about_reseau_page.dart';

class PageAbout extends StatelessWidget {
  const PageAbout({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Références')),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: LayoutBuilder(
            builder: (context, c) {
              final isWide = c.maxWidth >= 900;
              final tileW = isWide ? (c.maxWidth - 12) / 2 : c.maxWidth;

              Widget sized(Widget child) => SizedBox(width: tileW, child: child);

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  // 1) DMX
                  sized(
                    _NavTile(
                      title: 'DMX — fonctionnement (simple & complet)',
                      subtitle:
                          'Univers, adresses, trames, câblage RS-485, terminaison, erreurs terrain.\n'
                          'Inclut schémas + checklist.',
                      icon: Icons.cable,
                      onTap: () => _open(context, const AboutDmxPage()),
                    ),
                  ),

                  // 2) Art-Net
                  sized(
                    _NavTile(
                      title: 'Art-Net — DMX sur IP (nodes, unicast/broadcast)',
                      subtitle:
                          'Univers DMX sur Ethernet/UDP, nodes, broadcast vs unicast.\n'
                          'Limites réelles, stabilité réseau, RDM selon matériel.',
                      icon: Icons.router,
                      onTap: () => _open(context, const AboutArtNetPage()),
                    ),
                  ),

                  // 3) sACN
                  sized(
                    _NavTile(
                      title: 'sACN / E1.31 — multicast, IGMP, priorités',
                      subtitle:
                          'Standard DMX sur IP orienté réseau “pro”.\n'
                          'Multicast/unicast, IGMP snooping/querier, priorités multi-sources.',
                      icon: Icons.wifi_tethering,
                      onTap: () => _open(context, const AboutSacnPage()),
                    ),
                  ),

                  // 4) IP basics
                  sized(
                    _NavTile(
                      title: 'Réseau — bases IP / masque / DHCP (essentiel)',
                      subtitle:
                          'Comprendre IP, masque, passerelle, DHCP vs statique.\n'
                          'Exemples concrets (2.x, 10.x, 192.168.x) + checklist.',
                      icon: Icons.language,
                      onTap: () => _open(context, const AboutIpBasicsPage()),
                    ),
                  ),

                  // 5) Réseau lumière
                  sized(
                    _NavTile(
                      title: 'Réseau lumière — VLAN, IGMP, Wi-Fi vs filaire',
                      subtitle:
                          'Architecture simple et robuste pour Art-Net/sACN.\n'
                          'VLAN, IGMP snooping/querier, Wi-Fi (jitter), switchs, schémas + checklist.',
                      icon: Icons.lan,
                      onTap: () => _open(context, const AboutNetworkPage()),
                    ),
                  ),

                  // 6) Réseau câbles / fibre
                  sized(
                    _NavTile(
                      title: 'Réseau — RJ45 / Fibre / débits & longueurs',
                      subtitle:
                          'Cat5e→Cat8, fibre OM3/OM4/OS2, LC/SC/MPO, distances typiques, bonnes pratiques show.',
                      icon: Icons.cable, // (tu avais Icons.router, mais cable est plus logique ici)
                      onTap: () => _open(context, const AboutReseauPage()),
                    ),
                  ),

                  // 7) Vidéo
                  sized(
                    _NavTile(
                      title: 'Vidéo — SDI / NDI / IP (SRT/RTMP)',
                      subtitle:
                          'Choisir selon latence, fiabilité, câblage, réseau LAN vs WAN.\n'
                          'Tableaux + schéma.',
                      icon: Icons.connected_tv,
                      onTap: () => _open(context, const AboutVideoPage()),
                    ),
                  ),

                  // 8) Électrique
                  sized(
                    _NavTile(
                      title: 'Électrique — Schuko / P17 / puissances',
                      subtitle: 'Connecteurs, mono/tri, tableaux kW rapides (16A→400A), pièges terrain.',
                      icon: Icons.electrical_services,
                      onTap: () => _open(context, const AboutElectricitePage()),
                    ),
                  ),

                  // 9) Informatique
                  sized(
                    _NavTile(
                      title: 'Informatique — USB / HDMI / DP / SATA / NVMe…',
                      subtitle: 'Débits utiles, versions, limites réelles, pièges marketing.',
                      icon: Icons.usb,
                      onTap: () => _open(context, const AboutInformatiquePage()),
                    ),
                  ),
                ],
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
