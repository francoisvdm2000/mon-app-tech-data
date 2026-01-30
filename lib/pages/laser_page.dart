import 'package:flutter/material.dart';

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
            decoration: const InputDecoration(
              labelText: 'Nom du projecteur',
            ),
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

  // ✅ Option B : renommage via icône crayon
  Future<void> _renamePreset(LaserPreset preset) async {
    final controller = TextEditingController(text: preset.name);

    final newName = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Renommer le projecteur'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Nom du projecteur',
          ),
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

  @override
  Widget build(BuildContext context) {
    final bg = Colors.black;
    final cardGrey = const Color(0xFFE6E6E6);
    final orange = Colors.deepOrange;
    final blue = Colors.lightBlueAccent;

    final targetDistanceRaw = _targetDistanceController.text.trim();
    final parsedTargetDistance = _parseDouble(targetDistanceRaw) ?? 0.0;
    final hasTargetDistance = targetDistanceRaw.isNotEmpty && parsedTargetDistance > 0;

    // vert si usage <= 100 %
    final within = _target.isWithinLimit;
    final adviceColor = within ? Colors.greenAccent : Colors.redAccent;

    final String? adviceText = !hasTargetDistance
        ? null
        : (within
            ? 'Pleine puissance autorisée (100 %)'
            : 'Puissance maximale conseillée : ${_formatPercent(_target.recommendedMaxPercent)}');

    final filteredPresets = _presets.where((p) {
      if (_searchQuery.isEmpty) return true;
      return p.name.toLowerCase().contains(_searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        title: const Text('Laser'),
        centerTitle: false,
      ),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
          child: Column(
            children: [
              // Bloc entrées + Enregistrer
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: [
                    _inputRow(
                      label: 'Puissance (milliwatt)',
                      controller: _powerController,
                      hint: 'Puissance',
                    ),
                    const SizedBox(height: 10),
                    _inputRow(
                      label: 'Divergence (milliradian)',
                      controller: _divergenceController,
                      hint: 'Divergence',
                    ),
                    const SizedBox(height: 10),
                    _inputRow(
                      label: 'Diamètre de sortie (millimètre)',
                      controller: _diameterController,
                      hint: 'Diamètre',
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _saveCurrentPreset,
                        icon: const Icon(Icons.save),
                        label: const Text('Enregistrer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A1F44),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Enregistrements + recherche
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enregistrements',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // ✅ Recherche : texte plus foncé comme les autres inputs
                    TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Rechercher un projecteur',
                        hintStyle: const TextStyle(color: Colors.black45),
                        prefixIcon: const Icon(Icons.search, color: Colors.black54),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Colors.black26, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Colors.black87, width: 1.5),
                        ),
                        isDense: true,
                      ),
                    ),

                    const SizedBox(height: 8),

                    if (filteredPresets.isEmpty)
                      const Text(
                        'Aucun enregistrement',
                        style: TextStyle(color: Colors.black87),
                      )
                    else
                      ...filteredPresets.map((p) {
                        return Dismissible(
                          key: ValueKey(p.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16),
                            color: Colors.redAccent,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (_) => _deletePreset(p),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              p.name,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Puissance : ${p.powerMilliwatt.toStringAsFixed(0)} milliwatt • '
                              'Divergence : ${p.divergenceMilliradian.toStringAsFixed(2)} milliradian • '
                              'Diamètre : ${p.outputDiameterMillimeter.toStringAsFixed(1)} millimètre',
                              style: const TextStyle(color: Colors.black54),
                            ),
                            // ✅ pas de chevron, mais un crayon pour renommer
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _renamePreset(p),
                            ),
                            onTap: () => _applyPreset(p),
                          ),
                        );
                      }),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Bloc paramètres de sécurité
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(
                  color: orange,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Paramètres de sécurité retenus',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'MPE pour la distance nominale de danger oculaire (NOHD) : 25,4 W/m²\n'
                      '(Norme IEC 60825-1, édition 3.0)\n\n'
                      'MPE pour la distance d’exposition de la zone sensible (SZED) : 1 W/m²\n'
                      '(Norme ANSI Z136.6)\n\n'
                      'MPE pour la distance d’exposition de la zone critique (CZED) : 0,05 W/m²\n'
                      '(Norme ANSI Z136.6)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Bloc résultats
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cardGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: [
                    const Text('Résultat', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    _resultLine(
                      label: 'Distance nominale de danger oculaire (NOHD) :',
                      value: _formatMeters(_zones.nohdMeter),
                      valueColor: Colors.red,
                    ),
                     const SizedBox(height: 6),
                    _resultLine(
                      label: 'Distance d’exposition de la zone sensible (SZED) :',
                      value: _formatMeters(_zones.szedMeter),
                      valueColor: blue,
                    ),
                    const SizedBox(height: 6),
                    _resultLine(
                      label: 'Distance d’exposition de la zone critique (CZED) :',
                      value: _formatMeters(_zones.czedMeter),
                      valueColor: Colors.deepOrange,
                    ),
                    
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Distance cible
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Distance cible (mètre) :',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 180,
                    child: TextField(
                      controller: _targetDistanceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Distance cible',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: const Color(0xFF1F1F1F),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Colors.white54, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: Colors.white, width: 1.5),
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),

              // ✅ Important : ce if DOIT être dans children: [ ... ]
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

              const SizedBox(height: 16),

              const Text(
                'Calcul indicatif. Ne remplace pas une analyse de sécurité laser.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputRow({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.black87)),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 180,
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black45),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.black26, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.black87, width: 1.5),
              ),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _resultLine({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.black87)),
        ),
        Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
