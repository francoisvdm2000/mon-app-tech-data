import 'package:flutter/material.dart';

import '../../app/ui/widgets.dart'; // SectionCard, MiniPill, copyToClipboard

class AboutElectricitePage extends StatefulWidget {
  const AboutElectricitePage({super.key});

  @override
  State<AboutElectricitePage> createState() => _AboutElectricitePageState();
}

class _AboutElectricitePageState extends State<AboutElectricitePage> {
  final _scrollCtrl = ScrollController();

  // Anchors
  final _kBasics = GlobalKey();
  final _kConnectors = GlobalKey();
  final _kMonoTri = GlobalKey();
  final _kPowers = GlobalKey();
  final _kProtection = GlobalKey();
  final _kCables = GlobalKey();
  final _kGrounding = GlobalKey();
  final _kPitfalls = GlobalKey();
  final _kChecklist = GlobalKey();

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _goTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Électrique — Schuko / P17 / puissances'),
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          controller: _scrollCtrl,
          padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottom),
          child: Column(
            children: [
              _TocCard(
                items: [
                  _TocItem('1) Les bases (W, V, A, kW)', onTap: () => _goTo(_kBasics)),
                  _TocItem('2) Connecteurs : Schuko / P17 / CEE', onTap: () => _goTo(_kConnectors)),
                  _TocItem('3) Mono vs Tri : lire une arrivée', onTap: () => _goTo(_kMonoTri)),
                  _TocItem('4) Puissances rapides : 16A → 400A', onTap: () => _goTo(_kPowers)),
                  _TocItem('5) Protections : disjoncteur, diff, sélectivité', onTap: () => _goTo(_kProtection)),
                  _TocItem('6) Câbles & longueurs : sections / chutes', onTap: () => _goTo(_kCables)),
                  _TocItem('7) Terre / masses / parasites : réflexes', onTap: () => _goTo(_kGrounding)),
                  _TocItem('8) Pièges fréquents (terrain)', onTap: () => _goTo(_kPitfalls)),
                  _TocItem('9) Checklist rapide', onTap: () => _goTo(_kChecklist)),
                ],
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kBasics),
              const _SectionBasics(),
              const SizedBox(height: 12),

              _Anchor(key: _kConnectors),
              const _SectionConnectors(),
              const SizedBox(height: 12),

              _Anchor(key: _kMonoTri),
              const _SectionMonoTri(),
              const SizedBox(height: 12),

              _Anchor(key: _kPowers),
              const _SectionPowerTables(),
              const SizedBox(height: 12),

              _Anchor(key: _kProtection),
              const _SectionProtection(),
              const SizedBox(height: 12),

              _Anchor(key: _kCables),
              const _SectionCables(),
              const SizedBox(height: 12),

              _Anchor(key: _kGrounding),
              const _SectionGrounding(),
              const SizedBox(height: 12),

              _Anchor(key: _kPitfalls),
              const _SectionPitfalls(),
              const SizedBox(height: 12),

              _Anchor(key: _kChecklist),
              const _SectionChecklist(),
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
/// TOC
/// =======================

class _TocCard extends StatelessWidget {
  const _TocCard({required this.items});

  final List<_TocItem> items;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Table des matières',
      icon: Icons.menu_book,
      trailing: IconButton(
        tooltip: 'Copier la checklist',
        icon: const Icon(Icons.copy, color: Colors.white70),
        onPressed: () {
          final txt = '''
Électrique — Checklist rapide
☐ Identifier la source : Schuko / P17 mono / P17 tri
☐ Vérifier tension : 230V mono, 400V tri (entre phases)
☐ Vérifier calibre : 16A / 32A / 63A / 125A / 250A / 400A
☐ Répartir les charges (tri) : équilibrer L1/L2/L3
☐ Protections : disjoncteur + différentiel adapté
☐ Sections câbles : éviter chute de tension / échauffement
☐ Terre OK : continuité + pas de bidouille
'''.trim();
          copyToClipboard(context, txt);
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items
            .map((it) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: it.onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B0B0B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              it.label,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.88),
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.40)),
                        ],
                      ),
                    ),
                  ),
                ))
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
/// ANCHOR (IMPORTANT)
/// =======================
/// ✅ Pas de champ "key", pas de anchorKey. Juste ce bloc.
class _Anchor extends StatelessWidget {
  const _Anchor({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox(height: 0);
}

/// =======================
/// SECTIONS
/// =======================

class _SectionBasics extends StatelessWidget {
  const _SectionBasics();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '1) Les bases (W, V, A, kW)',
      icon: Icons.calculate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            'Sur le terrain, l’objectif n’est pas de faire un cours : '
            'c’est de savoir “combien je peux tirer” et “est-ce que ça va chauffer / disjoncter”.',
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Formules utiles (simplifiées)',
            bullets: [
              'Mono : P(W) = U(V) × I(A)  → 230V × 16A ≈ 3680W (≈ 3.7kW)',
              'Tri (approx) : P(kW) ≈ √3 × U(400V) × I(A) / 1000  → 400V tri 16A ≈ 11kW',
              'Règle terrain : ne vise pas 100% en continu (marge).',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Unités : ce qu’on lit sur le matos'),
          _BulletList(items: [
            'W / kW : puissance consommée.',
            'A : courant (ce qui fait chauffer les câbles).',
            'V : tension (230V mono, 400V tri entre phases).',
            'Cosφ / PF : facteur de puissance (LED/alim peuvent le dégrader).',
          ]),
        ],
      ),
    );
  }
}

