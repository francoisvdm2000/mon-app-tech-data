import 'package:flutter/material.dart';

import '../app/ui/widgets.dart'; // numFormatter, ResultBox-like styling helpers if needed
import 'laser/laser_calculations.dart';
import 'laser/laser_storage.dart';

class LaserPage extends StatefulWidget {
  const LaserPage({super.key});

  @override
  State<LaserPage> createState() => _LaserPageState();
}

class _LaserPageState extends State<LaserPage> {
  final _powerController = TextEditingController();
  final _divergenceController = TextEditingController();
  final _diameterController = TextEditingController();
  final _targetDistanceController = TextEditingController();

  final _searchController = TextEditingController();
  String _searchQuery = '';

  LaserResults _zones = const LaserResults(nohdMeter: 0, czedMeter: 0, szedMeter: 0);
  TargetDistanceAssessment _target = const TargetDistanceAssessment(
    powerMaxWattAtTarget: 0,
    usagePercent: 0,
    recommendedMaxPercent: 0,
    isWithinLimit: true,
  );

  List<LaserPreset> _presets = [];

  @override
  void initState() {
    super.initState();

    _powerController.addListener(_recompute);
    _divergenceController.addListener(_recompute);
    _diameterController.addListener(_recompute);
    _targetDistanceController.addListener(_recompute);

    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.trim().toLowerCase());
    });

    _loadPresets();
  }

  @override
  void dispose() {
    _powerController.dispose();
    _divergenceController.dispose();
    _diameterController.dispose();
    _targetDistanceController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPresets() async {
    final list = await LaserStorage.loadPresets();
    if (!mounted) return;
    setState(() => _presets = list);
  }

  double? _parseDouble(String raw) {
    final t = raw.trim().replaceAll(',', '.');
    if (t.isEmpty) return null;
    return double.tryParse(t);
  }

  LaserInputs? _readInputs() {
    final p = _parseDouble(_powerController.text);
    final div = _parseDouble(_divergenceController.text);
    final d = _parseDouble(_diameterController.text);

    if (p == null || div == null || d == null) return null;
    if (p <= 0 || div <= 0 || d <= 0) return null;

    return LaserInputs(
      powerMilliwatt: p,
      divergenceMilliradian: div,
      outputDiameterMillimeter: d,
    );
  }

  void _recompute() {
    final inputs = _readInputs();
    if (inputs == null) {
      setState(() {
        _zones = const LaserResults(nohdMeter: 0, czedMeter: 0, szedMeter: 0);
        _target = const TargetDistanceAssessment(
          powerMaxWattAtTarget: 0,
          usagePercent: 0,
          recommendedMaxPercent: 0,
          isWithinLimit: true,
        );
      });
      return;
    }

    final zones = LaserCalculations.computeZones(inputs);

    final targetDistance = _parseDouble(_targetDistanceController.text) ?? 0.0;
    final target = targetDistance > 0
        ? LaserCalculations.assessAtTargetDistance(inputs: inputs, targetDistanceMeter: targetDistance)
        : const TargetDistanceAssessment(
            powerMaxWattAtTarget: 0,
            usagePercent: 0,
            recommendedMaxPercent: 0,
            isWithinLimit: true,
          );

    setState(() {
      _zones = zones;
      _target = target;
    });
  }

  String _formatMeters(double value) {
    if (value <= 0) return '0 m';
    if (value < 10) return '${value.toStringAsFixed(1)} m';
    return '${value.toStringAsFixed(0)} m';
  }

  String _formatPercent(double value) {
    if (value <= 0) return '0 %';
    if (value >= 100) return '100 %';
    return '${value.toStringAsFixed(0)} %';
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<String?> _askNameDialog() async {
    final controller = TextEditingController();
    return showDialog<String?>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Enregistrer un projecteur'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Nom du projecteur'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isEmpty) return;
                Navigator.pop(ctx, name);
              },
              child: const Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveCurrentPreset() async {
    final inputs = _readInputs();
    if (inputs == null) {
      _showSnack('Veuillez entrer une puissance, une divergence et un diamètre valides.');
      return;
    }

    final name = await _askNameDialog();
    if (name == null) return;

    final targetDistance = _parseDouble(_targetDistanceController.text);
    final preset = LaserPreset(
      id: LaserStorage.makeId(),
      name: name,
      powerMilliwatt: inputs.powerMilliwatt,
      divergenceMilliradian: inputs.divergenceMilliradian,
      outputDiameterMillimeter: inputs.outputDiameterMillimeter,
      targetDistanceMeter: (targetDistance != null && targetDistance > 0) ? targetDistance : null,
      createdAt: DateTime.now(),
    );

    await LaserStorage.savePreset(preset);
    await _loadPresets();
    _showSnack('Enregistrement ajouté.');
  }

  void _applyPreset(LaserPreset preset) {
    _powerController.text = preset.powerMilliwatt.toString();
    _divergenceController.text = preset.divergenceMilliradian.toString();
    _diameterController.text = preset.outputDiameterMillimeter.toString();
    _targetDistanceController.text = preset.targetDistanceMeter?.toString() ?? '';
    _recompute();
  }

  Future<void> _deletePreset(LaserPreset preset) async {
    await LaserStorage.deletePreset(preset.id);
    await _loadPresets();
    _showSnack('Enregistrement supprimé.');
  }

  Future<void> _renamePreset(LaserPreset preset) async {
    final controller = TextEditingController(text: preset.name);

    final newName = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Renommer le projecteur'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nom du projecteur'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isEmpty) return;
              Navigator.pop(ctx, name);
            },
            child: const Text('Renommer'),
          ),
        ],
      ),
    );

    if (newName == null) return;

    final updated = LaserPreset(
      id: preset.id,
      name: newName,
      powerMilliwatt: preset.powerMilliwatt,
      divergenceMilliradian: preset.divergenceMilliradian,
      outputDiameterMillimeter: preset.outputDiameterMillimeter,
      targetDistanceMeter: preset.targetDistanceMeter,
      createdAt: preset.createdAt,
    );

    await LaserStorage.savePreset(updated);
    await _loadPresets();

    if (!mounted) return;
    _showSnack('Nom mis à jour.');
  }

  InputDecoration _dec(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
    );
  }

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

  Widget _resultsCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _zoneLine({
    required String label,
    required String desc,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0B0B0B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: color.withValues(alpha: 0.35)),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: color.withValues(alpha: 0.95),
                fontWeight: FontWeight.w900,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              desc,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.70), fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewPadding.bottom;

    final targetDistanceRaw = _targetDistanceController.text.trim();
    final parsedTargetDistance = _parseDouble(targetDistanceRaw) ?? 0.0;
    final hasTargetDistance = targetDistanceRaw.isNotEmpty && parsedTargetDistance > 0;

    final within = _target.isWithinLimit;
    final adviceColor = within ? Colors.greenAccent : Colors.redAccent;

    final String? adviceText = !hasTargetDistance
        ? null
        : (within ? 'Pleine puissance autorisée (100 %)' : 'Puissance maximale conseillée : ${_formatPercent(_target.recommendedMaxPercent)}');

    final filteredPresets = _presets.where((p) {
      if (_searchQuery.isEmpty) return true;
      return p.name.toLowerCase().contains(_searchQuery);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laser'),
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottomPad),
          child: Column(
            children: [
              // ---------------- Entrées + Enregistrer ----------------
              SectionCard(
                title: 'Entrées',
                icon: Icons.tune,
                child: Column(
                  children: [
                    _numField(
                      controller: _powerController,
                      label: 'Puissance (mW)',
                      hint: 'ex: 5000',
                      action: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    _numField(
                      controller: _divergenceController,
                      label: 'Divergence (mrad)',
                      hint: 'ex: 1.2',
                      action: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    _numField(
                      controller: _diameterController,
                      label: 'Diamètre de sortie (mm)',
                      hint: 'ex: 3.0',
                      action: TextInputAction.done,
                      onDone: _recompute,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _saveCurrentPreset,
                            icon: const Icon(Icons.save),
                            label: const Text('Enregistrer ce projecteur'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ---------------- Résultats ----------------
              _resultsCard(
                title: 'Résultats de sécurité',
                icon: Icons.shield_outlined,
                child: Column(
                  children: [
                    _zoneLine(
                      label: 'NOHD',
                      desc: 'Danger oculaire',
                      value: _formatMeters(_zones.nohdMeter),
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 10),
                    _zoneLine(
                      label: 'SZED',
                      desc: 'Zone sensible',
                      value: _formatMeters(_zones.szedMeter),
                      color: Colors.lightBlueAccent,
                    ),
                    const SizedBox(height: 10),
                    _zoneLine(
                      label: 'CZED',
                      desc: 'Zone critique',
                      value: _formatMeters(_zones.czedMeter),
                      color: Colors.deepOrangeAccent,
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: Colors.white12),
                    const SizedBox(height: 14),

                    _numField(
                      controller: _targetDistanceController,
                      label: 'Distance cible (m)',
                      hint: 'ex: 10',
                      action: TextInputAction.done,
                      onDone: _recompute,
                    ),

                    if (adviceText != null) ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          adviceText,
                          style: TextStyle(color: adviceColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ---------------- Presets ----------------
              SectionCard(
                title: 'Projecteurs enregistrés',
                icon: Icons.bookmarks_outlined,
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        labelText: 'Rechercher',
                        hintText: 'ex: “RGB 5W”',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 10),

                    if (filteredPresets.isEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Aucun enregistrement',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.70)),
                        ),
                      )
                    else
                      Column(
                        children: filteredPresets.map((p) {
                          return Dismissible(
                            key: ValueKey(p.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16),
                              color: Colors.redAccent.withValues(alpha: 0.85),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) => _deletePreset(p),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                p.name,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                              subtitle: Text(
                                'P: ${p.powerMilliwatt.toStringAsFixed(0)} mW • '
                                'Div: ${p.divergenceMilliradian.toStringAsFixed(2)} mrad • '
                                'Ø: ${p.outputDiameterMillimeter.toStringAsFixed(1)} mm',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.65)),
                              ),
                              trailing: IconButton(
                                tooltip: 'Renommer',
                                icon: const Icon(Icons.edit),
                                onPressed: () => _renamePreset(p),
                              ),
                              onTap: () => _applyPreset(p),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              
// ---------------- Paramètres normatifs (dropdown fermé) ----------------
              ExpandSectionCard(
                title: 'Paramètres de sécurité retenus',
                icon: Icons.info_outline,
                initiallyExpanded: false,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B0B0B),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
                  ),
                  child: Text(
                    'MPE pour la distance nominale de danger oculaire (NOHD) : 25,4 W/m²\n'
                    '(Norme IEC 60825-1, édition 3.0)\n\n'
                    'MPE pour la distance d’exposition de la zone sensible (SZED) : 1 W/m²\n'
                    '(Norme ANSI Z136.6)\n\n'
                    'MPE pour la distance d’exposition de la zone critique (CZED) : 0,05 W/m²\n'
                    '(Norme ANSI Z136.6)',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.35,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Text(
                'Calcul indicatif. Ne remplace pas une analyse de sécurité laser.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.38), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
