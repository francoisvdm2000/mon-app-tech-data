import 'package:flutter/material.dart';

import '../about_search.dart';
import '../about_dmx_page.dart';

class AboutDmxSearchIndex {
  static List<AboutSearchDoc> docs() => [
        AboutSearchDoc(
          title: 'DMX — bases (univers, adresses)',
          text: '''
DMX512: RS-485, 512 canaux (slots) par univers, valeurs 0–255.
Adresse de départ + mode (nombre de canaux) = cause principale des pannes.
8-bit 0–255. 16-bit = coarse + fine.
''',
          icon: Icons.view_stream,
          pageBuilder: () => const AboutDmxPage(),
          anchor: DmxAnchor.basics,
        ),
        AboutSearchDoc(
          title: 'DMX — trame (break, start code, slots)',
          text: '''
Trame DMX: BREAK, MAB, start code (souvent 0), puis slots 1..N jusqu’à 512.
Vitesse typique: 250 kbaud. Refresh ordre de grandeur ~20–44 trames/s.
''',
          icon: Icons.timeline,
          pageBuilder: () => const AboutDmxPage(),
          anchor: DmxAnchor.frame,
        ),
        AboutSearchDoc(
          title: 'DMX — câblage RS-485 (topologie)',
          text: '''
Topologie DMX: daisy-chain (console → fix1 → fix2 → ...).
Éviter le Y passif (réflexions). Splitter DMX opto si branches.
Câble DMX: paire torsadée 120Ω (RS-485).
''',
          icon: Icons.cable,
          pageBuilder: () => const AboutDmxPage(),
          anchor: DmxAnchor.cabling,
        ),
        AboutSearchDoc(
          title: 'DMX — terminaison 120Ω',
          text: '''
Terminaison 120Ω sur le dernier appareil de la chaîne.
Sans terminaison: réflexions → flicker, valeurs instables, pertes.
Une seule terminaison. Pas au milieu. Pas une par branche.
''',
          icon: Icons.power,
          pageBuilder: () => const AboutDmxPage(),
          anchor: DmxAnchor.termination,
        ),
        AboutSearchDoc(
          title: 'DMX — RDM (retour, compatibilités)',
          text: '''
RDM: DMX bidirectionnel (config/monitoring).
Support variable sur splitters/nodes (RDM pass-through / RDM proxy).
Discovery sensible si câblage borderline.
Couper RDM pour isoler si instable.
''',
          icon: Icons.settings_input_component,
          pageBuilder: () => const AboutDmxPage(),
          anchor: DmxAnchor.rdm,
        ),
        AboutSearchDoc(
          title: 'DMX — dépannage terrain',
          text: '''
Flicker: terminaison absente, Y passif, câble inadapté, parasites.
Tout marche sauf après un appareil: THRU/OUT HS ou appareil qui casse la ligne.
Méthode: chaîne courte, câble connu OK, ajout appareil par appareil, splitter.
''',
          icon: Icons.bug_report,
          pageBuilder: () => const AboutDmxPage(),
          anchor: DmxAnchor.troubleshooting,
        ),
        AboutSearchDoc(
          title: 'DMX — checklist',
          text: '''
Mode appareil correct (nombre de canaux).
Adresse DMX correcte (pas de chevauchement).
Daisy-chain (pas de Y passif).
Terminaison 120Ω sur le dernier.
Câble DMX/RS-485 paire torsadée 120Ω.
Splitter opto si branches.
''',
          icon: Icons.checklist,
          pageBuilder: () => const AboutDmxPage(),
          anchor: DmxAnchor.checklist,
        ),
      ];
}
