import 'package:flutter/material.dart';

import '../about_search.dart';
import '../about_ip_basics_page.dart';

class AboutIpBasicsSearchIndex {
  static List<AboutSearchDoc> docs() => [
        AboutSearchDoc(
          title: 'Réseau — bases IP / masque / DHCP (mémo)',
          text: '''
IP = adresse logique pour joindre un appareil sur un réseau.
Privé (LAN) : 10.x.x.x, 172.16–31.x.x, 192.168.x.x (non routés sur Internet).
Masque / sous-réseau = partie “réseau” vs “machine”.
Même sous-réseau = communication directe. Sinon → passerelle (routeur).
DHCP attribue IP automatiquement; statique = utile pour nodes/console.
''',
          icon: Icons.language,
          pageBuilder: () => const AboutIpBasicsPage(),
          anchor: null,
        ),

        AboutSearchDoc(
          title: 'IP — c’est quoi et à quoi ça sert ?',
          text: '''
Une adresse IP (IPv4) est un identifiant logique sur un réseau.
Elle permet de dire : “envoie ce paquet à cet appareil”.

Quand tu branches une console, un node Art-Net/sACN, un PC, un switch géré…
tout ce qui parle en réseau doit avoir une IP cohérente pour que les appareils se trouvent.

Image mentale :
MAC = identifiant matériel (carte réseau).
IP = adresse “postale” sur un réseau (changeable).
Masque = “quartier / code postal” (délimite le sous-réseau).
Passerelle = “sortie du quartier” (routeur).

IPv4 en 10 secondes :
Format : A.B.C.D (4 nombres de 0 à 255).
Ex : 192.168.0.50
Ce n’est pas magique : 32 bits (4 octets).
Ce qui compte : IP + masque cohérents entre appareils.

Mots utiles: ipv4, ip, adresse ip, mac, carte réseau, réseau local, lan.
''',
          icon: Icons.language,
          pageBuilder: () => const AboutIpBasicsPage(),
          anchor: null,
        ),

        AboutSearchDoc(
          title: 'Adresses privées — 10.x / 172.16-31 / 192.168',
          text: '''
Certaines plages d’adresses IPv4 sont réservées aux réseaux privés (LAN).
Elles ne sont pas routées sur Internet.

Les 3 grandes plages privées (LAN) :
10.0.0.0 → 10.255.255.255 (10.x.x.x)
172.16.0.0 → 172.31.255.255 (172.16–31.x.x)
192.168.0.0 → 192.168.255.255 (192.168.x.x)

Pourquoi on voit souvent 192.168.x.x ?
Box/routeurs grand public utilisent souvent 192.168.0.x ou 192.168.1.x.
C’est devenu un “standard de fait” en petits LAN.
En show, 10.x.x.x est pratique si tu veux beaucoup d’adresses ou plusieurs VLAN.

Et le fameux 2.x.x.x (Art-Net) ?
Beaucoup de matériel Art-Net sort d’usine avec une IP en 2.x.x.x (réseau fermé).
C’est pratique en plug&play (sans DHCP), mais ça surprend si ton PC est en 192.168.x.x.
Le “2.x” n’a rien de magique pour le broadcast/unicast.
Ce qui change le périmètre du broadcast, c’est le masque (souvent /8 = 255.0.0.0 en legacy).
Exemple : réseau 2.0.0.0/8 → broadcast = 2.255.255.255 (très large).
Solution : mettre PC/console dans la même plage + même masque, ou reconfigurer le node sur un plan 192/10.

Mots utiles: privé, lan, plage privée, rfc1918, 10., 172., 192.168, 2., art-net, plug and play.
''',
          icon: Icons.shield,
          pageBuilder: () => const AboutIpBasicsPage(),
          anchor: null,
        ),

        AboutSearchDoc(
          title: 'Masque & sous-réseaux — comprendre pour de vrai',
          text: '''
Le masque (subnet mask) dit quelles adresses sont “dans le même réseau”.
Sans masque, une IP ne veut pas dire grand-chose.

Règle terrain :
Même sous-réseau → communication directe.
Sinon → besoin d’une passerelle (routeur).

Masques les plus courants :
255.0.0.0 ( /8 )   → réseau large
255.255.0.0 ( /16 ) → réseau large
255.255.255.0 ( /24 ) → réseau “classique” (254 appareils)

Masque → adresse de broadcast :
Le broadcast dépend du sous-réseau, donc du masque.
192.168.10.0/24 → broadcast = 192.168.10.255
2.0.0.0/8 (255.0.0.0) → broadcast = 2.255.255.255
Plus le réseau est grand, plus un broadcast peut faire du bruit.

Exemple concret /24 :
IP : 192.168.0.50
Masque : 255.255.255.0 (/24)
Réseau : 192.168.0.0
Hôtes : 192.168.0.1 → 192.168.0.254
Si tu passes en 192.168.1.50 → ce n’est plus le même réseau.

Pourquoi faire des sous-réseaux ?
Organisation : séparer lumière/vidéo/intercom/internet…
Performance : limiter broadcast/multicast.
Sécurité : éviter qu’un PC invité perturbe.
Diagnostic : savoir “où” est un appareil.

Piège classique :
Même début d’IP ≠ même réseau si le masque n’est pas identique.
Ex : 10.0.0.5/8 et 10.0.0.200/24 → pas le même périmètre logique.

Mots utiles: masque, subnet, sous-réseau, cidr, /24, /16, /8, broadcast, réseau, host, hôte.
''',
          icon: Icons.grid_4x4,
          pageBuilder: () => const AboutIpBasicsPage(),
          anchor: null,
        ),

        AboutSearchDoc(
          title: 'DHCP / statique / passerelle / DNS',
          text: '''
DHCP (automatique) :
Un serveur DHCP donne : IP + masque + passerelle + DNS.
Pratique : tu branches, ça marche.
Risque show : si DHCP tombe/change/conflit → symptômes bizarres.

Statique (IP fixe) :
Tu définis IP + masque (et éventuellement passerelle/DNS).
Utile pour : console, nodes, switch géré, AP Wi-Fi show.
Risque : doublon d’IP si plan pas clair (conflit).

Passerelle (gateway) :
Adresse du routeur, sert pour aller “hors du réseau local”.
Réseau show isolé (sans Internet) → passerelle souvent inutile.
Mais pour sortir vers un autre VLAN / Internet → indispensable.

DNS :
Transforme un nom (example.com) en IP.
En show (Art-Net/sACN) souvent inutile car IP direct.
Utile si services (MAJ, licences, time server, streaming).

Règle simple :
Petit show fermé : statique partout, pas de passerelle, pas de DNS.
Show avec Internet/plusieurs réseaux : DHCP contrôlé + réservations, ou plan statique + routeur.

Mots utiles: dhcp, statique, ip fixe, gateway, passerelle, dns, routeur, serveur dhcp, réservation.
''',
          icon: Icons.settings_ethernet,
          pageBuilder: () => const AboutIpBasicsPage(),
          anchor: null,
        ),

        AboutSearchDoc(
          title: 'LAN vs hors LAN — comment deux appareils se parlent',
          text: '''
Quand A veut parler à B, il regarde le masque :
Si B est dans le même sous-réseau → A envoie directement sur le LAN.
Si B est hors sous-réseau → A envoie à la passerelle (routeur).

Exemple :
A = 192.168.0.10 /24
B = 192.168.0.50 /24 → même réseau → OK direct.
B = 192.168.1.50 /24 → réseau différent → besoin routeur/passerelle.

Pourquoi ça ping pas ?
Masque différent.
Pas de passerelle.
Pare-feu PC (Windows fréquent).
Câble / switch / VLAN : pas dans le même segment.

Broadcast vs unicast :
Unicast = vers une IP précise.
Broadcast = à tous sur le sous-réseau.
Broadcast devient vite bruyant en gros réseau.

Mots utiles: ping, pare-feu, firewall, vlan, switch, segment, unicast, broadcast, lan, route.
''',
          icon: Icons.swap_horiz,
          pageBuilder: () => const AboutIpBasicsPage(),
          anchor: null,
        ),

        AboutSearchDoc(
          title: 'Plans IP “show” — exemples prêts à copier',
          text: '''
Plan A — ultra simple (/24) :
Réseau : 192.168.10.0/24 (255.255.255.0)
Console : 192.168.10.10
PC : 192.168.10.20
Node 1 : 192.168.10.101
Node 2 : 192.168.10.102
Switch : 192.168.10.2
Passerelle : vide ou 192.168.10.1 si routeur.

Pourquoi ça marche bien :
Tout le monde dans le même sous-réseau.
Facile à dépanner.

Plan B — 10.x (/16) :
Réseau : 10.10.0.0/16 (255.255.0.0)
Console : 10.10.0.10
PC : 10.10.0.20
Nodes : 10.10.1.10 → 10.10.1.200
Switch : 10.10.0.2

Plan C — compat Art-Net 2.x (/8) :
Réseau : 2.0.0.0/8 (255.0.0.0)
PC : 2.0.0.10
Node 1 : 2.0.0.100
Node 2 : 2.0.0.101
Réseau isolé, pas d’Internet, pas de routage.

Mots utiles: plan ip, adressage, 192.168.10, 10.10, 2.0.0.0, /24, /16, /8, masque, node, console.
''',
          icon: Icons.map,
          pageBuilder: () => const AboutIpBasicsPage(),
          anchor: null,
        ),

        AboutSearchDoc(
          title: 'Dépannage réseau — symptômes → causes (méthode terrain)',
          text: '''
Symptômes → causes :
“Je vois le node mais ça répond pas” → masque différent / VLAN / pare-feu.
“Un appareil marche puis disparaît” → DHCP instable / conflit d’IP.
“Rien ne marche sauf sur le switch” → IP pas dans le même réseau / mauvais câble / port VLAN.
“Tout rame / pertes” → broadcast/multicast trop large / switch bas de gamme / boucle réseau.
“Ça marche en filaire mais pas en Wi-Fi” → jitter / roaming / bande saturée / power saving.

Méthode pro en 5 minutes :
1) Regarder IP + masque PC/console et node.
2) Vérifier même sous-réseau.
3) Ping + test interface web du node.
4) Si DHCP : table DHCP + doublons.
5) Si sACN multicast : IGMP snooping/querier.

Piège très fréquent :
Masque hérité sur PC (255.255.0.0 au lieu de 255.255.255.0) → incompréhensions.

Mots utiles: troubleshooting, dépannage, conflit ip, doublon ip, jitter, roaming, igmp, multicast, sACN.
''',
          icon: Icons.bug_report,
          pageBuilder: () => const AboutIpBasicsPage(),
          anchor: null,
        ),

        AboutSearchDoc(
          title: 'Mini-exercices — vérifier vite un masque / réseau',
          text: '''
Exercice 1 (/24) :
A = 192.168.10.50 /24
B = 192.168.10.200 /24 → même réseau
B = 192.168.11.200 /24 → pas le même réseau

Exercice 2 (/16) :
A = 10.10.5.10 /16
B = 10.10.200.20 /16 → même réseau (10.10.x.x)
B = 10.11.200.20 /16 → pas le même réseau

Astuce visuelle :
/24 → 3 premiers nombres identiques (A.B.C) = même réseau
/16 → 2 premiers nombres identiques (A.B) = même réseau
/8 → 1er nombre identique (A) = même réseau

Exercice 3 :
0.x.x.x : réservé
127.x.x.x : loopback
169.254.x.x : auto-IP (APIPA) quand DHCP absent → problème DHCP

Mots utiles: exercice, apipa, 169.254, loopback, 127.0.0.1, masque, cidr.
''',
          icon: Icons.quiz,
          pageBuilder: () => const AboutIpBasicsPage(),
          anchor: null,
        ),

        AboutSearchDoc(
          title: 'Checklist réseau (IP)',
          text: '''
Réseau — Checklist rapide (IP)
Tous les appareils dans le même sous-réseau (IP + masque cohérents)
Pas de doublon d’IP (conflit)
DHCP : soit tout le monde en DHCP, soit plan statique clair (éviter mélange flou)
Pour Art-Net/sACN : réseau dédié ou VLAN si possible
Switch géré si multicast/IGMP (sACN)
Wi-Fi : éviter pour data show critique (jitter), préférer filaire
Test simple : ping + vérifier masque/passerelle
''',
          icon: Icons.checklist,
          pageBuilder: () => const AboutIpBasicsPage(),
          anchor: null,
        ),
      ];
}
