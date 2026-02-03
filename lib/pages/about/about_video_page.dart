import 'package:flutter/material.dart';

import '../../app/ui/widgets.dart'; // SectionCard, copyToClipboard

class AboutVideoPage extends StatefulWidget {
  const AboutVideoPage({super.key, this.initialAnchor});

  /// ID d’ancre optionnel pour arriver DIRECT à la bonne section.
  /// Valeurs possibles :
  /// - kBasics
  /// - kResFps
  /// - kColor
  /// - kSync
  /// - kCables
  /// - kSdi
  /// - kHdmi
  /// - kNdi
  /// - kMappingLed
  /// - kChecklist
  final String? initialAnchor;

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
  void initState() {
    super.initState();

    // Jump direct après le premier build (sinon les context n’existent pas)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = widget.initialAnchor;
      if (id == null || id.trim().isEmpty) return;
      _goToAnchor(id.trim());
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  GlobalKey? _keyForAnchor(String id) {
    switch (id) {
      case 'kBasics':
        return _kBasics;
      case 'kResFps':
        return _kResFps;
      case 'kColor':
        return _kColor;
      case 'kSync':
        return _kSync;
      case 'kCables':
        return _kCables;
      case 'kSdi':
        return _kSdi;
      case 'kHdmi':
        return _kHdmi;
      case 'kNdi':
        return _kNdi;
      case 'kMappingLed':
        return _kMappingLed;
      case 'kChecklist':
        return _kChecklist;
    }
    return null;
  }

  void _goToAnchor(String id) {
    final key = _keyForAnchor(id);
    if (key == null) return;
    _goTo(key);
  }

  void _goTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      alignment: 0.06,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;

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
                onCopy: () {
                  final txt = '''
VIDÉO — repères terrain
• Résolution = taille (px). FPS = fluidité / latence.
• 4:2:2 / 4:4:4 + 10-bit = qualité couleur.
• SDI = robuste + longue distance.
• HDMI = fragile + court.
• NDI = IP (réseau), dépend du LAN.
• Genlock / Timecode = synchro.
'''.trim();
                  copyToClipboard(context, txt);
                },
                items: [
                  _TocItem('1) Bases vidéo (mots-clés)', onTap: () => _goTo(_kBasics)),
                  _TocItem('2) Résolution & FPS', onTap: () => _goTo(_kResFps)),
                  _TocItem('3) Couleur (4:4:4 / 4:2:2 / 10-bit)', onTap: () => _goTo(_kColor)),
                  _TocItem('4) Sync (Genlock / Timecode)', onTap: () => _goTo(_kSync)),
                  _TocItem('5) Câbles & distances', onTap: () => _goTo(_kCables)),
                  _TocItem('6) SDI (3G / 6G / 12G)', onTap: () => _goTo(_kSdi)),
                  _TocItem('7) HDMI — terrain', onTap: () => _goTo(_kHdmi)),
                  _TocItem('8) NDI — quand / pourquoi / limites', onTap: () => _goTo(_kNdi)),
                  _TocItem('9) Mapping / LED / multi-projo', onTap: () => _goTo(_kMappingLed)),
                  _TocItem('10) Checklist terrain', onTap: () => _goTo(_kChecklist)),
                ],
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kBasics),
              const _Section1Basics(),
              const SizedBox(height: 12),

              _Anchor(key: _kResFps),
              const _Section2ResFps(),
              const SizedBox(height: 12),

              _Anchor(key: _kColor),
              const _Section3Color(),
              const SizedBox(height: 12),

              _Anchor(key: _kSync),
              const _Section4Sync(),
              const SizedBox(height: 12),

              _Anchor(key: _kCables),
              const _Section5Cables(),
              const SizedBox(height: 12),

              _Anchor(key: _kSdi),
              const _Section6Sdi(),
              const SizedBox(height: 12),

              _Anchor(key: _kHdmi),
              const _Section7Hdmi(),
              const SizedBox(height: 12),

              _Anchor(key: _kNdi),
              const _Section8Ndi(),
              const SizedBox(height: 12),

              _Anchor(key: _kMappingLed),
              const _Section9Mapping(),
              const SizedBox(height: 12),

