import 'package:flutter/material.dart';

import '../../app/ui/widgets.dart';
import 'photometry_calculations.dart';

class PhotometryPage extends StatefulWidget {
  const PhotometryPage({super.key});

  @override
  State<PhotometryPage> createState() => _PhotometryPageState();
}

class _PhotometryPageState extends State<PhotometryPage> {
  // Outil 1 : lux <-> candela avec distance
  final _lux1 = TextEditingController();
  final _candela1 = TextEditingController();
  final _distance1 = TextEditingController();

  // Outil 2 : lumens <-> candela avec angle
  final _lumens2 = TextEditingController();
  final _candela2 = TextEditingController();
  final _angle2 = TextEditingController();

  // Outil 3 : lux depuis lumens + distance + angle
  final _lumens3 = TextEditingController();
  final _distance3 = TextEditingController();
  final _angle3 = TextEditingController();

  bool _isUpdating = false;

  String _summary1 = '';
  String _summary2 = '';
  String _summary3 = '';

  @override
  void initState() {
    super.initState();

    for (final c in [
      _lux1,
      _candela1,
      _distance1,
      _lumens2,
      _candela2,
      _angle2,
      _lumens3,
      _distance3,
      _angle3,
    ]) {
      c.addListener(_recomputeAll);
    }

    _recomputeAll();
  }

