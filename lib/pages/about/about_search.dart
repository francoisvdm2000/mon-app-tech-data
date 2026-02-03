// lib/pages/about/about_search.dart
import 'package:flutter/material.dart';

/// Un "document" indexable pour la recherche About.
///
/// IMPORTANT :
/// - Compatible avec les anciens indexes (title + text + pageBuilder + anchor)
/// - Compatible avec les nouveaux champs (pageId + pageTitle + anchorId + searchText)
/// - On ne supprime rien, on ajoute juste ce qu'il faut pour que tout compile.
class AboutSearchDoc {
  const AboutSearchDoc({
    // Commun (présent partout)
    required this.title,
    required this.icon,

    // Ancien format (utilisé par tes about_x_index.dart actuels)
    this.text,
    this.pageBuilder,
    this.anchor,

    // Nouveau format (optionnel)
    this.pageId,
    this.pageTitle,
    this.anchorId,
    this.searchText,
  });

  /// ---- Champs utilisés par tes indexes existants ----
  final String title; // ex: "Terminaison"
  final IconData icon;

  /// Ancien champ indexé (beaucoup de tes indexes utilisent "text:")
  final String? text;

  /// Ancien: comment ouvrir la page (Page widget)
  final Widget Function()? pageBuilder;

  /// Ancien: ancre typée (ex: DmxAnchor.basics)
  final Object? anchor;

  /// ---- Champs nouveaux (optionnels) ----
  /// pageId ex: "dmx"
  final String? pageId;

  /// pageTitle ex: "DMX — fonctionnement"
  final String? pageTitle;

  /// anchorId ex: "termination"
  final String? anchorId;

  /// Texte indexé (si tu l’utilises). Sinon on retombe sur "text".
  final String? searchText;

  /// =======================
  /// Getters de compatibilité
  /// =======================

  /// Texte réellement utilisé pour la recherche.
  /// - si searchText est fourni => on l’utilise
  /// - sinon on utilise text (ancien)
  /// - sinon chaîne vide
  String get effectiveSearchText => (searchText ?? text ?? '');

  /// Titre de page affichable pour la recherche.
  /// - si pageTitle est fourni => on l’utilise
  /// - sinon on met un fallback simple (évite les null)
  String get effectivePageTitle => (pageTitle ?? '');

  /// pageId exploitable par router.
  /// - si pageId est fourni => ok
  /// - sinon on renvoie '' (pas de crash, et tu peux décider plus tard)
  String get effectivePageId => (pageId ?? '');

  /// anchorId exploitable par router.
  /// - si anchorId est fourni => ok
  /// - sinon '' (évite null)
  String get effectiveAnchorId => (anchorId ?? '');
}

class AboutSearchHit {
  const AboutSearchHit({
    required this.doc,
    required this.score,
    required this.preview,
  });

  final AboutSearchDoc doc;
  final int score;
  final String preview;
}

class AboutSearchEngine {
  static List<AboutSearchHit> search(List<AboutSearchDoc> docs, String query) {
    final terms = splitQueryTerms(query);
    if (terms.isEmpty) return const [];

    final hits = <AboutSearchHit>[];

    for (final d in docs) {
      if (!docMatchesQuery(d, terms)) continue;

      hits.add(
        AboutSearchHit(
          doc: d,
          score: docScore(d, terms),
          preview: buildPreview(d.effectiveSearchText, terms.first),
        ),
      );
    }

    hits.sort((a, b) => b.score.compareTo(a.score));
    return hits.take(80).toList(growable: false);
  }
}

/// --- Helpers (utilisés aussi par about_page.dart) ---

List<String> splitQueryTerms(String raw) {
  final q = raw.trim().toLowerCase();
  if (q.isEmpty) return const [];
  return q
      .split(RegExp(r'[\s,;:/\-\._]+'))
      .where((t) => t.isNotEmpty)
      .toList(growable: false);
}

bool docMatchesQuery(AboutSearchDoc doc, List<String> terms) {
  final hay = '${doc.title} ${doc.effectivePageTitle} ${doc.effectiveSearchText}'.toLowerCase();
  for (final t in terms) {
    if (!hay.contains(t)) return false;
  }
  return true;
}

int docScore(AboutSearchDoc doc, List<String> terms) {
  final text = doc.effectiveSearchText.toLowerCase();
  final title = doc.title.toLowerCase();
  final pageTitle = doc.effectivePageTitle.toLowerCase();

  int score = 0;

  for (final t in terms) {
    // match dans les titres = plus fort
    if (title.contains(t)) score += 60;
    if (pageTitle.contains(t)) score += 30;

    // match dans contenu
    final count = _countOccurrences(text, t);
    score += count * 10;
  }

  return score;
}

int _countOccurrences(String text, String term) {
  int count = 0;
  int idx = 0;
  while (true) {
    idx = text.indexOf(term, idx);
    if (idx == -1) break;
    count++;
    idx += term.length;
  }
  return count;
}

String buildPreview(String text, String term) {
  final low = text.toLowerCase();
  final i = low.indexOf(term.toLowerCase());

  if (i < 0) {
    return text.length <= 160 ? text : '${text.substring(0, 160)}…';
  }

  final start = (i - 50).clamp(0, text.length);
  final end = (i + 130).clamp(0, text.length);

  final snippet = text.substring(start, end).trim();
  return (start > 0 ? '…' : '') + snippet + (end < text.length ? '…' : '');
}