class _SectionConnectors extends StatelessWidget {
  const _SectionConnectors();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '2) Connecteurs : Schuko / P17 / CEE',
      icon: Icons.electrical_services,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Subtitle('Schuko (DE/FR/BE — domestique/plateau léger)'),
          _BulletList(items: [
            'Typique : 230V mono, 16A max.',
            'Très courant, mais pas fait pour des grosses puissances continues.',
            'Attention aux multiprises, rallonges fines, faux contacts.',
          ]),
          SizedBox(height: 10),
          _Subtitle('P17 / CEE (indus — “bleu” et “rouge”)'),
          _BulletList(items: [
            'Bleu = 230V mono (souvent 16A/32A).',
            'Rouge = 400V tri (16A/32A/63A/125A/…).',
            'Toujours vérifier : nombre de broches + marquage (V/Hz/A).',
          ]),
          SizedBox(height: 10),
          _Callout(
            title: 'Réflexe terrain',
            bullets: [
              'Ne jamais “deviner” : regarde l’étiquette / le tableau / la tête P17.',
              'Avant d’brancher : calibre + type (mono/tri) + terre.',
              'Si adaptateur : vérifier que la chaîne complète supporte le calibre.',
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionMonoTri extends StatelessWidget {
  const _SectionMonoTri();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '3) Mono vs Tri : lire une arrivée',
      icon: Icons.bolt,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            'Mono : une phase + neutre + terre (230V). '
            'Tri : trois phases + (souvent) neutre + terre (400V entre phases, 230V phase-neutre).',
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Indices visuels (sans outil)',
            bullets: [
              'P17 bleu = mono (230V).',
              'P17 rouge = tri (400V).',
              'Nombre de broches : 3p+T (souvent sans neutre) ou 3p+N+T (avec neutre).',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Répartition des charges (tri)'),
          _BulletList(items: [
            'But : équilibrer L1 / L2 / L3 (évite surcharge d’une phase).',
            'Beaucoup d’alims/LED = courant non-linéaire → garde de la marge.',
            'Si neutre : il peut chauffer si déséquilibre + harmoniques.',
          ]),
        ],
      ),
    );
  }
}

