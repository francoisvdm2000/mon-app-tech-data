import 'package:flutter/material.dart';

import '../../app/ui/widgets.dart'; // SectionCard, ExpandSectionCard, MiniPill, copyToClipboard

class AboutSacnPage extends StatefulWidget {
  const AboutSacnPage({super.key, this.initialAnchor});

  /// ID d’ancre optionnel pour arriver DIRECT à la bonne section.
  /// Valeurs possibles :
  /// - k1Basics
  /// - k2Universe
  /// - k3Multicast
  /// - k4Priorities
  /// - k5Perf
  /// - k6Rdm
  /// - k7Diagrams
  /// - k7bAssets
  /// - k8Checklist
  final String? initialAnchor;

  @override
  State<AboutSacnPage> createState() => _AboutSacnPageState();
}

class _AboutSacnPageState extends State<AboutSacnPage> {
  final _scrollCtrl = ScrollController();

  final _k1Basics = GlobalKey();
  final _k2Universe = GlobalKey();
  final _k3Multicast = GlobalKey();
  final _k4Priorities = GlobalKey();
  final _k5Perf = GlobalKey();
  final _k6Rdm = GlobalKey();
  final _k7Diagrams = GlobalKey();
  final _k7bAssets = GlobalKey();
  final _k8Checklist = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final id = widget.initialAnchor;
      if (id == null || id.trim().isEmpty) return;
      _goToAnchor(id.trim());
    });
  }

  void _goTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      alignment: 0.02,
    );
  }

  GlobalKey? _keyForAnchor(String id) {
    switch (id) {
      case 'k1Basics':
        return _k1Basics;
      case 'k2Universe':
        return _k2Universe;
      case 'k3Multicast':
        return _k3Multicast;
      case 'k4Priorities':
        return _k4Priorities;
      case 'k5Perf':
        return _k5Perf;
      case 'k6Rdm':
        return _k6Rdm;
      case 'k7Diagrams':
        return _k7Diagrams;
      case 'k7bAssets':
        return _k7bAssets;
      case 'k8Checklist':
        return _k8Checklist;
    }
    return null;
  }

  void _goToAnchor(String id) {
    final key = _keyForAnchor(id);
    if (key == null) return;
    _goTo(key);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text('sACN / E1.31 — multicast & priorités'),
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          controller: _scrollCtrl,
          padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottom),
          child: Column(
            children: [
              _TocCard(
                onCopy: () {
                  final txt = [
                    'sACN (E1.31) = DMX sur IP (UDP), standard spectacle.',
                    'Universe sACN = 1..63999 (plage standard).',
                    'Multicast: IGMP snooping recommandé, sinon flood.',
                    'Priorité: utile avec sources multiples (console + backup).',
                  ].join('\n');
                  copyToClipboard(context, txt);
                },
                items: [
                  _TocItem('1) À quoi sert sACN ?', onTap: () => _goTo(_k1Basics)),
                  _TocItem('2) Univers (numérotation)', onTap: () => _goTo(_k2Universe)),
                  _TocItem('3) Multicast / Unicast + IGMP', onTap: () => _goTo(_k3Multicast)),
                  _TocItem('4) Priorités (multi-sources)', onTap: () => _goTo(_k4Priorities)),
                  _TocItem('5) Limites / perfs', onTap: () => _goTo(_k5Perf)),
                  _TocItem('6) RDM & sACN (proxy / selon matériel)', onTap: () => _goTo(_k6Rdm)),
                  _TocItem('7) Schémas', onTap: () => _goTo(_k7Diagrams)),
                  _TocItem('7bis) Images (assets)', onTap: () => _goTo(_k7bAssets)),
                  _TocItem('8) Checklist', onTap: () => _goTo(_k8Checklist)),
                ],
              ),
              const SizedBox(height: 12),

              _Anchor(key: _k1Basics),
              const _Section1Basics(),
              const SizedBox(height: 12),

              _Anchor(key: _k2Universe),
              const _Section2Universe(),
              const SizedBox(height: 12),

              _Anchor(key: _k3Multicast),
              const _Section3Multicast(),
              const SizedBox(height: 12),

              _Anchor(key: _k4Priorities),
              const _Section4Priorities(),
              const SizedBox(height: 12),

              _Anchor(key: _k5Perf),
              const _Section5Perf(),
              const SizedBox(height: 12),

              _Anchor(key: _k6Rdm),
              const _Section6Rdm(),
              const SizedBox(height: 12),

              _Anchor(key: _k7Diagrams),
              const _Section7Diagrams(),
              const SizedBox(height: 12),

              _Anchor(key: _k7bAssets),
              _Section7bAssets(
                onCopy: () {
                  final txt = '''
Assets recommandés (optionnels)
- assets/images/network/switch.png
- assets/images/network/igmp.png
- assets/images/network/node.png

pubspec.yaml (exemple)
flutter:
  assets:
    - assets/images/network/
'''.trim();
                  copyToClipboard(context, txt);
                },
              ),
              const SizedBox(height: 12),

              _Anchor(key: _k8Checklist),
              _Section8Checklist(
                onCopy: () {
                  final txt = '''
sACN (E1.31) — Checklist terrain
☐ Switch correct (idéalement manageable)
☐ IGMP snooping activé si multicast
☐ (Si possible) IGMP querier présent dans le VLAN (sinon comportements bizarres possibles)
☐ Unicast si réseau non maîtrisé / dépannage
☐ Priorités: vérifier sources multiples (console/backup)
☐ Mapping univers ↔ ports node vérifié
☐ Wi-Fi évité en prod
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
/// SECTIONS
/// =======================

class _Section1Basics extends StatelessWidget {
  const _Section1Basics();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '1) À quoi sert sACN ?',
      icon: Icons.wifi_tethering,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MiniPill('UDP'),
              MiniPill('Multicast'),
              MiniPill('Priorité'),
            ],
          ),
          SizedBox(height: 10),
          _Paragraph(
            "sACN (E1.31) est un standard largement utilisé pour transporter des univers DMX sur IP. "
            "Il est souvent privilégié quand on veut une architecture réseau propre: multicast bien géré, "
            "priorités standardisées, et un comportement plus “réseau pro”.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Quand c’est top',
            bullets: [
              'Beaucoup d’univers sur un réseau bien géré.',
              'Installations / gros réseaux avec plusieurs sources (priorités).',
              'Quand tu veux éviter le “broadcast partout”.',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section2Universe extends StatelessWidget {
  const _Section2Universe();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '2) Univers (numérotation)',
      icon: Icons.confirmation_number,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MiniPill('Universe 1..63999'),
              MiniPill('512 slots/universe'),
            ],
          ),
          SizedBox(height: 10),
          _Paragraph(
            "Un univers sACN correspond à un univers DMX: jusqu’à 512 slots. "
            "La numérotation sACN standard est 1..63999. "
            "En pratique, l’important est le mapping console ↔ node ↔ port DMX.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Erreur classique',
            bullets: [
              'Tu changes le numéro d’univers côté console, mais pas côté node (ou inverse).',
              'Tu patches “Universe 0” alors que le matériel attend une base 1.',
              'Tu mélanges des conventions de numérotation entre outils.',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section3Multicast extends StatelessWidget {
  const _Section3Multicast();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '3) Multicast / Unicast + IGMP',
      icon: Icons.hub,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            "sACN utilise souvent le multicast: chaque univers “vit” sur un groupe multicast, "
            "et les nodes s’abonnent aux univers dont ils ont besoin.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'IGMP snooping (pourquoi c’est important)',
            bullets: [
              'Sans IGMP: le switch “flood” le multicast partout → surcharge possible.',
              'Avec IGMP: le switch envoie seulement aux ports abonnés → réseau stable.',
              'Sur gros volumes: IGMP est souvent LA différence entre “ça marche” et “c’est l’enfer”.',
            ],
          ),
          SizedBox(height: 12),
          _Subtitle('Schéma : multicast & IGMP'),
          SizedBox(height: 10),
          _DiagramBox(aspect: 16 / 6.8, painter: _SacnMulticastPainter()),
          SizedBox(height: 10),
          _Subtitle('Unicast (option)'),
          _BulletList(items: [
            'Possible selon consoles/nodes.',
            'Utile en dépannage ou si réseau multicast non maîtrisé.',
            'Moins élégant mais parfois plus simple.',
          ]),
        ],
      ),
    );
  }
}

class _Section4Priorities extends StatelessWidget {
  const _Section4Priorities();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '4) Priorités (multi-sources)',
      icon: Icons.priority_high,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MiniPill('Source A prio 100'),
              MiniPill('Source B prio 90'),
            ],
          ),
          SizedBox(height: 10),
          _Paragraph(
            "sACN gère une notion de priorité: si plusieurs sources envoient le même univers, "
            "le récepteur garde la source la plus prioritaire. "
            "Très utile avec une console principale + une console backup + un media server.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Pièges',
            bullets: [
              'Deux sources non voulues sur le même univers → “ça se bat”.',
              'Priorité mal réglée → backup qui prend le dessus.',
              'Debug: couper une source et vérifier qui gagne.',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section5Perf extends StatelessWidget {
  const _Section5Perf();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '5) Limites / perfs',
      icon: Icons.speed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MiniPill('IGMP'),
              MiniPill('Switch'),
              MiniPill('Wi-Fi non'),
              MiniPill('CPU node'),
            ],
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Ce qui casse en premier',
            bullets: [
              'Multicast sans IGMP → flood.',
              'Switch non adapté (buffers/CPU) → pertes.',
              'Wi-Fi → jitter/pertes.',
              'Nodes limités (ports, firmware).',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Règles simples'),
          _BulletList(items: [
            'Switch géré + IGMP snooping si beaucoup d’univers.',
            'VLAN dédié lumière si possible.',
            'Unicast pour isoler en dépannage.',
          ]),
        ],
      ),
    );
  }
}

class _Section6Rdm extends StatelessWidget {
  const _Section6Rdm();

  @override
  Widget build(BuildContext context) {
    return ExpandSectionCard(
      title: '6) RDM & sACN (proxy / selon matériel)',
      icon: Icons.settings_input_component,
      initiallyExpanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            "Comme avec Art-Net, le RDM “sur IP” dépend souvent d’un mécanisme de proxy dans les nodes. "
            "Le standard sACN n’implique pas automatiquement que ton node fait du RDM correctement.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'À vérifier dans la doc du node',
            bullets: [
              'Support RDM proxy / RDM over IP.',
              'Limitations (discovery only, commandes partielles).',
              'Compatibilité avec splitters/opto côté DMX.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Méthode terrain'),
          _BulletList(items: [
            'Stabiliser DMX sans RDM.',
            'Tester RDM sur une ligne simple et propre.',
            'Si soucis: désactiver RDM, puis isoler node/splitter.',
          ]),
        ],
      ),
    );
  }
}

class _Section7Diagrams extends StatelessWidget {
  const _Section7Diagrams();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '7) Schémas',
      icon: Icons.schema,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Subtitle('Multicast + IGMP (idée)'),
          SizedBox(height: 10),
          _DiagramBox(aspect: 16 / 6.8, painter: _SacnMulticastPainter()),
          SizedBox(height: 14),
          _Subtitle('Priorités (2 sources)'),
          SizedBox(height: 10),
          _DiagramBox(aspect: 16 / 6.8, painter: _SacnPriorityPainter()),
        ],
      ),
    );
  }
}

class _Section7bAssets extends StatelessWidget {
  const _Section7bAssets({required this.onCopy});

  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return ExpandSectionCard(
      title: '7bis) Images (assets)',
      icon: Icons.image_outlined,
      trailing: IconButton(
        tooltip: 'Copier liste assets',
        icon: const Icon(Icons.copy, color: Colors.white70),
        onPressed: onCopy,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Paragraph("Optionnel: illustrer switch/IGMP/nodes avec des assets locaux."),
          SizedBox(height: 10),
          _AssetRow(
            items: [
              _AssetSpec(
                label: 'Switch',
                assetPath: 'assets/images/network/switch.png',
                hint: 'Managed = utile si IGMP/VLAN',
              ),
              _AssetSpec(
                label: 'IGMP',
                assetPath: 'assets/images/network/igmp.png',
                hint: 'Snooping/Querier',
              ),
              _AssetSpec(
                label: 'Node',
                assetPath: 'assets/images/network/node.png',
                hint: 'IP → DMX',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section8Checklist extends StatelessWidget {
  const _Section8Checklist({required this.onCopy});

  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '8) Checklist',
      icon: Icons.checklist,
      trailing: IconButton(
        tooltip: 'Copier',
        icon: const Icon(Icons.copy, color: Colors.white70),
        onPressed: onCopy,
      ),
      child: const _Callout(
        title: 'Avant d’accuser “le protocole”',
        bullets: [
          'IGMP snooping activé si multicast.',
          'VLAN dédié si possible.',
          'Unicast en dépannage.',
          'Priorités cohérentes si multi-sources.',
          'Wi-Fi évité en prod.',
        ],
      ),
    );
  }
}

/// =======================
/// DIAGRAM BOX + ASSETS
/// =======================

class _DiagramBox extends StatelessWidget {
  const _DiagramBox({required this.painter, this.aspect = 16 / 7});

  final CustomPainter painter;
  final double aspect;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspect,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF0B0B0B),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: CustomPaint(painter: painter),
        ),
      ),
    );
  }
}

class _AssetSpec {
  const _AssetSpec({required this.label, required this.assetPath, required this.hint});
  final String label;
  final String assetPath;
  final String hint;
}

class _AssetRow extends StatelessWidget {
  const _AssetRow({required this.items});
  final List<_AssetSpec> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, c) {
        final isNarrow = c.maxWidth < 520;
        if (isNarrow) {
          return Column(
            children: items
                .map((it) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _AssetTile(spec: it),
                    ))
                .toList(),
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < items.length; i++) ...[
              Expanded(child: _AssetTile(spec: items[i])),
              if (i != items.length - 1) const SizedBox(width: 10),
            ],
          ],
        );
      },
    );
  }
}

class _AssetTile extends StatelessWidget {
  const _AssetTile({required this.spec});
  final _AssetSpec spec;

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
            spec.label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontWeight: FontWeight.w900,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 8),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: Image.asset(
                  spec.assetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stack) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.image_not_supported, color: Colors.white.withValues(alpha: 0.45)),
                          const SizedBox(height: 6),
                          Text(
                            'Asset manquant',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            spec.hint,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.78), height: 1.25, fontSize: 12.5),
          ),
          const SizedBox(height: 8),
          Text(
            spec.assetPath,
            style: TextStyle(fontFamily: 'monospace', fontSize: 11.8, color: Colors.white.withValues(alpha: 0.55)),
          ),
        ],
      ),
    );
  }
}

/// =======================
/// DIAGRAMS
/// =======================

class _SacnMulticastPainter extends CustomPainter {
  const _SacnMulticastPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _grid(canvas, size);

    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final src = Offset(size.width * 0.14, size.height * 0.46);
    final sw = Offset(size.width * 0.40, size.height * 0.46);
    final group = Offset(size.width * 0.60, size.height * 0.46);

    final r1 = Offset(size.width * 0.86, size.height * 0.22);
    final r2 = Offset(size.width * 0.86, size.height * 0.46);
    final r3 = Offset(size.width * 0.86, size.height * 0.70);

    canvas.drawLine(src, sw, stroke);
    canvas.drawLine(sw, group, stroke);
    canvas.drawLine(group, r1, stroke);
    canvas.drawLine(group, r2, stroke);
    canvas.drawLine(group, r3, stroke);

    _box(canvas, size, src, 'Source\nsACN', accent: false);
    _box(canvas, size, sw, 'Switch\nIGMP snooping', accent: true);
    _box(canvas, size, group, 'Multicast\nUniverse U', accent: true);

    _small(canvas, size, r1, 'RX');
    _small(canvas, size, r2, 'RX');
    _small(canvas, size, r3, 'RX');

    final tp = _Text.tp(
      'Sans IGMP: flood\nAvec IGMP: seulement abonnés',
      fontSize: size.shortestSide * 0.060,
      color: Colors.white.withValues(alpha: 0.90),
      weight: FontWeight.w900,
    );
    _Text.paintLabel(canvas, Offset(size.width * 0.06, size.height * 0.75), tp);
  }

  void _grid(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF0B0B0B));
    final faint = Paint()
      ..color = Colors.white.withValues(alpha: 0.16)
      ..strokeWidth = 1;
    final step = size.shortestSide / 10;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), faint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), faint);
    }
  }

  void _box(Canvas canvas, Size size, Offset center, String label, {required bool accent}) {
    final w = size.width * 0.22;
    final h = size.height * 0.22;
    final rect = Rect.fromCenter(center: center, width: w, height: h);
    final rr = RRect.fromRectAndRadius(rect, Radius.circular(size.shortestSide * 0.05));

    final fill = Paint()
      ..color = accent ? const Color(0xFF1E88E5).withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.08);
    final border = Paint()
      ..color = accent ? const Color(0xFF1E88E5).withValues(alpha: 0.60) : Colors.white.withValues(alpha: 0.30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(rr, fill);
    canvas.drawRRect(rr, border);

    final tp = _Text.tp(
      label,
      fontSize: size.shortestSide * 0.052,
      color: Colors.white.withValues(alpha: 0.95),
      weight: FontWeight.w900,
    );
    _Text.center(canvas, rect, tp);
  }

  void _small(Canvas canvas, Size size, Offset center, String label) {
    final w = size.width * 0.08;
    final h = size.height * 0.12;
    final rect = Rect.fromCenter(center: center, width: w, height: h);
    final rr = RRect.fromRectAndRadius(rect, Radius.circular(size.shortestSide * 0.04));

    canvas.drawRRect(rr, Paint()..color = Colors.white.withValues(alpha: 0.07));
    canvas.drawRRect(
      rr,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.20)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final tp = _Text.tp(
      label,
      fontSize: size.shortestSide * 0.05,
      color: Colors.white.withValues(alpha: 0.90),
      weight: FontWeight.w900,
    );
    _Text.center(canvas, rect, tp);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SacnPriorityPainter extends CustomPainter {
  const _SacnPriorityPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _grid(canvas, size);

    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final a = Offset(size.width * 0.14, size.height * 0.30);
    final b = Offset(size.width * 0.14, size.height * 0.62);
    final sw = Offset(size.width * 0.40, size.height * 0.46);
    final rx = Offset(size.width * 0.80, size.height * 0.46);

    canvas.drawLine(a, sw, stroke);
    canvas.drawLine(b, sw, stroke);
    canvas.drawLine(sw, rx, stroke);

    _box(canvas, size, a, 'Source A\nprio 100', accent: true);
    _box(canvas, size, b, 'Source B\nprio 90', accent: false);
    _box(canvas, size, sw, 'Switch', accent: false);
    _box(canvas, size, rx, 'Récepteur\n(prend A)', accent: true);

    final tp = _Text.tp(
      'Le récepteur choisit la source la plus prioritaire',
      fontSize: size.shortestSide * 0.060,
      color: Colors.white.withValues(alpha: 0.90),
      weight: FontWeight.w900,
    );
    _Text.paintLabel(canvas, Offset(size.width * 0.06, size.height * 0.78), tp);
  }

  void _grid(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF0B0B0B));
    final faint = Paint()
      ..color = Colors.white.withValues(alpha: 0.16)
      ..strokeWidth = 1;
    final step = size.shortestSide / 10;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), faint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), faint);
    }
  }

  void _box(Canvas canvas, Size size, Offset center, String label, {required bool accent}) {
    final w = size.width * 0.24;
    final h = size.height * 0.22;
    final rect = Rect.fromCenter(center: center, width: w, height: h);
    final rr = RRect.fromRectAndRadius(rect, Radius.circular(size.shortestSide * 0.05));

    final fill = Paint()
      ..color = accent ? const Color(0xFF1E88E5).withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.08);
    final border = Paint()
      ..color = accent ? const Color(0xFF1E88E5).withValues(alpha: 0.60) : Colors.white.withValues(alpha: 0.30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(rr, fill);
    canvas.drawRRect(rr, border);

    final tp = _Text.tp(
      label,
      fontSize: size.shortestSide * 0.050,
      color: Colors.white.withValues(alpha: 0.95),
      weight: FontWeight.w900,
    );
    _Text.center(canvas, rect, tp);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// =======================
/// SMALL UI HELPERS
/// =======================

class _Anchor extends StatelessWidget {
  const _Anchor({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(height: 0);
}

class _Subtitle extends StatelessWidget {
  const _Subtitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.92),
        fontWeight: FontWeight.w900,
        fontSize: 14.5,
      ),
    );
  }
}

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

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items
          .map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ', style: TextStyle(color: Colors.white.withValues(alpha: 0.80), height: 1.35)),
                  Expanded(
                    child: Text(
                      s,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.80), height: 1.35, fontSize: 13.5),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
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
            style: TextStyle(color: Colors.white.withValues(alpha: 0.92), fontWeight: FontWeight.w900, fontSize: 13.5),
          ),
          const SizedBox(height: 8),
          _BulletList(items: bullets),
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
      "Info indicative (terrain). Les comportements dépendent des switchs (IGMP), nodes et firmwares.\n"
      "Objectif : comprendre et stabiliser un réseau sACN.",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white38, fontSize: 12, height: 1.35),
    );
  }
}

class _Text {
  static TextPainter tp(
    String s, {
    required double fontSize,
    required Color color,
    required FontWeight weight,
  }) {
    final t = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: weight,
          fontFamily: 'monospace',
          height: 1.15,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );
    t.layout();
    return t;
  }

  static void center(Canvas canvas, Rect rect, TextPainter tp) {
    final dx = rect.left + (rect.width - tp.width) / 2;
    final dy = rect.top + (rect.height - tp.height) / 2;
    tp.paint(canvas, Offset(dx, dy));
  }

  static void paintLabel(Canvas canvas, Offset pos, TextPainter tp) {
    final pad = 10.0;
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(pos.dx, pos.dy, tp.width + pad * 2, tp.height + pad * 2),
      const Radius.circular(12),
    );

    canvas.drawRRect(r, Paint()..color = Colors.black.withValues(alpha: 0.45));
    canvas.drawRRect(
      r,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.14)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    tp.paint(canvas, Offset(pos.dx + pad, pos.dy + pad));
  }
}

/// =======================
/// TOC
/// =======================

class _TocCard extends StatelessWidget {
  const _TocCard({required this.items, required this.onCopy});

  final List<_TocItem> items;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Sommaire',
      icon: Icons.list_alt,
      trailing: IconButton(
        tooltip: 'Copier repères',
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
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.92), fontWeight: FontWeight.w800),
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
