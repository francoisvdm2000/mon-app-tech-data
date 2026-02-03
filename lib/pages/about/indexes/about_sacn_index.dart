import 'package:flutter/material.dart';

import '../about_search.dart';
import '../about_sacn_page.dart';

class AboutSacnSearchIndex {
  static List<AboutSearchDoc> docs() => [
        // Mémo (toc copy)
        AboutSearchDoc(
          title: 'sACN / E1.31 — mémo',
          text: '''
sACN (E1.31) = DMX sur IP (UDP), standard spectacle.
Universe sACN = 1..63999 (plage standard).
Multicast: IGMP snooping recommandé, sinon flood.
Priorité: utile avec sources multiples (console + backup).
''',
          icon: Icons.wifi_tethering,
          pageBuilder: () => const AboutSacnPage(),
          anchor: null,
        ),

        // 1) À quoi sert sACN ?
        AboutSearchDoc(
          title: 'À quoi sert sACN ?',
          text: '''
sACN (E1.31) est un standard largement utilisé pour transporter des univers DMX sur IP.
Il est souvent privilégié quand on veut une architecture réseau propre: multicast bien géré,
priorités standardisées, et un comportement plus “réseau pro”.

Quand c’est top:
- Beaucoup d’univers sur un réseau bien géré.
- Installations / gros réseaux avec plusieurs sources (priorités).
- Quand tu veux éviter le “broadcast partout”.
''',
          icon: Icons.wifi_tethering,
          pageBuilder: () => const AboutSacnPage(),
          anchor: null,
        ),

        // 2) Univers (numérotation)
        AboutSearchDoc(
          title: 'Univers sACN (numérotation)',
          text: '''
Un univers sACN correspond à un univers DMX: jusqu’à 512 slots.
La numérotation sACN standard est 1..63999.
En pratique, l’important est le mapping console ↔ node ↔ port DMX.

Erreur classique:
- Tu changes le numéro d’univers côté console, mais pas côté node (ou inverse).
- Tu patches “Universe 0” alors que le matériel attend une base 1.
- Tu mélanges des conventions de numérotation entre outils.
''',
          icon: Icons.confirmation_number,
          pageBuilder: () => const AboutSacnPage(),
          anchor: null,
        ),

        // 3) Multicast / Unicast + IGMP
        AboutSearchDoc(
          title: 'Multicast / Unicast + IGMP (sACN)',
          text: '''
sACN utilise souvent le multicast: chaque univers “vit” sur un groupe multicast,
et les nodes s’abonnent aux univers dont ils ont besoin.

IGMP snooping (pourquoi c’est important):
- Sans IGMP: le switch “flood” le multicast partout → surcharge possible.
- Avec IGMP: le switch envoie seulement aux ports abonnés → réseau stable.
- Sur gros volumes: IGMP est souvent LA différence entre “ça marche” et “c’est l’enfer”.

Unicast (option):
- Possible selon consoles/nodes.
- Utile en dépannage ou si réseau multicast non maîtrisé.
- Moins élégant mais parfois plus simple.
''',
          icon: Icons.hub,
          pageBuilder: () => const AboutSacnPage(),
          anchor: null,
        ),

        // 4) Priorités (multi-sources)
        AboutSearchDoc(
          title: 'Priorités sACN (multi-sources)',
          text: '''
sACN gère une notion de priorité: si plusieurs sources envoient le même univers,
le récepteur garde la source la plus prioritaire.
Très utile avec une console principale + une console backup + un media server.

Pièges:
- Deux sources non voulues sur le même univers → “ça se bat”.
- Priorité mal réglée → backup qui prend le dessus.
- Debug: couper une source et vérifier qui gagne.
''',
          icon: Icons.priority_high,
          pageBuilder: () => const AboutSacnPage(),
          anchor: null,
        ),

        // 5) Limites / perfs
        AboutSearchDoc(
          title: 'Limites / perfs (sACN)',
          text: '''
Ce qui casse en premier:
- Multicast sans IGMP → flood.
- Switch non adapté (buffers/CPU) → pertes.
- Wi-Fi → jitter/pertes.
- Nodes limités (ports, firmware).

Règles simples:
- Switch géré + IGMP snooping si beaucoup d’univers.
- VLAN dédié lumière si possible.
- Unicast pour isoler en dépannage.
''',
          icon: Icons.speed,
          pageBuilder: () => const AboutSacnPage(),
          anchor: null,
        ),

        // 6) RDM & sACN
        AboutSearchDoc(
          title: 'RDM & sACN (proxy / selon matériel)',
          text: '''
Comme avec Art-Net, le RDM “sur IP” dépend souvent d’un mécanisme de proxy dans les nodes.
Le standard sACN n’implique pas automatiquement que ton node fait du RDM correctement.

À vérifier dans la doc du node:
- Support RDM proxy / RDM over IP.
- Limitations (discovery only, commandes partielles).
- Compatibilité avec splitters/opto côté DMX.

Méthode terrain:
- Stabiliser DMX sans RDM.
- Tester RDM sur une ligne simple et propre.
- Si soucis: désactiver RDM, puis isoler node/splitter.
''',
          icon: Icons.settings_input_component,
          pageBuilder: () => const AboutSacnPage(),
          anchor: null,
        ),

        // 7) Schémas
        AboutSearchDoc(
          title: 'Schémas sACN (multicast/IGMP & priorités)',
          text: '''
Schémas:
- Multicast + IGMP (idée)
- Priorités (2 sources)

Multicast + IGMP:
Le switch avec IGMP snooping n’envoie le multicast qu’aux ports abonnés.

Priorités:
Le récepteur choisit la source la plus prioritaire (ex: Source A prio 100 > Source B prio 90).
''',
          icon: Icons.schema,
          pageBuilder: () => const AboutSacnPage(),
          anchor: null,
        ),

        // 7bis) Assets
        AboutSearchDoc(
          title: 'Images (assets) — switch / IGMP / node',
          text: '''
Assets recommandés (optionnels)
- assets/images/network/switch.png
- assets/images/network/igmp.png
- assets/images/network/node.png

pubspec.yaml (exemple)
flutter:
  assets:
    - assets/images/network/

Optionnel: illustrer switch/IGMP/nodes avec des assets locaux.
''',
          icon: Icons.image_outlined,
          pageBuilder: () => const AboutSacnPage(),
          anchor: null,
        ),

        // 8) Checklist
        AboutSearchDoc(
          title: 'Checklist sACN (E1.31)',
          text: '''
sACN (E1.31) — Checklist terrain
- Switch correct (idéalement manageable)
- IGMP snooping activé si multicast
- (Si possible) IGMP querier présent dans le VLAN (sinon comportements bizarres possibles)
- Unicast si réseau non maîtrisé / dépannage
- Priorités: vérifier sources multiples (console/backup)
- Mapping univers ↔ ports node vérifié
- Wi-Fi évité en prod

Avant d’accuser “le protocole”:
- IGMP snooping activé si multicast.
- VLAN dédié si possible.
- Unicast en dépannage.
- Priorités cohérentes si multi-sources.
- Wi-Fi évité en prod.
''',
          icon: Icons.checklist,
          pageBuilder: () => const AboutSacnPage(),
          anchor: null,
        ),
      ];
}
