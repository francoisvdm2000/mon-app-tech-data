import 'package:flutter/material.dart';
import '../app/ui/widgets.dart';

class PageAbout extends StatelessWidget {
  const PageAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About me')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SectionCard(
          title: "À propos",
          icon: Icons.person,
          child: Text(
            "Ici, vous expliquerez qui vous êtes et pourquoi cette application existe.",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
