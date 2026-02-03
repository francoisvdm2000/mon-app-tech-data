import 'package:flutter/material.dart';

import '../about_search.dart';
import '../about_electricite_page.dart';

class AboutElectriciteSearchIndex {
  static List<AboutSearchDoc> docs() => [
        AboutSearchDoc(
          title: 'Électrique — bases (W, V, A, kW)',
          text: '''
Mono: P = U × I (230V × 16A ≈ 3.7kW).
Tri: P(kW) ≈ √3 × 400V × I / 1000 (16A ≈ 11kW).
Ne pas viser 100% en continu (marge).
W/kW puissance, A courant, V tension.
''',
          icon: Icons.calculate,
          pageBuilder: () => const AboutElectricitePage(),
          // (Si tu ajoutes un enum ElectriciteAnchor plus tard, tu le mets ici)
          anchor: null,
        ),
        AboutSearchDoc(
          title: 'Électrique — connecteurs (Schuko, P17/CEE)',
          text: '''
Schuko: 230V mono, 16A max (attention multiprises/rallonges fines/faux contacts).
P17/CEE: bleu = 230V mono (16A/32A), rouge = 400V tri (16A/32A/63A/125A...).
Toujours vérifier: broches, marquage (V/Hz/A), calibre chaîne complète.
''',
          icon: Icons.electrical_services,
          pageBuilder: () => const AboutElectricitePage(),
          anchor: null,
        ),
        AboutSearchDoc(
          title: 'Électrique — mono vs tri',
          text: '''
Mono: phase + neutre + terre (230V).
Tri: 3 phases + souvent neutre + terre (400V entre phases, 230V phase-neutre).
Équilibrer L1/L2/L3. Neutre peut chauffer si déséquilibre + harmoniques.
''',
          icon: Icons.bolt,
          pageBuilder: () => const AboutElectricitePage(),
          anchor: null,
        ),
        AboutSearchDoc(
          title: 'Électrique — puissances rapides (16A → 400A)',
          text: '''
Mono 230V: 16A≈3.7kW, 32A≈7.4kW, 63A≈14.5kW, 125A≈28.8kW.
Tri 400V: 16A≈11kW, 32A≈22kW, 63A≈44kW, 125A≈87kW, 250A≈173kW, 400A≈277kW.
Cosφ/PF peut réduire la marge.
''',
          icon: Icons.table_chart,
          pageBuilder: () => const AboutElectricitePage(),
          anchor: null,
        ),
        AboutSearchDoc(
          title: 'Électrique — protections (disjoncteur, différentiel)',
          text: '''
Disjoncteur: surintensité (surcharge/court-circuit). Calibre adapté câbles/prises.
Différentiel: fuite à la terre (30mA personnes, 300mA installation selon cas).
Sélectivité: répartir zones, éviter “tout sur la même ligne”.
Ne jamais augmenter le calibre pour éviter que ça saute.
''',
          icon: Icons.shield,
          pageBuilder: () => const AboutElectricitePage(),
          anchor: null,
        ),
      ];
}