              _Anchor(key: _kChecklist),
              _Section10Checklist(
                onCopy: () {
                  final txt = '''
VIDÉO — Checklist
☐ Même résolution & FPS partout
☐ HDMI : EDID / HDCP maîtrisés
☐ SDI : câble 75Ω + bon standard
☐ NDI/IP : LAN propre (switch, débit)
☐ Genlock / Timecode si synchro requise
☐ Tester source → écran direct
'''.trim();
                  copyToClipboard(context, txt);
                },
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

/// =======================
/// TOC (identique DMX)
/// =======================

class _TocCard extends StatelessWidget {
  const _TocCard({
    required this.items,
    required this.onCopy,
  });

  final List<_TocItem> items;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Sommaire',
      icon: Icons.menu_book,
      trailing: IconButton(
        tooltip: 'Copier résumé',
        icon: const Icon(Icons.copy, color: Colors.white70),
        onPressed: onCopy,
      ),
      child: Column(
        children: items
            .map(
              (it) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Material(
                  color: const Color(0xFF0B0B0B),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: it.onTap,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              it.label,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.92),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.55)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _TocItem {
  _TocItem(this.label, {required this.onTap});
  final String label;
  final VoidCallback onTap;
}

/// =======================
/// SECTIONS (ouvertes)
/// =======================

class _Section1Basics extends StatelessWidget {
  const _Section1Basics();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '1) Bases vidéo (mots-clés)',
      icon: Icons.video_library,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Paragraph(
            "La vidéo, c’est une image (pixels) envoyée à un rythme (FPS), avec une structure couleur "
            "(sampling / bit depth), transportée par un lien (SDI / HDMI / IP) et parfois synchronisée.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Vocabulaire utile',
            bullets: [
              'Résolution : largeur×hauteur (px).',
              'FPS : fluidité / latence.',
              'Progressif (p) vs entrelacé (i).',
              'Codec : compression (H.264, H.265…).',
              'Latency : critique en live.',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section2ResFps extends StatelessWidget {
  const _Section2ResFps();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '2) Résolution & FPS',
      icon: Icons.aspect_ratio,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Callout(
            title: 'Résolution',
            bullets: [
              '1080p = 1920×1080.',
              '4K UHD = 3840×2160.',
              'DCI 4K = 4096×2160 (cinéma).',
              'Plus de pixels = plus de débit.',
            ],
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'FPS',
            bullets: [
              '25/50 : standard Europe.',
              '30/60 : standard US / devices.',
              'Éviter de mixer 50 et 60 sans conversion.',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section3Color extends StatelessWidget {
  const _Section3Color();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '3) Couleur (4:4:4 / 4:2:2 / 10-bit)',
      icon: Icons.palette,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Callout(
            title: 'Sampling',
            bullets: [
              '4:4:4 : graphismes / keying.',
              '4:2:2 : pro courant.',
              '4:2:0 : fichiers / stream.',
            ],
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Bit depth',
            bullets: [
              '8-bit : standard.',
              '10-bit : meilleurs dégradés (HDR / LED).',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section4Sync extends StatelessWidget {
  const _Section4Sync();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '4) Sync (Genlock / Timecode)',
      icon: Icons.sync,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Callout(
            title: 'Genlock',
            bullets: [
              'Synchronise le rafraîchissement image.',
              'Utile en multi-cam / LED / broadcast.',
            ],
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Timecode',
            bullets: [
              'Synchronisation temporelle.',
              'Ne remplace pas le genlock.',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section5Cables extends StatelessWidget {
  const _Section5Cables();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '5) Câbles & distances',
      icon: Icons.cable,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Callout(
            title: 'Règles simples',
            bullets: [
              'HDMI : fragile, court.',
              'SDI : robuste, long.',
              'Fibre : très long + EMI free.',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section6Sdi extends StatelessWidget {
  const _Section6Sdi();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '6) SDI (3G / 6G / 12G)',
      icon: Icons.settings_input_hdmi,
      child: const _Callout(
        title: 'Repères',
        bullets: [
          '3G : 1080p60',
          '6G : 2160p30',
          '12G : 2160p60',
        ],
      ),
    );
  }
}

class _Section7Hdmi extends StatelessWidget {
  const _Section7Hdmi();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '7) HDMI — terrain',
      icon: Icons.tv,
      child: const _Callout(
        title: 'À surveiller',
        bullets: [
          'EDID',
          'HDCP',
          'Longueurs',
        ],
      ),
    );
  }
}

class _Section8Ndi extends StatelessWidget {
  const _Section8Ndi();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '8) NDI',
      icon: Icons.lan,
      child: const _Callout(
        title: 'IP vidéo',
        bullets: [
          'Flexible.',
          'Charge réseau.',
          'LAN propre requis.',
        ],
      ),
    );
  }
}

class _Section9Mapping extends StatelessWidget {
  const _Section9Mapping();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '9) Mapping / LED / multi-projo',
      icon: Icons.grid_view,
      child: const _Callout(
        title: 'Terrain',
        bullets: [
          'Même résolution / FPS.',
          'Mapping correct.',
          'Tester avec mires.',
        ],
      ),
    );
  }
}

class _Section10Checklist extends StatelessWidget {
  const _Section10Checklist({required this.onCopy});
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '10) Checklist terrain',
      icon: Icons.checklist,
      trailing: IconButton(
        icon: const Icon(Icons.copy, color: Colors.white70),
        onPressed: onCopy,
      ),
      child: const _Callout(
        title: 'Avant de paniquer',
        bullets: [
          'Vérifier résolution / FPS.',
          'Tester source → écran.',
          'Simplifier la chaîne.',
        ],
      ),
    );
  }
}

/// =======================
/// HELPERS
/// =======================

class _Anchor extends StatelessWidget {
  const _Anchor({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(height: 0);
}

class _Paragraph extends StatelessWidget {
  const _Paragraph(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: Colors.white.withValues(alpha: 0.80), height: 1.35, fontSize: 13.5),
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
          Text(title,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.92), fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          ...bullets.map((b) => Text('• $b',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.80), height: 1.35))),
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
      "Info indicative (terrain). Les comportements varient selon matériels.\nObjectif : comprendre vite et dépanner proprement.",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white38, fontSize: 12),
    );
  }
}
