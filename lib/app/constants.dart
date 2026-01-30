import 'package:flutter/material.dart';

/// =======================
/// COULEUR (BLEU NUIT)
/// =======================
const Color kAccent = Color(0xFF0A1F44);

/// =======================
/// TEXTES (DISCLAIMER / LASER)
/// =======================
const String kDisclaimerTitle = "⚠️ AVERTISSEMENT LÉGAL & NON-RESPONSABILITÉ";

const String kDisclaimerText = """
UTILISATION À TITRE INDICATIF UNIQUEMENT

Les calculs fournis par cette application (vidéo, lumière, laser) sont donnés à titre informatif et indicatif.
Ils ne remplacent en aucun cas :
- des calculs certifiés,
- des études techniques,
- les normes officielles en vigueur,
- ni la validation par un professionnel qualifié.

RESPONSABILITÉ
L’éditeur de cette application ne peut être tenu responsable d’erreurs de calcul, d’omissions, de dommages matériels,
d’accidents corporels, ou de tout incident survenant lors de l’installation, de l’exploitation ou de l’utilisation des équipements.

VIDÉO & PROJECTION
Les résultats (tailles, ratios, luminosité, overlaps, etc.) reposent sur des modèles théoriques et peuvent varier selon :
optique, zoom, uniformité, environnement lumineux, support, réglages, etc.
Toujours vérifier avec les documentations constructeur officielles.

LUMIÈRE
Les calculs sont indicatifs et ne tienent pas compte de toutes les conditions réelles (tolérances, pertes optiques,
dégradation des sources, normes locales, conditions ambiantes…).

LASER – SÉCURITÉ
Les calculs NOHD, SZED et CZED sont basés sur des hypothèses standards et des seuils théoriques.
Ils ne prennent pas en compte notamment :
- instruments optiques (jumelles, caméras, télescopes…),
- conditions atmosphériques (brouillard, pluie, poussière…),
- réflexions imprévues, usages détournés, réglages spécifiques.
L’utilisation d’un système laser implique une responsabilité directe de l’opérateur et une analyse de risques adaptée.

ACCEPTATION DES RISQUES
En utilisant cette application, l’utilisateur reconnaît :
- avoir pris connaissance des règles de sécurité applicables,
- être seul responsable de ses installations,
- assumer l’entière responsabilité des risques liés à l’utilisation des équipements (vidéo, lumière, laser),
- vérifier systématiquement les données avec les manuels constructeurs officiels.
""";

const String kLaserConsentTitle = "🔴 CONSENTEMENT LASER (OBLIGATOIRE)";
const String kLaserConsentText = """
ACCÈS À LA PARTIE LASER

La partie LASER de cette application concerne des calculs de sécurité (ex : NOHD, SZED, CZED).
Ces calculs sont indicatifs et ne remplacent pas :
- une analyse de risques,
- les normes en vigueur,
- les procédures d’exploitation,
- ni la validation par une personne qualifiée.

IMPORTANT
- Risque de lésions oculaires / cutanées en cas de mauvaise utilisation.
- Le calcul peut être faux si les paramètres entrés sont incomplets, erronés ou si le contexte réel diffère (optique,
  conditions atmosphériques, réflexions, alignement, etc.).
- L’opérateur est seul responsable de l’installation, de l’exploitation et de la conformité.

En validant, vous confirmez :
- comprendre les risques,
- respecter les règles de sécurité applicables,
- assumer l’entière responsabilité en cas de négligence ou mauvaise utilisation.
""";

/// =======================
/// SharedPreferences keys
/// =======================
const String kPrefDisclaimerAccepted = "disclaimerAccepted";
const String kPrefLaserAccepted = "laserAccepted";
