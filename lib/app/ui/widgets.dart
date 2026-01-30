import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// =======================
/// FORMATTERS
/// =======================

/// Entiers stricts (univers, adresse, canaux, etc.)
final TextInputFormatter intFormatter =
    FilteringTextInputFormatter.digitsOnly;

/// Décimal robuste :
/// - chiffres
/// - un seul séparateur décimal ('.' ou ',')
/// - PAS de signe
/// - PAS d’exposant
final TextInputFormatter numFormatter = TextInputFormatter.withFunction(
  (oldValue, newValue) {
    final text = newValue.text;

    // Champ vide = autorisé
    if (text.isEmpty) return newValue;

    // Autorise uniquement chiffres + '.' + ','
    if (!RegExp(r'^[0-9.,]+$').hasMatch(text)) {
      return oldValue;
    }

    // Un seul séparateur décimal maximum
    final dotCount = '.'.allMatches(text).length;
    final commaCount = ','.allMatches(text).length;
    if (dotCount + commaCount > 1) {
      return oldValue;
    }

    return newValue;
  },
);

/// =======================
/// UI WIDGETS
/// =======================

class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class ExpandSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final bool initiallyExpanded;
  final Widget? trailing;

  const ExpandSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.initiallyExpanded = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          iconColor: Colors.white70,
          collapsedIconColor: Colors.white70,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          title: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          children: [child],
        ),
      ),
    );
  }
}

class ResultBox extends StatelessWidget {
  final String text;
  const ResultBox(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) return const SizedBox.shrink();

    final isError = text.trimLeft().startsWith('❌');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isError
              ? Colors.redAccent.withAlpha(140)
              : Colors.white12,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.35,
          color: isError ? Colors.redAccent : Colors.white,
        ),
      ),
    );
  }
}

class MiniPill extends StatelessWidget {
  final String label;
  const MiniPill(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }
}

/// =======================
/// UTILS
/// =======================

Future<void> copyToClipboard(BuildContext context, String text) async {
  final t = text.trim();
  if (t.isEmpty) return;

  await Clipboard.setData(ClipboardData(text: t));
  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Copié dans le presse-papiers.')),
  );
}
