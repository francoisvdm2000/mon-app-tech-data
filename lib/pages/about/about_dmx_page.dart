import 'package:flutter/material.dart';

import '../../app/ui/widgets.dart'; // ExpandSectionCard, SectionCard, MiniPill, copyToClipboard

class AboutDmxPage extends StatefulWidget {
  const AboutDmxPage({super.key});

  @override
  State<AboutDmxPage> createState() => _AboutDmxPageState();
}

class _AboutDmxPageState extends State<AboutDmxPage> {
  final _scroll = ScrollController();

  // Anchors (TOC -> section)
  final _kBasics = GlobalKey();
  final _kFrame = GlobalKey();
  final _kCabling = GlobalKey();
  final _kTerm = GlobalKey();
  final _kTrouble = GlobalKey();
  final _kArtNet = GlobalKey();
  final _kSacn = GlobalKey();
  final _kCompare = GlobalKey();
  final _kDiagrams = GlobalKey();
  final _kChecklist = GlobalKey();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final ctx = key.currentContext;
    if (ctx == null) return;

    // ensure visible in scroll view
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DMX — fonctionnement (simple & complet)'),
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          controller: _scroll,
          padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottom),
          child: Column(
            children: [
              

              _TocCard(
                onTapBasics: () => _scrollTo(_kBasics),
                onTapFrame: () => _scrollTo(_kFrame),
                onTapCabling: () => _scrollTo(_kCabling),
                onTapTerm: () => _scrollTo(_kTerm),
                onTapTrouble: () => _scrollTo(_kTrouble),
                onTapArtNet: () => _scrollTo(_kArtNet),
                onTapSacn: () => _scrollTo(_kSacn),
                onTapCompare: () => _scrollTo(_kCompare),
                onTapDiagrams: () => _scrollTo(_kDiagrams),
                onTapChecklist: () => _scrollTo(_kChecklist),
              ),
              const SizedBox(height: 12),

              // Sections (all closed by default)
              _Anchor(key: _kBasics),
              const _SectionDMXBasics(),
              const SizedBox(height: 12),

              _Anchor(key: _kFrame),
              const _SectionDMXFrame(),
              const SizedBox(height: 12),

              _Anchor(key: _kCabling),
              const _SectionDMXCabling(),
              const SizedBox(height: 12),

              _Anchor(key: _kTerm),
              const _SectionTerminatorsAndSplitters(),
              const SizedBox(height: 12),

              _Anchor(key: _kTrouble),
              const _SectionTroubleshooting(),
              const SizedBox(height: 12),

              _Anchor(key: _kArtNet),
              const _SectionArtNet(),
              const SizedBox(height: 12),

              _Anchor(key: _kSacn),
              const _SectionSACN(),
              const SizedBox(height: 12),

              _Anchor(key: _kCompare),
              const _SectionCompare(),
              const SizedBox(height: 12),

              _Anchor(key: _kDiagrams),
              _SectionDiagrams(
                onCopy: () {
                  final txt = [
                    'DMX: console → fixture → fixture → ... → terminateur 120Ω',
                    'Art-Net/sACN: console → switch → nodes → DMX vers fixtures',
                    'Évite le Y passif : utilise un splitter DMX.',
                    'sACN multicast = IGMP snooping recommandé sur switch.',
                  ].join('\n');
                  copyToClipboard(context, txt);
                },
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kChecklist),
              _SectionChecklist(
                onCopy: () {
                  final txt = '''
DMX — Checklist
☐ Mode appareil correct (nombre de canaux)
☐ Adresse DMX correcte (pas de chevauchement)
☐ Daisy-chain (pas de Y passif)
☐ Terminaison 120Ω sur le dernier appareil
☐ Câble DMX/RS-485 (si possible)
☐ Splitter opto si plusieurs branches

Art-Net/sACN — Checklist
☐ Réseau dédié si possible
☐ Switch correct (IGMP snooping recommandé pour sACN)
☐ Unicast (souvent) ou multicast maîtrisé
☐ Mapping univers/ports/node vérifié
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

/// Small invisible widget used as anchor for ensureVisible.
class _Anchor extends StatelessWidget {
  const _Anchor({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(height: 1);
}


/// =======================
/// TOC (TABLE DES MATIÈRES)
/// =======================

class _TocCard extends StatelessWidget {
  const _TocCard({
    required this.onTapBasics,
    required this.onTapFrame,
    required this.onTapCabling,
    required this.onTapTerm,
    required this.onTapTrouble,
    required this.onTapArtNet,
    required this.onTapSacn,
    required this.onTapCompare,
    required this.onTapDiagrams,
    required this.onTapChecklist,
  });

  final VoidCallback onTapBasics;
  final VoidCallback onTapFrame;
  final VoidCallback onTapCabling;
  final VoidCallback onTapTerm;
  final VoidCallback onTapTrouble;
  final VoidCallback onTapArtNet;
  final VoidCallback onTapSacn;
  final VoidCallback onTapCompare;
  final VoidCallback onTapDiagrams;
  final VoidCallback onTapChecklist;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Sommaire',
      icon: Icons.format_list_bulleted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TocItem(index: '1', title: 'DMX, univers, adresses — la base', onTap: onTapBasics),
          _TocItem(index: '2', title: 'Trame DMX — break, start code, canaux', onTap: onTapFrame),
          _TocItem(index: '3', title: 'Câblage RS-485 — topologie & câble', onTap: onTapCabling),
          _TocItem(index: '4', title: 'Terminaison & splitters — éviter les réflexions', onTap: onTapTerm),
          _TocItem(index: '5', title: 'Dépannage terrain — symptômes → causes', onTap: onTapTrouble),
          _TocItem(index: '6', title: 'Art-Net — origine, pourquoi, versions', onTap: onTapArtNet),
          _TocItem(index: '7', title: 'sACN / E1.31 — multicast, IGMP, priorités', onTap: onTapSacn),
          _TocItem(index: '8', title: 'DMX vs Art-Net vs sACN — choisir', onTap: onTapCompare),
          _TocItem(index: '9', title: 'Schémas terrain', onTap: onTapDiagrams),
          _TocItem(index: '10', title: 'Checklist rapide', onTap: onTapChecklist),
        ],
      ),
    );
  }
}

class _TocItem extends StatelessWidget {
  const _TocItem({
    required this.index,
    required this.title,
    required this.onTap,
  });

  final String index;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
              ),
              child: Text(
                index,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.90),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.45)),
          ],
        ),
      ),
    );
  }
}

/// =======================
/// SECTION: BASICS
/// =======================

class _SectionDMXBasics extends StatelessWidget {
  const _SectionDMXBasics();

  @override
  Widget build(BuildContext context) {
    return ExpandSectionCard(
      title: '1) DMX, univers, adresses — la base',
      icon: Icons.view_stream,
      initiallyExpanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            "Le DMX512 est un protocole de contrôle très utilisé en spectacle (lumière, effets, dimmers). "
            "Un signal DMX transporte une “trame” qui contient jusqu’à 512 valeurs (0→255) : ce sont les canaux.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'À retenir',
            bullets: [
              '1 univers DMX = 512 canaux (slots).',
              'Une machine “écoute” une adresse de départ (ex: 101) et consomme N canaux.',
              'Les valeurs sont envoyées en continu (rafraîchissement), ce n’est pas “un ordre unique”.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Exemple simple'),
          _BulletList(items: [
            'Projecteur mode 16ch, adresse 101 → il utilise 101 à 116.',
            'Un dimmer 6ch, adresse 1 → il utilise 1 à 6.',
            'Deux appareils ne doivent pas “se chevaucher” sur les canaux du même univers.',
          ]),
        ],
      ),
    );
  }
}

/// =======================
/// SECTION: FRAME
/// =======================

class _SectionDMXFrame extends StatelessWidget {
  const _SectionDMXFrame();

  @override
  Widget build(BuildContext context) {
    return ExpandSectionCard(
      title: '2) Comment fonctionne une trame DMX',
      icon: Icons.timeline,
      initiallyExpanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            "Le DMX est un flux série. Chaque trame commence par un “Break” (une pause spéciale) "
            "qui indique aux récepteurs : “nouvelle trame”. Ensuite viennent les octets : un octet de start code "
            "(souvent 0) puis jusqu’à 512 octets de canaux (valeurs 0–255).",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Image mentale utile',
            bullets: [
              'Le contrôleur “rejoue” une table de 512 valeurs en boucle.',
              'Le break = top départ pour relire la table.',
              'Les appareils prennent ce qui les concerne (adresse + nombre de canaux).',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Fréquence / latence'),
          _BulletList(items: [
            'DMX typique : ~20 à 44 trames/s selon la longueur de trame et l’émetteur.',
            'Plus il y a de canaux réellement envoyés, plus une trame peut être “longue”.',
            'La sensation de latence vient surtout du traitement console + fixture + réseau (si IP).',
          ]),
        ],
      ),
    );
  }
}

/// =======================
/// SECTION: CABLING
/// =======================

class _SectionDMXCabling extends StatelessWidget {
  const _SectionDMXCabling();

  @override
  Widget build(BuildContext context) {
    return ExpandSectionCard(
      title: '3) Câblage RS-485 — ce qui marche (et ce qui casse)',
      icon: Icons.cable,
      initiallyExpanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Subtitle('Topologie'),
          _BulletList(items: [
            '✅ Daisy-chain : console → machine 1 → machine 2 → ... → dernière machine',
            '❌ Éviter le “Y” passif (split en 2 sans splitter) : réflexions, erreurs, flicker',
            '✅ Utiliser un splitter DMX (idéalement opto-isolé) si tu dois distribuer',
          ]),
          SizedBox(height: 10),
          _Subtitle('Câble'),
          _BulletList(items: [
            'DMX = paire torsadée 120Ω (câble DMX/RS-485).',
            'Un câble micro peut marcher sur de courtes distances… puis te piéger (impédance différente).',
            'Toujours privilégier connectique/patch propre : faux contact = panne “fantôme”.',
          ]),
          SizedBox(height: 10),
          _Callout(
            title: 'Astuce terrain',
            bullets: [
              'Si ça “flicker” aléatoirement : suspecte d’abord câble/terminaison/Y/splitter.',
              'Si une seule branche déconne : suspecte l’entrée/sortie DMX d’un appareil (thru).',
            ],
          ),
        ],
      ),
    );
  }
}

/// =======================
/// SECTION: TERMINATORS / SPLITTERS
/// =======================

class _SectionTerminatorsAndSplitters extends StatelessWidget {
  const _SectionTerminatorsAndSplitters();

  @override
  Widget build(BuildContext context) {
    return ExpandSectionCard(
      title: '4) Terminaison & splitters',
      icon: Icons.power,
      initiallyExpanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            "Le DMX (RS-485) doit être terminé à l’extrémité de la ligne : "
            "un terminateur 120Ω sur le dernier appareil. Sans terminaison, tu peux avoir des réflexions "
            "→ erreurs de lecture → scintillements, valeurs qui “bougent”.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Terminaison',
            bullets: [
              '✅ 120Ω sur le dernier appareil de la chaîne.',
              '❌ Pas au milieu, pas “partout”, pas sur plusieurs branches en parallèle.',
              'Sur petites lignes, ça peut “fonctionner sans”… mais ce n’est pas fiable.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Splitter DMX'),
          _BulletList(items: [
            'Permet de faire plusieurs branches correctement.',
            'Un opto-splitter isole électriquement : mieux contre parasites et défauts.',
            'Bon réflexe en festival/plateau chargé : console → splitter → branches.',
          ]),
        ],
      ),
    );
  }
}

/// =======================
/// SECTION: TROUBLESHOOT
/// =======================

class _SectionTroubleshooting extends StatelessWidget {
  const _SectionTroubleshooting();

  @override
  Widget build(BuildContext context) {
    return ExpandSectionCard(
      title: '5) Erreurs terrain fréquentes',
      icon: Icons.bug_report,
      initiallyExpanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Callout(
            title: 'Symptômes → causes probables',
            bullets: [
              'Flicker / valeurs instables → terminaison absente, Y, câble inadapté, parasites.',
              'Tout marche sauf “après” un appareil → DMX THRU/OUT HS ou config “DMX in only”.',
              'Machines “en décalage” → mauvaise adresse, mauvais mode (nombre de canaux).',
              'Une branche entière KO → splitter absent / mauvaise distribution / connecteur.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Méthode rapide'),
          _BulletList(items: [
            '1) Vérifie mode + adresse (souvent la vraie cause).',
            '2) Teste en chaîne courte (console → 1 fixture) avec câble connu OK.',
            '3) Ajoute ensuite, appareil par appareil, pour isoler le fautif.',
            '4) Termine correctement en fin de ligne.',
          ]),
        ],
      ),
    );
  }
}

/// =======================
/// SECTION: ART-NET
/// =======================

class _SectionArtNet extends StatelessWidget {
  const _SectionArtNet();

  @override
  Widget build(BuildContext context) {
    return ExpandSectionCard(
      title: '6) Art-Net — DMX sur IP (d’où ça vient, pourquoi, versions)',
      icon: Icons.router,
      initiallyExpanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            "Art-Net est une façon d’envoyer des univers DMX sur un réseau Ethernet/IP. "
            "L’idée : au lieu d’avoir une sortie DMX physique par univers, tu transportes les univers sur le réseau, "
            "puis des “nodes” (ou convertisseurs) ressortent du DMX près des machines.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Pourquoi c’est pratique',
            bullets: [
              'Distribuer beaucoup d’univers sur un seul câble réseau.',
              'Placer des nodes au plus près des projecteurs/dimmers.',
              'Facile à étendre (ajout de nodes), surtout en grands plateaux.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Versions (repères simples)'),
          _BulletList(items: [
            "Art-Net a évolué en ajoutant des capacités (plus d’univers, meilleure gestion réseau).",
            "En pratique terrain : l’important est que console et nodes soient compatibles et configurés correctement.",
            "On rencontre souvent Art-Net 3/4 sur matériel récent ; Art-Net 2 encore parfois sur ancien.",
          ]),
          SizedBox(height: 10),
          _Subtitle('Unicast / broadcast (simple)'),
          _BulletList(items: [
            "Broadcast : envoi “à tout le monde” sur le réseau → simple mais peut charger un LAN.",
            "Unicast : envoi vers l’IP du node → plus propre sur réseau chargé.",
            "Sur un petit réseau dédié lumière : broadcast peut passer. Sur réseau partagé : préfère unicast.",
          ]),
        ],
      ),
    );
  }
}

/// =======================
/// SECTION: sACN
/// =======================

class _SectionSACN extends StatelessWidget {
  const _SectionSACN();

  @override
  Widget build(BuildContext context) {
    return ExpandSectionCard(
      title: '7) sACN / E1.31 — multicast, priorités, réseaux propres',
      icon: Icons.wifi_tethering,
      initiallyExpanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            "sACN (E1.31) est un standard (ANSI E1.31) pour transporter des univers DMX sur IP. "
            "Il est souvent utilisé en installations et grosses distribs réseau, notamment grâce au multicast "
            "et à la gestion de priorités.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Points clés',
            bullets: [
              "Multicast : un univers peut être “diffusé” aux appareils qui s’y abonnent.",
              "Priorités : utile si plusieurs sources peuvent piloter (ex: secours).",
              "Réseau : nécessite un switch correct (IGMP snooping recommandé) pour éviter le flood.",
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('IGMP, c’est quoi (version terrain)'),
          _BulletList(items: [
            "Sans IGMP snooping : le multicast peut se comporter comme un broadcast → tout le réseau est inondé.",
            "Avec IGMP snooping : le switch envoie le flux seulement aux ports qui en ont besoin.",
            "Résultat : réseau beaucoup plus stable quand il y a beaucoup d’univers.",
          ]),
        ],
      ),
    );
  }
}

/// =======================
/// SECTION: COMPARE
/// =======================

class _SectionCompare extends StatelessWidget {
  const _SectionCompare();

  @override
  Widget build(BuildContext context) {
    return ExpandSectionCard(
      title: '8) DMX vs Art-Net vs sACN — lequel choisir ?',
      icon: Icons.compare_arrows,
      initiallyExpanded: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _CompareTable(),
          SizedBox(height: 10),
          _Callout(
            title: 'Règle simple',
            bullets: [
              "Petit setup / 1 univers / direct : DMX.",
              "Beaucoup d’univers / nodes distribués : Art-Net ou sACN.",
              "Réseau “propre” avec multicast + priorités : sACN (switch adapté).",
            ],
          ),
        ],
      ),
    );
  }
}

class _CompareTable extends StatelessWidget {
  const _CompareTable();

  @override
  Widget build(BuildContext context) {
    const headers = ['Critère', 'DMX', 'Art-Net', 'sACN'];
    const rows = [
      ['Transport', 'RS-485', 'Ethernet/IP', 'Ethernet/IP'],
      ['Topologie', 'Daisy-chain', 'Réseau + nodes', 'Réseau + nodes'],
      ['Scalabilité', 'Limitée', 'Très bonne', 'Très bonne'],
      ['Réseau', 'N/A', 'OK (unicast conseillé)', 'Multicast (IGMP conseillé)'],
      ['Priorités', 'Non', 'Selon implémentations', 'Oui (standard)'],
      ['Usage typique', 'petit/rapide', 'show/event', 'install/gros réseaux'],
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const _TableRowLine(isHeader: true, cells: headers),
          const SizedBox(height: 6),
          ...rows.map((r) => _TableRowLine(cells: r)),
        ],
      ),
    );
  }
}

class _TableRowLine extends StatelessWidget {
  const _TableRowLine({
    required this.cells,
    this.isHeader = false,
  });

  final List<String> cells;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: isHeader ? Colors.white : Colors.white.withValues(alpha: 0.85),
      fontWeight: isHeader ? FontWeight.w800 : FontWeight.w600,
      fontSize: 12.5,
      height: 1.2,
      fontFamily: 'monospace',
    );

    return Row(
      children: [
        Expanded(flex: 5, child: Text(cells[0], style: style)),
        Expanded(flex: 3, child: Text(cells[1], style: style)),
        Expanded(flex: 3, child: Text(cells[2], style: style)),
        Expanded(flex: 3, child: Text(cells[3], style: style)),
      ],
    );
  }
}

/// =======================
/// SECTION: DIAGRAMS
/// =======================

class _SectionDiagrams extends StatelessWidget {
  const _SectionDiagrams({required this.onCopy});
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return ExpandSectionCard(
      title: '9) Schémas (terrain)',
      icon: Icons.schema,
      initiallyExpanded: false,
      trailing: IconButton(
        tooltip: 'Copier (schémas + notes)',
        icon: const Icon(Icons.copy, color: Colors.white70),
        onPressed: onCopy,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Subtitle('DMX (RS-485) : daisy-chain + terminaison'),
          SizedBox(height: 10),
          _DiagramBox(painter: _DmxChainPainter()),
          SizedBox(height: 14),
          _Subtitle('Art-Net / sACN : réseau + nodes'),
          SizedBox(height: 10),
          _DiagramBox(painter: _IpDmxPainter()),
        ],
      ),
    );
  }
}

class _DiagramBox extends StatelessWidget {
  const _DiagramBox({required this.painter});
  final CustomPainter painter;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 7,
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

class _DmxChainPainter extends CustomPainter {
  const _DmxChainPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0B0B0B);
    canvas.drawRect(Offset.zero & size, bg);

    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final faint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final step = size.shortestSide / 10;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), faint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), faint);
    }

    final y = size.height * 0.55;
    final x0 = size.width * 0.10;
    final dx = size.width * 0.18;

    final nodes = <_Node>[
      _Node('CONSOLE', Offset(x0, y)),
      _Node('FIX 1', Offset(x0 + dx, y)),
      _Node('FIX 2', Offset(x0 + dx * 2, y)),
      _Node('FIX 3', Offset(x0 + dx * 3, y)),
      _Node('TERM 120Ω', Offset(x0 + dx * 4, y), isTerminator: true),
    ];

    for (int i = 0; i < nodes.length - 1; i++) {
      canvas.drawLine(nodes[i].pos, nodes[i + 1].pos, stroke);
    }

    for (final n in nodes) {
      _drawBox(canvas, size, n.pos, n.label, isTerminator: n.isTerminator);
    }

    final warnPos = Offset(size.width * 0.66, size.height * 0.18);
    final tp = _Text.tp(
      '✅ Daisy-chain\n❌ Pas de Y passif',
      fontSize: size.shortestSide * 0.07,
      color: Colors.white.withValues(alpha: 0.9),
      weight: FontWeight.w800,
    );
    _Text.paintLabel(canvas, warnPos, tp);
  }

  void _drawBox(Canvas canvas, Size size, Offset center, String label, {bool isTerminator = false}) {
    final w = size.width * 0.16;
    final h = size.height * 0.18;
    final rect = Rect.fromCenter(center: center, width: w, height: h);
    final rr = RRect.fromRectAndRadius(rect, Radius.circular(size.shortestSide * 0.05));

    final fill = Paint()
      ..color = isTerminator
          ? Colors.redAccent.withValues(alpha: 0.18)
          : Colors.white.withValues(alpha: 0.08);

    final border = Paint()
      ..color = isTerminator
          ? Colors.redAccent.withValues(alpha: 0.65)
          : Colors.white.withValues(alpha: 0.30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(rr, fill);
    canvas.drawRRect(rr, border);

    final tp = _Text.tp(
      label,
      fontSize: size.shortestSide * 0.065,
      color: Colors.white.withValues(alpha: 0.95),
      weight: FontWeight.w900,
    );
    _Text.center(canvas, rect, tp);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _IpDmxPainter extends CustomPainter {
  const _IpDmxPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0B0B0B);
    canvas.drawRect(Offset.zero & size, bg);

    final faint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final step = size.shortestSide / 10;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), faint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), faint);
    }

    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
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

    _drawBox(canvas, size, console, 'CONSOLE\nArt-Net / sACN');
    _drawBox(canvas, size, sw, 'SWITCH\n(IGMP pour sACN)', accent: true);
    _drawBox(canvas, size, node1, 'NODE 1\nDMX OUT');
    _drawBox(canvas, size, node2, 'NODE 2\nDMX OUT');

    _drawSmall(canvas, size, fix1, 'FIX');
    _drawSmall(canvas, size, fix2, 'FIX');
    _drawSmall(canvas, size, fix3, 'FIX');
    _drawSmall(canvas, size, fix4, 'FIX');

    final tp = _Text.tp(
      '✅ Réseau = beaucoup d’univers\n✅ Nodes proches des machines',
      fontSize: size.shortestSide * 0.07,
      color: Colors.white.withValues(alpha: 0.9),
      weight: FontWeight.w800,
    );
    _Text.paintLabel(canvas, Offset(size.width * 0.08, size.height * 0.70), tp);
  }

  void _drawBox(Canvas canvas, Size size, Offset center, String label, {bool accent = false}) {
    final w = size.width * 0.22;
    final h = size.height * 0.22;
    final rect = Rect.fromCenter(center: center, width: w, height: h);
    final rr = RRect.fromRectAndRadius(rect, Radius.circular(size.shortestSide * 0.05));

    final fill = Paint()
      ..color = accent
          ? const Color(0xFF1E88E5).withValues(alpha: 0.18)
          : Colors.white.withValues(alpha: 0.08);

    final border = Paint()
      ..color = accent
          ? const Color(0xFF1E88E5).withValues(alpha: 0.60)
          : Colors.white.withValues(alpha: 0.30)
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

  void _drawSmall(Canvas canvas, Size size, Offset center, String label) {
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

class _Node {
  const _Node(this.label, this.pos, {this.isTerminator = false});
  final String label;
  final Offset pos;
  final bool isTerminator;
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
    const pad = 10.0;
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
/// SECTION: CHECKLIST
/// =======================

class _SectionChecklist extends StatelessWidget {
  const _SectionChecklist({required this.onCopy});
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return ExpandSectionCard(
      title: '10) Checklist terrain (rapide)',
      icon: Icons.checklist,
      initiallyExpanded: false,
      trailing: IconButton(
        tooltip: 'Copier la checklist',
        icon: const Icon(Icons.copy, color: Colors.white70),
        onPressed: onCopy,
      ),
      child: const _Callout(
        title: 'À faire avant d’accuser “la console”',
        bullets: [
          'Vérifie mode + adresse (80% des cas).',
          'Teste une chaîne courte avec câble connu OK.',
          'Ajoute les appareils un par un pour isoler.',
          'Termine la ligne en fin (120Ω).',
          'Si plusieurs branches : splitter DMX (opto idéal).',
          'En IP : switch correct (IGMP pour sACN), unicast si doute.',
        ],
      ),
    );
  }
}

/// =======================
/// FOOTER
/// =======================

class _FooterNote extends StatelessWidget {
  const _FooterNote();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Info indicative. Les comportements exacts peuvent varier selon consoles, nodes, switchs et firmwares.\n"
      "Objectif ici : méthode terrain fiable et compréhension simple.",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white38, fontSize: 12, height: 1.35),
    );
  }
}

/// =======================
/// SMALL UI HELPERS
/// =======================

class _Subtitle extends StatelessWidget {
  const _Subtitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.92),
        fontWeight: FontWeight.w800,
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
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontWeight: FontWeight.w900,
              fontSize: 13.5,
            ),
          ),
          const SizedBox(height: 8),
          _BulletList(items: bullets),
        ],
      ),
    );
  }
}
