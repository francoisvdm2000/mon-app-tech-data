import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/ui/widgets.dart'; // numFormatter, intFormatter, ExpandSectionCard, ResultBox, copyToClipboard

class VideoMultiprojecteurPage extends StatefulWidget {
  const VideoMultiprojecteurPage({super.key});

  @override
  State<VideoMultiprojecteurPage> createState() => _VideoMultiprojecteurPageState();
}

class _VideoMultiprojecteurPageState extends State<VideoMultiprojecteurPage> {
  // CALC 5
  String _format5 = '16:9';
  final _c5WtotCtrl = TextEditingController();
  final _c5OverlapCtrl = TextEditingController(text: '10');
  final _c5NCtrl = TextEditingController(text: '2');
  String _r5 = '';

  // CALC 6
  String _format6 = '16:9';
  final _c6WtotCtrl = TextEditingController();
  final _c6DistanceCtrl = TextEditingController();
  final _c6OverlapCtrl = TextEditingController(text: '10');
  final _c6RatioMinCtrl = TextEditingController();
  final _c6RatioMaxCtrl = TextEditingController();
  final _c6LumensPerCtrl = TextEditingController(); // optionnel
  final _c6GainCtrl = TextEditingController(text: '1.0'); // optionnel
  String _r6 = '';

  @override
  void dispose() {
    _c5WtotCtrl.dispose();
    _c5OverlapCtrl.dispose();
    _c5NCtrl.dispose();

    _c6WtotCtrl.dispose();
    _c6DistanceCtrl.dispose();
    _c6OverlapCtrl.dispose();
    _c6RatioMinCtrl.dispose();
    _c6RatioMaxCtrl.dispose();
    _c6LumensPerCtrl.dispose();
    _c6GainCtrl.dispose();
    super.dispose();
  }

  double _ratioWHFromFormat(String fmt) {
    switch (fmt) {
      case '16:10':
        return 16 / 10;
      case '4:3':
        return 4 / 3;
      case '21:9':
        return 21 / 9;
      case '16:9':
      default:
        return 16 / 9;
    }
  }

  double? _d(TextEditingController c) {
    final t = c.text.trim().replaceAll(',', '.');
    return double.tryParse(t);
  }

  int? _i(TextEditingController c) {
    final t = c.text.trim();
    return int.tryParse(t);
  }

  InputDecoration _dec(String label, String hint) => InputDecoration(labelText: label, hintText: hint);

