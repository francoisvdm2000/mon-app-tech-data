import 'package:flutter/material.dart';
import '../app/constants.dart';
import '../app/ui/widgets.dart';

class PageMentionsLegales extends StatelessWidget {
  const PageMentionsLegales({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mentions légales")),
      body: SafeArea(
  bottom: true,
  child: SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: SectionCard(
      title: "Mentions légales",
      icon: Icons.gavel,
      child: const Text(kDisclaimerText, style: TextStyle(fontSize: 13)),
    ),
  ),
),

    );
  }
}
