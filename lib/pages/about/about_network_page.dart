import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../app/ui/widgets.dart'; // SectionCard, ExpandSectionCard, MiniPill, copyToClipboard

class AboutNetworkPage extends StatefulWidget {
  const AboutNetworkPage({super.key, this.initialAnchorId});

  /// ID d’ancre optionnel: 'basics', 'plan_ip', 'vlan', 'igmp', 'wifi', 'switch', 'diagrams', 'assets', 'checklist'
  final String? initialAnchorId;

  @override
  State<AboutNetworkPage> createState() => _AboutNetworkPageState();
}

class _AboutNetworkPageState extends State<AboutNetworkPage> {
  final _scrollCtrl = ScrollController();

  final _k1Basics = GlobalKey();
  final _k2PlanIp = GlobalKey();
  final _k3Vlan = GlobalKey();
  final _k4Igmp = GlobalKey();
  final _k5Wifi = GlobalKey();
  final _k6Switch = GlobalKey();
  final _k7Diagrams = GlobalKey();
  final _k7bAssets = GlobalKey();
  final _k8Checklist = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final id = widget.initialAnchorId?.trim();
      if (id == null || id.isEmpty) return;

      // Sur le web, parfois 1 frame de plus aide (transition / layout)
      Future.delayed(const Duration(milliseconds: 30), () {
        if (!mounted) return;
        _goToAnchor(id);
      });
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

