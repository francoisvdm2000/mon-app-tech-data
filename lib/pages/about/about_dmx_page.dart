import 'package:flutter/material.dart';

import '../../app/ui/widgets.dart'; // SectionCard, ExpandSectionCard, MiniPill, copyToClipboard
import 'about_route_args.dart';

/// ✅ Anchors (pour arriver directement à une section)
enum DmxAnchor {
  basics,
  frame,
  cabling,
  termination,
  rdm,
  troubleshooting,
  artnet,
  sacn,
  compare,
  diagrams,
  checklist,
}

class AboutDmxPage extends StatefulWidget {
  const AboutDmxPage({super.key, this.initialAnchor});

  /// Optionnel (appel direct). Sinon, la page lit aussi RouteSettings.arguments
  final DmxAnchor? initialAnchor;

  @override
  State<AboutDmxPage> createState() => _AboutDmxPageState();
}

class _AboutDmxPageState extends State<AboutDmxPage> {
  final _scrollCtrl = ScrollController();

  // Anchors (table des matières -> sections)
  final _k1Basics = GlobalKey();
  final _k2Frame = GlobalKey();
  final _k3Cabling = GlobalKey();
  final _k4Termination = GlobalKey();

  // RDM section anchor
  final _k4bRdm = GlobalKey();

  final _k5Troubleshooting = GlobalKey();
  final _k6ArtNet = GlobalKey();
  final _k7Sacn = GlobalKey();
  final _k8Compare = GlobalKey();
  final _k9Diagrams = GlobalKey();
  final _k10Checklist = GlobalKey();

