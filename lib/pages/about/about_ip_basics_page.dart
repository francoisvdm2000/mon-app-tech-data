import 'package:flutter/material.dart';

import '../../app/ui/widgets.dart'; // SectionCard, MiniPill, copyToClipboard

class AboutIpBasicsPage extends StatefulWidget {
  const AboutIpBasicsPage({super.key});

  @override
  State<AboutIpBasicsPage> createState() => _AboutIpBasicsPageState();
}

class _AboutIpBasicsPageState extends State<AboutIpBasicsPage> {
  final _scrollCtrl = ScrollController();

  // Sections (sommaire interne -> scroll)
  final _k1WhatIsIp = GlobalKey();
  final _k2PrivateRanges = GlobalKey();
  final _k3MaskSubnet = GlobalKey();
  final _k4GatewayDnsDhcp = GlobalKey();
  final _k5HowDevicesTalk = GlobalKey();
  final _k6CommonShowPlans = GlobalKey();
  final _k7Troubleshooting = GlobalKey();
  final _k8MiniExercises = GlobalKey();
  final _k9Checklist = GlobalKey();

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
        title: const Text('Réseau — bases IP / masque / DHCP (essentiel)'),
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
                    'IP = adresse logique pour joindre un appareil sur un réseau.',
                    'Privé (LAN) : 10.x.x.x, 172.16–31.x.x, 192.168.x.x (non routés sur Internet).',
                    'Masque / sous-réseau = dit quelle partie est “réseau” vs “machine”.',
                    'Même sous-réseau = communication directe. Sinon → passerelle (routeur).',
                    'DHCP attribue IP automatiquement; statique = utile pour nodes/console.',
                  ].join('\n');
                  copyToClipboard(context, txt);
                },
                items: [
                  _TocItem('1) C’est quoi une IP et à quoi ça sert ?', onTap: () => _goTo(_k1WhatIsIp)),
                  _TocItem('2) Pourquoi 192.x / 10.x / 172.x ? (adresses privées)', onTap: () => _goTo(_k2PrivateRanges)),
                  _TocItem('3) Masque & sous-réseaux : comprendre pour de vrai', onTap: () => _goTo(_k3MaskSubnet)),
                  _TocItem('4) DHCP, passerelle, DNS : qui fait quoi ?', onTap: () => _goTo(_k4GatewayDnsDhcp)),
                  _TocItem('5) Comment deux appareils se parlent (LAN vs hors LAN)', onTap: () => _goTo(_k5HowDevicesTalk)),
                  _TocItem('6) Plans IP “show” simples (exemples prêts à copier)', onTap: () => _goTo(_k6CommonShowPlans)),
                  _TocItem('7) Dépannage : symptômes → causes (méthode terrain)', onTap: () => _goTo(_k7Troubleshooting)),
                  _TocItem('8) Mini-exercices (vérifier vite un masque / un réseau)', onTap: () => _goTo(_k8MiniExercises)),
                  _TocItem('9) Checklist rapide', onTap: () => _goTo(_k9Checklist)),
                ],
              ),

              const SizedBox(height: 12),

              _Anchor(key: _k1WhatIsIp),
              const _Section1WhatIsIp(),
              const SizedBox(height: 12),

              _Anchor(key: _k2PrivateRanges),
              const _Section2PrivateRanges(),
              const SizedBox(height: 12),

              _Anchor(key: _k3MaskSubnet),
              const _Section3MaskSubnet(),
              const SizedBox(height: 12),

              _Anchor(key: _k4GatewayDnsDhcp),
              const _Section4GatewayDnsDhcp(),
              const SizedBox(height: 12),

              _Anchor(key: _k5HowDevicesTalk),
              const _Section5HowDevicesTalk(),
              const SizedBox(height: 12),

              _Anchor(key: _k6CommonShowPlans),
              const _Section6CommonShowPlans(),
              const SizedBox(height: 12),

              _Anchor(key: _k7Troubleshooting),
              const _Section7Troubleshooting(),
              const SizedBox(height: 12),

              _Anchor(key: _k8MiniExercises),
              const _Section8MiniExercises(),
              const SizedBox(height: 12),

              _Anchor(key: _k9Checklist),
              _Section9Checklist(
                onCopy: () {
                  final txt = '''
Réseau — Checklist rapide (IP)
☐ Tous les appareils sont dans le même sous-réseau (IP + masque cohérents)
☐ Pas de doublon d’IP (conflit)
☐ DHCP : soit tout le monde en DHCP, soit plan statique clair (éviter mélange flou)
☐ Pour Art-Net/sACN : réseau dédié ou VLAN si possible
☐ Switch géré si multicast/IGMP (sACN)
☐ Wi-Fi : éviter pour data show critique (jitter), préférer filaire
☐ Test simple : ping + vérifier masque/passerelle
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
/// TOC
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
      icon: Icons.list_alt,
      trailing: IconButton(
        tooltip: 'Copier mémo',
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
/// SECTIONS (inchangées)
/// =======================

class _Section1WhatIsIp extends StatelessWidget {
  const _Section1WhatIsIp();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '1) C’est quoi une IP et à quoi ça sert ?',
      icon: Icons.language,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            "Une adresse IP (IPv4) est un identifiant logique sur un réseau. "
            "Elle permet de dire : “envoie ce paquet à cet appareil”.\n\n"
            "Quand tu branches une console, un node Art-Net/sACN, un PC, un switch géré… "
            "tout ce qui parle en réseau doit avoir une IP cohérente pour que les appareils se trouvent.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Image mentale',
            bullets: [
              'MAC = identifiant matériel (carte réseau).',
              'IP = adresse “postale” sur un réseau (changeable).',
              'Masque = “quartier / code postal” (délimite le sous-réseau).',
              'Passerelle = “sortie du quartier” (routeur).',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('IPv4 en 10 secondes'),
          _BulletList(items: [
            'Format : A.B.C.D (4 nombres de 0 à 255).',
            'Ex : 192.168.0.50',
            'Ce n’est pas magique : ce sont 32 bits (4 octets).',
            'Ce qui compte pour toi : IP + masque doivent être cohérents entre appareils.',
          ]),
        ],
      ),
    );
  }
}

class _Section2PrivateRanges extends StatelessWidget {
  const _Section2PrivateRanges();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '2) Pourquoi 192.x / 10.x / 172.x ? (adresses privées)',
      icon: Icons.shield,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            "Certaines plages d’adresses IPv4 sont réservées aux réseaux privés (LAN). "
            "Elles ne sont pas routées sur Internet. C’est pour ça qu’on les utilise en show : "
            "tu peux faire ton réseau local sans “consommer” des IP publiques.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Les 3 grandes plages privées (LAN)',
            bullets: [
              '10.0.0.0 → 10.255.255.255 (souvent écrit “10.x.x.x”)',
              '172.16.0.0 → 172.31.255.255 (souvent “172.16–31.x.x”)',
              '192.168.0.0 → 192.168.255.255 (souvent “192.168.x.x”)',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Pourquoi on voit souvent 192.168.x.x ?'),
          _BulletList(items: [
            'Les box/routeurs grand public utilisent souvent 192.168.0.x ou 192.168.1.x.',
            'C’est devenu un “standard de fait” en petits LAN.',
            'Mais en show, 10.x.x.x est pratique si tu veux beaucoup d’adresses ou plusieurs VLAN.',
          ]),
          SizedBox(height: 10),
          _Subtitle('Et le fameux 2.x.x.x (Art-Net) ?'),
          _BulletList(items: [
            'Beaucoup de matériel Art-Net sort d’usine avec une IP en 2.x.x.x (réseau fermé).',
            'C’est “pratique” en plug&play (sans DHCP), mais ça surprend si ton PC est en 192.168.x.x.',
            'Important : le “2.x” n’a rien de magique pour le broadcast/unicast.',
            'Ce qui change le périmètre du broadcast, c’est le masque (souvent /8 = 255.0.0.0 en legacy).',
            'Exemple : réseau 2.0.0.0/8 → broadcast = 2.255.255.255 (très large).',
            'Solution simple : mettre PC/console dans la même plage + même masque, ou reconfigurer le node sur un plan 192/10.',
          ]),
        ],
      ),
    );
  }
}

class _Section3MaskSubnet extends StatelessWidget {
  const _Section3MaskSubnet();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '3) Masque & sous-réseaux : comprendre pour de vrai',
      icon: Icons.grid_4x4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            "Le masque (subnet mask) dit quelles adresses sont “dans le même réseau”. "
            "Sans masque, une IP ne veut pas dire grand-chose.\n\n"
            "Règle terrain : si deux appareils sont dans le même sous-réseau, "
            "ils se parlent directement. Sinon, ils ont besoin d’une passerelle (routeur).",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Masques les plus courants',
            bullets: [
              '255.0.0.0 ( /8 )   → réseau 10.x.x.x typique “large”',
              '255.255.0.0 ( /16 ) → réseau 10.10.x.x ou 192.168.x.x “large”',
              '255.255.255.0 ( /24 ) → réseau 192.168.0.x “classique” (254 appareils)',
            ],
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Masque → adresse de broadcast (très utile à comprendre)',
            bullets: [
              'Le broadcast dépend du sous-réseau, donc du masque (pas de “2 vs 192”).',
              '192.168.10.0/24 → broadcast = 192.168.10.255 (petit réseau).',
              '2.0.0.0/8 (255.0.0.0) → broadcast = 2.255.255.255 (réseau énorme).',
              'Plus le réseau est “grand”, plus un broadcast peut faire du bruit (si tu l’utilises souvent).',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Exemple concret (le plus utile) : /24'),
          _BulletList(items: [
            'IP : 192.168.0.50',
            'Masque : 255.255.255.0 ( /24 )',
            'Réseau : 192.168.0.0',
            'Appareils “dans le même réseau” : 192.168.0.1 → 192.168.0.254',
            'Si tu passes en 192.168.1.50 → ce n’est PLUS le même réseau.',
          ]),
          SizedBox(height: 10),
          _Subtitle('Pourquoi faire des sous-réseaux ?'),
          _BulletList(items: [
            'Organisation : séparer “lumière”, “vidéo”, “intercom”, “internet”…',
            'Performance : limiter le bruit (broadcast/multicast) à un groupe.',
            'Sécurité : éviter qu’un PC “invité” voie/perturbe le réseau show.',
            'Diagnostic : plus simple de savoir “où” est un appareil.',
          ]),
          SizedBox(height: 10),
          _Callout(
            title: 'Piège classique',
            bullets: [
              'Même “début” d’IP ≠ même réseau si le masque n’est pas identique.',
              'Ex : 10.0.0.5/8 et 10.0.0.200/24 → pas le même périmètre logique.',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section4GatewayDnsDhcp extends StatelessWidget {
  const _Section4GatewayDnsDhcp();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '4) DHCP, passerelle, DNS : qui fait quoi ?',
      icon: Icons.settings_ethernet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Subtitle('DHCP (attribution automatique)'),
          _BulletList(items: [
            'Un serveur DHCP “donne” : IP + masque + passerelle + DNS.',
            'Pratique : tu branches, ça marche.',
            'Risque show : si le DHCP tombe / change / conflit → symptômes bizarres.',
          ]),
          SizedBox(height: 10),
          _Subtitle('Statique (IP fixe)'),
          _BulletList(items: [
            'Tu définis IP + masque (et éventuellement passerelle/DNS).',
            'Très utile pour : console, nodes, switch géré, AP Wi-Fi show.',
            'Risque : doublon d’IP si plan pas clair (conflit).',
          ]),
          SizedBox(height: 10),
          _Callout(
            title: 'Passerelle (gateway)',
            bullets: [
              'C’est l’adresse du routeur : elle sert pour aller “hors du réseau local”.',
              'Si tu fais un réseau show isolé (sans Internet) → passerelle souvent inutile.',
              'Mais si tu veux sortir vers un autre VLAN / Internet → indispensable.',
            ],
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'DNS',
            bullets: [
              'DNS = “annuaire” : transforme un nom (ex: example.com) en IP.',
              'En show (Art-Net/sACN), souvent inutile : tu travailles en IP direct.',
              'Si tu utilises des services (MAJ, licences, time server, streaming) → DNS redevient utile.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Règle simple (débutant-friendly)'),
          _BulletList(items: [
            'Petit show fermé : statique partout, pas de passerelle, pas de DNS.',
            'Show avec Internet / plusieurs réseaux : DHCP contrôlé + réservations DHCP, ou plan statique + routeur.',
          ]),
        ],
      ),
    );
  }
}

class _Section5HowDevicesTalk extends StatelessWidget {
  const _Section5HowDevicesTalk();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '5) Comment deux appareils se parlent (LAN vs hors LAN)',
      icon: Icons.swap_horiz,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            "Quand A veut parler à B, il regarde le masque :\n"
            "• Si B est dans le même sous-réseau → A envoie directement sur le réseau local.\n"
            "• Si B est hors sous-réseau → A envoie à la passerelle (routeur), qui s’occupe du reste.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Exemple (facile)',
            bullets: [
              'A = 192.168.0.10 /24',
              'B = 192.168.0.50 /24 → même réseau → OK direct.',
              'B = 192.168.1.50 /24 → réseau différent → besoin routeur/passerelle.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Pourquoi ça “ping” pas ?'),
          _BulletList(items: [
            'Masque différent → A pense que B est “ailleurs” (ou inversement).',
            'Pas de passerelle → impossible de sortir du sous-réseau.',
            'Pare-feu PC → ping bloqué (Windows très fréquent).',
            'Câble / switch / VLAN : physiquement pas dans le même segment.',
          ]),
          SizedBox(height: 10),
          _Callout(
            title: 'Broadcast vs unicast (bonus utile)',
            bullets: [
              'Unicast : vers une IP précise (propre).',
              'Broadcast : “à tous” sur le sous-réseau (bruyant).',
              'En show : broadcast peut marcher en petit, mais devient vite source de bruit en gros réseau.',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section6CommonShowPlans extends StatelessWidget {
  const _Section6CommonShowPlans();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '6) Plans IP “show” simples (exemples prêts à copier)',
      icon: Icons.map,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Subtitle('Plan A — ultra simple (un seul réseau /24)'),
          _CodeBox(text: '''
Réseau : 192.168.10.0/24   (masque 255.255.255.0)

Console : 192.168.10.10
PC (contrôle) : 192.168.10.20
Node 1 : 192.168.10.101
Node 2 : 192.168.10.102
Switch géré : 192.168.10.2
Passerelle : (vide) ou 192.168.10.1 si routeur présent
'''),
          SizedBox(height: 10),
          _Callout(
            title: 'Pourquoi ça marche bien',
            bullets: [
              'Tout le monde dans le même sous-réseau → aucune surprise.',
              'Facile à expliquer, facile à dépanner.',
              'Idéal débutant / petit à moyen show.',
            ],
          ),
          SizedBox(height: 12),
          _Subtitle('Plan B — “10.x” quand tu veux grandir'),
          _CodeBox(text: '''
Réseau : 10.10.0.0/16   (masque 255.255.0.0)

Console : 10.10.0.10
PC : 10.10.0.20
Nodes : 10.10.1.10 → 10.10.1.200
Switch : 10.10.0.2
'''),
          SizedBox(height: 10),
          _Callout(
            title: 'Quand l’utiliser',
            bullets: [
              'Quand tu as beaucoup d’équipements (ou plusieurs zones).',
              'Quand tu prévois VLAN plus tard (lumière/vidéo/IT).',
            ],
          ),
          SizedBox(height: 12),
          _Subtitle('Plan C — compat Art-Net “2.x.x.x” (legacy)'),
          _CodeBox(text: '''
Réseau : 2.0.0.0/8   (masque 255.0.0.0)

PC/console : 2.0.0.10
Node 1 : 2.0.0.100
Node 2 : 2.0.0.101

⚠️ Réseau isolé, pas d’Internet, pas de routage.
'''),
          SizedBox(height: 10),
          _Callout(
            title: 'Attention',
            bullets: [
              'Ce plan est pratique pour du matériel ancien / par défaut.',
              'Mais évite de mélanger avec un LAN “normal” (192.168.x.x) sans routeur.',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section7Troubleshooting extends StatelessWidget {
  const _Section7Troubleshooting();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '7) Dépannage : symptômes → causes (méthode terrain)',
      icon: Icons.bug_report,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Callout(
            title: 'Symptômes → causes probables',
            bullets: [
              '“Je vois le node mais ça répond pas” → masque différent / VLAN / pare-feu.',
              '“Un appareil marche puis disparaît” → DHCP instable / conflit d’IP.',
              '“Rien ne marche sauf sur le switch” → IP pas dans le même réseau / mauvais câble / port VLAN.',
              '“Tout rame / pertes” → broadcast/multicast trop large / switch bas de gamme / boucle réseau.',
              '“Ça marche en filaire mais pas en Wi-Fi” → jitter / roaming / bande saturée / power saving.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Méthode pro en 5 minutes'),
          _BulletList(items: [
            '1) Regarder IP + masque de la console/PC et du node.',
            '2) Vérifier : même sous-réseau ? (ex: 192.168.10.x /24)',
            '3) Ping (si possible) + test d’accès interface web du node.',
            '4) Si DHCP : lister qui a quelle IP (table DHCP) et vérifier doublons.',
            '5) Si sACN multicast : vérifier IGMP snooping/querier (sinon flood).',
          ]),
          SizedBox(height: 10),
          _Callout(
            title: 'Piège très fréquent',
            bullets: [
              'Masque “hérité” sur un PC (255.255.0.0 au lieu de 255.255.255.0).',
              'Résultat : tu crois être “dans le même réseau”, mais pas comme l’autre appareil.',
            ],
          ),
        ],
      ),
    );
  }
}

class _Section8MiniExercises extends StatelessWidget {
  const _Section8MiniExercises();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '8) Mini-exercices (vérifier vite un masque / un réseau)',
      icon: Icons.quiz,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Subtitle('Exercice 1 : même réseau ou pas ? (/24)'),
          _BulletList(items: [
            'A = 192.168.10.50 /24',
            'B = 192.168.10.200 /24 → ✅ même réseau',
            'B = 192.168.11.200 /24 → ❌ pas le même réseau',
          ]),
          SizedBox(height: 10),
          _Subtitle('Exercice 2 : /16 (255.255.0.0)'),
          _BulletList(items: [
            'A = 10.10.5.10 /16',
            'B = 10.10.200.20 /16 → ✅ même réseau (10.10.x.x)',
            'B = 10.11.200.20 /16 → ❌ pas le même réseau',
          ]),
          SizedBox(height: 10),
          _Callout(
            title: 'Astuce visuelle',
            bullets: [
              '/24 → les 3 premiers nombres identiques (A.B.C) = même réseau.',
              '/16 → les 2 premiers nombres identiques (A.B) = même réseau.',
              '/8 → le 1er nombre identique (A) = même réseau.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Exercice 3 : éviter les IP “bizarres”'),
          _BulletList(items: [
            '0.x.x.x : réservé (pas une IP normale d’hôte).',
            '127.x.x.x : loopback (ton PC lui-même).',
            '169.254.x.x : auto-IP quand DHCP absent (APIPA) → signe de problème DHCP.',
          ]),
        ],
      ),
    );
  }
}

class _Section9Checklist extends StatelessWidget {
  const _Section9Checklist({required this.onCopy});
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '9) Checklist rapide',
      icon: Icons.checklist,
      trailing: IconButton(
        tooltip: 'Copier la checklist',
        icon: const Icon(Icons.copy, color: Colors.white70),
        onPressed: onCopy,
      ),
      child: const _Callout(
        title: 'Avant de chercher midi à 14h',
        bullets: [
          'Même sous-réseau = IP + masque cohérents.',
          'Aucun doublon d’IP (conflit).',
          'DHCP : OK si maîtrisé; sinon plan statique clair.',
          'Pare-feu PC : peut bloquer ping / discovery.',
          'Switch/VLAN : bon port, bon VLAN, pas de boucle.',
          'sACN multicast : IGMP snooping/querier recommandés.',
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
      "Objectif : comprendre assez pour câbler / config / dépanner vite en show.\n"
      "Les détails réseau peuvent être plus profonds, mais ces bases couvrent 90% des pannes terrain.",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white38, fontSize: 12, height: 1.35),
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
                  Text(
                    '•  ',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.80), height: 1.35),
                  ),
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

/// Petit bloc monospaced “copiable” (style technique)
class _CodeBox extends StatelessWidget {
  const _CodeBox({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(12),
      child: Text(
        text.trimRight(),
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.88),
          fontFamily: 'monospace',
          height: 1.25,
          fontSize: 12.8,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
