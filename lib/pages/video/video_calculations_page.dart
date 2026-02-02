import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../app/constants.dart';
import '../../app/ui/widgets.dart';

/// =======================
/// SOUS-PAGE : CALCULATEUR VIDÉO (ancien PageVideo)
/// =======================
class VideoCalculationsPage extends StatefulWidget {
  const VideoCalculationsPage({super.key});

  @override
  State<VideoCalculationsPage> createState() => _VideoCalculationsPageState();
}

class _VideoCalculationsPageState extends State<VideoCalculationsPage> {
  // Commun
  String _format = '16:9';

  final _distanceCtrl = TextEditingController(); // distance projection
  final _largeurCtrl = TextEditingController(); // largeur image
  final _ratioCtrl = TextEditingController(); // ratio de projection
  final _lumensCtrl = TextEditingController();
  final _gainCtrl = TextEditingController(text: '1.0');
  final _overlapPercentCtrl = TextEditingController(text: '10');
  final _largeurTotaleCtrl = TextEditingController(); // largeur totale de projection

  // Presets écran/support
  String _screenPreset = 'Front - écran blanc mat (gain 1.0)';
  double _minFl = 16.0;

  // Calcul 5
  final _calc5NCtrl = TextEditingController(text: '2');

  // Calcul 6
  final _calc6RatioMinCtrl = TextEditingController();
  final _calc6RatioMaxCtrl = TextEditingController();
  final _calc6LumensPerProjCtrl = TextEditingController();
  final _calc6GainCtrl = TextEditingController(text: '1.0');

  // Résultats
  String r1 = '';
  String r2 = '';
  String r3 = '';
  String r4 = '';
  String r5 = '';
  String r6 = '';

  void _unfocus() => FocusManager.instance.primaryFocus?.unfocus();

  @override
  void dispose() {
    _distanceCtrl.dispose();
    _largeurCtrl.dispose();
    _ratioCtrl.dispose();
    _lumensCtrl.dispose();
    _gainCtrl.dispose();
    _overlapPercentCtrl.dispose();
    _largeurTotaleCtrl.dispose();

    _calc5NCtrl.dispose();

    _calc6RatioMinCtrl.dispose();
    _calc6RatioMaxCtrl.dispose();
    _calc6LumensPerProjCtrl.dispose();
    _calc6GainCtrl.dispose();
    super.dispose();
  }

  // Helpers
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

