import 'package:flutter/material.dart';

import '../about_search.dart';
import '../about_reseau_page.dart';

class AboutReseauSearchIndex {
  static List<AboutSearchDoc> docs() => [
        // Mémo / résumé (toc copy)
        AboutSearchDoc(
          title: 'Réseau — repères terrain (mémo)',
          text: '''
RÉSEAU — repères terrain
RJ45 : Cat5e/6/6A → 1G/10G selon distance.
Fibre : longue distance + immunité EMI.
Switch : IGMP important pour sACN multicast.
VLAN : séparer lumière/vidéo/IT = stabilité.
''',
          icon: Icons.router,
          pageBuilder: () => const AboutReseauPage(),
          anchor: null,
        ),

        // 1) Bases réseau
        AboutSearchDoc(
          title: 'Bases réseau (LAN / IP / débit)',
          text: '''
Les 3 idées simples:
IP = adresse (ex: 10.0.0.50).
LAN = réseau local via switch (pas “internet”).
Débit = capacité (1G, 10G…), mais la stabilité dépend aussi du switch.

Topologie show (propre):
Console/PC → switch central → nodes/serveurs.
Évite les “daisy-chain réseau” au hasard.
Si possible : un réseau dédié show (pas le Wi-Fi public).

Mots utiles: lan, ip, débit, 1g, 10g, switch central, topologie, réseau dédié.
''',
          icon: Icons.lan,
          pageBuilder: () => const AboutReseauPage(),
          anchor: null,
        ),

        // 2) RJ45 / catégories
        AboutSearchDoc(
          title: 'RJ45 & catégories (Cat5e/6/6A)',
          text: '''
Repères rapides:
Cat5e : 1 Gbit/s “classique” (jusqu’à 100m).
Cat6 : 1G/10G (10G plutôt sur distances plus courtes).
Cat6A : 10G jusqu’à 100m (repère pratique).
Au-delà : Cat7/8 existent, mais Cat6A est souvent le sweet spot terrain.

Terrain:
Toujours tester/étiqueter les câbles (surtout quand c’est loué).
Évite les connecteurs abîmés : un RJ45 “fatigué” = pannes fantômes.
Prévoir du 10G si tu fais vidéo IP lourde.

Mots utiles: rj45, cat5e, cat6, cat6a, cat7, cat8, 1g, 10g, 100m, câble, connecteur.
''',
          icon: Icons.settings_ethernet,
          pageBuilder: () => const AboutReseauPage(),
          anchor: null,
        ),

        // 3) PoE
        AboutSearchDoc(
          title: 'PoE (alimentation réseau)',
          text: '''
PoE permet d’alimenter des équipements via RJ45 (cam IP, AP Wi-Fi, petits nodes…).
Le point critique : le budget PoE total du switch.

Repères:
PoE (802.3af) ≈ 15W, PoE+ (802.3at) ≈ 30W, PoE++/bt plus haut.
Le switch a un “budget” total (ex: 120W).
Si tu dépasses le budget : certains ports ne s’allument plus / reboot.

Mots utiles: poe, poe+, 802.3af, 802.3at, 802.3bt, budget poe, watts, 15w, 30w, reboot.
''',
          icon: Icons.power,
          pageBuilder: () => const AboutReseauPage(),
          anchor: null,
        ),

        // 4) Fibre
        AboutSearchDoc(
          title: 'Fibre (SM/MM) + connecteurs (LC/SC)',
          text: '''
Pourquoi la fibre en show:
Très longues distances.
Immunité aux parasites (EMI), top en environnements chargés.
Pratique pour relier FOH ↔ plateau ↔ régie.

Multimode vs Monomode (repère simple):
Multimode (MM) : distances “moyennes” (souvent bâtiment / plateau).
Monomode (SM) : très longues distances.
Les modules (SFP) doivent matcher le type de fibre.

Connecteurs:
LC : petit, très courant sur SFP.
SC : plus gros, courant en infrastructure.
Toujours protéger/clean (poussière = pertes).

Mots utiles: fibre, optique, sm, mm, monomode, multimode, lc, sc, emi, poussière, pertes, foh, régie.
''',
          icon: Icons.cable,
          pageBuilder: () => const AboutReseauPage(),
          anchor: null,
        ),

        // 5) SFP
        AboutSearchDoc(
          title: 'SFP / SFP+ / QSFP (modules)',
          text: '''
Repères:
SFP : souvent 1G.
SFP+ : souvent 10G.
QSFP/QSFP+ : 40G (selon usage).
Un module = vitesse + type fibre + longueur (tout doit être cohérent).

En pratique :
Prends des modules compatibles avec le switch (et idéalement du même fournisseur/modèle)
pour éviter les surprises.

Mots utiles: sfp, sfp+, qsfp, module, transceiver, 1g, 10g, 40g, compatibilité.
''',
          icon: Icons.memory,
          pageBuilder: () => const AboutReseauPage(),
          anchor: null,
        ),

        // 6) Switches
        AboutSearchDoc(
          title: 'Switches (VLAN / IGMP / QoS)',
          text: '''
Fonctions utiles en spectacle:
VLAN : séparer lumière / vidéo / IT.
IGMP snooping : indispensable si tu utilises sACN multicast à grande échelle.
QoS : utile si tu mixes beaucoup de flux (selon contexte).

Erreurs fréquentes:
Switch “cheap” qui flood le multicast → réseau qui s’écroule.
Boucle réseau sans STP → tempête de broadcast.
Wi-Fi public sur le même LAN que le show → instabilité.

Mots utiles: switch, vlan, igmp, igmp snooping, qos, multicast, flood, stp, boucle, broadcast storm.
''',
          icon: Icons.hub,
          pageBuilder: () => const AboutReseauPage(),
          anchor: null,
        ),

        // 7) Art-Net / sACN
        AboutSearchDoc(
          title: 'Art-Net / sACN sur réseau (conseils)',
          text: '''
Art-Net (terrain):
Souvent simple à mettre en place.
Broadcast possible sur petit LAN dédié, mais unicast est plus propre.
Mapping univers/ports = point numéro 1 à vérifier.

sACN (terrain):
Multicast : efficace, mais exige un switch correct (IGMP).
Priorités : utile si plusieurs sources.
Sur gros shows : sACN + IGMP est souvent le choix “propre”.

Mots utiles: art-net, artnet, sacn, sACN, unicast, broadcast, multicast, igmp, mapping, univers, ports.
''',
          icon: Icons.lightbulb_outline,
          pageBuilder: () => const AboutReseauPage(),
          anchor: null,
        ),

        // 8) Checklist
        AboutSearchDoc(
          title: 'Checklist réseau',
          text: '''
RÉSEAU — Checklist
Plan IP clair (plage / masques)
Switch correct (IGMP si sACN multicast)
VLAN si plusieurs “mondes” (lumière/vidéo/IT)
Câbles testés + étiquetés
Fibre : modules compatibles + connecteurs propres
Éviter boucles (STP) + éviter Wi-Fi public sur show LAN

Rapide:
Switch correct + câbles propres.
IGMP si sACN multicast.
Séparer les usages (VLAN).

Mots utiles: checklist, plan ip, masque, igmp, vlan, câble, étiquetage, fibre, stp, wifi public.
''',
          icon: Icons.checklist,
          pageBuilder: () => const AboutReseauPage(),
          anchor: null,
        ),
      ];
}