  Widget _numField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputAction? action,
    VoidCallback? onDone,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
      inputFormatters: [numFormatter],
      textInputAction: action,
      onSubmitted: (_) => onDone?.call(),
      decoration: _dec(label, hint),
    );
  }

  Widget _intField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputAction? action,
    VoidCallback? onDone,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [intFormatter],
      textInputAction: action,
      onSubmitted: (_) => onDone?.call(),
      decoration: _dec(label, hint),
    );
  }

  Widget _formatDropdown({
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: const InputDecoration(labelText: 'Format (ratio)'),
      items: const [
        DropdownMenuItem(value: '16:9', child: Text('16:9')),
        DropdownMenuItem(value: '16:10', child: Text('16:10')),
        DropdownMenuItem(value: '4:3', child: Text('4:3')),
        DropdownMenuItem(value: '21:9', child: Text('21:9')),
      ],
      onChanged: (v) => onChanged(v ?? '16:9'),
    );
  }

  Widget _calcSection({
    required String title,
    required IconData icon,
    required List<Widget> inputs,
    required VoidCallback onCalc,
    required String result,
    bool initiallyExpanded = false,
  }) {
    return ExpandSectionCard(
      title: title,
      icon: icon,
      initiallyExpanded: initiallyExpanded,
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

  void _calc5() {
    final wTot = _d(_c5WtotCtrl);
    final pPercent = _d(_c5OverlapCtrl);
    final n = _i(_c5NCtrl);

    if (wTot == null || pPercent == null || n == null) {
      setState(() => _r5 = '❌ Données manquantes : Largeur totale + Overlap% + N.');
      return;
    }
    if (wTot <= 0) {
      setState(() => _r5 = '❌ Largeur totale doit être > 0.');
      return;
    }
    if (n < 2) {
      setState(() => _r5 = '❌ N doit être ≥ 2.');
      return;
    }
    if (pPercent < 0 || pPercent >= 100) {
      setState(() => _r5 = '❌ Overlap% doit être entre 0 et 99.9.');
      return;
    }

    final p = pPercent / 100.0;
    final denom = (n - (n - 1) * p);
    if (denom <= 0) {
      setState(() => _r5 = '❌ Paramètres impossibles (denom ≤ 0).');
      return;
    }

    final wParProj = wTot / denom;
    final overlapM = p * wParProj;

    final ratioWH = _ratioWHFromFormat(_format5);
    final hTot = wTot / ratioWH;

    setState(() {
      _r5 =
          'Format: $_format5\n'
          'Largeur totale: ${wTot.toStringAsFixed(3)} m\n'
          'N: $n | Overlap: ${pPercent.toStringAsFixed(1)}%\n\n'
          '- Largeur par projecteur: ${wParProj.toStringAsFixed(3)} m\n'
          '- Overlap entre 2 projos: ${overlapM.toStringAsFixed(3)} m\n'
          '- Hauteur totale: ${hTot.toStringAsFixed(3)} m';
    });
  }

  void _calc6() {
    final wTot = _d(_c6WtotCtrl);
    final distance = _d(_c6DistanceCtrl);
    final pPercent = _d(_c6OverlapCtrl);
    final ratioMin = _d(_c6RatioMinCtrl);
    final ratioMax = _d(_c6RatioMaxCtrl);

    final lumensPerProj = _d(_c6LumensPerCtrl); // optional
    final gain = _d(_c6GainCtrl); // optional

    if (wTot == null || distance == null || pPercent == null) {
      setState(() => _r6 = '❌ Données manquantes : Largeur totale + Distance + Overlap%.');
      return;
    }
    if (wTot <= 0 || distance <= 0) {
      setState(() => _r6 = '❌ Largeur totale et distance doivent être > 0.');
      return;
    }
    if (pPercent < 0 || pPercent >= 100) {
      setState(() => _r6 = '❌ Overlap% doit être entre 0 et 99.9.');
      return;
    }

    double? a = ratioMin;
    double? b = ratioMax;

    if (a == null && b == null) {
      setState(() => _r6 = '❌ Données manquantes : Ratio min et/ou Ratio max.');
      return;
    }
    a ??= b;
    b ??= a;

    if (a == null || b == null || a <= 0 || b <= 0) {
      setState(() => _r6 = '❌ Ratio invalide (doit être > 0).');
      return;
    }

    final ratioMinOk = math.min(a, b);
    final ratioMaxOk = math.max(a, b);
    final p = pPercent / 100.0;

    double widthPerProj(double ratio) => distance / ratio;

    int computeN(double wPerProj) {
      final step = wPerProj * (1 - p);
      if (step <= 0) return 999999;
      final nDouble = 1 + ((wTot / wPerProj) - 1) / (1 - p);
      return nDouble.ceil().clamp(1, 999999);
    }

    double coverage(double wPerProj, int n) => wPerProj * (1 + (n - 1) * (1 - p));

    final wAtMin = widthPerProj(ratioMinOk);
    final nAtMin = computeN(wAtMin);
    final covAtMin = coverage(wAtMin, nAtMin);

    final wAtMax = widthPerProj(ratioMaxOk);
    final nAtMax = computeN(wAtMax);
    final covAtMax = coverage(wAtMax, nAtMax);

    final ratioWH = _ratioWHFromFormat(_format6);
    final hTot = wTot / ratioWH;
    final area = wTot * hTot;

    String lumiForN(int n) {
      if (lumensPerProj == null || gain == null || lumensPerProj.toString().isEmpty || gain.toString().isEmpty) {
        return "Luminosité (optionnelle) : renseigne Lumens/projo + Gain pour estimer.";
      }
      if (lumensPerProj <= 0 || gain <= 0) {
        return "Luminosité: ❌ Lumens/projo et gain doivent être > 0.";
      }
      final totalLumensUseful = n * lumensPerProj * gain;
      final lux = totalLumensUseful / area;
      final nits = totalLumensUseful / (math.pi * area);
      final fl = nits / 3.426;

      return "Luminosité estimée (N=$n)\n"
          "Surface: ${area.toStringAsFixed(2)} m²\n"
          "Lux eq: ${lux.toStringAsFixed(0)}\n"
          "Nits: ${nits.toStringAsFixed(1)} | ft-L: ${fl.toStringAsFixed(1)}";
    }

    setState(() {
      _r6 =
          "Format: $_format6\n"
          "Largeur totale=${wTot.toStringAsFixed(3)} m | Distance=${distance.toStringAsFixed(3)} m | Overlap=${pPercent.toStringAsFixed(1)}%\n"
          "Hauteur totale=${hTot.toStringAsFixed(3)} m | Surface=${area.toStringAsFixed(2)} m²\n"
          "Ratio min/max: ${ratioMinOk.toStringAsFixed(3)} → ${ratioMaxOk.toStringAsFixed(3)}\n\n"
          "Cas ratio plus ouvert (min) = $nAtMin projos | couverture ≈ ${covAtMin.toStringAsFixed(3)} m\n"
          "${lumiForN(nAtMin)}\n\n"
          "Cas ratio plus serré (max) = $nAtMax projos | couverture ≈ ${covAtMax.toStringAsFixed(3)} m\n"
          "${lumiForN(nAtMax)}\n\n"
          "Note: estimation indicative.";
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      appBar: AppBar(title: const Text('Multiprojecteur')),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottom),
          child: Column(
            children: [
              _calcSection(
                title: 'Calcul 5 — Largeur par projecteur',
                icon: Icons.grid_on,
                initiallyExpanded: true,
                inputs: [
                  _formatDropdown(value: _format5, onChanged: (v) => setState(() => _format5 = v)),
                  const SizedBox(height: 12),
                  _numField(
                    controller: _c5WtotCtrl,
                    label: 'Largeur totale de projection (m)',
                    hint: 'ex: 18.0',
                    action: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  _numField(
                    controller: _c5OverlapCtrl,
                    label: 'Overlap (%)',
                    hint: 'ex: 10',
                    action: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  _intField(
                    controller: _c5NCtrl,
                    label: 'Nombre de projecteurs (N)',
                    hint: 'ex: 2',
                    action: TextInputAction.done,
                    onDone: _calc5,
                  ),
                ],
                onCalc: _calc5,
                result: _r5,
              ),
              const SizedBox(height: 12),
              _calcSection(
                title: 'Calcul 6 — Nombre de projecteurs (ratio min/max)',
                icon: Icons.auto_fix_high,
                inputs: [
                  _formatDropdown(value: _format6, onChanged: (v) => setState(() => _format6 = v)),
                  const SizedBox(height: 12),
                  _numField(
                    controller: _c6WtotCtrl,
                    label: 'Largeur totale de projection (m)',
                    hint: 'ex: 18.0',
                    action: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  _numField(
                    controller: _c6DistanceCtrl,
                    label: 'Distance de projection (m)',
                    hint: 'ex: 12.0',
                    action: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  _numField(
                    controller: _c6OverlapCtrl,
                    label: 'Overlap (%)',
                    hint: 'ex: 10',
                    action: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  _numField(
                    controller: _c6RatioMinCtrl,
                    label: 'Ratio min',
                    hint: 'ex: 1.20',
                    action: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  _numField(
                    controller: _c6RatioMaxCtrl,
                    label: 'Ratio max',
                    hint: 'ex: 1.80',
                    action: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Optionnel : luminosité',
                      style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _numField(
                    controller: _c6LumensPerCtrl,
                    label: 'Lumens par projecteur',
                    hint: 'ex: 20000',
                    action: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  _numField(
                    controller: _c6GainCtrl,
                    label: 'Gain',
                    hint: 'ex: 1.0',
                    action: TextInputAction.done,
                    onDone: _calc6,
                  ),
                ],
                onCalc: _calc6,
                result: _r6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
