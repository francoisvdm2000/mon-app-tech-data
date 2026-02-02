import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../app/ui/widgets.dart'; // intFormatter, numFormatter, ExpandSectionCard
import '../../app/utils/png_exporter.dart';
import 'mire_painters.dart';

class _FormDropdown<T> extends StatelessWidget {
  const _FormDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(labelText: label),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items,
          onChanged: (v) {
            if (v == null) return;
            onChanged(v);
          },
        ),
      ),
    );
  }
}

class MireEcranVideoPage extends StatefulWidget {
  const MireEcranVideoPage({super.key});

  @override
  State<MireEcranVideoPage> createState() => _MireEcranVideoPageState();
}

class _MireEcranVideoPageState extends State<MireEcranVideoPage> {
  // --- Mire simple
  final _wSimpleCtrl = TextEditingController(text: '1920');
  final _hSimpleCtrl = TextEditingController(text: '1080');
  VideoSimpleMireType _simpleType = VideoSimpleMireType.comboAll;

  // --- Mire mapping
  final _wMapCtrl = TextEditingController(text: '3840');
  final _hMapCtrl = TextEditingController(text: '2160');
  final _nProjCtrl = TextEditingController(text: '2');
  final _overlapCtrl = TextEditingController(text: '10.0');
  MappingOrientation _orientation = MappingOrientation.horizontal;
  VideoMappingMireType _mapType = VideoMappingMireType.combo;

  String _errSimple = '';
  String _errMap = '';

  @override
  void dispose() {
    _wSimpleCtrl.dispose();
    _hSimpleCtrl.dispose();
    _wMapCtrl.dispose();
    _hMapCtrl.dispose();
    _nProjCtrl.dispose();
    _overlapCtrl.dispose();
    super.dispose();
  }

  int? _i(TextEditingController c) => int.tryParse(c.text.trim());
  double? _d(TextEditingController c) => double.tryParse(c.text.trim().replaceAll(',', '.'));

  void _validateSimple() {
    final w = _i(_wSimpleCtrl);
    final h = _i(_hSimpleCtrl);

    if (w == null || h == null || w <= 0 || h <= 0) {
      setState(() => _errSimple = '❌ Largeur/hauteur invalides (px).');
      return;
    }
    setState(() => _errSimple = '');
  }

  void _validateMapping() {
    final w = _i(_wMapCtrl);
    final h = _i(_hMapCtrl);
    final n = _i(_nProjCtrl);
    final ov = _d(_overlapCtrl);

    if (w == null || h == null || w <= 0 || h <= 0) {
      setState(() => _errMap = '❌ Largeur/hauteur invalides (px).');
      return;
    }
    if (n == null || n <= 0) {
      setState(() => _errMap = '❌ Nombre de projecteurs invalide (N > 0).');
      return;
    }
    if (ov == null || ov < 0 || ov >= 100) {
      setState(() => _errMap = '❌ Overlap invalide (0 à 99.9).');
      return;
    }
    setState(() => _errMap = '');
  }

