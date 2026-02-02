import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/ui/widgets.dart'; // numFormatter, ExpandSectionCard, ResultBox, copyToClipboard

class VideoBrightnessPage extends StatefulWidget {
  const VideoBrightnessPage({super.key});

  @override
  State<VideoBrightnessPage> createState() => _VideoBrightnessPageState();
}

class _VideoBrightnessPageState extends State<VideoBrightnessPage> {
  String _format = '16:9';

  final _widthCtrl = TextEditingController();
  final _lumensCtrl = TextEditingController();
  final _gainCtrl = TextEditingController(text: '1.0');

  String _screenPreset = 'Front - écran blanc mat (gain 1.0)';
  double _minFl = 16.0;

  String _r = '';

  @override
  void dispose() {
    _widthCtrl.dispose();
    _lumensCtrl.dispose();
    _gainCtrl.dispose();
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

  void _applyPreset(String preset) {
    double gain;
    double minFl;

    switch (preset) {
      case 'Front - écran blanc mat (gain 1.0)':
        gain = 1.0;
        minFl = 16.0;
        break;
      case 'Front - écran gris (gain 0.8)':
        gain = 0.8;
        minFl = 16.0;
        break;
      case 'Front - écran high gain (gain 1.3)':
        gain = 1.3;
        minFl = 16.0;
        break;

      case 'Rétro - toile diffusion (gain 0.7)':
        gain = 0.7;
        minFl = 10.0;
        break;
      case 'Rétro - toile claire (gain 0.9)':
        gain = 0.9;
        minFl = 10.0;
        break;

      case 'Mapping - peinture mate (gain 0.75)':
        gain = 0.75;
        minFl = 30.0;
        break;
      case 'Mapping - peinture satinée (gain 0.9)':
        gain = 0.9;
        minFl = 30.0;
        break;
      case 'Mapping - pierre claire (gain 0.6)':
        gain = 0.6;
        minFl = 35.0;
        break;
      case 'Mapping - pierre sombre (gain 0.35)':
        gain = 0.35;
        minFl = 45.0;
        break;
      case 'Mapping - vitre (gain 0.15)':
        gain = 0.15;
        minFl = 60.0;
        break;

      default:
        gain = 1.0;
        minFl = 16.0;
    }

    setState(() {
      _screenPreset = preset;
      _minFl = minFl;
      _gainCtrl.text = gain.toStringAsFixed(2);
    });
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

  void _calc4() {
    final lumens = _d(_lumensCtrl);
    final gain = _d(_gainCtrl);
    final w = _d(_widthCtrl);

    if (lumens == null || gain == null || w == null) {
      setState(() => _r = '❌ Données manquantes : Largeur + Lumens + Gain.');
      return;
    }
    if (lumens <= 0 || gain <= 0 || w <= 0) {
      setState(() => _r = '❌ Lumens/Gain/Largeur doivent être > 0.');
      return;
    }

    final ratioWH = _ratioWHFromFormat(_format);
    final h = w / ratioWH;
    final area = w * h;

    final lux = lumens / area;
    final luxEq = (lumens * gain) / area;

    final nits = (lumens * gain) / (math.pi * area);
    final fl = nits / 3.426;

    final ok = fl >= _minFl;

    setState(() {
      _r =
          'Format: $_format\n'
          'Surface: ${area.toStringAsFixed(3)} m²\n'
          'Lux (lm/m²): ${lux.toStringAsFixed(0)}\n'
          'Lux eq (gain): ${luxEq.toStringAsFixed(0)}\n'
          'Luminance: ${nits.toStringAsFixed(1)} nits | ${fl.toStringAsFixed(1)} ft-L\n'
          'Seuil mini ($_screenPreset): ${_minFl.toStringAsFixed(0)} ft-L → ${ok ? "OK ✅" : "Trop faible ❌"}\n'
          'Note: estimation indicative (Lambert).';
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      appBar: AppBar(title: const Text('Luminosité')),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottom),
          child: Column(
            children: [
              _calcSection(
                title: 'Calcul 4 — Lux / nits / ft-L + seuil',
                icon: Icons.brightness_6,
                inputs: [
                  DropdownButtonFormField<String>(
                    initialValue: _format,
                    decoration: const InputDecoration(labelText: 'Format (ratio)'),
                    items: const [
                      DropdownMenuItem(value: '16:9', child: Text('16:9')),
                      DropdownMenuItem(value: '16:10', child: Text('16:10')),
                      DropdownMenuItem(value: '4:3', child: Text('4:3')),
                      DropdownMenuItem(value: '21:9', child: Text('21:9')),
                    ],
                    onChanged: (v) => setState(() => _format = v ?? '16:9'),
                  ),
                  const SizedBox(height: 12),
                  _numField(
                    controller: _widthCtrl,
                    label: "Largeur d'image (m)",
                    hint: 'ex: 6.0',
                    action: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  _numField(
                    controller: _lumensCtrl,
                    label: 'Lumens (ANSI)',
                    hint: 'ex: 20000',
                    action: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  _numField(
                    controller: _gainCtrl,
                    label: 'Gain',
                    hint: 'ex: 1.0',
                    action: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _screenPreset,
                    decoration: const InputDecoration(labelText: 'Écran / Support (preset)'),
                    items: const [
                      DropdownMenuItem(value: 'Front - écran blanc mat (gain 1.0)', child: Text('Front - écran blanc mat')),
                      DropdownMenuItem(value: 'Front - écran gris (gain 0.8)', child: Text('Front - écran gris')),
                      DropdownMenuItem(value: 'Front - écran high gain (gain 1.3)', child: Text('Front - écran high gain')),
                      DropdownMenuItem(value: 'Rétro - toile diffusion (gain 0.7)', child: Text('Rétro - toile diffusion')),
                      DropdownMenuItem(value: 'Rétro - toile claire (gain 0.9)', child: Text('Rétro - toile claire')),
                      DropdownMenuItem(value: 'Mapping - peinture mate (gain 0.75)', child: Text('Mapping - peinture mate')),
                      DropdownMenuItem(value: 'Mapping - peinture satinée (gain 0.9)', child: Text('Mapping - peinture satinée')),
                      DropdownMenuItem(value: 'Mapping - pierre claire (gain 0.6)', child: Text('Mapping - pierre claire')),
                      DropdownMenuItem(value: 'Mapping - pierre sombre (gain 0.35)', child: Text('Mapping - pierre sombre')),
                      DropdownMenuItem(value: 'Mapping - vitre (gain 0.15)', child: Text('Mapping - vitre')),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      _applyPreset(v);
                    },
                  ),
                ],
                onCalc: _calc4,
                result: _r,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
