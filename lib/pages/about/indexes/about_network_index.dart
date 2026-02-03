import 'package:flutter/material.dart';
import '../about_search.dart';

class AboutNetworkSearchIndex {
  static List<AboutSearchDoc> docs() => [
        AboutSearchDoc(
          pageId: 'network',
          pageTitle: 'Réseau lumière — VLAN, IGMP, Wi-Fi',
          title: 'Réseau lumière — mémo',
          anchorId: 'basics',
          icon: Icons.lan,
          searchText: '''
Réseau lumière: viser simple, dédié, et stable.
VLAN = séparer le trafic (lumière vs reste).
IGMP = indispensable si sACN multicast à grande échelle.
Wi-Fi = ok dépannage, rarement ok en prod critique.
''',
        ),

        AboutSearchDoc(
          pageId: 'network',
          pageTitle: 'Réseau lumière — VLAN, IGMP, Wi-Fi',
          title: 'IGMP (sACN multicast)',
          anchorId: 'igmp',
          icon: Icons.hub,
          searchText: '''
IGMP snooping permet au switch de savoir quels ports veulent quel multicast.
Sans ça, le multicast peut être inondé sur tous les ports → saturation.
IGMP querier: parfois nécessaire pour éviter des glitches.
''',
        ),

        // Ajoute les autres sections pareil :
        AboutSearchDoc(
          pageId: 'network',
          pageTitle: 'Réseau lumière — VLAN, IGMP, Wi-Fi',
          title: 'Plan IP (simple)',
          anchorId: 'plan_ip',
          icon: Icons.alt_route,
          searchText: 'DHCP vs statique, masque /24, conflits IP, etc.',
        ),

        AboutSearchDoc(
          pageId: 'network',
          pageTitle: 'Réseau lumière — VLAN, IGMP, Wi-Fi',
          title: 'VLAN (séparation)',
          anchorId: 'vlan',
          icon: Icons.layers,
          searchText: 'VLAN, trunk/access, isolation trafic…',
        ),

        AboutSearchDoc(
          pageId: 'network',
          pageTitle: 'Réseau lumière — VLAN, IGMP, Wi-Fi',
          title: 'Wi-Fi vs filaire',
          anchorId: 'wifi',
          icon: Icons.wifi,
          searchText: 'Jitter, pertes, interférences…',
        ),

        AboutSearchDoc(
          pageId: 'network',
          pageTitle: 'Réseau lumière — VLAN, IGMP, Wi-Fi',
          title: 'Switch: ce qu’il faut',
          anchorId: 'switch',
          icon: Icons.settings_ethernet,
          searchText: 'managed/unmanaged, IGMP snooping…',
        ),

        AboutSearchDoc(
          pageId: 'network',
          pageTitle: 'Réseau lumière — VLAN, IGMP, Wi-Fi',
          title: 'Schémas',
          anchorId: 'diagrams',
          icon: Icons.schema,
          searchText: 'Schémas VLAN, wifi vs filaire…',
        ),

        AboutSearchDoc(
          pageId: 'network',
          pageTitle: 'Réseau lumière — VLAN, IGMP, Wi-Fi',
          title: 'Images (assets)',
          anchorId: 'assets',
          icon: Icons.image_outlined,
          searchText: 'assets/images/connectors/rj45.png ...',
        ),

        AboutSearchDoc(
          pageId: 'network',
          pageTitle: 'Réseau lumière — VLAN, IGMP, Wi-Fi',
          title: 'Checklist',
          anchorId: 'checklist',
          icon: Icons.checklist,
          searchText: 'Checklist réseau lumière…',
        ),
      ];
}
