import 'package:flutter/material.dart';

import '../../app/ui/widgets.dart';
import 'dipswitch_calculations.dart';

class DipSwitchPage extends StatefulWidget {
  const DipSwitchPage({super.key});

  @override
  State<DipSwitchPage> createState() => _DipSwitchPageState();
}

class _DipSwitchPageState extends State<DipSwitchPage> {
  final _addressController = TextEditingController();
  final _intervalController = TextEditingController(text: '1');

  bool _isUpdating = false;
  bool _useAddressMinusOne = false; // OFF par défaut
  List<bool> _switches = List<bool>.filled(9, false);

  String _result = '';
  bool _endOfUniverseWarning = false; // ✅ alerte fin d’univers

  @override
  void initState() {
    super.initState();
    _addressController.addListener(_onAddressChanged);
    _intervalController.addListener(_recomputeText);
    _recomputeText();
  }

  @override
  void dispose() {
    _addressController.dispose();
    _intervalController.dispose();
    super.dispose();
  }

  int? _parseInt(String raw) {
    final t = raw.trim();
    if (t.isEmpty) return null;
    return int.tryParse(t);
  }

  int _clampInt(int v, int min, int max) {
    if (v < min) return min;
    if (v > max) return max;
    return v;
  }

  int _addressToBinaryValue(int address) {
    if (_useAddressMinusOne) {
      return _clampInt(address - 1, 0, 511);
    }
    return _clampInt(address, 0, 511);
  }

  int _binaryValueToAddress(int value) {
    final v = _clampInt(value, 0, 511);
    if (_useAddressMinusOne) {
      return _clampInt(v + 1, 1, 512);
    }
    return _clampInt(v == 0 ? 1 : v, 1, 512);
  }

  void _resetAll() {
    setState(() {
      _isUpdating = true;
      _addressController.clear();
      _intervalController.text = '1';
      _useAddressMinusOne = false;
      _switches = List<bool>.filled(9, false);
      _endOfUniverseWarning = false;
      _isUpdating = false;
      _recomputeText();
    });
  }

  void _onAddressChanged() {
    if (_isUpdating) return;

    final a = _parseInt(_addressController.text);
    if (a == null || a < 1 || a > 512) {
      setState(() {
        _switches = List<bool>.filled(9, false);
        _endOfUniverseWarning = false;
        _recomputeText();
      });
      return;
    }

    final value = _addressToBinaryValue(a);
    setState(() {
      _switches = DipSwitchCalculations.addressToSwitches(value);
      _endOfUniverseWarning = false; // changer l'adresse “efface” l’alerte
      _recomputeText();
    });
  }

  void _onSwitchToggled(int index) {
    setState(() {
      _switches[index] = !_switches[index];
    });

    final v = DipSwitchCalculations.switchesToAddress(_switches);
    final addr = _binaryValueToAddress(v);

    _isUpdating = true;
    _addressController.text = addr.toString();
    _isUpdating = false;

    setState(() => _endOfUniverseWarning = false);
    _recomputeText();
  }

  void _nextAddress() {
    final a = _parseInt(_addressController.text) ?? 1;
    final step = _parseInt(_intervalController.text) ?? 1;
    final safeStep = step <= 0 ? 1 : step;

    final next = a + safeStep;

    if (next > 512) {
      // ✅ on signale en rouge, sans avancer
      setState(() => _endOfUniverseWarning = true);
      _recomputeText();
      return;
    }

    _isUpdating = true;
    _addressController.text = next.toString();
    _isUpdating = false;

    setState(() => _endOfUniverseWarning = false);
    _onAddressChanged();
  }

  void _toggleAddressMode(bool v) {
    setState(() {
      _useAddressMinusOne = v;
      _endOfUniverseWarning = false;
    });
    _onAddressChanged();
  }

