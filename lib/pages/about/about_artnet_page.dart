import 'package:flutter/material.dart';

import '../../app/ui/widgets.dart'; // SectionCard, ExpandSectionCard, MiniPill, copyToClipboard

class AboutArtNetPage extends StatefulWidget {
  const AboutArtNetPage({super.key});

  @override
  State<AboutArtNetPage> createState() => _AboutArtNetPageState();
}

class _AboutArtNetPageState extends State<AboutArtNetPage> {
  final _scrollCtrl = ScrollController();

  final _k1Basics = GlobalKey();
  final _k2Addressing = GlobalKey();
  final _k3Limits = GlobalKey();
  final _k4NodesRdm = GlobalKey();
  final _k5Troubleshooting = GlobalKey();
  final _k6Diagrams = GlobalKey();
  final _k6bAssets = GlobalKey();
  final _k7Checklist = GlobalKey();

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
        title: const Text('Art-Net — univers DMX sur IP (simple & complet)'),
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
                    'Art-Net = DMX sur Ethernet via UDP.',
                    'Échelle: beaucoup d’univers via nodes (DMX-out) distribués.',
                    'Diffusion: broadcast (simple mais flood) ou unicast (plus propre).',
                    'Limites réelles: Wi-Fi, switch basique, firmware nodes, réglages univers/mapping.',
                    'RDM: possible via “RDM proxy” selon nodes (support variable).',
                  ].join('\n');
                  copyToClipboard(context, txt);
                },
                items: [
                  _TocItem('1) Art-Net — c’est quoi et pourquoi', onTap: () => _goTo(_k1Basics)),
                  _TocItem('2) Adressage & univers — mapping propre', onTap: () => _goTo(_k2Addressing)),
                  _TocItem('3) Limites & perf — ce qui casse en premier', onTap: () => _goTo(_k3Limits)),
                  _TocItem('4) Nodes, splitters & RDM', onTap: () => _goTo(_k4NodesRdm)),
                  _TocItem('5) Dépannage — symptômes → causes', onTap: () => _goTo(_k5Troubleshooting)),
                  _TocItem('6) Schémas (réseau / unicast vs broadcast)', onTap: () => _goTo(_k6Diagrams)),
                  _TocItem('6bis) Images (assets) — RJ45/switch/câbles', onTap: () => _goTo(_k6bAssets)),
                  _TocItem('7) Checklist rapide', onTap: () => _goTo(_k7Checklist)),
                ],
              ),

              const SizedBox(height: 12),

              _Anchor(key: _k1Basics),
              const _Section1Basics(),
              const SizedBox(height: 12),

              _Anchor(key: _k2Addressing),
              const _Section2Addressing(),
              const SizedBox(height: 12),

              _Anchor(key: _k3Limits),
              const _Section3Limits(),
              const SizedBox(height: 12),

              _Anchor(key: _k4NodesRdm),
              const _Section4NodesRdm(),
              const SizedBox(height: 12),

              _Anchor(key: _k5Troubleshooting),
              const _Section5Troubleshooting(),
              const SizedBox(height: 12),

              _Anchor(key: _k6Diagrams),
              const _Section6Diagrams(),
              const SizedBox(height: 12),

              _Anchor(key: _k6bAssets),
              _Section6bAssets(
                onCopy: () {
                  final txt = '''
Assets recommandés (optionnels)
- assets/images/connectors/rj45.png
- assets/images/network/switch.png
- assets/images/cables/ethernet_cat5e_cat6.png
- assets/images/cables/ethernet_short_patch.png

pubspec.yaml (exemple)
flutter:
  assets:
    - assets/images/connectors/
    - assets/images/network/
    - assets/images/cables/
'''.trim();
                  copyToClipboard(context, txt);
                },
              ),
              const SizedBox(height: 12),

              _Anchor(key: _k7Checklist),
              _Section7Checklist(
                onCopy: () {
                  final txt = '''
Art-Net — Checklist terrain
☐ Réseau dédié si possible (ou VLAN)
☐ IP plan clair (DHCP vs statique), masque cohérent
☐ Unicast si réseau chargé (éviter broadcast flood)
☐ Univers ↔ node/port vérifiés (mapping)
☐ Switch correct (éviter hubs / vieux switchs instables)
☐ Wi-Fi évité si show critique (préférer filaire)
☐ Si RDM: node “RDM proxy” confirmé + câblage DMX stable
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
      title: '1) Art-Net — c’est quoi et pourquoi',
      icon: Icons.router,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MiniPill('UDP'),
              MiniPill('Univers DMX sur IP'),
              MiniPill('Nodes DMX-out'),
            ],
          ),
          SizedBox(height: 10),
          _Paragraph(
            "Art-Net transporte des univers DMX sur un réseau Ethernet (IP). "
            "Au lieu de tirer une ligne DMX par univers, tu envoies des “paquets” sur le réseau, "
            "et un node convertit en DMX près des machines.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Pourquoi c’est utile',
            bullets: [
              'Scalable : beaucoup d’univers sur un seul câble réseau.',
              'Distribution : nodes proches des projecteurs/dimmers → moins de longues lignes DMX.',
              'Patch flexible : changer un univers ou déplacer un node est rapide.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Deux mots à retenir'),
          _BulletList(items: [
            'Art-Net ne remplace pas le DMX : il le transporte sur IP.',
            'La stabilité dépend souvent plus du réseau (switch, Wi-Fi, broadcast) que du protocole.',
          ]),
        ],
      ),
    );
  }
}

class _Section2Addressing extends StatelessWidget {
  const _Section2Addressing();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '2) Adressage & univers — mapping propre',
      icon: Icons.map,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MiniPill('Univers'),
              MiniPill('Node / Port'),
              MiniPill('Mapping'),
            ],
          ),
          SizedBox(height: 10),
          _Paragraph(
            "Ton objectif : que chaque univers émis par la source arrive au bon node (et au bon port DMX) "
            "sans ambiguïté. La plupart des pannes Art-Net = mauvais univers, mauvais subnet/net, ou broadcast qui sature.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Méthode simple (qui évite 80% des erreurs)',
            bullets: [
              '1) Écris sur papier: “Univers 1 → Node A port 1”, “Univers 2 → Node A port 2”, etc.',
              '2) Mets des IP stables (DHCP réservé ou statiques).',
              '3) Préfère l’unicast si tu as plus d’un node ou un réseau partagé.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Broadcast vs Unicast'),
          _BulletList(items: [
            'Broadcast : tu envoies à tout le monde → facile mais peut “flood” un switch.',
            'Unicast : tu envoies vers l’IP du node → plus propre et prévisible.',
            'En show: si doute → unicast.',
          ]),
          SizedBox(height: 10),
          _Subtitle('Univers : pratique terrain'),
          _BulletList(items: [
            'Garde une numérotation simple (ex: 1…N).',
            'Évite “un univers partout” : documente tes mappings.',
            'Sur certains setups, “Net/Subnet/Universe” existent : pense “mapping”, pas “magie”.',
          ]),
        ],
      ),
    );
  }
}

class _Section3Limits extends StatelessWidget {
  const _Section3Limits();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '3) Limites & perf — ce qui casse en premier',
      icon: Icons.speed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Callout(
            title: 'Les limites “réelles” (dans l’ordre)',
            bullets: [
              'Wi-Fi : latence variable + pertes → flicker ou décrochages.',
              'Broadcast : surcharge un LAN (tout le monde reçoit tout).',
              'Switch “bas de gamme” : buffers limités, gestion multicast/broadcast médiocre.',
              'Nodes : limite firmware/CPU (nb d’univers, fréquence, options).',
              'PC/source : driver, charge CPU, antivirus, carte réseau, etc.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Vitesse de refresh'),
          _BulletList(items: [
            'Le DMX “classique” est souvent ~20–44 fps selon trame.',
            'Sur IP, tu peux envoyer plus, mais les nodes ne suivent pas toujours (et ce n’est pas toujours utile).',
            'Stabilité > fréquence : mieux vaut stable à 30–40 fps que “vite” mais instable.',
          ]),
          SizedBox(height: 10),
          _Subtitle('Règles simples'),
          _BulletList(items: [
            'Réseau dédié (ou VLAN).',
            'Unicast si plusieurs nodes.',
            'Filaire pour les shows critiques.',
          ]),
        ],
      ),
    );
  }
}

class _Section4NodesRdm extends StatelessWidget {
  const _Section4NodesRdm();

  @override
  Widget build(BuildContext context) {
    return ExpandSectionCard(
      title: '4) Nodes, splitters & RDM',
      icon: Icons.device_hub,
      initiallyExpanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            "Un node = IP → DMX. Il peut avoir 1, 2, 4, 8 ports DMX. "
            "La stabilité dépend du node ET du câblage DMX côté sortie (terminaison, topologie, splitters).",
          ),
          SizedBox(height: 10),
          _Subtitle('Nodes vs Splitters'),
          _BulletList(items: [
            'Node : convertit IP→DMX (et parfois DMX→IP).',
            'Splitter DMX : distribue une ligne DMX en branches (opto conseillé).',
            'Bon design : IP jusqu’au plus près, puis DMX court et propre.',
          ]),
          SizedBox(height: 10),
          _Callout(
            title: 'RDM sur Art-Net (support variable)',
            bullets: [
              'Certains nodes supportent un “RDM proxy” : la console voit/configure les appareils RDM via IP.',
              'D’autres ne supportent RDM du tout, ou partiellement.',
              'Un splitter opto “classique” peut bloquer le retour RDM (selon modèle).',
              'Conseil: si tu veux RDM, choisis explicitement du matériel marqué RDM compatible.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Bon réflexe terrain'),
          _BulletList(items: [
            'Si DMX instable : règle DMX d’abord (terminaison, câble, Y passif) puis seulement IP.',
            'Si RDM instable : désactive RDM pour vérifier que le DMX pur est stable.',
          ]),
        ],
      ),
    );
  }
}

class _Section5Troubleshooting extends StatelessWidget {
  const _Section5Troubleshooting();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '5) Dépannage — symptômes → causes',
      icon: Icons.bug_report,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Callout(
            title: 'Symptômes → causes probables',
            bullets: [
              'Flicker sur tout le plateau → Wi-Fi, broadcast flood, switch saturé.',
              'Un node OK, l’autre non → univers/mapping, IP, unicast mal configuré.',
              'Décrochages aléatoires → câble RJ45 défectueux, switch instable, PC qui droppe des paquets.',
              'Un seul port DMX d’un node KO → câble DMX, terminaison, appareil qui casse la ligne.',
              'RDM discovery impossible → node/splitter non compatible RDM, câblage DMX “borderline”.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Méthode rapide'),
          _BulletList(items: [
            '1) Passe en unicast vers un seul node (test simple).',
            '2) Vérifie univers/mapping (papier + node config).',
            '3) Test en filaire direct (PC → switch → node) avec câble connu OK.',
            '4) Isole le DMX : node → 1 appareil + terminaison.',
          ]),
        ],
      ),
    );
  }
}

class _Section6Diagrams extends StatelessWidget {
  const _Section6Diagrams();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '6) Schémas (réseau / unicast vs broadcast)',
      icon: Icons.schema,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Subtitle('Architecture propre (IP → nodes → DMX court)'),
          SizedBox(height: 10),
          _DiagramBox(painter: _ArtNetTopologyPainter()),
          SizedBox(height: 14),
          _Subtitle('Broadcast vs Unicast (idée)'),
          SizedBox(height: 10),
          _DiagramBox(aspect: 16 / 6.8, painter: _UnicastBroadcastPainter()),
        ],
      ),
    );
  }
}

class _Section6bAssets extends StatelessWidget {
  const _Section6bAssets({required this.onCopy});
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return ExpandSectionCard(
      title: '6bis) Images (assets) — RJ45/switch/câbles',
      icon: Icons.image_outlined,
      trailing: IconButton(
        tooltip: 'Copier liste assets',
        icon: const Icon(Icons.copy, color: Colors.white70),
        onPressed: onCopy,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Paragraph(
            "Section prévue pour illustrer le réseau (RJ45, switch, câbles). "
            "Si les assets n’existent pas, l’app affiche un fallback propre.",
          ),
          SizedBox(height: 10),
          _Subtitle('Exemples'),
          SizedBox(height: 10),
          _AssetRow(
            items: [
              _AssetSpec(label: 'RJ45', assetPath: 'assets/images/connectors/rj45.png', hint: 'Connecteur Ethernet'),
              _AssetSpec(
                label: 'Switch',
                assetPath: 'assets/images/network/switch.png',
                hint: 'Switch (idéalement géré si IGMP/VLAN)',
              ),
              _AssetSpec(
                label: 'Câble Ethernet',
                assetPath: 'assets/images/cables/ethernet_cat5e_cat6.png',
                hint: 'Cat5e/Cat6 = base fiable',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section7Checklist extends StatelessWidget {
  const _Section7Checklist({required this.onCopy});
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '7) Checklist rapide',
      icon: Icons.checklist,
      trailing: IconButton(
        tooltip: 'Copier la checklist',
        icon: const Icon(Icons.copy, color: Colors.white70),
        onPressed: onCopy,
      ),
      child: const _Callout(
        title: 'Avant de paniquer',
        bullets: [
          'Unicast si plusieurs nodes.',
          'Réseau dédié (ou VLAN) si possible.',
          'Filaire pour show critique.',
          'Univers/mapping documentés.',
          'Test IP simple → 1 node → 1 appareil + terminaison.',
        ],
      ),
    );
  }
}

/// =======================
/// TOC + SMALL UI
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

class _Anchor extends StatelessWidget {
  const _Anchor({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(height: 0);
}

class _FooterNote extends StatelessWidget {
  const _FooterNote();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Info indicative (terrain). Selon nodes/switch/firmwares, le comportement peut varier.\n"
      "Objectif ici : comprendre et diagnostiquer vite.",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white38, fontSize: 12, height: 1.35),
    );
  }
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

/// =======================
/// DIAGRAMS
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

class _ArtNetTopologyPainter extends CustomPainter {
  const _ArtNetTopologyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _Grid.paint(canvas, size);

    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final console = Offset(size.width * 0.16, size.height * 0.32);
    final sw = Offset(size.width * 0.42, size.height * 0.32);
    final node1 = Offset(size.width * 0.70, size.height * 0.22);
    final node2 = Offset(size.width * 0.70, size.height * 0.52);

    canvas.drawLine(console, sw, stroke);
    canvas.drawLine(sw, node1, stroke);
    canvas.drawLine(sw, node2, stroke);

    final dmxStroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final fix1 = Offset(size.width * 0.88, size.height * 0.16);
    final fix2 = Offset(size.width * 0.88, size.height * 0.28);
    final fix3 = Offset(size.width * 0.88, size.height * 0.46);
    final fix4 = Offset(size.width * 0.88, size.height * 0.58);

    canvas.drawLine(node1, fix1, dmxStroke);
    canvas.drawLine(node1, fix2, dmxStroke);
    canvas.drawLine(node2, fix3, dmxStroke);
    canvas.drawLine(node2, fix4, dmxStroke);

    _Box.draw(canvas, size, console, 'SOURCE\n(PC/console)', accent: false);
    _Box.draw(canvas, size, sw, 'SWITCH', accent: true);
    _Box.draw(canvas, size, node1, 'NODE 1\nDMX OUT', accent: false);
    _Box.draw(canvas, size, node2, 'NODE 2\nDMX OUT', accent: false);

    _Box.small(canvas, size, fix1, 'FIX');
    _Box.small(canvas, size, fix2, 'FIX');
    _Box.small(canvas, size, fix3, 'FIX');
    _Box.small(canvas, size, fix4, 'FIX');

    _Text.paintLabel(
      canvas,
      Offset(size.width * 0.08, size.height * 0.70),
      _Text.tp(
        'IP long / DMX court',
        fontSize: size.shortestSide * 0.065,
        color: Colors.white.withValues(alpha: 0.90),
        weight: FontWeight.w900,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _UnicastBroadcastPainter extends CustomPainter {
  const _UnicastBroadcastPainter();

  @override
  void paint(Canvas canvas, Size size) {
    _Grid.paint(canvas, size);

    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final faintStroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final src = Offset(size.width * 0.14, size.height * 0.50);
    final sw = Offset(size.width * 0.40, size.height * 0.50);

    final n1 = Offset(size.width * 0.70, size.height * 0.25);
    final n2 = Offset(size.width * 0.70, size.height * 0.50);
    final n3 = Offset(size.width * 0.70, size.height * 0.75);

    canvas.drawLine(src, sw, stroke);
    canvas.drawLine(sw, n1, faintStroke);
    canvas.drawLine(sw, n2, stroke);
    canvas.drawLine(sw, n3, faintStroke);

    _Box.draw(canvas, size, src, 'SOURCE', accent: false);
    _Box.draw(canvas, size, sw, 'SWITCH', accent: true);
    _Box.draw(canvas, size, n1, 'NODE A', accent: false);
    _Box.draw(canvas, size, n2, 'NODE B', accent: false);
    _Box.draw(canvas, size, n3, 'NODE C', accent: false);

    _Text.paintLabel(
      canvas,
      Offset(size.width * 0.06, size.height * 0.10),
      _Text.tp(
        'Unicast: paquets vers un node',
        fontSize: size.shortestSide * 0.055,
        color: Colors.white.withValues(alpha: 0.90),
        weight: FontWeight.w900,
      ),
    );
    _Text.paintLabel(
      canvas,
      Offset(size.width * 0.06, size.height * 0.80),
      _Text.tp(
        'Broadcast: tout le monde reçoit',
        fontSize: size.shortestSide * 0.055,
        color: Colors.white.withValues(alpha: 0.85),
        weight: FontWeight.w900,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// =======================
/// ASSETS UI (fallback)
/// =======================

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
/// PAINTER HELPERS
/// =======================

class _Grid {
  static void paint(Canvas canvas, Size size) {
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
}

class _Box {
  static void draw(Canvas canvas, Size size, Offset center, String label, {required bool accent}) {
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
      fontSize: size.shortestSide * 0.055,
      color: Colors.white.withValues(alpha: 0.95),
      weight: FontWeight.w900,
    );
    _Text.center(canvas, rect, tp);
  }

  static void small(Canvas canvas, Size size, Offset center, String label) {
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
}

class _Text {
  static TextPainter tp(String s, {required double fontSize, required Color color, required FontWeight weight}) {
    final t = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(fontSize: fontSize, color: color, fontWeight: weight, fontFamily: 'monospace', height: 1.15),
      ),
      textDirection: TextDirection.ltr,
    );
    t.layout();
    return t;
  }

  static void center(Canvas canvas, Rect rect, TextPainter tp) {
    tp.paint(canvas, Offset(rect.left + (rect.width - tp.width) / 2, rect.top + (rect.height - tp.height) / 2));
  }

  static void paintLabel(Canvas canvas, Offset pos, TextPainter tp) {
    const pad = 10.0;
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(pos.dx, pos.dy, tp.width + pad * 2, tp.height + pad * 2),
      const Radius.circular(12),
    );
    canvas.drawRRect(r, Paint()..color = Colors.black.withValues(alpha: 0.45));
    canvas.drawRRect(r, Paint()..color = Colors.white.withValues(alpha: 0.14)..style = PaintingStyle.stroke..strokeWidth = 1.5);
    tp.paint(canvas, Offset(pos.dx + pad, pos.dy + pad));
  }
}
