import 'package:flutter/material.dart';

import '../../app/ui/widgets.dart'; // SectionCard, copyToClipboard

class AboutReseauPage extends StatefulWidget {
  const AboutReseauPage({super.key, this.initialAnchor});

  /// ID d’ancre optionnel pour arriver DIRECT à la bonne section.
  /// Valeurs possibles :
  /// - kBasics
  /// - kRj45
  /// - kPoE
  /// - kFiber
  /// - kSfp
  /// - kSwitch
  /// - kArtNetSacn
  /// - kChecklist
  final String? initialAnchor;

  @override
  State<AboutReseauPage> createState() => _AboutReseauPageState();
}

class _AboutReseauPageState extends State<AboutReseauPage> {
  final _scroll = ScrollController();

  final _kBasics = GlobalKey();
  final _kRj45 = GlobalKey();
  final _kPoE = GlobalKey();
  final _kFiber = GlobalKey();
  final _kSfp = GlobalKey();
  final _kSwitch = GlobalKey();
  final _kArtNetSacn = GlobalKey();
  final _kChecklist = GlobalKey();

  @override
  void initState() {
    super.initState();
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

  GlobalKey? _keyForAnchor(String id) {
    switch (id) {
      case 'kBasics':
        return _kBasics;
      case 'kRj45':
        return _kRj45;
      case 'kPoE':
        return _kPoE;
      case 'kFiber':
        return _kFiber;
      case 'kSfp':
        return _kSfp;
      case 'kSwitch':
        return _kSwitch;
      case 'kArtNetSacn':
        return _kArtNetSacn;
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

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      appBar: AppBar(title: const Text('Réseau — repères terrain')),
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
RÉSEAU — repères terrain
• RJ45 : Cat5e/6/6A → 1G/10G selon distance.
• Fibre : longue distance + immunité EMI.
• Switch : IGMP important pour sACN multicast.
• VLAN : séparer lumière/vidéo/IT = stabilité.
'''.trim();
                  copyToClipboard(context, txt);
                },
                items: [
                  _TocItem('1) Bases réseau (LAN / IP / débit)', onTap: () => _goTo(_kBasics)),
                  _TocItem('2) RJ45 & catégories (Cat5e/6/6A/…)', onTap: () => _goTo(_kRj45)),
                  _TocItem('3) PoE (alimentation réseau)', onTap: () => _goTo(_kPoE)),
                  _TocItem('4) Fibre (SM/MM) + connecteurs (LC/SC)', onTap: () => _goTo(_kFiber)),
                  _TocItem('5) SFP / SFP+ / QSFP (modules)', onTap: () => _goTo(_kSfp)),
                  _TocItem('6) Switches (VLAN / IGMP / QoS)', onTap: () => _goTo(_kSwitch)),
                  _TocItem('7) Art-Net / sACN sur réseau (conseils)', onTap: () => _goTo(_kArtNetSacn)),
                  _TocItem('8) Checklist', onTap: () => _goTo(_kChecklist)),
                ],
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kBasics),
              const _Section1Basics(),
              const SizedBox(height: 12),

              _Anchor(key: _kRj45),
              const _Section2Rj45(),
              const SizedBox(height: 12),

              _Anchor(key: _kPoE),
              const _Section3Poe(),
              const SizedBox(height: 12),

              _Anchor(key: _kFiber),
              const _Section4Fiber(),
              const SizedBox(height: 12),

              _Anchor(key: _kSfp),
              const _Section5Sfp(),
              const SizedBox(height: 12),

              _Anchor(key: _kSwitch),
              const _Section6Switch(),
              const SizedBox(height: 12),

              _Anchor(key: _kArtNetSacn),
              const _Section7ArtNetSacn(),
              const SizedBox(height: 12),

              _Anchor(key: _kChecklist),
              _Section8Checklist(
                onCopy: () {
                  final txt = '''
RÉSEAU — Checklist
☐ Plan IP clair (plage / masques)
☐ Switch correct (IGMP si sACN multicast)
☐ VLAN si plusieurs “mondes” (lumière/vidéo/IT)
☐ Câbles testés + étiquetés
☐ Fibre : modules compatibles + connecteurs propres
☐ Éviter boucles (STP) + éviter Wi-Fi public sur show LAN
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
/// TOC (style DMX)
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
      icon: Icons.router,
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
/// SECTIONS (tuiles ouvertes)
/// =======================

class _Section1Basics extends StatelessWidget {
  const _Section1Basics();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '1) Bases réseau (LAN / IP / débit)',
      icon: Icons.lan,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Callout(
            title: 'Les 3 idées simples',
            bullets: [
              'IP = adresse (ex: 10.0.0.50).',
              'LAN = réseau local via switch (pas “internet”).',
              'Débit = capacité (1G, 10G…), mais la stabilité dépend aussi du switch.',
            ],
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Topologie show (propre)',
            bullets: [
              'Console/PC → switch central → nodes/serveurs.',
              'Évite les “daisy-chain réseau” au hasard.',
              'Si possible : un réseau dédié show (pas le Wi-Fi public).',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section2Rj45 extends StatelessWidget {
  const _Section2Rj45();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '2) RJ45 & catégories (Cat5e/6/6A/…)',
      icon: Icons.settings_ethernet,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Callout(
            title: 'Repères rapides',
            bullets: [
              'Cat5e : 1 Gbit/s “classique” (jusqu’à 100m).',
              'Cat6 : 1G/10G (10G plutôt sur distances plus courtes).',
              'Cat6A : 10G jusqu’à 100m (repère pratique).',
              'Au-delà : Cat7/8 existent, mais Cat6A est souvent le sweet spot terrain.',
            ],
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Terrain',
            bullets: [
              'Toujours tester/étiqueter les câbles (surtout quand c’est loué).',
              'Évite les connecteurs abîmés : un RJ45 “fatigué” = pannes fantômes.',
              'Prévoir du 10G si tu fais vidéo IP lourde.',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section3Poe extends StatelessWidget {
  const _Section3Poe();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '3) PoE (alimentation réseau)',
      icon: Icons.power,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Paragraph(
            "PoE permet d’alimenter des équipements via RJ45 (cam IP, AP Wi-Fi, petits nodes…). "
            "Le point critique : le budget PoE total du switch.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Repères',
            bullets: [
              'PoE (802.3af) ≈ 15W, PoE+ (802.3at) ≈ 30W, PoE++/bt plus haut.',
              'Le switch a un “budget” total (ex: 120W).',
              'Si tu dépasses le budget : certains ports ne s’allument plus / reboot.',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section4Fiber extends StatelessWidget {
  const _Section4Fiber();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '4) Fibre (SM/MM) + connecteurs (LC/SC)',
      icon: Icons.cable,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Callout(
            title: 'Pourquoi la fibre en show',
            bullets: [
              'Très longues distances.',
              'Immunité aux parasites (EMI), top en environnements chargés.',
              'Pratique pour relier FOH ↔ plateau ↔ régie.',
            ],
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Multimode vs Monomode (repère simple)',
            bullets: [
              'Multimode (MM) : distances “moyennes” (souvent bâtiment / plateau).',
              'Monomode (SM) : très longues distances.',
              'Les modules (SFP) doivent matcher le type de fibre.',
            ],
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Connecteurs',
            bullets: [
              'LC : petit, très courant sur SFP.',
              'SC : plus gros, courant en infrastructure.',
              'Toujours protéger/clean (poussière = pertes).',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section5Sfp extends StatelessWidget {
  const _Section5Sfp();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '5) SFP / SFP+ / QSFP (modules)',
      icon: Icons.memory,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Callout(
            title: 'Repères',
            bullets: [
              'SFP : souvent 1G.',
              'SFP+ : souvent 10G.',
              'QSFP/QSFP+ : 40G (selon usage).',
              'Un module = vitesse + type fibre + longueur (tout doit être cohérent).',
            ],
          ),
          SizedBox(height: 10),
          _Paragraph(
            "En pratique : prends des modules compatibles avec le switch (et idéalement du même fournisseur/modèle) "
            "pour éviter les surprises.",
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
      title: '6) Switches (VLAN / IGMP / QoS)',
      icon: Icons.hub,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Callout(
            title: 'Fonctions utiles en spectacle',
            bullets: [
              'VLAN : séparer lumière / vidéo / IT.',
              'IGMP snooping : indispensable si tu utilises sACN multicast à grande échelle.',
              'QoS : utile si tu mixes beaucoup de flux (selon contexte).',
            ],
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Erreurs fréquentes',
            bullets: [
              'Switch “cheap” qui flood le multicast → réseau qui s’écroule.',
              'Boucle réseau sans STP → tempête de broadcast.',
              'Wi-Fi public sur le même LAN que le show → instabilité.',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section7ArtNetSacn extends StatelessWidget {
  const _Section7ArtNetSacn();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '7) Art-Net / sACN sur réseau (conseils)',
      icon: Icons.lightbulb_outline,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Callout(
            title: 'Art-Net (terrain)',
            bullets: [
              'Souvent simple à mettre en place.',
              'Broadcast possible sur petit LAN dédié, mais unicast est plus propre.',
              'Mapping univers/ports = point numéro 1 à vérifier.',
            ],
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'sACN (terrain)',
            bullets: [
              'Multicast : efficace, mais exige un switch correct (IGMP).',
              'Priorités : utile si plusieurs sources.',
              'Sur gros shows : sACN + IGMP est souvent le choix “propre”.',
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
        title: 'Rapide',
        bullets: [
          'Switch correct + câbles propres.',
          'IGMP si sACN multicast.',
          'Séparer les usages (VLAN).',
        ],
      ),
    );
  }
}

/// =======================
/// SMALL UI HELPERS
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
      "Info indicative (terrain). Les capacités exactes varient selon matériel / câbles / modules.\n"
      "Objectif : repères simples + méthode fiable.",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white38, fontSize: 12, height: 1.35),
    );
  }
}