  void _recomputeText() {
    final a = _parseInt(_addressController.text);
    final step = _parseInt(_intervalController.text) ?? 1;

    final lines = <String>[];
    lines.add('Conversion indicative dip-switch / adresse DMX');
    lines.add('');
    lines.add('Mode : ${_useAddressMinusOne ? 'Adresse moins 1' : 'Adresse directe'}');
    lines.add('');

    if (a == null) {
      lines.add('Adresse DMX : non renseignée');
    } else {
      final value = _addressToBinaryValue(a);
      lines.add('Adresse DMX : $a');
      lines.add('Valeur binaire utilisée : $value');
    }

    lines.add('Intervalle : ${step <= 0 ? 1 : step} canal');

    setState(() => _result = lines.join('\n'));
  }

Widget _dipSwitch() {
  // Dimensions de base
  const double baseDipWidth = 28;
  const double baseDipHeight = 60;
  const double baseKnobHeight = 22;
  const double baseSpacing = 14;

  // Largeur idéale (9 switches uniquement, plus de légende)
  const double perSwitchWidth = baseDipWidth + baseSpacing;
  const double idealTotalWidth = (9 * perSwitchWidth) - baseSpacing;

  return LayoutBuilder(
    builder: (context, constraints) {
      final available = constraints.maxWidth;

      // Scale down uniquement sur petits écrans
      final scale = (available / idealTotalWidth).clamp(0.72, 1.0);

      final dipWidth = baseDipWidth * scale;
      final dipHeight = baseDipHeight * scale;
      final knobHeight = baseKnobHeight * scale;
      final spacing = baseSpacing * scale;

      Widget dipToggle(int i) {
        final weight = DipSwitchCalculations.weights[i];
        final on = _switches[i];

        return Padding(
          padding: EdgeInsets.only(right: i == 8 ? 0 : spacing),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                  'Switch ${i + 1}',
                  style: TextStyle(color: Colors.white70, fontSize: 12 * scale),
                ),
              ),
              SizedBox(height: 4 * scale),
              Text(
                '($weight)',
                style: TextStyle(color: Colors.white54, fontSize: 12 * scale),
              ),
              SizedBox(height: 6 * scale),
              GestureDetector(
                onTap: () => _onSwitchToggled(i),
                child: Container(
                  width: dipWidth,
                  height: dipHeight,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4 * scale),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Stack(
                    children: [
                      // Repères intégrés (gain de place, explicite)
                      Positioned(
                        top: 4 * scale,
                        left: 0,
                        right: 0,
                        child: Text(
                          'ON',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 9 * scale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4 * scale,
                        left: 0,
                        right: 0,
                        child: Text(
                          'OFF',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 9 * scale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      // Knob
                      Align(
                        alignment: on ? Alignment.topCenter : Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.all(3 * scale),
                          height: knobHeight,
                          decoration: BoxDecoration(
                            color: on ? Colors.greenAccent : Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(3 * scale),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF0B0B0B),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Fais défiler horizontalement si nécessaire.',
              style: TextStyle(color: Colors.white54, fontSize: 12 * scale),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    for (int i = 0; i < 9; i++) dipToggle(i),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dip-switch DMX'),
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
              title: 'Entrées',
              icon: Icons.edit,
              initiallyExpanded: true,
              child: Column(
                children: [
                  TextField(
                    controller: _addressController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [numFormatter],
                    decoration: const InputDecoration(
                      labelText: 'Adresse DMX (1 à 512)',
                      hintText: 'Exemple : 1',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _intervalController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [numFormatter],
                    decoration: const InputDecoration(
                      labelText: 'Intervalle (nombre de canaux)',
                      hintText: 'Exemple : 16',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Utiliser adresse moins 1',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      Switch(
                        value: _useAddressMinusOne,
                        onChanged: _toggleAddressMode,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextAddress,
                      child: const Text('Adresse suivante selon l’intervalle'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            ExpandSectionCard(
              title: 'Dip-switch',
              icon: Icons.tune,
              initiallyExpanded: true,
              child: _dipSwitch(),
            ),

            const SizedBox(height: 14),
            ExpandSectionCard(
              title: 'Résumé',
              icon: Icons.info_outline,
              initiallyExpanded: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_endOfUniverseWarning) ...[
                    const Text(
                      'Fin de l’univers : l’adresse suivante dépasserait 512.',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  ResultBox(_result),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
