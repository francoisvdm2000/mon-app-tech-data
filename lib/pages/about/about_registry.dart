// lib/pages/about/about_registry.dart
import 'package:flutter/material.dart';

import 'about_search.dart';

// Indexes (texte scannable)
import 'indexes/about_dmx_index.dart';
import 'indexes/about_artnet_index.dart';
import 'indexes/about_sacn_index.dart';
import 'indexes/about_ip_basics_index.dart';
import 'indexes/about_reseau_index.dart';
import 'indexes/about_network_index.dart';
import 'indexes/about_video_index.dart';
import 'indexes/about_electricite_index.dart';
import 'indexes/about_informatique_index.dart';

// Pages (pour tuiles classiques)
import 'about_dmx_page.dart';
import 'about_artnet_page.dart';
import 'about_sacn_page.dart';
import 'about_ip_basics_page.dart';
import 'about_reseau_page.dart';
import 'about_network_page.dart';
import 'about_video_page.dart';
import 'about_electricite_page.dart';
import 'about_informatique_page.dart';

class AboutRegistry {
  static List<AboutSearchDoc> allDocs() => [
        ...AboutDmxSearchIndex.docs(),
        ...AboutArtNetSearchIndex.docs(),
        ...AboutSacnSearchIndex.docs(),
        ...AboutIpBasicsSearchIndex.docs(),
        ...AboutReseauSearchIndex.docs(),
        ...AboutNetworkSearchIndex.docs(),
        ...AboutVideoSearchIndex.docs(),
        ...AboutElectriciteSearchIndex.docs(),
        ...AboutInformatiqueSearchIndex.docs(),
      ];

  static List<AboutTile> tiles() => const [
        AboutTile(
          title: 'DMX — fonctionnement (simple & complet)',
          subtitle:
              'Univers, adresses, trames, câblage RS-485, terminaison, erreurs terrain.\n'
              'Inclut schémas + checklist.',
          icon: Icons.cable,
          pageBuilder: AboutDmxPage.new,
        ),
        AboutTile(
          title: 'Art-Net — DMX sur IP (nodes, unicast/broadcast)',
          subtitle:
              'Univers DMX sur Ethernet/UDP, nodes, broadcast vs unicast.\n'
              'Limites réelles, stabilité réseau, RDM selon matériel, schémas + checklist.',
          icon: Icons.router,
          pageBuilder: AboutArtNetPage.new,
        ),
        AboutTile(
          title: 'sACN / E1.31 — multicast, IGMP, priorités',
          subtitle:
              'Standard DMX sur IP orienté réseau pro.\n'
              'Multicast/unicast, IGMP snooping/querier, priorités multi-sources, schémas + checklist.',
          icon: Icons.wifi_tethering,
          pageBuilder: AboutSacnPage.new,
        ),
        AboutTile(
          title: 'Réseau — bases IP / masque / DHCP (essentiel)',
          subtitle:
              'Comprendre IP, masque, passerelle, DHCP vs statique.\n'
              'Exemples concrets (2.x.x.x, 10.x, 192.168.x), tests rapides, pièges show.',
          icon: Icons.language,
          pageBuilder: AboutIpBasicsPage.new,
        ),
        AboutTile(
          title: 'Réseau — RJ45 / Fibre / débits & longueurs',
          subtitle:
              'Cat5e→Cat8, fibre OM3/OM4/OS2, LC/SC/MPO, distances typiques, bonnes pratiques show.',
          icon: Icons.cable,
          pageBuilder: AboutReseauPage.new,
        ),
        AboutTile(
          title: 'Réseau lumière — VLAN, IGMP, Wi-Fi vs filaire',
          subtitle:
              'Architecture simple et robuste pour Art-Net/sACN.\n'
              'VLAN, IGMP snooping/querier, Wi-Fi (jitter), switchs, schémas + checklist.',
          icon: Icons.lan,
          pageBuilder: AboutNetworkPage.new,
        ),
        AboutTile(
          title: 'Vidéo — SDI / NDI / IP (SRT/RTMP)',
          subtitle:
              'Choisir selon latence, fiabilité, câblage, réseau LAN vs WAN.\n'
              'Tableaux + schéma.',
          icon: Icons.connected_tv,
          pageBuilder: AboutVideoPage.new,
        ),
        AboutTile(
          title: 'Électrique — Schuko / P17 / puissances',
          subtitle: 'Connecteurs, mono/tri, tableaux kW rapides (16A→400A), pièges terrain.',
          icon: Icons.electrical_services,
          pageBuilder: AboutElectricitePage.new,
        ),
        AboutTile(
          title: 'Informatique — USB / HDMI / DP / SATA / NVMe…',
          subtitle: 'Débits utiles, versions, limites réelles, pièges marketing.',
          icon: Icons.usb,
          pageBuilder: AboutInformatiquePage.new,
        ),
      ];

  /// Permet à la recherche d'ouvrir la bonne page à partir du doc.pageId.
  /// IMPORTANT : on n'enlève rien, on ajoute juste un mapping.
  static Widget Function() pageBuilderFor(String pageId) {
    switch (pageId) {
      case 'dmx':
        return AboutDmxPage.new;
      case 'artnet':
        return AboutArtNetPage.new;
      case 'sacn':
        return AboutSacnPage.new;
      case 'ip_basics':
        return AboutIpBasicsPage.new;
      case 'reseau':
        return AboutReseauPage.new;
      case 'network':
        return AboutNetworkPage.new;
      case 'video':
        return AboutVideoPage.new;
      case 'electricite':
        return AboutElectricitePage.new;
      case 'informatique':
        return AboutInformatiquePage.new;
    }

    // Fallback (au cas où un index a un pageId inconnu)
    return AboutDmxPage.new;
  }
}

class AboutTile {
  const AboutTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.pageBuilder,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget Function() pageBuilder;
}