  bool _didJump = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didJump) return;
    _didJump = true;

    Object? effective = widget.initialAnchor;

    if (effective == null) {
      final args = ModalRoute.of(context)?.settings.arguments;

      // ✅ cas 1: ancien système (AboutRouteArgs)
      if (args is AboutRouteArgs) {
        effective = args.anchor;
      }

      // ✅ cas 2: nouveau système simple (on passe directement l'enum)
      if (effective == null && args is DmxAnchor) {
        effective = args;
      }
    }

    final a = (effective is DmxAnchor) ? effective : null;
    final target = _keyForAnchor(a);
    if (target == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureVisible(target, alignment: 0.05, durationMs: 300);
    });
  }

  GlobalKey? _keyForAnchor(DmxAnchor? a) {
    if (a == null) return null;
    switch (a) {
      case DmxAnchor.basics:
        return _k1Basics;
      case DmxAnchor.frame:
        return _k2Frame;
      case DmxAnchor.cabling:
        return _k3Cabling;
      case DmxAnchor.termination:
        return _k4Termination;
      case DmxAnchor.rdm:
        return _k4bRdm;
      case DmxAnchor.troubleshooting:
        return _k5Troubleshooting;
      case DmxAnchor.artnet:
        return _k6ArtNet;
      case DmxAnchor.sacn:
        return _k7Sacn;
      case DmxAnchor.compare:
        return _k8Compare;
      case DmxAnchor.diagrams:
        return _k9Diagrams;
      case DmxAnchor.checklist:
        return _k10Checklist;
    }
  }

  void _ensureVisible(
    GlobalKey key, {
    required double alignment,
    required int durationMs,
  }) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: Duration(milliseconds: durationMs),
      curve: Curves.easeOutCubic,
      alignment: alignment,
    );
  }

  void _goTo(GlobalKey key) => _ensureVisible(key, alignment: 0.02, durationMs: 280);

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
        title: const Text('DMX — fonctionnement (simple & complet)'),
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
                    'DMX = RS-485, 512 canaux (slots) par univers, valeurs 0–255 (8-bit).',
                    'Timing: 250 kbaud, univers plein ≈ ~44 Hz (ordre de grandeur).',
                    'Topologie: daisy-chain (pas de Y passif). Terminaison 120Ω sur le dernier.',
                    'RDM = DMX bidirectionnel (config/monitoring) → compatibilité splitters/nodes à vérifier.',
                    'Art-Net / sACN = univers DMX transportés sur Ethernet/IP via nodes/splitters.',
                    'sACN = multicast + priorités (IGMP snooping recommandé).',
                  ].join('\n');
                  copyToClipboard(context, txt);
                },
                items: [
                  _TocItem('1) DMX, univers, adresses — la base', onTap: () => _goTo(_k1Basics)),
                  _TocItem('2) Trame DMX — break, start code, canaux', onTap: () => _goTo(_k2Frame)),
                  _TocItem('3) Câblage RS-485 — topologie & câble', onTap: () => _goTo(_k3Cabling)),
                  _TocItem('4) Terminaison & splitters — éviter les réflexions', onTap: () => _goTo(_k4Termination)),
                  _TocItem('4bis) RDM — limites & compatibilités', onTap: () => _goTo(_k4bRdm)),
                  _TocItem('5) Dépannage terrain — symptômes → causes', onTap: () => _goTo(_k5Troubleshooting)),
                  _TocItem('6) Art-Net — origine, pourquoi, versions, adressage', onTap: () => _goTo(_k6ArtNet)),
                  _TocItem('7) sACN / E1.31 — multicast, IGMP, priorités', onTap: () => _goTo(_k7Sacn)),
                  _TocItem('8) DMX vs Art-Net vs sACN — choisir', onTap: () => _goTo(_k8Compare)),
                  _TocItem('9) Schémas terrain (DMX / IP / pinout)', onTap: () => _goTo(_k9Diagrams)),
                  _TocItem('10) Checklist rapide', onTap: () => _goTo(_k10Checklist)),
                ],
              ),

              const SizedBox(height: 12),

              _Anchor(key: _k1Basics),
              const _Section1Basics(),
              const SizedBox(height: 12),

              _Anchor(key: _k2Frame),
              const _Section2Frame(),
              const SizedBox(height: 12),

              _Anchor(key: _k3Cabling),
              const _Section3Cabling(),
              const SizedBox(height: 12),

              _Anchor(key: _k4Termination),
              const _Section4TerminationSplitters(),
              const SizedBox(height: 12),

              _Anchor(key: _k4bRdm),
              const _Section4bRdm(),
              const SizedBox(height: 12),

              _Anchor(key: _k5Troubleshooting),
              const _Section5Troubleshooting(),
              const SizedBox(height: 12),

              _Anchor(key: _k6ArtNet),
              const _Section6ArtNet(),
              const SizedBox(height: 12),

              _Anchor(key: _k7Sacn),
              const _Section7Sacn(),
              const SizedBox(height: 12),

              _Anchor(key: _k8Compare),
              const _Section8Compare(),
              const SizedBox(height: 12),

              _Anchor(key: _k9Diagrams),
              const _Section9Diagrams(),
              const SizedBox(height: 12),

              _Anchor(key: _k10Checklist),
              _Section10Checklist(
                onCopy: () {
                  final txt = '''
DMX — Checklist terrain
☐ Mode appareil correct (nombre de canaux)
☐ Adresse DMX correcte (pas de chevauchement)
☐ Daisy-chain (pas de Y passif)
☐ Terminaison 120Ω sur le dernier appareil
☐ Câble DMX/RS-485 (paire torsadée 120Ω) si possible
☐ Splitter opto si plusieurs branches
☐ Éloigner DMX des sources parasites (alims, dimmers) si possible
☐ Si RDM: vérifier compatibilité splitter/node + câblage impeccable

Art-Net / sACN — Checklist terrain
☐ Réseau dédié si possible (ou VLAN)
☐ Switch correct; IGMP snooping recommandé (sACN multicast)
☐ Unicast (souvent) ou multicast maîtrisé (éviter flood)
☐ Mapping univers ↔ ports/node vérifié
☐ IP plan clair (adresses, masque, DHCP vs statique)
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
/// TOC (Table des matières)
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
/// SECTION 1 — BASICS
/// =======================

class _Section1Basics extends StatelessWidget {
  const _Section1Basics();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '1) DMX, univers, adresses — la base',
      icon: Icons.view_stream,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MiniPill('1 univers = 512 slots'),
              MiniPill('0–255 (8-bit)'),
              MiniPill('16-bit = 2 canaux'),
            ],
          ),
          SizedBox(height: 10),
          _Paragraph(
            "DMX512 est un protocole de contrôle très utilisé en spectacle (lumière, effets, dimmers). "
            "C’est un flux série (RS-485) qui envoie en boucle une “trame” contenant jusqu’à 512 valeurs. "
            "Chaque valeur = un canal (0→255).",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'À retenir',
            bullets: [
              '1 univers DMX = 512 canaux (slots) numérotés 1→512.',
              'Un appareil écoute une adresse de départ (ex: 101) et consomme N canaux (selon son mode).',
              'Le contrôleur renvoie tout en continu : si tu arrêtes d’émettre, les appareils “gèlent” (ou passent en fallback).',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Adresse + mode = 80% des pannes'),
          _BulletList(items: [
            'Projecteur en mode 16ch à l’adresse 101 → il utilise 101→116.',
            'Un dimmer 6ch à l’adresse 1 → il utilise 1→6.',
            'Deux appareils ne doivent pas se chevaucher sur un même univers.',
          ]),
          SizedBox(height: 10),
          _Subtitle('8-bit, 16-bit (pan/tilt, dimmer fin)'),
          _BulletList(items: [
            'Beaucoup de paramètres sont en 8-bit (0→255).',
            'Pour plus de précision, certains paramètres utilisent 16-bit (deux canaux : coarse + fine).',
            'Ex: PAN coarse (canal X) + PAN fine (canal X+1).',
          ]),
          SizedBox(height: 10),
          _Callout(
            title: 'Vocabulaire terrain',
            bullets: [
              'Univers : “paquet” de 512 canaux.',
              'Adresse : premier canal utilisé par l’appareil.',
              'Mode : combien de canaux l’appareil consomme.',
              'THRU/OUT : sortie DMX qui continue la chaîne.',
            ],
          ),
        ],
      ),
    );
  }
}

// ... (le reste de ton fichier est inchangé)


/// =======================
/// SECTION 2 — FRAME
/// =======================

class _Section2Frame extends StatelessWidget {
  const _Section2Frame();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '2) Trame DMX — break, start code, canaux',
      icon: Icons.timeline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MiniPill('250 kbaud'),
              MiniPill('~44 trames/s (512 slots)'),
              MiniPill('Start code 0'),
            ],
          ),
          SizedBox(height: 10),
          _Paragraph(
            "Une trame DMX est une séquence répétée en boucle. "
            "Elle commence par un BREAK (pause plus longue) qui dit aux récepteurs : “nouvelle trame”. "
            "Ensuite vient un Start Code (souvent 0), puis jusqu’à 512 octets de canaux (valeurs 0–255).",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Image mentale simple',
            bullets: [
              'La console rejoue une table de 512 cases en boucle.',
              'Le BREAK = top départ pour relire la table.',
              'Chaque appareil ne lit que sa “fenêtre” (adresse + N canaux).',
            ],
          ),
          SizedBox(height: 12),
          _Subtitle('Timeline DMX (visuel)'),
          SizedBox(height: 10),
          _DiagramBox(aspect: 16 / 6.8, painter: _DmxTimingPainter()),
          SizedBox(height: 10),
          _Subtitle('Vitesse / latence (terrain)'),
          _BulletList(items: [
            'DMX est typiquement à 250 kbaud (format série “DMX”).',
            'Selon la longueur de trame, tu vois souvent ~20 à 44 trames/s.',
            'Un univers plein (512 slots) donne souvent ~44 Hz (ordre de grandeur).',
            'La latence ressentie vient souvent plus de la console, du traitement fixture, ou du réseau (si Art-Net/sACN) que du DMX brut.',
          ]),
          SizedBox(height: 10),
          _Subtitle('Start code (à connaître, sans se perdre)'),
          _BulletList(items: [
            'Start code 0 : “DMX normal” (la grande majorité des cas).',
            'D’autres start codes existent (ex: RDM) : à retenir surtout si tu as des comportements étranges avec des splitters/convertisseurs.',
          ]),
        ],
      ),
    );
  }
}

/// =======================
/// SECTION 3 — CABLING
/// =======================

class _Section3Cabling extends StatelessWidget {
  const _Section3Cabling();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '3) Câblage RS-485 — topologie & câble',
      icon: Icons.cable,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Subtitle('Topologie (le point critique)'),
          _BulletList(items: [
            '✅ Daisy-chain : console → appareil 1 → appareil 2 → ... → dernier',
            '❌ Éviter le “Y” passif (split en 2 sans splitter) : réflexions → erreurs → flicker',
            '✅ Si tu dois faire plusieurs branches : splitter DMX (idéalement opto-isolé)',
          ]),
          SizedBox(height: 10),
          _Subtitle('Le bon câble'),
          _BulletList(items: [
            'DMX = paire torsadée 120Ω (câble DMX / RS-485).',
            'Un câble micro peut “marcher” sur courte distance, puis devenir instable (impédance différente).',
            'Plus le plateau est “sale” (parasites, longues distances), plus le vrai câble DMX devient important.',
          ]),
          SizedBox(height: 10),
          _Callout(
            title: 'Connecteurs XLR (rappel terrain)',
            bullets: [
              'Standard DMX : XLR 5 broches (souvent XLR 3 broches en pratique).',
              'La compatibilité “physique” ne veut pas dire “câble correct”.',
              'Le problème n°1 n’est pas le protocole : c’est le câblage / topologie / terminaison.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Combien d’appareils ?'),
          _BulletList(items: [
            'RS-485 a des limites de charge : en pratique, si tu empiles trop d’appareils sans splitter, ça devient instable.',
            'Réflexe pro : splitter (opto) quand tu as beaucoup de lignes/branches, ou un réseau de machines important.',
          ]),
        ],
      ),
    );
  }
}

/// =======================
/// SECTION 4 — TERMINATION / SPLITTERS
/// =======================

class _Section4TerminationSplitters extends StatelessWidget {
  const _Section4TerminationSplitters();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '4) Terminaison & splitters — éviter les réflexions',
      icon: Icons.power,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Paragraph(
            "Le DMX (RS-485) se comporte comme une ligne de transmission. "
            "Sans terminaison, une partie du signal se réfléchit en bout de ligne → erreurs de lecture. "
            "Ça se voit en flicker, valeurs instables, appareils qui “perdent” le signal.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Terminaison 120Ω',
            bullets: [
              '✅ 120Ω sur le DERNIER appareil de la chaîne.',
              '❌ Pas au milieu, pas sur plusieurs branches en parallèle.',
              'Même si “ça marche sans” sur petit setup : ça n’est pas fiable en conditions réelles.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Splitter DMX (opto) = outil de stabilité'),
          _BulletList(items: [
            'Permet de créer plusieurs branches sans Y passif.',
            'Isolation optique : protège contre parasites, erreurs de masse, défauts d’un appareil.',
            'Bon réflexe festival/plateau chargé : console → splitter → branches.',
          ]),
          SizedBox(height: 10),
          _Subtitle('RDM (bonus utile)'),
          _BulletList(items: [
            'RDM = “retour” sur DMX (bidirectionnel) pour config/monitoring.',
            'Tous les splitters/nodes ne le laissent pas passer : si tu fais du RDM, vérifie compatibilités.',
          ]),
        ],
      ),
    );
  }
}

/// =======================
/// SECTION 4bis — RDM
/// =======================

class _Section4bRdm extends StatelessWidget {
  const _Section4bRdm();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '4bis) RDM — limites & compatibilités',
      icon: Icons.settings_input_component,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MiniPill('Bidirectionnel'),
              MiniPill('Discovery'),
              MiniPill('Pass-through variable'),
            ],
          ),
          SizedBox(height: 10),
          _Paragraph(
            "RDM (Remote Device Management) ajoute un canal de retour sur la même ligne DMX : "
            "la console peut détecter/configurer des appareils (adresse, mode, capteurs, etc.). "
            "C’est utile, mais plus exigeant sur la qualité de la ligne et la compatibilité du matériel intermédiaire.",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Limites / pièges terrain',
            bullets: [
              'RDM a besoin d’un chemin bidirectionnel : certains splitters, nodes ou opto-isolateurs bloquent le retour.',
              'Le “discovery” peut être sensible : câblage borderline + réflexions = réponses perdues.',
              'Deux contrôleurs RDM sur la même ligne = conflits possibles (selon setup).',
              'RDM sur réseau (via node) : dépend de l’implémentation du node (RDM proxy, support partiel, etc.).',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Compatibilité splitters / nodes'),
          _BulletList(items: [
            'Splitter “RDM compatible” : il route les trames RDM retour vers la console (ou fait du proxy).',
            'Beaucoup de splitters DMX classiques isolent et “cassent” le retour : parfait pour la stabilité DMX, mais pas pour RDM.',
            'Sur nodes Art-Net/sACN : cherche explicitement “RDM proxy” / “RDM over IP” dans la doc.',
          ]),
          SizedBox(height: 10),
          _Subtitle('Bonnes pratiques simples'),
          _BulletList(items: [
            'D’abord stabiliser le DMX (topologie, terminaison, câble) avant d’activer RDM.',
            'Limiter les branches pendant un discovery (moins de complexité).',
            'En cas de souci : désactiver RDM temporairement pour vérifier que le DMX “pur” est stable.',
          ]),
        ],
      ),
    );
  }
}

/// =======================
/// SECTION 5 — TROUBLESHOOTING
/// =======================

class _Section5Troubleshooting extends StatelessWidget {
  const _Section5Troubleshooting();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '5) Dépannage terrain — symptômes → causes',
      icon: Icons.bug_report,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Callout(
            title: 'Symptômes → causes probables',
            bullets: [
              'Flicker / valeurs instables → terminaison absente, Y passif, câble inadapté, parasites.',
              'Tout marche sauf “après” un appareil → THRU/OUT HS, ou appareil configuré bizarrement.',
              'Machines “en décalage” → mauvais mode (nombre de canaux) ou mauvaise adresse.',
              'Une branche entière KO → pas de splitter, distribution mauvaise, connecteur/câble cassé.',
              'Comportement aléatoire quand tu allumes une grosse alim/dimmer → masse/parasites, routing câble, absence d’opto.',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Méthode rapide (qui marche vraiment)'),
          _BulletList(items: [
            '1) Vérifie mode + adresse (souvent LA cause).',
            '2) Test “chaîne courte” : console → 1 appareil (câble connu OK) + terminaison.',
            '3) Ajoute appareil par appareil pour isoler celui qui casse la ligne.',
            '4) Dès que tu branches en branches : splitter.',
            '5) Si plateau “sale” : opto + câble DMX + chemins propres.',
            '6) Si RDM activé et instable : coupe RDM pour isoler le problème (DMX vs retour).',
          ]),
          SizedBox(height: 10),
          _Callout(
            title: 'Raccourci mental',
            bullets: [
              'DMX instable = presque toujours “réflexions / topologie / câble / parasites” avant “protocole”.',
            ],
          ),
        ],
      ),
    );
  }
}

/// =======================
/// SECTION 6 — ART-NET
/// =======================

class _Section6ArtNet extends StatelessWidget {
  const _Section6ArtNet();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '6) Art-Net — origine, pourquoi, versions, adressage',
      icon: Icons.router,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              MiniPill('UDP'),
              MiniPill('Broadcast/Unicast'),
              MiniPill('Univers DMX sur IP'),
            ],
          ),
          SizedBox(height: 10),
          _Paragraph(
            "Art-Net transporte des univers DMX sur Ethernet/IP. "
            "Au lieu d’avoir une sortie DMX physique par univers, tu envoies les univers sur le réseau, "
            "puis des nodes (convertisseurs) ressortent du DMX près des machines. "
            "Art-Net est historiquement très répandu en événementiel (facile, “plug & play” sur réseau dédié).",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Pourquoi c’est pratique',
            bullets: [
              'Beaucoup d’univers sur un seul lien réseau.',
              'Nodes proches des projecteurs/dimmers → moins de longues lignes DMX.',
              'Ajout/évolution rapide (tu rajoutes un node, tu patch).',
            ],
          ),
          SizedBox(height: 10),
          _Subtitle('Unicast vs Broadcast (terrain)'),
          _BulletList(items: [
            'Broadcast : simple, mais peut charger un LAN (tout le monde reçoit tout).',
            'Unicast : tu envoies vers l’IP des nodes → plus propre et plus stable sur réseau chargé.',
            'Règle show : si réseau partagé/complexe → unicast. Si petit LAN dédié → broadcast peut suffire.',
          ]),
          SizedBox(height: 10),
          _Subtitle('Limites réelles (ce qui casse en premier)'),
          _BulletList(items: [
            'Wi-Fi : souvent le goulot (latence variable, pertes).',
            'Broadcast : peut “flood” un switch et saturer des ports inutiles.',
            'Nodes : CPU/firmware peuvent limiter le nombre d’univers à haute fréquence.',
            'Règle simple : réseau dédié (ou VLAN) + unicast si beaucoup d’univers.',
          ]),
          SizedBox(height: 10),
          _Subtitle('Port / réseau “classique” Art-Net'),
          _BulletList(items: [
            'Art-Net utilise UDP (port Art-Net dédié).',
            'Historiquement, beaucoup de matériel démarre en 2.x.x.x sur réseau fermé (pratique, mais attention au routage).',
            'Bon réflexe : réseau lumière séparé (ou VLAN) pour éviter d’inonder le reste.',
          ]),
          SizedBox(height: 10),
          _Callout(
            title: 'Versions (repère utile)',
            bullets: [
              'Art-Net 2 : encore vu sur ancien matériel.',
              'Art-Net 3 / 4 : plus récent, plus robuste en gros réseaux.',
              'Le plus important n’est pas “la version” mais la cohérence : adressage, univers, unicast/broadcast, switch.',
            ],
          ),
        ],
      ),
    );
  }
}

/// =======================
/// SECTION 7 — sACN
/// =======================

class _Section7Sacn extends StatelessWidget {
  const _Section7Sacn();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '7) sACN / E1.31 — multicast, IGMP, priorités',
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
            "sACN (ANSI E1.31) est un standard pour transporter des univers DMX sur IP. "
            "Il est très apprécié en réseaux “propres” parce qu’il s’appuie bien sur le multicast et propose "
            "des mécanismes standardisés (dont la priorité).",
          ),
          SizedBox(height: 10),
          _Callout(
            title: 'Points clés',
            bullets: [
              'Multicast : chaque univers est diffusé, et seuls les appareils abonnés doivent le recevoir.',
              'Priorités : utile si plusieurs sources existent (console + backup + media server).',
              'Réseau : IGMP snooping recommandé, sinon le multicast peut se transformer en “flood”.',
            ],
          ),
          SizedBox(height: 12),
          _Subtitle('Schéma : multicast & IGMP'),
          SizedBox(height: 10),
          _DiagramBox(aspect: 16 / 6.8, painter: _SacnMulticastPainter()),
          SizedBox(height: 10),
          _Subtitle('IGMP snooping (explication terrain)'),
          _BulletList(items: [
            'Sans IGMP : le switch envoie le multicast à (presque) tous les ports → saturation possible.',
            'Avec IGMP : le switch apprend quels ports “veulent” quel univers → envoi uniquement où il faut.',
            'Résultat : réseau stable quand tu as beaucoup d’univers.',
          ]),
          SizedBox(height: 10),
          _Callout(
            title: 'Règle simple',
            bullets: [
              'sACN + beaucoup d’univers = switch géré/IGMP (ou architecture réseau bien pensée).',
            ],
          ),
        ],
      ),
    );
  }
}

/// =======================
/// SECTION 8 — COMPARE
/// =======================

class _Section8Compare extends StatelessWidget {
  const _Section8Compare();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '8) DMX vs Art-Net vs sACN — choisir',
      icon: Icons.compare_arrows,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _CompareTable(),
          SizedBox(height: 10),
          _Callout(
            title: 'Choix rapide (pratique)',
            bullets: [
              'Petit setup / 1–2 univers / direct : DMX.',
              'Beaucoup d’univers / nodes distribués : Art-Net ou sACN.',
              'Réseau pro (multicast + priorités + gros volumes) : sACN (switch IGMP).',
              'Événementiel “rapide” en réseau dédié : Art-Net est très courant.',
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
      ['Topologie', 'Chaîne', 'LAN + nodes', 'LAN + nodes'],
      ['Univers', '1 sortie = 1 univers', 'Très scalable', 'Très scalable'],
      ['Diffusion', 'N/A', 'Broadcast/Unicast', 'Multicast/Unicast'],
      ['Priorités', 'Non', 'Selon implém.', 'Oui (standard)'],
      ['Switch', 'N/A', 'simple ok', 'IGMP recommandé'],
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
      fontWeight: isHeader ? FontWeight.w900 : FontWeight.w700,
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
/// SECTION 9 — DIAGRAMS
/// =======================

class _Section9Diagrams extends StatelessWidget {
  const _Section9Diagrams();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '9) Schémas terrain (DMX / IP / pinout)',
      icon: Icons.schema,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _Subtitle('DMX : daisy-chain + terminaison'),
          SizedBox(height: 10),
          _DiagramBox(painter: _DmxChainPainter()),
          SizedBox(height: 14),

          _Subtitle('DMX : timeline trame (BREAK → slots → loop)'),
          SizedBox(height: 10),
          _DiagramBox(aspect: 16 / 6.8, painter: _DmxTimingPainter()),
          SizedBox(height: 14),

          _Subtitle('XLR5 DMX : pinout (référence rapide)'),
          SizedBox(height: 10),
          _DiagramBox(aspect: 16 / 8, painter: _Xlr5PinoutPainter()),
          SizedBox(height: 14),

          _Subtitle('Terminator 120Ω : où et pourquoi'),
          SizedBox(height: 10),
          _DiagramBox(aspect: 16 / 8, painter: _TerminatorPainter()),
          SizedBox(height: 14),

          _Subtitle('Art-Net / sACN : réseau + nodes'),
          SizedBox(height: 10),
          _DiagramBox(painter: _IpDmxPainter()),
          SizedBox(height: 14),

          _Subtitle('sACN : multicast & IGMP (idée)'),
          SizedBox(height: 10),
          _DiagramBox(aspect: 16 / 6.8, painter: _SacnMulticastPainter()),
        ],
      ),
    );
  }
}

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

/// =======================
/// SECTION 10 — CHECKLIST
/// =======================

class _Section10Checklist extends StatelessWidget {
  const _Section10Checklist({required this.onCopy});

  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '10) Checklist rapide',
      icon: Icons.checklist,
      trailing: IconButton(
        tooltip: 'Copier la checklist',
        icon: const Icon(Icons.copy, color: Colors.white70),
        onPressed: onCopy,
      ),
      child: const _Callout(
        title: 'À faire avant d’accuser “la console”',
        bullets: [
          'Mode + adresse (toujours vérifier).',
          'Test chaîne courte avec câble connu OK.',
          'Ajout appareil par appareil pour isoler.',
          'Terminaison 120Ω sur le dernier.',
          'Splitter opto si plusieurs branches.',
          'Si RDM : vérifier splitter/node compatible.',
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
      "Info indicative (terrain). Les comportements exacts peuvent varier selon consoles, nodes, switchs et firmwares.\n"
      "Objectif ici : comprendre et dépanner vite, avec une méthode fiable.",
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

/// =======================
/// DIAGRAMS (CustomPainter)
/// =======================

class _DmxTimingPainter extends CustomPainter {
  const _DmxTimingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0B0B0B);
    canvas.drawRect(Offset.zero & size, bg);

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

    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final y = size.height * 0.55;
    final left = size.width * 0.07;
    final right = size.width * 0.93;

    canvas.drawLine(Offset(left, y), Offset(right, y), stroke);

    final xBreakEnd = size.width * 0.19;
    final xMabEnd = size.width * 0.27;
    final xStartCodeEnd = size.width * 0.34;
    final xSlotsEnd = size.width * 0.86;

    final accentBreak = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.55)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final accentMab = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final accentSlots = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(left, y), Offset(xBreakEnd, y), accentBreak);
    canvas.drawLine(Offset(xBreakEnd, y), Offset(xMabEnd, y), accentMab);
    canvas.drawLine(Offset(xStartCodeEnd, y), Offset(xSlotsEnd, y), accentSlots);

    _tick(canvas, Offset(xBreakEnd, y), size);
    _tick(canvas, Offset(xMabEnd, y), size);
    _tick(canvas, Offset(xStartCodeEnd, y), size);
    _tick(canvas, Offset(xSlotsEnd, y), size);

    _Text.paintLabel(
      canvas,
      Offset(left, size.height * 0.12),
      _Text.tp(
        'BREAK',
        fontSize: size.shortestSide * 0.070,
        color: Colors.white.withValues(alpha: 0.92),
        weight: FontWeight.w900,
      ),
    );
    _Text.paintLabel(
      canvas,
      Offset(xBreakEnd - size.width * 0.03, size.height * 0.25),
      _Text.tp(
        'MAB',
        fontSize: size.shortestSide * 0.060,
        color: Colors.white.withValues(alpha: 0.90),
        weight: FontWeight.w900,
      ),
    );
    _Text.paintLabel(
      canvas,
      Offset(xMabEnd + size.width * 0.02, size.height * 0.12),
      _Text.tp(
        'Start\ncode',
        fontSize: size.shortestSide * 0.058,
        color: Colors.white.withValues(alpha: 0.90),
        weight: FontWeight.w900,
      ),
    );
    _Text.paintLabel(
      canvas,
      Offset(xStartCodeEnd + size.width * 0.05, size.height * 0.20),
      _Text.tp(
        'Slots 1…N\n(jusqu’à 512)',
        fontSize: size.shortestSide * 0.058,
        color: Colors.white.withValues(alpha: 0.92),
        weight: FontWeight.w900,
      ),
    );

    final foot = _Text.tp(
      'Boucle (refresh) — univers plein ≈ ~44 Hz (ordre de grandeur)',
      fontSize: size.shortestSide * 0.052,
      color: Colors.white.withValues(alpha: 0.85),
      weight: FontWeight.w800,
    );
    _Text.paintLabel(canvas, Offset(left, size.height * 0.74), foot);
  }

  void _tick(Canvas canvas, Offset p, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 2;
    canvas.drawLine(p.translate(0, -size.height * 0.10), p.translate(0, size.height * 0.10), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SacnMulticastPainter extends CustomPainter {
  const _SacnMulticastPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0B0B0B);
    canvas.drawRect(Offset.zero & size, bg);

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

    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final src1 = Offset(size.width * 0.14, size.height * 0.30);
    final src2 = Offset(size.width * 0.14, size.height * 0.62);
    final sw = Offset(size.width * 0.40, size.height * 0.46);

    final group = Offset(size.width * 0.60, size.height * 0.46);

    final r1 = Offset(size.width * 0.86, size.height * 0.22);
    final r2 = Offset(size.width * 0.86, size.height * 0.46);
    final r3 = Offset(size.width * 0.86, size.height * 0.70);

    canvas.drawLine(src1, sw, stroke);
    canvas.drawLine(src2, sw, stroke);
    canvas.drawLine(sw, group, stroke);

    canvas.drawLine(group, r1, stroke);
    canvas.drawLine(group, r2, stroke);
    canvas.drawLine(group, r3, stroke);

    _box(canvas, size, src1, 'SOURCE A\n(prio 100)', accent: false);
    _box(canvas, size, src2, 'SOURCE B\n(prio 90)', accent: false);

    _box(canvas, size, sw, 'SWITCH\nIGMP snooping', accent: true);
    _box(canvas, size, group, 'MULTICAST\nUniverse U', accent: true);

    _small(canvas, size, r1, 'RX');
    _small(canvas, size, r2, 'RX');
    _small(canvas, size, r3, 'RX');

    final tp = _Text.tp(
      'Sans IGMP : flood\nAvec IGMP : seulement ports abonnés',
      fontSize: size.shortestSide * 0.060,
      color: Colors.white.withValues(alpha: 0.90),
      weight: FontWeight.w900,
    );
    _Text.paintLabel(canvas, Offset(size.width * 0.08, size.height * 0.80), tp);
  }

  void _box(Canvas canvas, Size size, Offset center, String label, {required bool accent}) {
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

class _DmxChainPainter extends CustomPainter {
  const _DmxChainPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0B0B0B);
    canvas.drawRect(Offset.zero & size, bg);

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

    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.88)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final y = size.height * 0.55;
    final x0 = size.width * 0.10;
    final dx = size.width * 0.18;

    final nodes = <_Node>[
      _Node('CONSOLE', Offset(x0, y)),
      _Node('FIX 1', Offset(x0 + dx, y)),
      _Node('FIX 2', Offset(x0 + dx * 2, y)),
      _Node('FIX 3', Offset(x0 + dx * 3, y)),
      _Node('TERM\n120Ω', Offset(x0 + dx * 4, y), isTerminator: true),
    ];

    for (int i = 0; i < nodes.length - 1; i++) {
      canvas.drawLine(nodes[i].pos, nodes[i + 1].pos, stroke);
    }

    for (final n in nodes) {
      _drawBox(canvas, size, n.pos, n.label, isTerminator: n.isTerminator);
    }

    final warnPos = Offset(size.width * 0.68, size.height * 0.18);
    final tp = _Text.tp(
      '✅ Daisy-chain\n❌ Pas de Y passif',
      fontSize: size.shortestSide * 0.07,
      color: Colors.white.withValues(alpha: 0.92),
      weight: FontWeight.w900,
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
      fontSize: size.shortestSide * 0.060,
      color: Colors.white.withValues(alpha: 0.95),
      weight: FontWeight.w900,
    );
    _Text.center(canvas, rect, tp);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Xlr5PinoutPainter extends CustomPainter {
  const _Xlr5PinoutPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0B0B0B);
    canvas.drawRect(Offset.zero & size, bg);

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

    final cx = size.width * 0.32;
    final cy = size.height * 0.52;
    final r = size.shortestSide * 0.24;

    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    final pins = <int, Offset>{
      1: Offset(cx, cy + r * 0.45),
      2: Offset(cx - r * 0.38, cy - r * 0.10),
      3: Offset(cx + r * 0.38, cy - r * 0.10),
      4: Offset(cx - r * 0.22, cy - r * 0.55),
      5: Offset(cx + r * 0.22, cy - r * 0.55),
    };

    for (final e in pins.entries) {
      canvas.drawCircle(
        e.value,
        r * 0.12,
        Paint()..color = Colors.white.withValues(alpha: 0.85),
      );
      final tp = _Text.tp(
        '${e.key}',
        fontSize: size.shortestSide * 0.055,
        color: const Color(0xFF0B0B0B),
        weight: FontWeight.w900,
      );
      _Text.center(canvas, Rect.fromCenter(center: e.value, width: r * 0.22, height: r * 0.22), tp);
    }

    final rightX = size.width * 0.58;
    final topY = size.height * 0.18;

    _label(
      canvas,
      Offset(rightX, topY),
      'XLR5 (DMX) — repère rapide',
      size.shortestSide * 0.070,
      Colors.white.withValues(alpha: 0.94),
      FontWeight.w900,
    );

    final bullets = [
      'Pin 1 : Shield / masse',
      'Pin 2 : Data−',
      'Pin 3 : Data+',
      'Pin 4/5 : “data 2” (rare / optionnel)',
      'En pratique : XLR3 souvent utilisé (1/2/3)',
    ];
    _bulletBox(canvas, Rect.fromLTWH(rightX, topY + 22, size.width * 0.38, size.height * 0.60), bullets);
  }

  void _label(Canvas c, Offset p, String s, double fs, Color col, FontWeight w) {
    final tp = _Text.tp(s, fontSize: fs, color: col, weight: w);
    tp.paint(c, p);
  }

  void _bulletBox(Canvas c, Rect r, List<String> items) {
    final rr = RRect.fromRectAndRadius(r, const Radius.circular(14));
    c.drawRRect(rr, Paint()..color = Colors.black.withValues(alpha: 0.35));
    c.drawRRect(
      rr,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.14)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    double y = r.top + 12;
    for (final s in items) {
      final tp = _Text.tp(
        '• $s',
        fontSize: r.shortestSide * 0.13,
        color: Colors.white.withValues(alpha: 0.86),
        weight: FontWeight.w700,
      );
      tp.paint(c, Offset(r.left + 12, y));
      y += tp.height + 6;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TerminatorPainter extends CustomPainter {
  const _TerminatorPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0B0B0B);
    canvas.drawRect(Offset.zero & size, bg);

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

    final line = Paint()
      ..color = Colors.white.withValues(alpha: 0.88)
      ..strokeWidth = 2;

    final y = size.height * 0.55;
    final x0 = size.width * 0.10;
    final x1 = size.width * 0.78;

    canvas.drawLine(Offset(x0, y), Offset(x1, y), line);

    _box(canvas, size, Offset(size.width * 0.60, y), 'DERNIER\nAPPAREIL', accent: false);
    _box(canvas, size, Offset(size.width * 0.84, y), 'TERM\n120Ω', accent: true);

    _label(canvas, Offset(size.width * 0.10, size.height * 0.14), 'Terminaison = 120Ω en fin de ligne', size.shortestSide * 0.075);

    final rr = Rect.fromCenter(center: Offset(size.width * 0.84, size.height * 0.23), width: size.width * 0.20, height: size.height * 0.20);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rr, const Radius.circular(14)),
      Paint()..color = Colors.black.withValues(alpha: 0.35),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rr, const Radius.circular(14)),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.14)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    final tp = _Text.tp(
      '120Ω\nentre\nData− et Data+',
      fontSize: size.shortestSide * 0.060,
      color: Colors.white.withValues(alpha: 0.90),
      weight: FontWeight.w900,
    );
    _Text.center(canvas, rr, tp);

    final tip = _Text.tp(
      '✅ Une seule terminaison\n❌ Pas au milieu\n❌ Pas sur chaque branche',
      fontSize: size.shortestSide * 0.055,
      color: Colors.white.withValues(alpha: 0.88),
      weight: FontWeight.w800,
    );
    _Text.paintLabel(canvas, Offset(size.width * 0.10, size.height * 0.70), tip);
  }

  void _box(Canvas canvas, Size size, Offset center, String label, {required bool accent}) {
    final w = size.width * 0.18;
    final h = size.height * 0.20;
    final rect = Rect.fromCenter(center: center, width: w, height: h);
    final rr = RRect.fromRectAndRadius(rect, Radius.circular(size.shortestSide * 0.05));

    final fill = Paint()
      ..color = accent
          ? Colors.redAccent.withValues(alpha: 0.18)
          : Colors.white.withValues(alpha: 0.08);

    final border = Paint()
      ..color = accent
          ? Colors.redAccent.withValues(alpha: 0.65)
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

  void _label(Canvas canvas, Offset pos, String text, double fs) {
    final tp = _Text.tp(
      text,
      fontSize: fs,
      color: Colors.white.withValues(alpha: 0.94),
      weight: FontWeight.w900,
    );
    tp.paint(canvas, pos);
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
      ..color = Colors.white.withValues(alpha: 0.16)
      ..strokeWidth = 1;

    final step = size.shortestSide / 10;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), faint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), faint);
    }

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

    _box(canvas, size, console, 'CONSOLE\nArt-Net / sACN', accent: false);
    _box(canvas, size, sw, 'SWITCH\n(IGMP pour sACN)', accent: true);
    _box(canvas, size, node1, 'NODE 1\nDMX OUT', accent: false);
    _box(canvas, size, node2, 'NODE 2\nDMX OUT', accent: false);

    _small(canvas, size, fix1, 'FIX');
    _small(canvas, size, fix2, 'FIX');
    _small(canvas, size, fix3, 'FIX');
    _small(canvas, size, fix4, 'FIX');

    final tp = _Text.tp(
      '✅ Beaucoup d’univers\n✅ Nodes proches des machines',
      fontSize: size.shortestSide * 0.07,
      color: Colors.white.withValues(alpha: 0.90),
      weight: FontWeight.w900,
    );
    _Text.paintLabel(canvas, Offset(size.width * 0.08, size.height * 0.70), tp);
  }

  void _box(Canvas canvas, Size size, Offset center, String label, {required bool accent}) {
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
