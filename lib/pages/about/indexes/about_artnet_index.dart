// lib/pages/about/indexes/about_artnet_index.dart
import 'package:flutter/material.dart';

import '../about_search.dart';

/// Index de recherche pour Art-Net.
/// (Utilisé par AboutRegistry.allDocs())
class AboutArtNetSearchIndex {
  static List<AboutSearchDoc> docs() => [
        AboutSearchDoc(
          pageId: 'artnet',
          pageTitle: 'Art-Net — DMX sur IP (nodes, unicast/broadcast)',
          title: 'Art-Net — bases',
          anchorId: 'basics',
          icon: Icons.router,
          searchText: '''
Art-Net transporte des univers DMX sur Ethernet/IP.
UDP, réseau dédié, nodes (convertisseurs DMX).
Broadcast vs unicast : broadcast simple mais peut flood/saturer, unicast plus propre.
''',
        ),
        AboutSearchDoc(
          pageId: 'artnet',
          pageTitle: 'Art-Net — DMX sur IP (nodes, unicast/broadcast)',
          title: 'Adressage / univers (rappel)',
          anchorId: 'addressing',
          icon: Icons.router,
          searchText: '''
Adressage Art-Net : univers DMX envoyés sur le réseau.
Cohérence patch console <-> node indispensable.
Attention aux plages IP (souvent 2.x.x.x en matériel ancien).
''',
        ),
        AboutSearchDoc(
          pageId: 'artnet',
          pageTitle: 'Art-Net — DMX sur IP (nodes, unicast/broadcast)',
          title: 'Limites réelles (ce qui casse en premier)',
          anchorId: 'limits',
          icon: Icons.warning_amber_rounded,
          searchText: '''
Limites : Wi-Fi = latence variable, pertes.
Broadcast peut saturer un switch / ports inutiles.
Nodes/firmwares : limite d’univers à haute fréquence selon matériel.
Règle simple : réseau dédié (ou VLAN) + unicast si beaucoup d’univers.
''',
        ),
        AboutSearchDoc(
          pageId: 'artnet',
          pageTitle: 'Art-Net — DMX sur IP (nodes, unicast/broadcast)',
          title: 'Nodes, splitters, RDM (compatibilités)',
          anchorId: 'nodes_rdm',
          icon: Icons.settings_input_component,
          searchText: '''
Nodes : convertissent IP <-> DMX (DMX OUT).
RDM : support variable selon nodes/splitters (RDM proxy, pass-through).
Toujours vérifier compatibilité si tu veux discovery/config via RDM.
''',
        ),
        AboutSearchDoc(
          pageId: 'artnet',
          pageTitle: 'Art-Net — DMX sur IP (nodes, unicast/broadcast)',
          title: 'Dépannage Art-Net (terrain)',
          anchorId: 'troubleshooting',
          icon: Icons.bug_report,
          searchText: '''
Pannes fréquentes : mauvais patch univers, mauvais IP/mask, broadcast qui flood,
Wi-Fi instable, switch non adapté, node mal configuré.
Méthode : tester en unicast, réseau dédié, vérifier mapping univers <-> ports.
''',
        ),
        AboutSearchDoc(
          pageId: 'artnet',
          pageTitle: 'Art-Net — DMX sur IP (nodes, unicast/broadcast)',
          title: 'Schémas',
          anchorId: 'diagrams',
          icon: Icons.schema,
          searchText: '''
Schémas réseau : console -> switch -> nodes -> DMX vers fixtures.
Architecture simple, unicast recommandé si réseau chargé.
''',
        ),
        AboutSearchDoc(
          pageId: 'artnet',
          pageTitle: 'Art-Net — DMX sur IP (nodes, unicast/broadcast)',
          title: 'Checklist Art-Net',
          anchorId: 'checklist',
          icon: Icons.checklist,
          searchText: '''
Checklist : réseau dédié/VLAN, switch OK, unicast si doute,
mapping univers/ports node, IP plan clair (DHCP vs statique).
''',
        ),
      ];
}

/// ---------------------------------------------------------------------------
/// ⚠️ Ancien contenu présent dans ce fichier (tu l’avais collé ici).
/// On NE SUPPRIME PAS :
/// - on renomme pour éviter les warnings camelCase + incohérences
/// - on garde un build() stub pour que ça compile
/// ---------------------------------------------------------------------------

class AboutArtNetPageIndexStub extends StatefulWidget {
  const AboutArtNetPageIndexStub({super.key, this.initialAnchorId});

  /// ✅ "basics", "addressing", "limits", ...
  final String? initialAnchorId;

  @override
  State<AboutArtNetPageIndexStub> createState() => AboutArtNetPageIndexStubState();
}

class AboutArtNetPageIndexStubState extends State<AboutArtNetPageIndexStub> {
  final _scrollCtrl = ScrollController();

  final _k1Basics = GlobalKey();
  final _k2Addressing = GlobalKey();
  final _k3Limits = GlobalKey();
  final _k4NodesRdm = GlobalKey();
  final _k5Troubleshooting = GlobalKey();
  final _k6Diagrams = GlobalKey();
  final _k6bAssets = GlobalKey();
  final _k7Checklist = GlobalKey();

  GlobalKey? _keyForAnchorId(String? id) {
    switch (id) {
      case 'basics':
        return _k1Basics;
      case 'addressing':
        return _k2Addressing;
      case 'limits':
        return _k3Limits;
      case 'nodes_rdm':
        return _k4NodesRdm;
      case 'troubleshooting':
        return _k5Troubleshooting;
      case 'diagrams':
        return _k6Diagrams;
      case 'assets':
        return _k6bAssets;
      case 'checklist':
        return _k7Checklist;
      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final key = _keyForAnchorId(widget.initialAnchorId);
      final ctx = key?.currentContext;
      if (ctx == null) return;

      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        alignment: 0.05,
      );
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Stub minimal pour compiler (le vrai contenu est dans about_artnet_page.dart)
    return const Scaffold(
      body: Center(
        child: Text(
          'Stub Art-Net (index file). Utiliser about_artnet_page.dart pour la page réelle.',
        ),
      ),
    );
  }
}
