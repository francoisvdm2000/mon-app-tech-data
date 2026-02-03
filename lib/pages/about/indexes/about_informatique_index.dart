import 'package:flutter/material.dart';

import '../about_search.dart';
import '../about_informatique_page.dart';

class AboutInformatiqueSearchIndex {
  static List<AboutSearchDoc> docs() => [
        AboutSearchDoc(
          title: 'Informatique — repères terrain (résumé)',
          text: '''
INFO — repères terrain
USB-C = forme, pas vitesse : vérifier la norme.
NVMe (M.2) bien plus rapide que SATA.
DisplayPort/HDMI = standards : attention versions/câbles.
Sur serveurs vidéo : stockage + GPU + débit = base.
''',
          icon: Icons.computer,
          pageBuilder: () => const AboutInformatiquePage(),
          anchor: null,
        ),

        AboutSearchDoc(
          title: 'USB / USB-C / Thunderbolt',
          text: '''
Point critique :
USB-C = connecteur (forme). Ça ne dit pas la vitesse.
Un câble USB-C peut être “charge only” et ne pas passer la data/vidéo.

Repères vitesses (ordre de grandeur) :
USB 2.0 : lent (claviers, dongles, petits périph).
USB 3.x : beaucoup plus rapide (disques, interfaces).
USB4 / Thunderbolt : très haut débit (dock, eGPU, vidéo selon matériel).

En show : si un périphérique “déconne”, suspecte le câble (qualité/standard) avant le device.
Mots utiles: usb, usb-c, thunderbolt, usb4, dock, egpu, câble, charge only, data, video.
''',
          icon: Icons.usb,
          pageBuilder: () => const AboutInformatiquePage(),
          anchor: null,
        ),

        AboutSearchDoc(
          title: 'Stockage — SATA / NVMe / SSD',
          text: '''
SATA vs NVMe :
SSD SATA : bon et stable, mais limité (interface ancienne).
SSD NVMe (M.2) : bien plus rapide (idéal pour serveurs média, gros fichiers).

Terrain vidéo :
Lecture de gros fichiers 4K/ProRes → NVMe recommandé.
Attention température : un NVMe peut throttler (ralentir) si ça chauffe.
Toujours tester en conditions réelles avant le show.

Mots utiles: stockage, sata, nvme, ssd, m.2, prores, 4k, température, chauffe, throttling.
''',
          icon: Icons.storage,
          pageBuilder: () => const AboutInformatiquePage(),
          anchor: null,
        ),

        AboutSearchDoc(
          title: 'Liaisons vidéo — DisplayPort / HDMI',
          text: '''
Repère important :
Les versions comptent : câble + port + device doivent être compatibles.
Longue distance = convertisseurs actifs / fibre souvent nécessaires.

DP vs HDMI (très simplifié) :
HDMI : omniprésent (TV, processors), mais EDID/HDCP peuvent gêner.
DisplayPort : très courant PC, souvent très “capable” en débit.

Mots utiles: displayport, dp, hdmi, edid, hdcp, convertisseur, actif, fibre, résolution, fps.
''',
          icon: Icons.display_settings,
          pageBuilder: () => const AboutInformatiquePage(),
          anchor: null,
        ),

        AboutSearchDoc(
          title: 'PCIe / GPU — repères',
          text: '''
Pour les serveurs vidéo / mapping : GPU + bus + drivers = stabilité.
Problèmes typiques : drivers, câbles, conversion, limitations de sorties.

Terrain :
Bloquer une version de driver stable avant un gros show.
Éviter les adaptateurs “cheap”.
Tester à la résolution/FPS réels du show.

Mots utiles: pcie, gpu, driver, drivers, mapping, serveur vidéo, stabilité, adaptateur, conversion.
''',
          icon: Icons.developer_board,
          pageBuilder: () => const AboutInformatiquePage(),
          anchor: null,
        ),

        AboutSearchDoc(
          title: 'Checklist informatique (plateau)',
          text: '''
INFO — Checklist
Câbles USB-C certifiés (data/vidéo si besoin)
Stockage adapté (NVMe si gros flux)
Drivers GPU stables (version connue)
Test résolution/FPS réels
Éviter adaptateurs cheap
''',
          icon: Icons.checklist,
          pageBuilder: () => const AboutInformatiquePage(),
          anchor: null,
        ),
      ];
}