  @override
  void dispose() {
    for (final c in [
      _lux1,
      _candela1,
      _distance1,
      _lumens2,
      _candela2,
      _angle2,
      _lumens3,
      _distance3,
      _angle3,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double? _parse(String raw) {
    final t = raw.trim().replaceAll(',', '.');
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  bool _ok(double? v) => v != null && v > 0;

  String _fmt(double v, {int decimals = 2}) {
    if (v <= 0) return '0';
    return v.toStringAsFixed(decimals);
  }

  void _set(TextEditingController c, String value) {
    _isUpdating = true;
    c.text = value;
    _isUpdating = false;
  }

  void _resetAll() {
    _isUpdating = true;
    for (final c in [
      _lux1,
      _candela1,
      _distance1,
      _lumens2,
      _candela2,
      _angle2,
      _lumens3,
      _distance3,
      _angle3,
    ]) {
      c.clear();
    }
    _isUpdating = false;
    _recomputeAll();
  }

  void _recomputeAll() {
    if (_isUpdating) return;
    _recompute1();
    _recompute2();
    _recompute3();
  }

  void _recompute1() {
    final lux = _parse(_lux1.text);
    final cd = _parse(_candela1.text);
    final dist = _parse(_distance1.text);

    final luxOk = _ok(lux);
    final cdOk = _ok(cd);
    final distOk = _ok(dist);

    final count = (luxOk ? 1 : 0) + (cdOk ? 1 : 0) + (distOk ? 1 : 0);

    // Strict: seulement si exactement 2 valeurs valides
    if (count == 2 && distOk) {
      final d = dist;
      if (d != null && d > 0) {
        if (!luxOk && cdOk) {
          final c = cd;
          if (c != null && c > 0) {
            final computed = PhotometryCalculations.luxFromCandela(
              candela: c,
              distanceMeter: d,
            );
            _set(_lux1, computed > 0 ? _fmt(computed, decimals: 1) : '');
          }
        } else if (!cdOk && luxOk) {
          final l = lux;
          if (l != null && l > 0) {
            final computed = PhotometryCalculations.candelaFromLux(
              lux: l,
              distanceMeter: d,
            );
            _set(_candela1, computed > 0 ? _fmt(computed, decimals: 0) : '');
          }
        }
      }
    }

    final lux2 = _parse(_lux1.text) ?? 0.0;
    final cd2 = _parse(_candela1.text) ?? 0.0;
    final d2 = _parse(_distance1.text) ?? 0.0;

    setState(() {
      _summary1 =
          'Éclairement : ${_fmt(lux2, decimals: 1)} lux\n'
          'Intensité lumineuse : ${_fmt(cd2, decimals: 0)} candela\n'
          'Distance : ${_fmt(d2, decimals: 2)} mètre';
    });
  }

  void _recompute2() {
    final lumens = _parse(_lumens2.text);
    final cd = _parse(_candela2.text);
    final angle = _parse(_angle2.text);

    final lmOk = _ok(lumens);
    final cdOk = _ok(cd);
    final aOk = _ok(angle);

    final count = (lmOk ? 1 : 0) + (cdOk ? 1 : 0) + (aOk ? 1 : 0);

    if (count == 2 && aOk) {
      final a = angle;
      if (a != null && a > 0) {
        if (!lmOk && cdOk) {
          final c = cd;
          if (c != null && c > 0) {
            final computed = PhotometryCalculations.lumensFromCandelaAndBeamAngle(
              candela: c,
              beamAngleDegree: a,
            );
            _set(_lumens2, computed > 0 ? _fmt(computed, decimals: 0) : '');
          }
        } else if (!cdOk && lmOk) {
          final lm = lumens;
          if (lm != null && lm > 0) {
            final computed = PhotometryCalculations.candelaFromLumensAndBeamAngle(
              lumens: lm,
              beamAngleDegree: a,
            );
            _set(_candela2, computed > 0 ? _fmt(computed, decimals: 0) : '');
          }
        }
      }
    }

    final lm2 = _parse(_lumens2.text) ?? 0.0;
    final cd2 = _parse(_candela2.text) ?? 0.0;
    final a2 = _parse(_angle2.text) ?? 0.0;
    final omega = PhotometryCalculations.solidAngleSteradianFromBeamAngle(
      beamAngleDegree: a2,
    );

    setState(() {
      _summary2 =
          'Flux lumineux : ${_fmt(lm2, decimals: 0)} lumen\n'
          'Intensité lumineuse : ${_fmt(cd2, decimals: 0)} candela\n'
          'Angle de faisceau : ${_fmt(a2, decimals: 1)} degré\n'
          'Angle solide : ${_fmt(omega, decimals: 3)} stéradian';
    });
  }

  void _recompute3() {
    final lumens = _parse(_lumens3.text);
    final dist = _parse(_distance3.text);
    final angle = _parse(_angle3.text);

    double lux = 0.0;
    if (_ok(lumens) && _ok(dist) && _ok(angle)) {
      final lm = lumens;
      final d = dist;
      final a = angle;
      if (lm != null && d != null && a != null && lm > 0 && d > 0 && a > 0) {
        lux = PhotometryCalculations.luxFromLumensDistanceAndBeamAngle(
          lumens: lm,
          distanceMeter: d,
          beamAngleDegree: a,
        );
      }
    }

    final lm2 = lumens ?? 0.0;
    final d2 = dist ?? 0.0;
    final a2 = angle ?? 0.0;

    setState(() {
      _summary3 =
          'Flux lumineux : ${_fmt(lm2, decimals: 0)} lumen\n'
          'Distance : ${_fmt(d2, decimals: 2)} mètre\n'
          'Angle de faisceau : ${_fmt(a2, decimals: 1)} degré\n'
          'Éclairement estimé : ${_fmt(lux, decimals: 1)} lux';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photométrie'),
        actions: [
          IconButton(
            tooltip: 'Réinitialiser',
            onPressed: _resetAll,
            icon: const Icon(Icons.restart_alt),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            ExpandSectionCard(
              title: 'Lux et candela',
              icon: Icons.light_mode,
              initiallyExpanded: true,
              child: Column(
                children: [
                  TextField(
                    controller: _lux1,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [numFormatter],
                    decoration: const InputDecoration(
                      labelText: 'Éclairement (lux)',
                      hintText: 'Exemple : 500',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _candela1,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [numFormatter],
                    decoration: const InputDecoration(
                      labelText: 'Intensité lumineuse (candela)',
                      hintText: 'Exemple : 20000',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _distance1,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [numFormatter],
                    decoration: const InputDecoration(
                      labelText: 'Distance (mètre)',
                      hintText: 'Exemple : 5',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ResultBox(_summary1),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ExpandSectionCard(
              title: 'Lumen et candela',
              icon: Icons.flash_on,
              initiallyExpanded: false,
              child: Column(
                children: [
                  TextField(
                    controller: _lumens2,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [numFormatter],
                    decoration: const InputDecoration(
                      labelText: 'Flux lumineux (lumen)',
                      hintText: 'Exemple : 20000',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _candela2,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [numFormatter],
                    decoration: const InputDecoration(
                      labelText: 'Intensité lumineuse (candela)',
                      hintText: 'Exemple : 150000',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _angle2,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [numFormatter],
                    decoration: const InputDecoration(
                      labelText: 'Angle de faisceau (degré)',
                      hintText: 'Exemple : 10',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ResultBox(_summary2),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ExpandSectionCard(
              title: 'Lux à partir de lumen',
              icon: Icons.calculate,
              initiallyExpanded: false,
              child: Column(
                children: [
                  TextField(
                    controller: _lumens3,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [numFormatter],
                    decoration: const InputDecoration(
                      labelText: 'Flux lumineux (lumen)',
                      hintText: 'Exemple : 20000',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _distance3,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [numFormatter],
                    decoration: const InputDecoration(
                      labelText: 'Distance (mètre)',
                      hintText: 'Exemple : 8',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _angle3,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [numFormatter],
                    decoration: const InputDecoration(
                      labelText: 'Angle de faisceau (degré)',
                      hintText: 'Exemple : 15',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ResultBox(_summary3),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Calculs indicatifs. Les résultats dépendent du faisceau réel, des optiques et des conditions de mesure.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
