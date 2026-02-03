// lib/pages/about/about_search_page.dart
import 'package:flutter/material.dart';

import 'about_registry.dart';
import 'about_router.dart';
import 'about_search.dart';

class AboutSearchPage extends StatefulWidget {
  const AboutSearchPage({super.key});

  @override
  State<AboutSearchPage> createState() => _AboutSearchPageState();
}

class _AboutSearchPageState extends State<AboutSearchPage> {
  final _ctrl = TextEditingController();
  List<AboutSearchHit> _hits = const [];

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_runSearch);
  }

  @override
  void dispose() {
    _ctrl.removeListener(_runSearch);
    _ctrl.dispose();
    super.dispose();
  }

  void _runSearch() {
    final docs = AboutRegistry.allDocs();
    setState(() {
      _hits = AboutSearchEngine.search(docs, _ctrl.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final q = _ctrl.text.trim();

    return Scaffold(
      appBar: AppBar(title: const Text('Recherche (About)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                hintText: 'Tape un mot (ex: igmp, masque, rj45, nvme, unicast...)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: q.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _ctrl.clear(),
                      ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: _hits.isEmpty
                ? _EmptyState(query: q)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                    itemCount: _hits.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final h = _hits[i];
                      return _HitTile(
                        hit: h,
                        onTap: () {
                          // ✅ Utiliser les getters "effective..." => plus de warnings dead_code/dead_null_aware_expression
                          final pageId = h.doc.effectivePageId;
                          final anchorId = h.doc.effectiveAnchorId;

                          if (pageId.isEmpty) return;

                          AboutRouter.open(
                            context,
                            pageId,
                            anchorId: anchorId.isEmpty ? null : anchorId,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _HitTile extends StatelessWidget {
  const _HitTile({required this.hit, required this.onTap});

  final AboutSearchHit hit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final d = hit.doc;

    // ✅ Getters : toujours String non-null
    final pageTitle = d.effectivePageTitle;
    final title = d.title;
    final anchorId = d.effectiveAnchorId;

    return Material(
      color: const Color(0xFF0B0B0B),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(d.icon, color: Colors.white70),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      pageTitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.80),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      hit.preview,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.70),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Aller à: $anchorId',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.50),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text(
          'Tape un mot pour chercher dans les pages About.',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.65)),
        ),
      );
    }
    return Center(
      child: Text(
        'Aucun résultat pour: "$query"',
        style: TextStyle(color: Colors.white.withValues(alpha: 0.65)),
      ),
    );
  }
}
