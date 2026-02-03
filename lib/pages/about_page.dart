import 'package:flutter/material.dart';

import 'package:mon_app_tech/pages/about/about_registry.dart';
import 'package:mon_app_tech/pages/about/about_search.dart';

class PageAbout extends StatelessWidget {
  const PageAbout({super.key});

  void _openDoc(BuildContext context, AboutSearchDoc doc) {
    final Widget Function() pageBuilder =
        doc.pageBuilder ?? AboutRegistry.pageBuilderFor(doc.effectivePageId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => pageBuilder(),
        settings: RouteSettings(
          // On envoie l'anchor enum si dispo, sinon l'anchorId (String)
          arguments: doc.anchor ?? doc.effectiveAnchorId,
        ),
      ),
    );
  }

  void _openTile(BuildContext context, Widget Function() pageBuilder) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => pageBuilder()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final docs = AboutRegistry.allDocs();
    final tiles = AboutRegistry.tiles();

    return Scaffold(
      appBar: AppBar(title: const Text('Références')),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SearchBox(
                docs: docs,
                onOpen: (doc) => _openDoc(context, doc),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, c) {
                  final isWide = c.maxWidth >= 900;
                  final tileW = isWide ? (c.maxWidth - 12) / 2 : c.maxWidth;

                  Widget sized(Widget child) => SizedBox(width: tileW, child: child);

                  final widgets = <Widget>[
                    for (final t in tiles)
                      sized(
                        _NavTile(
                          title: t.title,
                          subtitle: t.subtitle,
                          icon: t.icon,
                          onTap: () => _openTile(context, t.pageBuilder),
                        ),
                      ),
                  ];

                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: widgets,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =======================
/// SEARCH BOX (plein texte)
/// =======================

class _SearchBox extends StatelessWidget {
  const _SearchBox({
    required this.docs,
    required this.onOpen,
  });

  final List<AboutSearchDoc> docs;
  final ValueChanged<AboutSearchDoc> onOpen;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Autocomplete<AboutSearchDoc>(
          optionsBuilder: (TextEditingValue value) {
            final terms = splitQueryTerms(value.text);
            if (terms.isEmpty) return const Iterable<AboutSearchDoc>.empty();

            final results = docs.where((d) => docMatchesQuery(d, terms)).toList()
              ..sort((a, b) => docScore(b, terms).compareTo(docScore(a, terms)));

            return results.take(12);
          },
          displayStringForOption: (d) => d.title,
          fieldViewBuilder: (ctx, controller, focusNode, onSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Rechercher dans les pages (ex: IGMP, subnet, terminaison, RDM, EDID...)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: controller.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Effacer',
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.clear();
                          focusNode.requestFocus();
                        },
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
              onChanged: (_) => (ctx as Element).markNeedsBuild(),
              onSubmitted: (_) => onSubmitted(),
            );
          },
          optionsViewBuilder: (ctx, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                color: const Color(0xFF111111),
                elevation: 8,
                borderRadius: BorderRadius.circular(14),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 360, maxWidth: 760),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, _) =>
                        Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
                    itemBuilder: (context, i) {
                      final d = options.elementAt(i);
                      return InkWell(
                        onTap: () => onSelected(d),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              Icon(d.icon, color: Colors.white.withValues(alpha: 0.85), size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  d.title,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.40)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          onSelected: (d) {
            FocusScope.of(context).unfocus();
            onOpen(d);
          },
        ),
      ),
    );
  }
}

/// =======================
/// NAV TILE (inchangé)
/// =======================

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.75),
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.55)),
            ],
          ),
        ),
      ),
    );
  }
}
