import 'package:flutter/material.dart';

import '../../app/ui/widgets.dart'; // numFormatter, intFormatter, ExpandSectionCard, ResultBox, copyToClipboard

class VideoLedPage extends StatefulWidget {
  const VideoLedPage({super.key});

  @override
  State<VideoLedPage> createState() => _VideoLedPageState();
}

class _VideoLedPageState extends State<VideoLedPage> {
  // Inputs (autonomes, pas d'encart global)
  final _tilesXCtrl = TextEditingController();
  final _tilesYCtrl = TextEditingController();

  final _tileWpxCtrl = TextEditingController();
  final _tileHpxCtrl = TextEditingController();

  final _tileWcmCtrl = TextEditingController();
  final _tileHcmCtrl = TextEditingController();

  String _r = '';

  @override
  void dispose() {
    _tilesXCtrl.dispose();
    _tilesYCtrl.dispose();
    _tileWpxCtrl.dispose();
    _tileHpxCtrl.dispose();
    _tileWcmCtrl.dispose();
    _tileHcmCtrl.dispose();
    super.dispose();
  }

  int? _i(TextEditingController c) => int.tryParse(c.text.trim());
  double? _d(TextEditingController c) {
    final t = c.text.trim().replaceAll(',', '.');
    return double.tryParse(t);
  }

  Widget _intField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputAction? action,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [intFormatter],
      textInputAction: action,
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }

  Widget _numField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputAction? action,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
      inputFormatters: [numFormatter],
      textInputAction: action,
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }

  Widget _calcSection({
    required String title,
    required IconData icon,
    required List<Widget> inputs,
    required VoidCallback onCalc,
    required String result,
  }) {
    return ExpandSectionCard(
      title: title,
      icon: icon,
      initiallyExpanded: true,
      child: Column(
        children: [
          ...inputs,
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onCalc,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calculer'),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                tooltip: 'Copier le résultat',
                onPressed: () => copyToClipboard(context, result),
                icon: const Icon(Icons.copy),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ResultBox(result),
        ],
      ),
    );
  }

  void _calcLed() {
    final tilesX = _i(_tilesXCtrl);
    final tilesY = _i(_tilesYCtrl);

    final tileWpx = _i(_tileWpxCtrl);
    final tileHpx = _i(_tileHpxCtrl);

    final tileWcm = _d(_tileWcmCtrl);
    final tileHcm = _d(_tileHcmCtrl);

    if (tilesX == null || tilesY == null || tileWpx == null || tileHpx == null || tileWcm == null || tileHcm == null) {
      setState(() => _r = '❌ Données manquantes : Tiles X/Y + Tile px + Tile cm.');
      return;
    }
    if (tilesX <= 0 || tilesY <= 0 || tileWpx <= 0 || tileHpx <= 0 || tileWcm <= 0 || tileHcm <= 0) {
      setState(() => _r = '❌ Toutes les valeurs doivent être > 0.');
      return;
    }

    final wallWpx = tilesX * tileWpx;
    final wallHpx = tilesY * tileHpx;

    final wallWm = (tilesX * tileWcm) / 100.0;
    final wallHm = (tilesY * tileHcm) / 100.0;

    final pitchXmm = (tileWcm * 10.0) / tileWpx;
    final pitchYmm = (tileHcm * 10.0) / tileHpx;

    String pitchLabel;
    if ((pitchXmm - pitchYmm).abs() <= 0.05) {
      pitchLabel = '${((pitchXmm + pitchYmm) / 2.0).toStringAsFixed(2)} mm';
    } else {
      pitchLabel = 'X ${pitchXmm.toStringAsFixed(2)} mm • Y ${pitchYmm.toStringAsFixed(2)} mm';
    }

    setState(() {
  _r =
      '✅ Résolution mur: $wallWpx × $wallHpx px\n'
      '✅ Taille mur: ${wallWm.toStringAsFixed(2)} × ${wallHm.toStringAsFixed(2)} m\n'
      'Tile: $tileWpx×$tileHpx px • ${tileWcm.toStringAsFixed(2)}×${tileHcm.toStringAsFixed(2)} cm\n'
      'Pitch calculé: $pitchLabel';
});

  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      appBar: AppBar(title: const Text('LED')),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottom),
          child: Column(
            children: [
              _calcSection(
                title: 'Calcul — Pixels / tiles',
                icon: Icons.grid_4x4,
                inputs: [
                  Row(
                    children: [
                      Expanded(
                        child: _intField(
                          controller: _tilesXCtrl,
                          label: 'Tiles horizontales (X)',
                          hint: 'ex: 15',
                          action: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _intField(
                          controller: _tilesYCtrl,
                          label: 'Tiles verticales (Y)',
                          hint: 'ex: 8',
                          action: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _intField(
                          controller: _tileWpxCtrl,
                          label: 'Tile largeur (px)',
                          hint: 'ex: 128',
                          action: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _intField(
                          controller: _tileHpxCtrl,
                          label: 'Tile hauteur (px)',
                          hint: 'ex: 128',
                          action: TextInputAction.next,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _numField(
                          controller: _tileWcmCtrl,
                          label: 'Tile largeur (cm)',
                          hint: 'ex: 33.28',
                          action: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _numField(
                          controller: _tileHcmCtrl,
                          label: 'Tile hauteur (cm)',
                          hint: 'ex: 33.28',
                          action: TextInputAction.done,
                        ),
                      ),
                    ],
                  ),
                ],
                onCalc: _calcLed,
                result: _r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
