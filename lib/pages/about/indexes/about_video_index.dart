import 'package:flutter/material.dart';

import '../about_search.dart';
import '../about_video_page.dart';

class AboutVideoSearchIndex {
  static List<AboutSearchDoc> docs() => [
        // Mémo (toc copy)
        AboutSearchDoc(
          title: 'Vidéo — mémo',
          text: '''
VIDÉO — repères terrain
• Résolution = taille (px). FPS = fluidité / latence.
• 4:2:2 / 4:4:4 + 10-bit = qualité couleur.
• SDI = robuste + longue distance.
• HDMI = fragile + court.
• NDI = IP (réseau), dépend du LAN.
• Genlock / Timecode = synchro.
''',
          icon: Icons.menu_book,
          pageBuilder: () => const AboutVideoPage(),
          anchor: null,
        ),

        // 1) Bases vidéo (mots-clés)
        AboutSearchDoc(
          title: 'Bases vidéo (mots-clés)',
          text: '''
La vidéo, c’est une image (pixels) envoyée à un rythme (FPS), avec une structure couleur
(sampling / bit depth), transportée par un lien (SDI / HDMI / IP) et parfois synchronisée.

Vocabulaire utile:
- Résolution : largeur×hauteur (px).
- FPS : fluidité / latence.
- Progressif (p) vs entrelacé (i).
- Codec : compression (H.264, H.265…).
- Latency : critique en live.
''',
          icon: Icons.video_library,
          pageBuilder: () => const AboutVideoPage(),
          anchor: null,
        ),

        // 2) Résolution & FPS
        AboutSearchDoc(
          title: 'Résolution & FPS',
          text: '''
Résolution:
- 1080p = 1920×1080.
- 4K UHD = 3840×2160.
- DCI 4K = 4096×2160 (cinéma).
- Plus de pixels = plus de débit.

FPS:
- 25/50 : standard Europe.
- 30/60 : standard US / devices.
- Éviter de mixer 50 et 60 sans conversion.
''',
          icon: Icons.aspect_ratio,
          pageBuilder: () => const AboutVideoPage(),
          anchor: null,
        ),

        // 3) Couleur (4:4:4 / 4:2:2 / 10-bit)
        AboutSearchDoc(
          title: 'Couleur (4:4:4 / 4:2:2 / 10-bit)',
          text: '''
Sampling:
- 4:4:4 : graphismes / keying.
- 4:2:2 : pro courant.
- 4:2:0 : fichiers / stream.

Bit depth:
- 8-bit : standard.
- 10-bit : meilleurs dégradés (HDR / LED).
''',
          icon: Icons.palette,
          pageBuilder: () => const AboutVideoPage(),
          anchor: null,
        ),

        // 4) Sync (Genlock / Timecode)
        AboutSearchDoc(
          title: 'Sync (Genlock / Timecode)',
          text: '''
Genlock:
- Synchronise le rafraîchissement image.
- Utile en multi-cam / LED / broadcast.

Timecode:
- Synchronisation temporelle.
- Ne remplace pas le genlock.
''',
          icon: Icons.sync,
          pageBuilder: () => const AboutVideoPage(),
          anchor: null,
        ),

        // 5) Câbles & distances
        AboutSearchDoc(
          title: 'Câbles & distances',
          text: '''
Règles simples:
- HDMI : fragile, court.
- SDI : robuste, long.
- Fibre : très long + EMI free.
''',
          icon: Icons.cable,
          pageBuilder: () => const AboutVideoPage(),
          anchor: null,
        ),

        // 6) SDI (3G / 6G / 12G)
        AboutSearchDoc(
          title: 'SDI (3G / 6G / 12G)',
          text: '''
Repères:
- 3G : 1080p60
- 6G : 2160p30
- 12G : 2160p60
''',
          icon: Icons.settings_input_hdmi,
          pageBuilder: () => const AboutVideoPage(),
          anchor: null,
        ),

        // 7) HDMI — terrain
        AboutSearchDoc(
          title: 'HDMI — terrain',
          text: '''
À surveiller:
- EDID
- HDCP
- Longueurs
''',
          icon: Icons.tv,
          pageBuilder: () => const AboutVideoPage(),
          anchor: null,
        ),

        // 8) NDI
        AboutSearchDoc(
          title: 'NDI (vidéo sur IP)',
          text: '''
IP vidéo:
- Flexible.
- Charge réseau.
- LAN propre requis.
''',
          icon: Icons.lan,
          pageBuilder: () => const AboutVideoPage(),
          anchor: null,
        ),

        // 9) Mapping / LED / multi-projo
        AboutSearchDoc(
          title: 'Mapping / LED / multi-projo',
          text: '''
Terrain:
- Même résolution / FPS.
- Mapping correct.
- Tester avec mires.
''',
          icon: Icons.grid_view,
          pageBuilder: () => const AboutVideoPage(),
          anchor: null,
        ),

        // 10) Checklist terrain
        AboutSearchDoc(
          title: 'Vidéo — checklist terrain',
          text: '''
VIDÉO — Checklist
☐ Même résolution & FPS partout
☐ HDMI : EDID / HDCP maîtrisés
☐ SDI : câble 75Ω + bon standard
☐ NDI/IP : LAN propre (switch, débit)
☐ Genlock / Timecode si synchro requise
☐ Tester source → écran direct

Avant de paniquer:
- Vérifier résolution / FPS.
- Tester source → écran.
- Simplifier la chaîne.
''',
          icon: Icons.checklist,
          pageBuilder: () => const AboutVideoPage(),
          anchor: null,
        ),
      ];
}