  Widget _previewBox({
    required int w,
    required int h,
    required CustomPainter painter,
  }) {
    return AspectRatio(
      aspectRatio: w / h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CustomPaint(painter: painter),
        ),
      ),
    );
  }

  Future<Uint8List> _renderToPngBytes({
    required int widthPx,
    required int heightPx,
    required CustomPainter painter,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = Size(widthPx.toDouble(), heightPx.toDouble());

    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);
    painter.paint(canvas, size);

    final picture = recorder.endRecording();
    final img = await picture.toImage(widthPx, heightPx);
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List();
  }

  Future<void> _exportSimple() async {
    _validateSimple();
    if (_errSimple.isNotEmpty) return;

    final w = _i(_wSimpleCtrl)!;
    final h = _i(_hSimpleCtrl)!;

    final painter = VideoSimpleMirePainter(
      widthPx: w,
      heightPx: h,
      type: _simpleType,
    );

    final png = await _renderToPngBytes(widthPx: w, heightPx: h, painter: painter);
    final filename = 'mire_video_simple_${w}x${h}_${_simpleType.name}.png';
    await exportPngBytes(png, filename);
  }

  Future<void> _exportMapping() async {
    _validateMapping();
    if (_errMap.isNotEmpty) return;

    final w = _i(_wMapCtrl)!;
    final h = _i(_hMapCtrl)!;
    final n = _i(_nProjCtrl)!;
    final ov = _d(_overlapCtrl)!;

    final painter = VideoMappingMirePainter(
      widthPx: w,
      heightPx: h,
      nProjectors: n,
      overlapPercent: ov,
      orientation: _orientation,
      type: _mapType,
    );

    final png = await _renderToPngBytes(widthPx: w, heightPx: h, painter: painter);

    final oriTag = _orientation == MappingOrientation.horizontal ? 'H' : 'V';
    final ovTag = ov.toStringAsFixed(1).replaceAll('.', '_');
    final filename = 'mire_video_mapping_${w}x${h}_N${n}_ov${ovTag}_${oriTag}_${_mapType.name}.png';

    await exportPngBytes(png, filename);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    final wSimple = _i(_wSimpleCtrl) ?? 1920;
    final hSimple = _i(_hSimpleCtrl) ?? 1080;

    final wMap = _i(_wMapCtrl) ?? 3840;
    final hMap = _i(_hMapCtrl) ?? 2160;
    final nMap = _i(_nProjCtrl) ?? 2;
    final ovMap = _d(_overlapCtrl) ?? 10.0;

    final simplePainter = VideoSimpleMirePainter(
      widthPx: wSimple,
      heightPx: hSimple,
      type: _simpleType,
    );

    final mapPainter = VideoMappingMirePainter(
      widthPx: wMap,
      heightPx: hMap,
      nProjectors: nMap,
      overlapPercent: ovMap,
      orientation: _orientation,
      type: _mapType,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Mires écran vidéo')),
      body: SafeArea(
        bottom: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottom),
          child: Column(
            children: [
              ExpandSectionCard(
                title: 'Mire écran simple',
                icon: Icons.tv,
                initiallyExpanded: true,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _wSimpleCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [intFormatter],
                            decoration: const InputDecoration(labelText: 'Largeur (px)', hintText: 'ex: 1920'),
                            onChanged: (_) => _validateSimple(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _hSimpleCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [intFormatter],
                            decoration: const InputDecoration(labelText: 'Hauteur (px)', hintText: 'ex: 1080'),
                            onChanged: (_) => _validateSimple(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _FormDropdown<VideoSimpleMireType>(
                      label: 'Type de mire',
                      value: _simpleType,
                      items: const [
                        DropdownMenuItem(
                          value: VideoSimpleMireType.comboAll,
                          child: Text('Combo (grille + cercles + 2 barres centrées)'),
                        ),
                        DropdownMenuItem(value: VideoSimpleMireType.gridSafe, child: Text('Grille + safe + cercles')),
                        DropdownMenuItem(value: VideoSimpleMireType.colorBars, child: Text('Barres + rampes + cercles')),
                        DropdownMenuItem(value: VideoSimpleMireType.uniformity, child: Text('Uniformité + cercles')),
                        DropdownMenuItem(value: VideoSimpleMireType.checkerboard, child: Text('Damier + cercles')),
                      ],
                      onChanged: (v) {
                        setState(() => _simpleType = v);
                        _validateSimple();
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _exportSimple,
                            icon: const Icon(Icons.image_outlined),
                            label: const Text('Exporter PNG'),
                          ),
                        ),
                      ],
                    ),
                    if (_errSimple.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(_errSimple, style: const TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                    const SizedBox(height: 12),
                    _previewBox(w: wSimple, h: hSimple, painter: simplePainter),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ExpandSectionCard(
                title: 'Mire mapping multi-projecteur',
                icon: Icons.auto_awesome_mosaic,
                initiallyExpanded: true,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _wMapCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [intFormatter],
                            decoration: const InputDecoration(labelText: 'Largeur (px)', hintText: 'ex: 3840'),
                            onChanged: (_) => _validateMapping(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _hMapCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [intFormatter],
                            decoration: const InputDecoration(labelText: 'Hauteur (px)', hintText: 'ex: 2160'),
                            onChanged: (_) => _validateMapping(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _nProjCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [intFormatter],
                            decoration: const InputDecoration(labelText: 'Nombre de projecteurs (N)', hintText: 'ex: 2'),
                            onChanged: (_) => _validateMapping(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _overlapCtrl,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                            inputFormatters: [numFormatter],
                            decoration: const InputDecoration(labelText: 'Overlap (%)', hintText: 'ex: 10.0'),
                            onChanged: (_) => _validateMapping(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _FormDropdown<MappingOrientation>(
                      label: 'Orientation',
                      value: _orientation,
                      items: const [
                        DropdownMenuItem(value: MappingOrientation.horizontal, child: Text('Horizontal')),
                        DropdownMenuItem(value: MappingOrientation.vertical, child: Text('Vertical')),
                      ],
                      onChanged: (v) {
                        setState(() => _orientation = v);
                        _validateMapping();
                      },
                    ),
                    const SizedBox(height: 12),
                    _FormDropdown<VideoMappingMireType>(
                      label: 'Type mapping',
                      value: _mapType,
                      items: const [
                        DropdownMenuItem(value: VideoMappingMireType.combo, child: Text('Combo (zones + overlap + blend)')),
                        DropdownMenuItem(value: VideoMappingMireType.zonesAndOverlap, child: Text('Zones + overlap')),
                        DropdownMenuItem(value: VideoMappingMireType.blendRamps, child: Text('Blend ramps')),
                      ],
                      onChanged: (v) {
                        setState(() => _mapType = v);
                        _validateMapping();
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _exportMapping,
                            icon: const Icon(Icons.image_outlined),
                            label: const Text('Exporter PNG'),
                          ),
                        ),
                      ],
                    ),
                    if (_errMap.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(_errMap, style: const TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                    const SizedBox(height: 12),
                    _previewBox(w: wMap, h: hMap, painter: mapPainter),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
