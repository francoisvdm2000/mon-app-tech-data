import 'package:flutter/material.dart';

import '../../app/ui/widgets.dart'; // SectionCard, ExpandSectionCard, copyToClipboard

class AboutVideoPage extends StatefulWidget {
  const AboutVideoPage({super.key});

  @override
  State<AboutVideoPage> createState() => _AboutVideoPageState();
}

class _AboutVideoPageState extends State<AboutVideoPage> {
  final _scroll = ScrollController();

  final _kBasics = GlobalKey();
  final _kResFps = GlobalKey();
  final _kColor = GlobalKey();
  final _kSync = GlobalKey();
  final _kCables = GlobalKey();
  final _kSdi = GlobalKey();
  final _kHdmi = GlobalKey();
  final _kNdi = GlobalKey();
  final _kMappingLed = GlobalKey();
  final _kChecklist = GlobalKey();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _goTo(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      alignment: 0.06,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    final toc = <_TocEntry>[
      _TocEntry('1) Bases vidéo (mots-clés)', _kBasics),
      _TocEntry('2) Résolution & FPS', _kResFps),
      _TocEntry('3) Couleur (4:4:4 / 4:2:2 / 10-bit)', _kColor),
      _TocEntry('4) Sync (Genlock / Timecode)', _kSync),
      _TocEntry('5) Câbles & distances (coax / HDMI / fibre)', _kCables),
      _TocEntry('6) SDI (3G/6G/12G) — terrain', _kSdi),
      _TocEntry('7) HDMI — terrain', _kHdmi),
      _TocEntry('8) NDI — quand / pourquoi / limites', _kNdi),
      _TocEntry('9) Mapping / Multi-projo / LED processors', _kMappingLed),
      _TocEntry('10) Checklist terrain', _kChecklist),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Vidéo — repères terrain')),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          controller: _scroll,
          padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottom),
          child: Column(
            children: [
              _TocCard(
                title: 'Sommaire',
                icon: Icons.menu_book,
                entries: toc,
                onTapEntry: _goTo,
                onCopy: () {
                  final txt = '''
VIDÉO — repères terrain
• Résolution = taille (px). FPS = fluidité / latence.
• 4:2:2/4:4:4 + 10-bit = qualité couleur (surtout HDR / key).
• SDI = robuste + longues distances. HDMI = fragile + court.
• NDI = IP (réseau), pratique mais dépend du LAN.
• Genlock/Timecode = synchro cam/serveurs/LED.
'''.trim();
                  copyToClipboard(context, txt);
                },
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kBasics),
              ExpandSectionCard(
                title: '1) Bases vidéo (mots-clés)',
                icon: Icons.video_library,
                initiallyExpanded: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    _Paragraph(
                      "La vidéo, c’est surtout : une image (pixels) envoyée à un rythme (FPS), avec une structure couleur (sampling/bit depth), "
                      "transportée par un lien (SDI/HDMI/IP) et parfois synchronisée (genlock/timecode).",
                    ),
                    SizedBox(height: 10),
                    _Callout(
                      title: 'Vocabulaire utile',
                      bullets: [
                        'Résolution : largeur×hauteur en pixels (ex: 1920×1080).',
                        'FPS (images/s) : 25, 30, 50, 60… (plus = plus fluide).',
                        'Progressif (p) vs entrelacé (i) : aujourd’hui surtout “p”.',
                        'Codec (compression) : H.264/H.265/ProRes… (fichiers/stream).',
                        'Latency : temps entre source et écran (souvent critique en live).',
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kResFps),
              ExpandSectionCard(
                title: '2) Résolution & FPS',
                icon: Icons.aspect_ratio,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    _Callout(
                      title: 'Résolution',
                      bullets: [
                        '1080p = 1920×1080 (Full HD).',
                        '4K UHD = 3840×2160 (souvent “4K” en vidéo).',
                        'DCI 4K = 4096×2160 (cinéma, pas toujours compatible LED/TV).',
                        'Plus de pixels = plus de débit + plus de charge GPU/serveur.',
                      ],
                    ),
                    SizedBox(height: 10),
                    _Callout(
                      title: 'FPS (choix terrain)',
                      bullets: [
                        '25/50 FPS : standard Europe (broadcast).',
                        '30/60 FPS : standard US et beaucoup de devices.',
                        'Si tu mixes sources : évite de mélanger 50 et 60 sans conversion.',
                        'Plus de FPS = plus de débit (surtout en IP/NDI).',
                      ],
                    ),
                    SizedBox(height: 10),
                    _Paragraph(
                      "En live, le plus important n’est pas d’avoir “le plus haut”, mais d’avoir une chaîne stable : "
                      "même résolution, même fréquence, et un mapping clair.",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kColor),
              ExpandSectionCard(
                title: '3) Couleur (4:4:4 / 4:2:2 / 10-bit)',
                icon: Icons.palette,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    _Paragraph(
                      "La couleur vidéo est souvent comprimée : on réduit la précision couleur (chroma subsampling) "
                      "car l’œil voit mieux la luminance que la chroma.",
                    ),
                    SizedBox(height: 10),
                    _Callout(
                      title: 'Sampling',
                      bullets: [
                        '4:4:4 : couleur complète (idéal pour graphismes, textes, keying propre).',
                        '4:2:2 : très courant en pro (bon compromis).',
                        '4:2:0 : très courant sur fichiers/stream (moins bon pour textes fins).',
                      ],
                    ),
                    SizedBox(height: 10),
                    _Callout(
                      title: 'Bit depth',
                      bullets: [
                        '8-bit : standard “basic”.',
                        '10-bit : meilleur dégradé (moins de banding), utile HDR/LED/gradients.',
                      ],
                    ),
                    SizedBox(height: 10),
                    _Paragraph(
                      "Règle simple : si tu affiches des UI/typos fines sur LED, vise une chaîne la plus “propre” possible "
                      "(éviter 4:2:0 si tu peux).",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kSync),
              ExpandSectionCard(
                title: '4) Sync (Genlock / Timecode)',
                icon: Icons.sync,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    _Callout(
                      title: 'Genlock (sync vidéo)',
                      bullets: [
                        'But : synchroniser le “moment” où les images se rafraîchissent.',
                        'Utile : multi-cam, serveurs, murs LED, régie broadcast.',
                        'Sans genlock : parfois “tearing”, ou décalage cam/écran (moire / banding).',
                      ],
                    ),
                    SizedBox(height: 10),
                    _Callout(
                      title: 'Timecode (sync temporelle)',
                      bullets: [
                        'But : caler des contenus dans le temps (ex: show time, playback).',
                        'LTC/MTC/embedded selon systèmes.',
                        'Ne remplace pas genlock : ce sont 2 sujets différents.',
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kCables),
              ExpandSectionCard(
                title: '5) Câbles & distances (coax / HDMI / fibre)',
                icon: Icons.cable,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    _Callout(
                      title: 'Règles simples',
                      bullets: [
                        'HDMI : sensible, plus c’est long plus c’est risqué (qualité câble + débit).',
                        'SDI : très robuste et simple (verrouillage BNC), grandes longueurs.',
                        'Fibre : distances énormes + immunité EMI, nécessite convertisseurs/SFP.',
                      ],
                    ),
                    SizedBox(height: 10),
                    _Paragraph(
                      "En pratique, le débit dépend de la résolution/FPS/bit depth. "
                      "Donc : plus tu montes, plus il faut des câbles/convertisseurs de qualité.",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kSdi),
              ExpandSectionCard(
                title: '6) SDI (3G/6G/12G) — terrain',
                icon: Icons.settings_input_hdmi,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    _Callout(
                      title: 'SDI en bref',
                      bullets: [
                        'SDI = vidéo sur coax 75Ω (BNC).',
                        '3G-SDI : typiquement jusqu’à 1080p60.',
                        '6G-SDI : typiquement jusqu’à 2160p30.',
                        '12G-SDI : typiquement jusqu’à 2160p60 (4K60).',
                      ],
                    ),
                    SizedBox(height: 10),
                    _Callout(
                      title: 'Terrain',
                      bullets: [
                        'Avantage : robuste, connecteurs verrouillés, facile à diagnostiquer.',
                        'Attention : compatibilité (3G level A/B), convertisseurs selon devices.',
                        'Toujours un vrai câble 75Ω (pas n’importe quel coax).',
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kHdmi),
              ExpandSectionCard(
                title: '7) HDMI — terrain',
                icon: Icons.tv,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    _Callout(
                      title: 'HDMI : ce qu’on oublie souvent',
                      bullets: [
                        'EDID : l’écran “annonce” ce qu’il accepte → peut forcer du 1080p au lieu de 4K.',
                        'HDCP : protection (source peut refuser d’afficher sur certains splitters/convertisseurs).',
                        'Longueurs : au-delà, active/fibre/convertisseurs souvent nécessaires.',
                      ],
                    ),
                    SizedBox(height: 10),
                    _Callout(
                      title: 'Conseil',
                      bullets: [
                        'En show : si tu peux, convertis en SDI pour la distribution.',
                        'Si HDMI obligatoire : prévois un EDID manager et du câblage certifié.',
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kNdi),
              ExpandSectionCard(
                title: '8) NDI — quand / pourquoi / limites',
                icon: Icons.lan,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    _Paragraph(
                      "NDI est un protocole vidéo sur IP (réseau). "
                      "C’est très pratique pour router de la vidéo sans matrices physiques, mais ça dépend du LAN.",
                    ),
                    SizedBox(height: 10),
                    _Callout(
                      title: 'Avantages',
                      bullets: [
                        'Routage flexible (switches), discovery facile.',
                        'Moins de câbles vidéo dédiés, surtout en régie/stream.',
                        'Bon pour cam IP / postes de prod / retours.',
                      ],
                    ),
                    SizedBox(height: 10),
                    _Callout(
                      title: 'Limites / risques',
                      bullets: [
                        'Charge réseau (surtout en haute résol / FPS).',
                        'Latence variable selon réseau/PC.',
                        'Besoin d’un LAN propre : switch gigabit/10G, VLAN si possible.',
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kMappingLed),
              ExpandSectionCard(
                title: '9) Mapping / Multi-projo / LED processors',
                icon: Icons.grid_view,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    _Callout(
                      title: 'Multi-projo / blend (mapping)',
                      bullets: [
                        'Chaque projo couvre une zone + overlap (blend).',
                        'La mire sert à aligner géométrie + blend + niveaux.',
                        'Règle : même résolution/fps/latence entre projecteurs si possible.',
                      ],
                    ),
                    SizedBox(height: 10),
                    _Callout(
                      title: 'Mur LED (processors)',
                      bullets: [
                        'Un processor reçoit une ou plusieurs entrées vidéo et “mappe” vers la grille de tiles.',
                        'Toujours vérifier : résolution d’entrée, mapping, refresh (Hz), scaling.',
                        'Les problèmes typiques : mauvais mapping, mauvaise fréquence, cablage data inversé.',
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kChecklist),
              ExpandSectionCard(
                title: '10) Checklist terrain',
                icon: Icons.checklist,
                trailing: IconButton(
                  tooltip: 'Copier',
                  icon: const Icon(Icons.copy, color: Colors.white70),
                  onPressed: () {
                    final txt = '''
VIDÉO — Checklist
☐ Même résolution & FPS sur toute la chaîne
☐ HDMI : EDID/HDCP maîtrisés (sinon convertis en SDI)
☐ SDI : bon câble 75Ω, bon standard (3G A/B, 12G…)
☐ NDI/IP : réseau propre (switch correct, débit)
☐ Genlock/Timecode si synchro requise
☐ Mires : géométrie + focus + uniformité + blend
'''.trim();
                    copyToClipboard(context, txt);
                  },
                ),
                child: const _Callout(
                  title: 'Avant de paniquer',
                  bullets: [
                    '1) Vérifie résolution/FPS.',
                    '2) Vérifie EDID/HDCP (HDMI).',
                    '3) Test en direct source→écran.',
                    '4) Remplace câble/adaptateur suspect.',
                    '5) Simplifie la chaîne puis remonte.',
                  ],
                ),
              ),
              const SizedBox(height: 18),

              const _FooterNote(),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===== Sommaire cliquable =====

class _TocEntry {
  const _TocEntry(this.label, this.key);
  final String label;
  final GlobalKey key;
}

class _TocCard extends StatelessWidget {
  const _TocCard({
    required this.title,
    required this.icon,
    required this.entries,
    required this.onTapEntry,
    required this.onCopy,
  });

  final String title;
  final IconData icon;
  final List<_TocEntry> entries;
  final ValueChanged<GlobalKey> onTapEntry;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: title,
      icon: icon,
      trailing: IconButton(
        tooltip: 'Copier',
        icon: const Icon(Icons.copy, color: Colors.white70),
        onPressed: onCopy,
      ),
      child: Column(
        children: entries
            .map(
              (e) => _TocRow(
                label: e.label,
                onTap: () => onTapEntry(e.key),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TocRow extends StatelessWidget {
  const _TocRow({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.65)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.88),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Anchor extends StatelessWidget {
  const _Anchor({super.key});

 

  @override
  Widget build(BuildContext context) => const SizedBox(height: 0);
}

/// ===== petits helpers texte =====

class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.80),
        height: 1.35,
        fontSize: 13.5,
      ),
    );
  }
}

class _Callout extends StatelessWidget {
  const _Callout({required this.title, required this.bullets});
  final String title;
  final List<String> bullets;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontWeight: FontWeight.w900,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 8),
          ...bullets.map((s) => _Bullet(s)),
        ],
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ', style: TextStyle(color: Colors.white.withValues(alpha: 0.80), height: 1.35)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.80), height: 1.35, fontSize: 13.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Info indicative (terrain). Les capacités exactes varient selon matériels/câbles/standards.\n"
      "Objectif : repères simples + méthode fiable.",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white38, fontSize: 12, height: 1.35),
    );
  }
}
