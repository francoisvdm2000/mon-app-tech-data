import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app/constants.dart';
import 'about_page.dart';
import 'mentions_page.dart';
import 'lumiere_page.dart';
import 'laser_page.dart';
import 'video/video_page.dart';
import 'laser/laser_consent_dialog.dart';

class PageAccueil extends StatefulWidget {
  const PageAccueil({super.key});

  @override
  State<PageAccueil> createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
  @override
  void initState() {
    super.initState();
    _checkDisclaimerOnStart();
  }

  Future<void> _checkDisclaimerOnStart() async {
    final prefs = await SharedPreferences.getInstance();
    final accepted = prefs.getBool(kPrefDisclaimerAccepted) ?? false;
    if (!accepted) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showDisclaimerDialog());
    }
  }

  Future<void> _acceptDisclaimer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kPrefDisclaimerAccepted, true);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _resetConsents() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kPrefDisclaimerAccepted);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Consentements réinitialisés.")),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _showDisclaimerDialog());
  }

  void _showDisclaimerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool checked = false;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: const Color(0xFF111111),
              title: const Text(kDisclaimerTitle),
              content: SizedBox(
                width: double.maxFinite,
                height: 420,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          kDisclaimerText,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      value: checked,
                      onChanged: (v) => setStateDialog(() => checked = v ?? false),
                      title: const Text(
                        "Je certifie avoir lu et accepté ces conditions.",
                        style: TextStyle(fontSize: 13),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: Colors.white,
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: checked ? _acceptDisclaimer : null,
                  child: const Text("J'accepte"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _goToLaserWithConsent() async {
    if (!mounted) return;

    final accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return LaserConsentDialog(
          onAccepted: () async {
            // consentement affiché à chaque entrée -> rien à stocker
          },
        );
      },
    );

    if (accepted == true && mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LaserPage()));
    }
  }

  void _push(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _homeTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
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
                  Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.55)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.70),
                  height: 1.25,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      appBar: AppBar(title: const Text('Accueil')),
      drawer: Drawer(
        backgroundColor: const Color(0xFF111111),
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text(
                "Menu",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            ListTile(
              title: const Text("Mentions légales"),
              leading: const Icon(Icons.gavel),
              onTap: () {
                Navigator.pop(context);
                _push(const PageMentionsLegales());
              },
            ),
            ListTile(
              title: const Text("Réinitialiser consentements"),
              leading: const Icon(Icons.refresh),
              onTap: () {
                Navigator.pop(context);
                _resetConsents();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottom),
          child: Column(
            children: [
              _homeTile(
                icon: Icons.video_settings,
                title: "Vidéo",
                subtitle: "Lentille & mesure, luminosité, multiprojecteur, LED et mires.",
                onTap: () => _push(const PageVideo()),
              ),
              const SizedBox(height: 12),

              _homeTile(
                icon: Icons.lightbulb_outline,
                title: "Lumière",
                subtitle: "Taille de projection, dip-switch DMX, photométrie, catalogue, patch DMX.",
                onTap: () => _push(const PageLumiere()),
              ),
              const SizedBox(height: 12),

              _homeTile(
                icon: Icons.center_focus_strong,
                title: "Laser",
                subtitle: "Calculs et sécurité laser (consentement requis à chaque entrée).",
                onTap: _goToLaserWithConsent,
              ),
              const SizedBox(height: 12),

              // ✅ Déplacé en dernier + renommé
              _homeTile(
                icon: Icons.menu_book,
                title: "Références",
                subtitle: "DMX / réseau / vidéo : fiches & repères terrain.",
                onTap: () => _push(const PageAbout()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