class _SectionPowerTables extends StatelessWidget {
  const _SectionPowerTables();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '4) Puissances rapides : 16A → 400A',
      icon: Icons.table_chart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Subtitle('Mono 230V (ordre de grandeur)'),
          SizedBox(height: 8),
          _SimpleTable(rows: [
            ['16A', '≈ 3.7 kW'],
            ['32A', '≈ 7.4 kW'],
            ['63A', '≈ 14.5 kW'],
            ['125A', '≈ 28.8 kW'],
          ]),
          SizedBox(height: 12),
          _Subtitle('Tri 400V (ordre de grandeur)'),
          SizedBox(height: 8),
          _SimpleTable(rows: [
            ['16A', '≈ 11 kW'],
            ['32A', '≈ 22 kW'],
            ['63A', '≈ 44 kW'],
            ['125A', '≈ 87 kW'],
            ['250A', '≈ 173 kW'],
            ['400A', '≈ 277 kW'],
          ]),
          SizedBox(height: 10),
          _Callout(
            title: 'Important',
            bullets: [
              'Ce sont des ordres de grandeur (cosφ/PF peuvent réduire la “vraie” marge).',
              'En continu : évite 100% (chauffe, tolérances, pics).',
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionProtection extends StatelessWidget {
  const _SectionProtection();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '5) Protections : disjoncteur, différentiel, sélectivité',
      icon: Icons.shield,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Subtitle('Disjoncteur (surintensité)'),
          _BulletList(items: [
            'Protège contre surcharge / court-circuit.',
            'Le calibre (16A/32A/…) doit correspondre aux câbles + prises.',
          ]),
          SizedBox(height: 10),
          _Subtitle('Différentiel (fuite à la terre)'),
          _BulletList(items: [
            'Protège les personnes (ex: 30mA) et/ou l’installation (ex: 300mA).',
            'En événementiel : attention aux défauts cumulés (beaucoup d’alims).',
          ]),
          SizedBox(height: 10),
          _Callout(
            title: 'Sélectivité (version terrain)',
            bullets: [
              'Si tout est sur le même diff/disj : un défaut coupe tout.',
              'Mieux : répartir par zones, éviter “tout sur la même ligne”.',
              'Ne jamais “augmenter le calibre” pour éviter que ça saute.',
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCables extends StatelessWidget {
  const _SectionCables();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '6) Câbles & longueurs : sections / chutes',
      icon: Icons.cable,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            'Plus c’est long, plus ça chute (tension) et plus ça chauffe (courant). '
            'La “bonne” section dépend du courant ET de la longueur.',
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Règles terrain (pragmatiques)',
            bullets: [
              'Évite les rallonges fines à forte charge (ça chauffe).',
              'Si tu dois tirer loin : augmente la section, ou rapproche la distribution.',
              'Sur tri : vérifier aussi le neutre si présent (déséquilibre).',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Symptômes de chute'),
          _BulletList(items: [
            'Alims qui “cliquent”, redémarrent, matériel instable.',
            'LED qui scintille, audio qui buzz (alims en souffrance).',
            'Câble/prise tiède → danger (arrêter, répartir, sectionner).',
          ]),
        ],
      ),
    );
  }
}

class _SectionGrounding extends StatelessWidget {
  const _SectionGrounding();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '7) Terre / masses / parasites : réflexes',
      icon: Icons.gpp_good,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Callout(
            title: 'À faire',
            bullets: [
              'Toujours garder la terre (ne jamais la “lever” pour enlever un buzz).',
              'Séparer puissance et signaux (audio/DMX/réseau) quand possible.',
              'Éviter les boucles : distribution claire, chemins propres.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Buzz audio / parasites'),
          _BulletList(items: [
            'Souvent : problème de masse / boucle / distribution sale.',
            'Solution : DI, isolation audio, routing câbles, pas de hacks dangereux.',
          ]),
        ],
      ),
    );
  }
}

class _SectionPitfalls extends StatelessWidget {
  const _SectionPitfalls();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '8) Pièges fréquents (terrain)',
      icon: Icons.warning_amber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Callout(
            title: 'Les classiques',
            bullets: [
              '“Ça marche donc c’est OK” : non → chauffe / intermittence / danger.',
              'Multiprises en cascade + grosse charge : échauffement.',
              'Adaptateurs sans vérifier calibre : point faible caché.',
              'Tri mal réparti : une phase sature → ça disjoncte.',
              'Neutre oublié (3P+T vs 3P+N+T) : certains équipements en ont besoin.',
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionChecklist extends StatelessWidget {
  const _SectionChecklist();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '9) Checklist rapide',
      icon: Icons.checklist,
      trailing: IconButton(
        tooltip: 'Copier',
        icon: const Icon(Icons.copy, color: Colors.white70),
        onPressed: () {
          final txt = '''
Checklist électrique — Terrain
☐ Source identifiée (Schuko / P17 bleu / P17 rouge)
☐ Calibre validé (16/32/63/125/…)
☐ Mono vs tri compris (avec/sans neutre)
☐ Répartition tri (L1/L2/L3) équilibrée
☐ Protections OK (disj + diff)
☐ Câbles adaptés (section + longueur)
☐ Terre OK (pas de bidouille)
'''.trim();
          copyToClipboard(context, txt);
        },
      ),
      child: const _Callout(
        title: 'À faire avant de charger',
        bullets: [
          'Identifier le type (mono/tri) et le calibre.',
          'Calcul rapide kW, garder de la marge.',
          'Répartir les charges, éviter une phase saturée.',
          'Vérifier les protections et la terre.',
          'Surveiller échauffement prises/câbles.',
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
      'Info indicative. Toujours appliquer les règles de sécurité, '
      'et respecter l’installation / les normes locales.\n'
      'Objectif ici : réflexes terrain et ordres de grandeur.',
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

class _SimpleTable extends StatelessWidget {
  const _SimpleTable({required this.rows});

  final List<List<String>> rows;

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
        children: rows
            .map(
              (r) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        r[0],
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        r[1],
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
