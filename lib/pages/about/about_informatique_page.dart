import 'package:flutter/material.dart';

import '../../app/ui/widgets.dart';

class AboutInformatiquePage extends StatefulWidget {
  const AboutInformatiquePage({super.key});

  @override
  State<AboutInformatiquePage> createState() => _AboutInformatiquePageState();
}

class _AboutInformatiquePageState extends State<AboutInformatiquePage> {
  final _scroll = ScrollController();

  final _kUsb = GlobalKey();
  final _kStorage = GlobalKey();
  final _kVideo = GlobalKey();
  final _kPcie = GlobalKey();
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
      _TocEntry('1) USB / USB-C / Thunderbolt', _kUsb),
      _TocEntry('2) Stockage (SATA / NVMe / SSD)', _kStorage),
      _TocEntry('3) Liaisons vidéo (DP / HDMI)', _kVideo),
      _TocEntry('4) PCIe / GPU (repères)', _kPcie),
      _TocEntry('5) Checklist (plateau)', _kChecklist),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Informatique — repères terrain')),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          controller: _scroll,
          padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottom),
          child: Column(
            children: [
              _TocCard(
                title: 'Sommaire',
                icon: Icons.computer,
                entries: toc,
                onTapEntry: _goTo,
                onCopy: () {
                  final txt = '''
INFO — repères terrain
• USB-C = forme, pas vitesse : vérifier la norme.
• NVMe (M.2) bien plus rapide que SATA.
• DisplayPort/HDMI = standards, attention versions/câbles.
• Sur serveurs vidéo : stockage + GPU + débit sont la base.
'''.trim();
                  copyToClipboard(context, txt);
                },
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kUsb),
              ExpandSectionCard(
                title: '1) USB / USB-C / Thunderbolt',
                icon: Icons.usb,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Callout(
                      title: 'Point critique',
                      bullets: [
                        'USB-C = connecteur (forme). Ça ne dit pas la vitesse.',
                        'Un câble USB-C peut être “charge only” et ne pas passer la data/vidéo.',
                      ],
                    ),
                    SizedBox(height: 10),
                    _Callout(
                      title: 'Repères vitesses (ordre de grandeur)',
                      bullets: [
                        'USB 2.0 : lent (claviers, dongles, petits périph).',
                        'USB 3.x : beaucoup plus rapide (disques, interfaces).',
                        'USB4 / Thunderbolt : très haut débit (dock, eGPU, vidéo selon matériel).',
                      ],
                    ),
                    SizedBox(height: 10),
                    _Paragraph(
                      "En show : si un périphérique “déconne”, suspecte le câble (qualité/standard) avant le device.",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kStorage),
              ExpandSectionCard(
                title: '2) Stockage (SATA / NVMe / SSD)',
                icon: Icons.storage,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Callout(
                      title: 'SATA vs NVMe',
                      bullets: [
                        'SSD SATA : bon et stable, mais limité (interface ancienne).',
                        'SSD NVMe (M.2) : bien plus rapide (idéal pour serveurs média, gros fichiers).',
                      ],
                    ),
                    SizedBox(height: 10),
                    _Callout(
                      title: 'Terrain vidéo',
                      bullets: [
                        'Lecture de gros fichiers 4K/ProRes → NVMe recommandé.',
                        'Attention à la température : un NVMe peut throttler (ralentir) si ça chauffe.',
                        'Toujours tester en conditions réelles avant le show.',
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kVideo),
              ExpandSectionCard(
                title: '3) Liaisons vidéo (DP / HDMI)',
                icon: Icons.display_settings,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Callout(
                      title: 'Repère important',
                      bullets: [
                        'Les versions comptent : câble + port + device doivent être compatibles.',
                        'Longue distance = convertisseurs actifs / fibre souvent nécessaires.',
                      ],
                    ),
                    SizedBox(height: 10),
                    _Callout(
                      title: 'DP vs HDMI (très simplifié)',
                      bullets: [
                        'HDMI : omniprésent (TV, processors), mais EDID/HDCP peuvent gêner.',
                        'DisplayPort : très courant PC, souvent très “capable” en débit.',
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kPcie),
              ExpandSectionCard(
                title: '4) PCIe / GPU (repères)',
                icon: Icons.developer_board,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Paragraph(
                      "Pour les serveurs vidéo / mapping : GPU + bus + drivers = stabilité. "
                      "Les problèmes typiques : drivers, câbles, conversion, et limitations de sorties.",
                    ),
                    SizedBox(height: 10),
                    _Callout(
                      title: 'Terrain',
                      bullets: [
                        'Bloquer une version de driver stable avant un gros show.',
                        'Éviter les adaptateurs “cheap”.',
                        'Tester à la résolution/FPS réels du show.',
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              _Anchor(key: _kChecklist),
              ExpandSectionCard(
                title: '5) Checklist (plateau)',
                icon: Icons.checklist,
                trailing: IconButton(
                  tooltip: 'Copier',
                  icon: const Icon(Icons.copy, color: Colors.white70),
                  onPressed: () {
                    final txt = '''
INFO — Checklist
☐ Câbles USB-C certifiés (data/vidéo si besoin)
☐ Stockage adapté (NVMe si gros flux)
☐ Drivers GPU stables (version connue)
☐ Test résolution/FPS réels
☐ Éviter adaptateurs cheap
'''.trim();
                    copyToClipboard(context, txt);
                  },
                ),
                child: const _Callout(
                  title: 'Rapide',
                  bullets: [
                    'Câble/standard correct.',
                    'Drivers stables.',
                    'Test réel avant show.',
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

/// ===== mini-widgets =====

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
            .map((e) => InkWell(
                  onTap: () => onTapEntry(e.key),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Row(
                      children: [
                        Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.65)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            e.label,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.88),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

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
      "Info indicative (terrain). Les capacités exactes varient selon matériel/versions.\n"
      "Objectif : repères simples + méthode fiable.",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white38, fontSize: 12, height: 1.35),
    );
  }
}