  /// Mapping anchorId (provenant des index) -> GlobalKey (sur la page)
  GlobalKey? _keyForAnchor(String id) {
    switch (id) {
      case 'basics':
        return _k1Basics;
      case 'plan_ip':
        return _k2PlanIp;
      case 'vlan':
        return _k3Vlan;
      case 'igmp':
        return _k4Igmp;
      case 'wifi':
        return _k5Wifi;
      case 'switch':
        return _k6Switch;
      case 'diagrams':
        return _k7Diagrams;
      case 'assets':
        return _k7bAssets;
      case 'checklist':
        return _k8Checklist;
      default:
        return null;
    }
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
        title: const Text('Réseau lumière — VLAN, IGMP, Wi-Fi'),
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
                    'Réseau lumière: viser simple, dédié, et stable.',
                    'VLAN = séparer le trafic (lumière vs reste).',
                    'IGMP = indispensable si sACN multicast à grande échelle.',
                    'Wi-Fi = ok dépannage, rarement ok en prod critique.',
                  ].join('\n');
                  copyToClipboard(context, txt);
                },
                items: [
                  _TocItem('1) Objectif: réseau stable', onTap: () => _goTo(_k1Basics)),
                  _TocItem('2) Plan IP (simple)', onTap: () => _goTo(_k2PlanIp)),
                  _TocItem('3) VLAN (séparation)', onTap: () => _goTo(_k3Vlan)),
                  _TocItem('4) IGMP (sACN multicast)', onTap: () => _goTo(_k4Igmp)),
                  _TocItem('5) Wi-Fi vs filaire', onTap: () => _goTo(_k5Wifi)),
                  _TocItem('6) Switch: ce qu’il faut', onTap: () => _goTo(_k6Switch)),
                  _TocItem('7) Schémas', onTap: () => _goTo(_k7Diagrams)),
                  _TocItem('7bis) Images (assets)', onTap: () => _goTo(_k7bAssets)),
                  _TocItem('8) Checklist', onTap: () => _goTo(_k8Checklist)),
                ],
              ),
              const SizedBox(height: 12),

              _Anchor(key: _k1Basics),
              const _Section1Basics(),
              const SizedBox(height: 12),

              _Anchor(key: _k2PlanIp),
              const _Section2PlanIp(),
              const SizedBox(height: 12),

              _Anchor(key: _k3Vlan),
              const _Section3Vlan(),
              const SizedBox(height: 12),

              _Anchor(key: _k4Igmp),
              const _Section4Igmp(),
              const SizedBox(height: 12),

              _Anchor(key: _k5Wifi),
              const _Section5Wifi(),
              const SizedBox(height: 12),

              _Anchor(key: _k6Switch),
              const _Section6Switch(),
              const SizedBox(height: 12),

              _Anchor(key: _k7Diagrams),
              const _Section7Diagrams(),
              const SizedBox(height: 12),

              _Anchor(key: _k7bAssets),
              _Section7bAssets(
                onCopy: () {
                  final txt = '''
Assets recommandés (optionnels)
- assets/images/connectors/rj45.png
- assets/images/network/switch.png
- assets/images/network/ap.png

pubspec.yaml (exemple)
flutter:
  assets:
    - assets/images/connectors/
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
Réseau lumière — Checklist
☐ Réseau dédié ou VLAN lumière
☐ Plan IP clair (DHCP ou statique) + masque ok
☐ Switch correct; boucles évitées
☐ sACN multicast: IGMP snooping ON
☐ IGMP querier présent dans le VLAN (si infra le nécessite)
☐ Unicast en dépannage (surtout Art-Net)
☐ Wi-Fi: éviter prod critique (jitter/pertes)
☐ Tests: ping stable + charge progressive (univers)
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
      title: '1) Objectif: réseau stable',
      icon: Icons.lan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MiniPill('Dédié/VLAN'),
              MiniPill('Filaire'),
              MiniPill('IGMP si multicast'),
            ],
          ),
          SizedBox(height: 10),
          _Paragraph(
            "Un réseau lumière doit être prévisible: faible perte, faible jitter, architecture simple. "
            "Quand ça bug, c’est rarement “le protocole” et souvent l’infra (switch, Wi-Fi, boucles, flood).",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Règle de base',
            bullets: [
              'Si tu peux: filaire + switch correct + réseau dédié (ou VLAN).',
              'Si tu dois partager: VLAN + règles claires.',
              'sACN multicast: IGMP devient vite obligatoire.',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section2PlanIp extends StatelessWidget {
  const _Section2PlanIp();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '2) Plan IP (simple)',
      icon: Icons.alt_route,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            "Choisis une stratégie simple et cohérente. "
            "Deux approches: DHCP (simple) ou statique (prévisible). "
            "Le pire: un mélange non documenté.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Exemple de plan (simple)',
            bullets: [
              'VLAN lumière: 10.10.0.0/24',
              'Console/PC: 10.10.0.10',
              'Nodes: 10.10.0.100–150',
              'Switch mgmt: 10.10.0.2',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Erreurs classiques'),
          _BulletList(items: [
            'Masque différent (ex: /24 vs /16) → machines invisibles.',
            'Deux appareils même IP → comportement aléatoire.',
            'DHCP + statique sur même range sans contrôle → conflits.',
          ]),
        ],
      ),
    );
  }
}

class _Section3Vlan extends StatelessWidget {
  const _Section3Vlan();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '3) VLAN (séparation)',
      icon: Icons.layers,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            "Un VLAN te permet d’isoler la lumière du reste (internet, production vidéo, invités…). "
            "Ça évite le bruit réseau et réduit le risque qu’un autre service casse ton show.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Ce que tu gagnes',
            bullets: [
              'Moins de trafic parasite.',
              'Moins de risques (DHCP externe, broadcast non désiré).',
              'Debug plus simple (tout ce qui est dans le VLAN = lumière).',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Attention'),
          _BulletList(items: [
            'Un VLAN = il faut que tous les ports soient bien configurés (access/trunk).',
            'Si tu ne maîtrises pas: réseau dédié “physique” est souvent plus simple.',
          ]),
        ],
      ),
    );
  }
}

class _Section4Igmp extends StatelessWidget {
  const _Section4Igmp();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '4) IGMP (sACN multicast)',
      icon: Icons.hub,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MiniPill('IGMP snooping'),
              MiniPill('IGMP querier'),
              MiniPill('Multicast flood'),
            ],
          ),
          SizedBox(height: 10),
          _Paragraph(
            "IGMP snooping permet au switch de savoir quels ports veulent quel multicast. "
            "Sans ça, le multicast peut être inondé sur tous les ports → saturation.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'IGMP querier (idée simple)',
            bullets: [
              'Dans certains réseaux/VLAN, il faut un querier pour maintenir les abonnements IGMP.',
              'Sans querier: selon les switchs, les abonnements expirent et tu vois des “glitches”.',
              'Si tu es en petit réseau dédié: parfois tout marche, mais en gros réseau: c’est critique.',
            ],
          ),
          SizedBox(height: 12),
          _Subtitle('Schéma : IGMP (idée)'),
          SizedBox(height: 10),
          _DiagramBox(aspect: 16 / 6.8, painter: _IgmpPainter()),
        ],
      ),
    );
  }
}

// ... (le reste de ton fichier reste IDENTIQUE)
// Je ne recopie pas tout ici pour éviter un pavé,
// mais si tu veux je te renvoie le fichier entier d’un bloc.


class _Section5Wifi extends StatelessWidget {
  const _Section5Wifi();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '5) Wi-Fi vs filaire',
      icon: Icons.wifi,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Subtitle('Filaire'),
          _BulletList(items: [
            '✅ Latence stable, pertes faibles (si infra propre).',
            '✅ Recommandé en prod.',
          ]),
          SizedBox(height: 10),
          _Subtitle('Wi-Fi'),
          _BulletList(items: [
            '✅ Pratique (setup rapide, tablette).',
            '❌ Latence variable (jitter), pertes, interférences.',
            '❌ Multicast parfois mal géré selon AP/config.',
            'OK dépannage / petites configs non critiques, rarement OK en show chargé.',
          ]),
          SizedBox(height: 10),
          _Callout(
            title: 'Règle simple',
            bullets: [
              'Show critique = filaire.',
              'Wi-Fi = confort opérateur (UI), pas transport principal DMX/IP si gros volume.',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section6Switch extends StatelessWidget {
  const _Section6Switch();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '6) Switch: ce qu’il faut',
      icon: Icons.settings_ethernet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Callout(
            title: 'Minimum recommandé',
            bullets: [
              'Switch Ethernet correct (pas hub).',
              'Câbles OK (RJ45, connecteurs).',
              'Éviter boucles (ou STP maîtrisé).',
              'Si sACN multicast: IGMP snooping.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Managed vs unmanaged'),
          _BulletList(items: [
            'Unmanaged: ok petit réseau dédié (simple).',
            'Managed: utile pour VLAN/IGMP/diagnostics (gros réseau).',
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
          _Subtitle('VLAN: séparer lumière / reste'),
          SizedBox(height: 10),
          _DiagramBox(aspect: 16 / 6.8, painter: _VlanPainter()),
          SizedBox(height: 14),
          _Subtitle('Wi-Fi vs filaire (idée)'),
          SizedBox(height: 10),
          _DiagramBox(aspect: 16 / 6.8, painter: _WifiVsWiredPainter()),
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
          _Paragraph("Optionnel: illustrer RJ45, switch, point d’accès Wi-Fi."),
          SizedBox(height: 10),
          _AssetRow(
            items: [
              _AssetSpec(label: 'RJ45', assetPath: 'assets/images/connectors/rj45.png', hint: 'Ethernet cuivre'),
              _AssetSpec(label: 'Switch', assetPath: 'assets/images/network/switch.png', hint: 'Géré si VLAN/IGMP'),
              _AssetSpec(label: 'AP Wi-Fi', assetPath: 'assets/images/network/ap.png', hint: 'Confort UI, pas prod critique'),
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
        title: 'Avant d’ouvrir Wireshark 😄',
        bullets: [
          'Plan IP clair, masque cohérent.',
          'Réseau dédié / VLAN lumière.',
          'Switch OK, pas de boucles.',
          'IGMP pour sACN multicast.',
          'Wi-Fi évité en prod critique.',
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
            style: TextStyle(color: Colors.white.withValues(alpha: 0.92), fontWeight: FontWeight.w900, fontSize: 13.5),
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
          Text(spec.hint, style: TextStyle(color: Colors.white.withValues(alpha: 0.78), height: 1.25, fontSize: 12.5)),
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

class _VlanPainter extends CustomPainter {
  const _VlanPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _grid(canvas, size);

    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final core = Offset(size.width * 0.35, size.height * 0.50);
    final light = Offset(size.width * 0.70, size.height * 0.35);
    final other = Offset(size.width * 0.70, size.height * 0.65);

    canvas.drawLine(core, light, stroke);
    canvas.drawLine(core, other, stroke);

    _box(canvas, size, core, 'Switch core\n(trunk)', accent: true);
    _box(canvas, size, light, 'VLAN lumière\n(Art-Net/sACN)', accent: true);
    _box(canvas, size, other, 'VLAN autre\n(internet/vidéo)', accent: false);

    final tp = _Text.tp(
      'Séparer le trafic = moins de surprises',
      fontSize: size.shortestSide * 0.060,
      color: Colors.white.withValues(alpha: 0.90),
      weight: FontWeight.w900,
    );
    _Text.paintLabel(canvas, Offset(size.width * 0.06, size.height * 0.80), tp);
  }

  void _grid(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF0B0B0B));
    final faint = Paint()..color = Colors.white.withValues(alpha: 0.16)..strokeWidth = 1;
    final step = size.shortestSide / 10;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), faint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), faint);
    }
  }

  void _box(Canvas canvas, Size size, Offset center, String label, {required bool accent}) {
    final w = size.width * 0.28;
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

class _IgmpPainter extends CustomPainter {
  const _IgmpPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _grid(canvas, size);

    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final src = Offset(size.width * 0.14, size.height * 0.46);
    final sw = Offset(size.width * 0.40, size.height * 0.46);
    final rx1 = Offset(size.width * 0.86, size.height * 0.30);
    final rx2 = Offset(size.width * 0.86, size.height * 0.62);

    canvas.drawLine(src, sw, stroke);
    canvas.drawLine(sw, rx1, stroke);
    canvas.drawLine(sw, rx2, stroke);

    _box(canvas, size, src, 'Source\nmulticast', accent: false);
    _box(canvas, size, sw, 'Switch\nIGMP', accent: true);
    _box(canvas, size, rx1, 'Node RX\n(abonné)', accent: true);
    _box(canvas, size, rx2, 'Port inutile\n(non abonné)', accent: false);

    final tp = _Text.tp(
      'Avec IGMP: le port inutile ne reçoit pas',
      fontSize: size.shortestSide * 0.060,
      color: Colors.white.withValues(alpha: 0.90),
      weight: FontWeight.w900,
    );
    _Text.paintLabel(canvas, Offset(size.width * 0.06, size.height * 0.78), tp);
  }

  void _grid(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF0B0B0B));
    final faint = Paint()..color = Colors.white.withValues(alpha: 0.16)..strokeWidth = 1;
    final step = size.shortestSide / 10;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), faint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), faint);
    }
  }

  void _box(Canvas canvas, Size size, Offset center, String label, {required bool accent}) {
    final w = size.width * 0.26;
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

class _WifiVsWiredPainter extends CustomPainter {
  const _WifiVsWiredPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _grid(canvas, size);

    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final console = Offset(size.width * 0.18, size.height * 0.50);
    final sw = Offset(size.width * 0.45, size.height * 0.32);
    final ap = Offset(size.width * 0.45, size.height * 0.68);
    final node = Offset(size.width * 0.78, size.height * 0.50);

    canvas.drawLine(console, sw, stroke);
    canvas.drawLine(sw, node, stroke);

    final wifi = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 2;
    _dashedLine(canvas, console, ap, wifi, dash: 8, gap: 6);
    _dashedLine(canvas, ap, node, wifi, dash: 8, gap: 6);

    _box(canvas, size, console, 'Console', accent: false);
    _box(canvas, size, sw, 'Filaire\nstable', accent: true);
    _box(canvas, size, ap, 'Wi-Fi\njitter', accent: false);
    _box(canvas, size, node, 'Node', accent: false);

    final tp = _Text.tp(
      'Filaire = stable\nWi-Fi = variable',
      fontSize: size.shortestSide * 0.060,
      color: Colors.white.withValues(alpha: 0.90),
      weight: FontWeight.w900,
    );
    _Text.paintLabel(canvas, Offset(size.width * 0.06, size.height * 0.80), tp);
  }

  void _grid(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF0B0B0B));
    final faint = Paint()..color = Colors.white.withValues(alpha: 0.16)..strokeWidth = 1;
    final step = size.shortestSide / 10;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), faint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), faint);
    }
  }

  void _dashedLine(Canvas canvas, Offset a, Offset b, Paint paint, {double dash = 8, double gap = 6}) {
    final dx = b.dx - a.dx;
    final dy = b.dy - a.dy;
    final dist = math.sqrt(dx * dx + dy * dy);
    if (dist <= 0.001) return;
    final dir = Offset(dx / dist, dy / dist);

    double t = 0;
    while (t < dist) {
      final p1 = a + dir * t;
      final p2 = a + dir * (t + dash).clamp(0, dist);
      canvas.drawLine(p1, p2, paint);
      t += dash + gap;
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
      style: TextStyle(color: Colors.white.withValues(alpha: 0.92), fontWeight: FontWeight.w900, fontSize: 14.5),
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
      style: TextStyle(color: Colors.white.withValues(alpha: 0.80), height: 1.35, fontSize: 13.5),
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
      "Info indicative (terrain). Selon le matériel réseau, IGMP/VLAN peuvent être indispensables.\n"
      "Objectif : rester simple et robuste.",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white38, fontSize: 12, height: 1.35),
    );
  }
}

class _Text {
  static TextPainter tp(String s, {required double fontSize, required Color color, required FontWeight weight}) {
    final t = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(fontSize: fontSize, color: color, fontWeight: weight, fontFamily: 'monospace', height: 1.15),
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
      Paint()..color = Colors.white.withValues(alpha: 0.14)..style = PaintingStyle.stroke..strokeWidth = 1.5,
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