  void _appliquerPresetEcran(String preset) {
    double gain;
    double minFl;

    switch (preset) {
      // Front
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

      // Rétro
      case 'Rétro - toile diffusion (gain 0.7)':
        gain = 0.7;
        minFl = 10.0;
        break;
      case 'Rétro - toile claire (gain 0.9)':
        gain = 0.9;
        minFl = 10.0;
        break;

      // Mapping
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

  List<Widget> _summaryPills() {
    final d = _d(_distanceCtrl);
    final w = _d(_largeurCtrl);
    final ratio = _d(_ratioCtrl);
    final wTot = _d(_largeurTotaleCtrl);
    final overlap = _d(_overlapPercentCtrl);

    double? h;
    double? area;

    if (w != null && w > 0) {
      final ratioWH = _ratioWHFromFormat(_format);
      h = w / ratioWH;
      area = w * h;
    }

    String fmt(double? v, {int dec = 2, String unit = ''}) =>
        v == null ? '-' : '${v.toStringAsFixed(dec)}$unit';

    return [
      MiniPill('Format: $_format'),
      MiniPill('Distance: ${fmt(d, dec: 2, unit: ' m')}'),
      MiniPill('Largeur: ${fmt(w, dec: 2, unit: ' m')}'),
      MiniPill('Ratio: ${fmt(ratio, dec: 3)}'),
      MiniPill('Hauteur: ${fmt(h, dec: 2, unit: ' m')}'),
      MiniPill('Surface: ${fmt(area, dec: 2, unit: ' m²')}'),
      MiniPill('Largeur totale: ${fmt(wTot, dec: 2, unit: ' m')}'),
      MiniPill('Overlap: ${fmt(overlap, dec: 1, unit: ' %')}'),
    ];
  }

  InputDecoration _dec(String label, String hint) =>
      InputDecoration(labelText: label, hintText: hint);

  Widget _numField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputAction? action,
    VoidCallback? onDone,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
          decimal: true, signed: false),
      inputFormatters: [numFormatter],
      textInputAction: action,
      onSubmitted: (_) => onDone?.call(),
      decoration: _dec(label, hint),
    );
  }

  // =======================
  // CALCULS
  // =======================
  void calc1() {
    final d = _d(_distanceCtrl);
    final w = _d(_largeurCtrl);

    if (d == null || w == null) {
      setState(() => r1 = '❌ Données manquantes: Distance + Largeur.');
      return;
    }
    if (w <= 0) {
      setState(() => r1 = '❌ La largeur doit être > 0.');
      return;
    }

    final ratio = d / w;
    setState(() {
      r1 = '✅ Ratio de projection = ${ratio.toStringAsFixed(3)}';
      if (_ratioCtrl.text.trim().isEmpty) {
        _ratioCtrl.text = ratio.toStringAsFixed(3);
      }
    });
  }

  void calc2() {
    final d = _d(_distanceCtrl);
    final ratio = _d(_ratioCtrl);

    if (d == null || ratio == null) {
      setState(() => r2 = '❌ Données manquantes: Distance + Ratio.');
      return;
    }
    if (ratio <= 0) {
      setState(() => r2 = '❌ Le ratio doit être > 0.');
      return;
    }

    final w = d / ratio;
    setState(() => r2 = '✅ Largeur image = ${w.toStringAsFixed(3)} m');
  }

  void calc3() {
    final w = _d(_largeurCtrl);
    if (w == null) {
      setState(() => r3 = '❌ Donnée manquante: Largeur.');
      return;
    }
    if (w <= 0) {
      setState(() => r3 = '❌ La largeur doit être > 0.');
      return;
    }

    final ratioWH = _ratioWHFromFormat(_format);
    final h = w / ratioWH;
    setState(() => r3 = '✅ Hauteur = ${h.toStringAsFixed(3)} m (format $_format)');
  }

  void calc4() {
    final lumens = _d(_lumensCtrl);
    final gain = _d(_gainCtrl);
    final w = _d(_largeurCtrl);

    if (lumens == null || gain == null || w == null) {
      setState(() => r4 = '❌ Données manquantes: Lumens + Gain + Largeur.');
      return;
    }
    if (lumens <= 0 || gain <= 0 || w <= 0) {
      setState(() => r4 = '❌ Lumens/Gain/Largeur doivent être > 0.');
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
      r4 =
          'Surface: ${area.toStringAsFixed(3)} m² (format $_format)\n'
          'Lux (lm/m²): ${lux.toStringAsFixed(0)}\n'
          'Lux eq (gain): ${luxEq.toStringAsFixed(0)}\n'
          'Luminance: ${nits.toStringAsFixed(1)} nits | ${fl.toStringAsFixed(1)} ft-L\n'
          'Seuil mini ($_screenPreset): ${_minFl.toStringAsFixed(0)} ft-L → ${ok ? "OK ✅" : "Trop faible ❌"}\n'
          'Note: conversion nits/ft-L basée sur une hypothèse Lambertienne (approx).';
    });
  }

  void calc5() {
    final wTot = _d(_largeurTotaleCtrl);
    final pPercent = _d(_overlapPercentCtrl);
    final n = _i(_calc5NCtrl);

    if (wTot == null || pPercent == null || n == null) {
      setState(() => r5 =
          '❌ Données manquantes: Largeur totale + Overlap% + Nombre de projecteurs.');
      return;
    }
    if (wTot <= 0) {
      setState(() => r5 = '❌ Largeur totale doit être > 0.');
      return;
    }
    if (n < 2) {
      setState(() => r5 = '❌ Le nombre de projecteurs doit être ≥ 2.');
      return;
    }
    if (pPercent < 0 || pPercent >= 100) {
      setState(() => r5 = '❌ Overlap% doit être entre 0 et 99.9.');
      return;
    }

    final p = pPercent / 100.0;

    final denom = (n - (n - 1) * p);
    if (denom <= 0) {
      setState(() => r5 = '❌ Paramètres impossibles (denom ≤ 0).');
      return;
    }

    final wParProj = wTot / denom;
    final overlapM = p * wParProj;

    final ratioWH = _ratioWHFromFormat(_format);
    final hTot = wTot / ratioWH;

    setState(() {
      r5 =
          'Largeur totale: ${wTot.toStringAsFixed(3)} m\n'
          'N: $n | Overlap: ${pPercent.toStringAsFixed(1)}% (sur largeur projo)\n\n'
          '- Largeur par projecteur: ${wParProj.toStringAsFixed(3)} m\n'
          '- Overlap entre 2 projos: ${overlapM.toStringAsFixed(3)} m\n'
          '- Hauteur totale (format $_format): ${hTot.toStringAsFixed(3)} m';
    });
  }

  void calc6() {
    final wTot = _d(_largeurTotaleCtrl);
    final distance = _d(_distanceCtrl);
    final pPercent = _d(_overlapPercentCtrl);

    final ratioMin = _d(_calc6RatioMinCtrl);
    final ratioMax = _d(_calc6RatioMaxCtrl);

    final lumensPerProj = _d(_calc6LumensPerProjCtrl);
    final gain = _d(_calc6GainCtrl);

    if (wTot == null || distance == null || pPercent == null) {
      setState(() => r6 =
          '❌ Données manquantes: Largeur totale + Distance + Overlap%.');
      return;
    }
    if (wTot <= 0 || distance <= 0) {
      setState(() => r6 =
          '❌ Largeur totale et distance doivent être > 0.');
      return;
    }
    if (pPercent < 0 || pPercent >= 100) {
      setState(() => r6 = '❌ Overlap% doit être entre 0 et 99.9.');
      return;
    }

    double? a = ratioMin;
    double? b = ratioMax;

    if (a == null && b == null) {
      setState(() => r6 = '❌ Données manquantes: Ratio min et/ou Ratio max.');
      return;
    }
    if (a == null && b != null) a = b;
    if (b == null && a != null) b = a;

    if (a == null || b == null || a <= 0 || b <= 0) {
      setState(() => r6 = '❌ Ratio invalide (doit être > 0).');
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

    double coverage(double wPerProj, int n) =>
        wPerProj * (1 + (n - 1) * (1 - p));

    final wAtMin = widthPerProj(ratioMinOk);
    final nAtMin = computeN(wAtMin);
    final covAtMin = coverage(wAtMin, nAtMin);

    final wAtMax = widthPerProj(ratioMaxOk);
    final nAtMax = computeN(wAtMax);
    final covAtMax = coverage(wAtMax, nAtMax);

    final ratioWH = _ratioWHFromFormat(_format);
    final hTot = wTot / ratioWH;
    final area = wTot * hTot;

    String lumiForN(int n) {
      if (lumensPerProj == null || gain == null) {
        return "Luminosité (optionnelle): renseigne Lumens/projo + Gain pour l'estimation.";
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
          "Lux eq: ${lux.toStringAsFixed(0)} (lm/m²)\n"
          "Nits: ${nits.toStringAsFixed(1)} | ft-L: ${fl.toStringAsFixed(1)}";
    }

    setState(() {
      r6 =
          "Largeur totale=${wTot.toStringAsFixed(3)} m | Distance=${distance.toStringAsFixed(3)} m | Overlap=${pPercent.toStringAsFixed(1)}%\n"
          "Format $_format → Hauteur totale=${hTot.toStringAsFixed(3)} m | Surface=${area.toStringAsFixed(2)} m²\n"
          "Ratio min/max: ${ratioMinOk.toStringAsFixed(3)} → ${ratioMaxOk.toStringAsFixed(3)}\n\n"
          "Cas ratio plus ouvert (min) = $nAtMin projos | couverture ≈ ${covAtMin.toStringAsFixed(3)} m\n"
          "${lumiForN(nAtMin)}\n\n"
          "Cas ratio plus serré (max) = $nAtMax projos | couverture ≈ ${covAtMax.toStringAsFixed(3)} m\n"
          "${lumiForN(nAtMax)}\n\n"
          "Note: estimation indicative (blend/overlap réels peuvent réduire un peu).";
    });
  }

  void calculerTout() {
    _unfocus();
    calc1();
    calc2();
    calc3();
    calc4();
    calc5();
    calc6();
  }

  void resetAll() {
    _unfocus();

    _distanceCtrl.clear();
    _largeurCtrl.clear();
    _ratioCtrl.clear();
    _lumensCtrl.clear();
    _gainCtrl.text = '1.0';
    _overlapPercentCtrl.text = '10';
    _largeurTotaleCtrl.clear();

    _calc5NCtrl.text = '2';

    _calc6RatioMinCtrl.clear();
    _calc6RatioMaxCtrl.clear();
    _calc6LumensPerProjCtrl.clear();
    _calc6GainCtrl.text = '1.0';

    setState(() {
      _format = '16:9';
      _screenPreset = 'Front - écran blanc mat (gain 1.0)';
      _minFl = 16.0;

      r1 = '';
      r2 = '';
      r3 = '';
      r4 = '';
      r5 = '';
      r6 = '';
    });
  }

  Future<void> exportVideoPdf() async {
    final doc = pw.Document();
    final now = DateTime.now();
    final dateStr =
        "${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} "
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    String safe(String s) => s.trim().isEmpty ? "-" : s.trim();

    final inputs = <String>[
      "Date: $dateStr",
      "Format: $_format",
      "Distance (m): ${safe(_distanceCtrl.text)}",
      "Largeur image (m): ${safe(_largeurCtrl.text)}",
      "Ratio: ${safe(_ratioCtrl.text)}",
      "Lumens: ${safe(_lumensCtrl.text)}",
      "Gain: ${safe(_gainCtrl.text)}",
      "Preset écran: $_screenPreset",
      "Overlap (%): ${safe(_overlapPercentCtrl.text)}",
      "Largeur totale (m): ${safe(_largeurTotaleCtrl.text)}",
      "N (calc5): ${safe(_calc5NCtrl.text)}",
      "Ratio min (calc6): ${safe(_calc6RatioMinCtrl.text)}",
      "Ratio max (calc6): ${safe(_calc6RatioMaxCtrl.text)}",
      "Lumens/projo (calc6): ${safe(_calc6LumensPerProjCtrl.text)}",
      "Gain (calc6): ${safe(_calc6GainCtrl.text)}",
    ].join("\n");

    final results = <String>[
      "Calcul 1:\n${safe(r1)}",
      "Calcul 2:\n${safe(r2)}",
      "Calcul 3:\n${safe(r3)}",
      "Calcul 4:\n${safe(r4)}",
      "Calcul 5:\n${safe(r5)}",
      "Calcul 6:\n${safe(r6)}",
    ].join("\n\n");

    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text("Mon App Technique – Export Vidéo",
              style: pw.TextStyle(
                  fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 8),
          pw.Text(kDisclaimerTitle,
              style: pw.TextStyle(
                  fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          pw.Text(kDisclaimerText, style: const pw.TextStyle(fontSize: 9)),
          pw.Divider(),
          pw.Text("Paramètres",
              style: pw.TextStyle(
                  fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          pw.Text(inputs, style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 10),
          pw.Text("Résultats",
              style: pw.TextStyle(
                  fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 4),
          pw.Text(results, style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => doc.save(),
      name: "export_video.pdf",
    );
  }

  // =======================
  // UI
  // =======================
  Widget _calcActionsRow({
    required VoidCallback onCalc,
    required String resultText,
  }) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onCalc,
            icon: const Icon(Icons.calculate),
            label: const Text("Calculer"),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          tooltip: "Copier le résultat",
          onPressed: () => copyToClipboard(context, resultText),
          icon: const Icon(Icons.copy),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculs vidéo'),
        actions: [
          IconButton(
            tooltip: "Copier tous les résultats",
            onPressed: () {
              final all = [
                if (r1.trim().isNotEmpty) "Calcul 1:\n$r1",
                if (r2.trim().isNotEmpty) "Calcul 2:\n$r2",
                if (r3.trim().isNotEmpty) "Calcul 3:\n$r3",
                if (r4.trim().isNotEmpty) "Calcul 4:\n$r4",
                if (r5.trim().isNotEmpty) "Calcul 5:\n$r5",
                if (r6.trim().isNotEmpty) "Calcul 6:\n$r6",
              ].join("\n\n");
              copyToClipboard(context, all);
            },
            icon: const Icon(Icons.copy_all),
          ),
          IconButton(
            tooltip: "Exporter PDF",
            onPressed: exportVideoPdf,
            icon: const Icon(Icons.picture_as_pdf),
          ),
        ],
      ),

      // Barre sticky (déjà OK avec SafeArea)
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border(top: BorderSide(color: Colors.white.withAlpha(128))),
          ),
          child: LayoutBuilder(
            builder: (context, c) {
              final narrow = c.maxWidth < 520;

              final calcBtn = ElevatedButton.icon(
                onPressed: calculerTout,
                icon: const Icon(Icons.calculate),
                label: const Text(
                  "Calculer tout",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );

              final resetBtn = ElevatedButton.icon(
                onPressed: resetAll,
                icon: const Icon(Icons.refresh),
                label: const Text(
                  "Reset",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );

              if (narrow) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: double.infinity, child: calcBtn),
                    const SizedBox(height: 10),
                    SizedBox(width: double.infinity, child: resetBtn),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: calcBtn),
                  const SizedBox(width: 10),
                  Expanded(child: resetBtn),
                ],
              );
            },
          ),
        ),
      ),

      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, c) {
              final isWide = c.maxWidth >= 900;
              final cardWidth = isWide ? (c.maxWidth - 12) / 2 : c.maxWidth;

              Widget sized(Widget child) => SizedBox(width: cardWidth, child: child);

              final cards = <Widget>[
                sized(SectionCard(
                  title: "Résumé (pastilles)",
                  icon: Icons.dashboard,
                  trailing: IconButton(
                    tooltip: "Copier le résumé",
                    onPressed: () {
                      final t = _summaryPills()
                          .whereType<MiniPill>()
                          .map((p) => (p.label))
                          .join(" | ");
                      copyToClipboard(context, t);
                    },
                    icon: const Icon(Icons.copy, color: Colors.white70),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _summaryPills(),
                  ),
                )),

                sized(ExpandSectionCard(
                  title: "Paramètres communs",
                  icon: Icons.tune,
                  initiallyExpanded: true,
                  child: Column(
                    children: [
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
                        controller: _distanceCtrl,
                        label: 'Distance de projection (m)',
                        hint: 'ex: 12.0',
                        action: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),

                      _numField(
                        controller: _largeurCtrl,
                        label: "Largeur d'image (m)",
                        hint: 'ex: 6.0',
                        action: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),

                      _numField(
                        controller: _ratioCtrl,
                        label: 'Ratio de projection',
                        hint: 'ex: 1.60',
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
                          _appliquerPresetEcran(v);
                        },
                      ),
                      const SizedBox(height: 12),

                      _numField(
                        controller: _overlapPercentCtrl,
                        label: 'Overlap (%)',
                        hint: 'ex: 10',
                        action: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),

                      _numField(
                        controller: _largeurTotaleCtrl,
                        label: 'Largeur totale de projection (m)',
                        hint: 'ex: 18.0',
                        action: TextInputAction.done,
                        onDone: calculerTout,
                      ),
                    ],
                  ),
                )),

                sized(ExpandSectionCard(
                  title: "Calcul 1 — Ratio (Distance / Largeur)",
                  icon: Icons.straighten,
                  child: Column(
                    children: [
                      _calcActionsRow(onCalc: calc1, resultText: r1),
                      const SizedBox(height: 10),
                      ResultBox(r1),
                    ],
                  ),
                )),

                sized(ExpandSectionCard(
                  title: "Calcul 2 — Largeur (Distance / Ratio)",
                  icon: Icons.swap_horiz,
                  child: Column(
                    children: [
                      _calcActionsRow(onCalc: calc2, resultText: r2),
                      const SizedBox(height: 10),
                      ResultBox(r2),
                    ],
                  ),
                )),

                sized(ExpandSectionCard(
                  title: "Calcul 3 — Hauteur (Largeur + Format)",
                  icon: Icons.height,
                  child: Column(
                    children: [
                      _calcActionsRow(onCalc: calc3, resultText: r3),
                      const SizedBox(height: 10),
                      ResultBox(r3),
                    ],
                  ),
                )),

                sized(ExpandSectionCard(
                  title: "Calcul 4 — Luminosité (lux / nits / ft-L + seuil)",
                  icon: Icons.brightness_6,
                  child: Column(
                    children: [
                      _calcActionsRow(onCalc: calc4, resultText: r4),
                      const SizedBox(height: 10),
                      ResultBox(r4),
                    ],
                  ),
                )),

                sized(ExpandSectionCard(
                  title: "Calcul 5 — Overlap (Largeur totale + N)",
                  icon: Icons.grid_on,
                  child: Column(
                    children: [
                      _numField(
                        controller: _calc5NCtrl,
                        label: 'Nombre de projecteurs (N)',
                        hint: 'ex: 2',
                        action: TextInputAction.done,
                        onDone: calc5,
                      ),
                      const SizedBox(height: 12),
                      _calcActionsRow(onCalc: calc5, resultText: r5),
                      const SizedBox(height: 10),
                      ResultBox(r5),
                    ],
                  ),
                )),

                sized(ExpandSectionCard(
                  title: "Calcul 6 — Nb projecteurs auto + luminosité",
                  icon: Icons.auto_fix_high,
                  child: Column(
                    children: [
                      _numField(
                        controller: _calc6RatioMinCtrl,
                        label: 'Ratio min',
                        hint: 'ex: 1.20',
                        action: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      _numField(
                        controller: _calc6RatioMaxCtrl,
                        label: 'Ratio max',
                        hint: 'ex: 1.80',
                        action: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Optionnel : luminosité",
                          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _numField(
                        controller: _calc6LumensPerProjCtrl,
                        label: 'Lumens par projecteur',
                        hint: 'ex: 20000',
                        action: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      _numField(
                        controller: _calc6GainCtrl,
                        label: 'Gain (calc 6)',
                        hint: 'ex: 1.0',
                        action: TextInputAction.done,
                        onDone: calc6,
                      ),
                      const SizedBox(height: 12),
                      _calcActionsRow(onCalc: calc6, resultText: r6),
                      const SizedBox(height: 10),
                      ResultBox(r6),
                    ],
                  ),
                )),
              ];

              return SingleChildScrollView(
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: cards,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
