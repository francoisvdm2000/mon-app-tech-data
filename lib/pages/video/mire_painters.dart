import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

enum VideoSimpleMireType { gridSafe, checkerboard, colorBars, uniformity, comboAll }
enum VideoMappingMireType { zonesAndOverlap, blendRamps, combo }
enum MappingOrientation { horizontal, vertical }
enum LedMireType { pixelPerfect, gridLabels, colorBars, uniformity, tilesId }

const kMagenta = Color(0xFFFF00FF);

class _PaintUtil {
  static const double borderStroke = 2.0;

  static TextPainter text(
    String s, {
    double size = 16,
    Color color = Colors.white,
    FontWeight weight = FontWeight.w700,
    TextAlign align = TextAlign.left,
  }) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: weight,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: align,
      maxLines: 10,
    );
    tp.layout();
    return tp;
  }

  static int _gcd(int a, int b) {
    a = a.abs();
    b = b.abs();
    while (b != 0) {
      final t = a % b;
      a = b;
      b = t;
    }
    return a == 0 ? 1 : a;
  }

  static String ratioLabel(int w, int h) {
    if (w <= 0 || h <= 0) return '-';
    final g = _gcd(w, h);
    final rw = (w ~/ g);
    final rh = (h ~/ g);
    final val = (w / h);
    return '${val.toStringAsFixed(3)} ($rw:$rh)';
  }

  /// Zone safe pour éviter tout clipping (preview ET export).
  static Rect safeRect(Size size) {
    final inset = borderStroke / 2.0;
    return Rect.fromLTWH(inset, inset, size.width - inset * 2, size.height - inset * 2);
  }

  static void borderInside(Canvas canvas, Size size) {
    final r = safeRect(size);
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderStroke;
    canvas.drawRect(r, p);
  }

  static void drawInfoBadge(
    Canvas canvas,
    Size size, {
    required String title,
    required int widthPx,
    required int heightPx,
    String? subtitle,
    Alignment align = Alignment.bottomLeft,
  }) {
    final pad = size.shortestSide * 0.020;

    final line1 = title;
    final line2 = '${widthPx}x$heightPx px  •  Ratio ${ratioLabel(widthPx, heightPx)}';
    final line3 = (subtitle == null || subtitle.trim().isEmpty) ? null : subtitle.trim();

    final t1 = text(
      line1,
      size: size.shortestSide * 0.030,
      weight: FontWeight.w800,
      color: Colors.white.withValues(alpha: 0.94),
    );
    final t2 = text(
      line2,
      size: size.shortestSide * 0.024,
      weight: FontWeight.w700,
      color: Colors.white.withValues(alpha: 0.78),
    );
    final t3 = line3 == null
        ? null
        : text(
            line3,
            size: size.shortestSide * 0.022,
            weight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.68),
          );

    final contentW = math.max(t1.width, math.max(t2.width, t3?.width ?? 0));
    final contentH = t1.height + pad * 0.35 + t2.height + (t3 == null ? 0 : (pad * 0.25 + t3.height));

    final boxW = contentW + pad * 2.0;
    final boxH = contentH + pad * 1.4;

    Offset origin;
    if (align == Alignment.bottomLeft) {
      origin = Offset(pad, size.height - boxH - pad);
    } else if (align == Alignment.topLeft) {
      origin = Offset(pad, pad);
    } else if (align == Alignment.topRight) {
      origin = Offset(size.width - boxW - pad, pad);
    } else {
      origin = Offset(size.width - boxW - pad, size.height - boxH - pad);
    }

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(origin.dx, origin.dy, boxW, boxH),
      Radius.circular(size.shortestSide * 0.016),
    );

    final bg = Paint()..color = Colors.black.withValues(alpha: 0.60);
    final stroke = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawRRect(rrect, bg);
    canvas.drawRRect(rrect, stroke);

    double x = origin.dx + pad;
    double y = origin.dy + pad * 0.70;

    t1.paint(canvas, Offset(x, y));
    y += t1.height + pad * 0.20;

    t2.paint(canvas, Offset(x, y));
    y += t2.height;

    if (t3 != null) {
      y += pad * 0.22;
      t3.paint(canvas, Offset(x, y));
    }
  }

  static void circles(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final maxR = math.min(size.width, size.height) * 0.48;

    final pMain = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final pFine = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(c, maxR * (i / 5), pMain);
    }
    for (int i = 1; i <= 10; i++) {
      canvas.drawCircle(c, maxR * (i / 10), pFine);
    }
  }

  static void circlesInRect(Canvas canvas, Rect r) {
    canvas.save();
    canvas.clipRect(r);

    final c = Offset(r.center.dx, r.center.dy);
    final maxR = math.min(r.width, r.height) * 0.48;

    final pMain = Paint()
      ..color = Colors.white.withValues(alpha: 0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final pFine = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i <= 5; i++) {
      canvas.drawCircle(c, maxR * (i / 5), pMain);
    }
    for (int i = 1; i <= 10; i++) {
      canvas.drawCircle(c, maxR * (i / 10), pFine);
    }

    canvas.restore();
  }

  static void crosshair(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.80)
      ..strokeWidth = 2;

    final cx = size.width / 2;
    final cy = size.height / 2;

    canvas.drawLine(Offset(cx, 0), Offset(cx, size.height), p);
    canvas.drawLine(Offset(0, cy), Offset(size.width, cy), p);

    final s = size.shortestSide * 0.03;
    canvas.drawLine(Offset(cx - s, cy), Offset(cx + s, cy), p);
    canvas.drawLine(Offset(cx, cy - s), Offset(cx, cy + s), p);
  }

  /// Petit tag avec fond pour éviter les collisions visuelles.
  static void tag(
    Canvas canvas,
    Rect zone, {
    required String textValue,
    required Alignment anchor,
    double maxWidthFactor = 0.60,
    double fontSize = 40,
  }) {
    final pad = math.max(8.0, zone.shortestSide * 0.02);
    final maxW = zone.width * maxWidthFactor;

    double fs = fontSize;
    TextPainter tp = text(textValue, size: fs, weight: FontWeight.w900, color: Colors.white.withValues(alpha: 0.95));
    while (tp.width > maxW && fs > 16) {
      fs *= 0.90;
      tp = text(textValue, size: fs, weight: FontWeight.w900, color: Colors.white.withValues(alpha: 0.95));
    }

    final boxW = tp.width + pad * 2;
    final boxH = tp.height + pad * 1.4;

    Offset o;
    if (anchor == Alignment.center) {
      o = Offset(zone.center.dx - boxW / 2, zone.center.dy - boxH / 2);
    } else if (anchor == Alignment.topLeft) {
      o = Offset(zone.left + pad, zone.top + pad);
    } else if (anchor == Alignment.topRight) {
      o = Offset(zone.right - boxW - pad, zone.top + pad);
    } else if (anchor == Alignment.bottomLeft) {
      o = Offset(zone.left + pad, zone.bottom - boxH - pad);
    } else {
      o = Offset(zone.right - boxW - pad, zone.bottom - boxH - pad);
    }

    final rr = RRect.fromRectAndRadius(Rect.fromLTWH(o.dx, o.dy, boxW, boxH), Radius.circular(pad * 0.8));
    canvas.drawRRect(rr, Paint()..color = Colors.black.withValues(alpha: 0.45));
    canvas.drawRRect(
      rr,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.14)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    tp.paint(canvas, Offset(o.dx + pad, o.dy + pad * 0.55));
  }

  static void warningTag(Canvas canvas, Rect zone, String textValue) {
    final pad = math.max(8.0, zone.shortestSide * 0.02);
    final tp = text(
      textValue,
      size: zone.shortestSide * 0.08,
      weight: FontWeight.w900,
      color: Colors.white.withValues(alpha: 0.98),
    );

    final boxW = tp.width + pad * 2;
    final boxH = tp.height + pad * 1.4;
    final o = Offset(zone.left + pad, zone.top + pad);

    final rr = RRect.fromRectAndRadius(Rect.fromLTWH(o.dx, o.dy, boxW, boxH), Radius.circular(pad * 0.8));
    canvas.drawRRect(rr, Paint()..color = Colors.redAccent.withValues(alpha: 0.75));
    canvas.drawRRect(
      rr,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    tp.paint(canvas, Offset(o.dx + pad, o.dy + pad * 0.55));
  }
}

/// ---------------- VIDEO SIMPLE ----------------
class VideoSimpleMirePainter extends CustomPainter {
  VideoSimpleMirePainter({
    required this.widthPx,
    required this.heightPx,
    required this.type,
  });

  final int widthPx;
  final int heightPx;
  final VideoSimpleMireType type;

  @override
  void paint(Canvas canvas, Size size) {
    final sr = _PaintUtil.safeRect(size);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);

    canvas.save();
    canvas.translate(sr.left, sr.top);
    final inner = Size(sr.width, sr.height);

    switch (type) {
      case VideoSimpleMireType.gridSafe:
        _gridSafe(canvas, inner);
        _PaintUtil.circles(canvas, inner);
        _PaintUtil.crosshair(canvas, inner);
        break;
      case VideoSimpleMireType.checkerboard:
        _checker(canvas, inner, cells: 12);
        _PaintUtil.circles(canvas, inner);
        _PaintUtil.crosshair(canvas, inner);
        break;
      case VideoSimpleMireType.colorBars:
        _colorBars(canvas, inner);
        _PaintUtil.circles(canvas, inner);
        _PaintUtil.crosshair(canvas, inner);
        break;
      case VideoSimpleMireType.uniformity:
        _uniformity(canvas, inner);
        _PaintUtil.circles(canvas, inner);
        _PaintUtil.crosshair(canvas, inner);
        break;
      case VideoSimpleMireType.comboAll:
        _comboAll(canvas, inner);
        break;
    }

    canvas.restore();

    _PaintUtil.drawInfoBadge(
      canvas,
      size,
      title: type == VideoSimpleMireType.comboAll ? 'VIDEO / MIRE COMBO' : 'VIDEO / MIRE SIMPLE',
      widthPx: widthPx,
      heightPx: heightPx,
      subtitle: _subtitleFor(type),
      align: Alignment.bottomLeft,
    );
    _PaintUtil.borderInside(canvas, size);
  }

  String _subtitleFor(VideoSimpleMireType t) {
    switch (t) {
      case VideoSimpleMireType.gridSafe:
        return 'Grille + safe + cercles';
      case VideoSimpleMireType.checkerboard:
        return 'Damier + cercles';
      case VideoSimpleMireType.colorBars:
        return 'Barres + rampes + cercles';
      case VideoSimpleMireType.uniformity:
        return 'Uniformité + cercles';
      case VideoSimpleMireType.comboAll:
        return 'Grille + safe + 2 barres centrées + cercles';
    }
  }

  void _gridSafe(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: 0.14)
      ..strokeWidth = 1;

    final minorStep = size.shortestSide / 16;
    for (double x = 0; x <= size.width; x += minorStep) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y <= size.height; y += minorStep) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final safe90 = Rect.fromLTWH(size.width * 0.05, size.height * 0.05, size.width * 0.90, size.height * 0.90);
    final safe80 = Rect.fromLTWH(size.width * 0.10, size.height * 0.10, size.width * 0.80, size.height * 0.80);

    final p1 = Paint()
      ..color = Colors.white.withValues(alpha: 0.60)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final p2 = Paint()
      ..color = Colors.white.withValues(alpha: 0.30)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(safe90, p1);
    canvas.drawRect(safe80, p2);
  }

  void _checker(Canvas canvas, Size size, {int cells = 10}) {
    final cellW = size.width / cells;
    final cellH = size.height / cells;

    for (int y = 0; y < cells; y++) {
      for (int x = 0; x < cells; x++) {
        final isDark = (x + y).isEven;
        final rect = Rect.fromLTWH(x * cellW, y * cellH, cellW, cellH);
        canvas.drawRect(rect, Paint()..color = isDark ? Colors.black : Colors.white.withValues(alpha: 0.9));
      }
    }
  }

  void _colorBars(Canvas canvas, Size size) {
    final barH = size.height * 0.66;
    final colors = <Color>[
      Colors.white,
      Colors.yellow,
      Colors.cyan,
      Colors.green,
      kMagenta,
      Colors.red,
      Colors.blue,
      Colors.black,
    ];
    final w = size.width / colors.length;

    for (int i = 0; i < colors.length; i++) {
      canvas.drawRect(Rect.fromLTWH(i * w, 0, w, barH), Paint()..color = colors[i]);
    }

    final rampRect = Rect.fromLTWH(0, barH, size.width, size.height - barH);
    final shader = ui.Gradient.linear(rampRect.topLeft, rampRect.topRight, const [Colors.black, Colors.white]);
    canvas.drawRect(rampRect, Paint()..shader = shader);
  }

  void _uniformity(Canvas canvas, Size size) {
    final w = size.width / 2;
    final h = size.height / 2;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(w, 0, w, h), Paint()..color = const Color(0xFF808080));
    canvas.drawRect(Rect.fromLTWH(0, h, w, h), Paint()..color = Colors.red);
    canvas.drawRect(Rect.fromLTWH(w, h, w, h), Paint()..color = Colors.black);
  }

  void _comboAll(Canvas canvas, Size size) {
    _gridSafe(canvas, size);
    _PaintUtil.circles(canvas, size);
    _PaintUtil.crosshair(canvas, size);

    final inset = size.shortestSide * 0.06;
    final barW = size.width - inset * 2;
    final barH = size.height * 0.14;

    final topCenterY = size.height * 0.25;
    final colorRect = Rect.fromCenter(center: Offset(size.width / 2, topCenterY), width: barW, height: barH);
    _drawColorBar(canvas, colorRect);

    final bottomCenterY = size.height * 0.75;
    final grayRect = Rect.fromCenter(center: Offset(size.width / 2, bottomCenterY), width: barW, height: barH);
    _drawGrayRamp(canvas, grayRect);

    final border = Paint()
      ..color = Colors.white.withValues(alpha: 0.50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(colorRect, border);
    canvas.drawRect(grayRect, border);
  }

  void _drawColorBar(Canvas canvas, Rect r) {
    final colors = <Color>[
      Colors.white,
      Colors.yellow,
      Colors.cyan,
      Colors.green,
      kMagenta,
      Colors.red,
      Colors.blue,
      Colors.black,
    ];
    final w = r.width / colors.length;
    for (int i = 0; i < colors.length; i++) {
      canvas.drawRect(Rect.fromLTWH(r.left + i * w, r.top, w, r.height), Paint()..color = colors[i]);
    }
  }

  void _drawGrayRamp(Canvas canvas, Rect r) {
    final shader = ui.Gradient.linear(r.topLeft, r.topRight, const [Colors.black, Colors.white]);
    canvas.drawRect(r, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant VideoSimpleMirePainter oldDelegate) {
    return oldDelegate.widthPx != widthPx || oldDelegate.heightPx != heightPx || oldDelegate.type != type;
  }
}

/// ---------------- VIDEO MAPPING ----------------
class VideoMappingMirePainter extends CustomPainter {
  VideoMappingMirePainter({
    required this.widthPx,
    required this.heightPx,
    required this.nProjectors,
    required this.overlapPercent,
    required this.orientation,
    required this.type,
  });

  final int widthPx;
  final int heightPx;
  final int nProjectors;
  final double overlapPercent;
  final MappingOrientation orientation;
  final VideoMappingMireType type;

  @override
  void paint(Canvas canvas, Size size) {
    final sr = _PaintUtil.safeRect(size);
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);

    canvas.save();
    canvas.translate(sr.left, sr.top);
    final inner = Size(sr.width, sr.height);

    final n = nProjectors.clamp(1, 64);
    final p = (overlapPercent / 100.0).clamp(0.0, 0.99);

    final total = (orientation == MappingOrientation.horizontal) ? inner.width : inner.height;
    final projSize = total / (n - (n - 1) * p);
    final overlap = projSize * p;
    final step = projSize - overlap;

    final zoneColors = <Color>[
      const Color(0xFF1E88E5),
      const Color(0xFF43A047),
      const Color(0xFFE53935),
      const Color(0xFFFDD835),
      const Color(0xFF8E24AA),
      const Color(0xFF00ACC1),
    ];

    _globalMicroGrid(canvas, inner);
    _PaintUtil.circles(canvas, inner);
    _PaintUtil.crosshair(canvas, inner);

    // Zones projo
    for (int i = 0; i < n; i++) {
      final start = i * step;
      final end = start + projSize;

      Rect zone;
      if (orientation == MappingOrientation.horizontal) {
        zone = Rect.fromLTWH(start, 0, end - start, inner.height);
      } else {
        zone = Rect.fromLTWH(0, start, inner.width, end - start);
      }

      final c = zoneColors[i % zoneColors.length].withValues(alpha: 0.18);
      canvas.drawRect(zone, Paint()..color = c);

      final border = Paint()
        ..color = Colors.white.withValues(alpha: 0.40)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(zone, border);

      _PaintUtil.circlesInRect(canvas, zone);
      _zoneGrid(canvas, zone, baseStep: inner.shortestSide / 12);

      // ✅ PROJO centré
      _PaintUtil.tag(
        canvas,
        zone,
        textValue: 'PROJO ${i + 1}',
        anchor: Alignment.center,
        maxWidthFactor: 0.75,
        fontSize: inner.shortestSide * 0.10,
      );
    }

    // Overlaps : PAS de texte, juste zone grisée
    for (int i = 0; i < n - 1; i++) {
      final oStart = (i + 1) * step;
      final oEnd = oStart + overlap;

      Rect overlapRect;
      if (orientation == MappingOrientation.horizontal) {
        overlapRect = Rect.fromLTWH(oStart, 0, oEnd - oStart, inner.height);
      } else {
        overlapRect = Rect.fromLTWH(0, oStart, inner.width, oEnd - oStart);
      }

      if (type == VideoMappingMireType.zonesAndOverlap || type == VideoMappingMireType.combo) {
        _overlapShade(canvas, overlapRect);
        _hatchLightLess(canvas, overlapRect);
      }

      if (type == VideoMappingMireType.blendRamps || type == VideoMappingMireType.combo) {
        _blendRamp(canvas, overlapRect, orientation: orientation);
      }

      final op = Paint()
        ..color = Colors.white.withValues(alpha: 0.70)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRect(overlapRect, op);
    }

    canvas.restore();

    _PaintUtil.drawInfoBadge(
      canvas,
      size,
      title: 'VIDEO / MIRE MAPPING',
      widthPx: widthPx,
      heightPx: heightPx,
      subtitle:
          'N=$n • Overlap ${overlapPercent.toStringAsFixed(1)}% • '
          '${orientation == MappingOrientation.horizontal ? "Horizontal" : "Vertical"}',
      align: Alignment.bottomLeft,
    );
    _PaintUtil.borderInside(canvas, size);
  }

  void _globalMicroGrid(Canvas canvas, Size size) {
    final step = size.shortestSide / 16;
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1;

    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  void _zoneGrid(Canvas canvas, Rect zone, {required double baseStep}) {
    final step = baseStep.clamp(14.0, 48.0);
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
      ..strokeWidth = 1;

    for (double x = zone.left; x <= zone.right; x += step) {
      canvas.drawLine(Offset(x, zone.top), Offset(x, zone.bottom), p);
    }
    for (double y = zone.top; y <= zone.bottom; y += step) {
      canvas.drawLine(Offset(zone.left, y), Offset(zone.right, y), p);
    }
  }

  void _overlapShade(Canvas canvas, Rect r) {
    canvas.drawRect(r, Paint()..color = Colors.white.withValues(alpha: 0.07));
  }

  /// Diagonales plus légères = moins “brouillon”.
  void _hatchLightLess(Canvas canvas, Rect r) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
      ..strokeWidth = 2;

    final step = (r.shortestSide / 4).clamp(40.0, 120.0); // ✅ moins dense
    for (double x = r.left - r.height; x < r.right + r.height; x += step) {
      canvas.drawLine(Offset(x, r.bottom), Offset(x + r.height, r.top), p);
    }
  }

  void _blendRamp(Canvas canvas, Rect r, {required MappingOrientation orientation}) {
    final shader = (orientation == MappingOrientation.horizontal)
        ? ui.Gradient.linear(
            r.topLeft,
            r.topRight,
            [Colors.white.withValues(alpha: 0.82), Colors.black.withValues(alpha: 0.82)],
          )
        : ui.Gradient.linear(
            r.topLeft,
            r.bottomLeft,
            [Colors.white.withValues(alpha: 0.82), Colors.black.withValues(alpha: 0.82)],
          );

    canvas.drawRect(r.deflate(6), Paint()..shader = shader);

    final tt = _PaintUtil.text('BLEND', size: r.shortestSide * 0.18, color: Colors.white.withValues(alpha: 0.9));
    tt.paint(canvas, Offset(r.left + 12, r.bottom - tt.height - 12));
  }

  @override
  bool shouldRepaint(covariant VideoMappingMirePainter oldDelegate) {
    return oldDelegate.widthPx != widthPx ||
        oldDelegate.heightPx != heightPx ||
        oldDelegate.nProjectors != nProjectors ||
        oldDelegate.overlapPercent != overlapPercent ||
        oldDelegate.orientation != orientation ||
        oldDelegate.type != type;
  }
}

/// ---------------- LED ----------------
class LedMirePainter extends CustomPainter {
  LedMirePainter({
    required this.widthPx,
    required this.heightPx,
    required this.type,
    this.tileWpx,
    this.tileHpx,
    this.tileWcm,
    this.tileHcm,
    this.tilesX,
    this.tilesY,
  });

  final int widthPx;
  final int heightPx;
  final LedMireType type;

  final int? tileWpx;
  final int? tileHpx;

  final double? tileWcm;
  final double? tileHcm;

  final int? tilesX;
  final int? tilesY;


  @override
  void paint(Canvas canvas, Size size) {
    final sr = _PaintUtil.safeRect(size);

    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.black);
    canvas.save();
    canvas.translate(sr.left, sr.top);
    final inner = Size(sr.width, sr.height);

    switch (type) {
      case LedMireType.pixelPerfect:
        _pixelPerfect(canvas, inner);
        _PaintUtil.circles(canvas, inner);
        _PaintUtil.crosshair(canvas, inner);
        break;

      case LedMireType.gridLabels:
        _gridLabels(canvas, inner);
        _PaintUtil.circles(canvas, inner);
        _PaintUtil.crosshair(canvas, inner);
        break;

      case LedMireType.colorBars:
        _colorBars(canvas, inner);
        _PaintUtil.circles(canvas, inner);
        _PaintUtil.crosshair(canvas, inner);
        break;

      case LedMireType.uniformity:
        _uniformity(canvas, inner);
        _PaintUtil.circles(canvas, inner);
        _PaintUtil.crosshair(canvas, inner);
        break;

      case LedMireType.tilesId:
        _tilesId(canvas, inner);
        _PaintUtil.circles(canvas, inner);
        _PaintUtil.crosshair(canvas, inner);
        break;
    }

    canvas.restore();

    _PaintUtil.drawInfoBadge(
      canvas,
      size,
      title: type == LedMireType.tilesId ? 'LED / TILES ID' : 'LED / MIRE',
      widthPx: widthPx,
      heightPx: heightPx,
      subtitle: type == LedMireType.tilesId ? _tilesSubtitle() : _subtitleFor(type),
      align: Alignment.bottomLeft,
    );

    _PaintUtil.borderInside(canvas, size);
  }

  String _subtitleFor(LedMireType t) {
    switch (t) {
      case LedMireType.pixelPerfect:
        return 'Pixel perfect + cercles';
      case LedMireType.gridLabels:
        return 'Grille + repères + cercles';
      case LedMireType.colorBars:
        return 'Barres + rampes + cercles';
      case LedMireType.uniformity:
        return 'Uniformité + cercles';
      case LedMireType.tilesId:
        return _tilesSubtitle();
    }
  }

  String _tilesSubtitle() {
  final tw = tileWpx ?? 0;
  final th = tileHpx ?? 0;

  if (tw <= 0 || th <= 0) return 'Renseigne Tile (px) pour numérotation.';

  final nx = tilesX ?? (widthPx ~/ tw);
  final ny = tilesY ?? (heightPx ~/ th);

  String tilePhys = '';
  String pitchStr = '';
  String wallPhys = '';

  if ((tileWcm ?? 0) > 0 && (tileHcm ?? 0) > 0) {
    final px = (tileWcm! * 10.0) / tw;
    final py = (tileHcm! * 10.0) / th;

    if ((px - py).abs() <= 0.05) {
      pitchStr = 'Pitch ~ ${((px + py) / 2).toStringAsFixed(2)} mm';
    } else {
      pitchStr = 'Pitch X ${px.toStringAsFixed(2)} • Y ${py.toStringAsFixed(2)} mm';
    }

    tilePhys = 'Tile ${tileWcm!.toStringAsFixed(2)}×${tileHcm!.toStringAsFixed(2)} cm';

    final wallWm = (nx * tileWcm!) / 100.0;
    final wallHm = (ny * tileHcm!) / 100.0;
    wallPhys = 'Mur ~ ${wallWm.toStringAsFixed(2)}×${wallHm.toStringAsFixed(2)} m';
  }

  final base = 'Tile ${tw}x$th px • Grille $nx x $ny';
  final extras = [tilePhys, pitchStr, wallPhys].where((e) => e.trim().isNotEmpty).join(' • ');

  return extras.isEmpty ? base : '$base • $extras';
}


  void _pixelPerfect(Canvas canvas, Size size) {
    final p1 = Paint()..color = Colors.white.withValues(alpha: 0.85);
    final p2 = Paint()..color = Colors.black;

    final step = (size.width / 320).clamp(1.0, 3.0);
    bool white = true;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawRect(Rect.fromLTWH(x, 0, step, size.height * 0.5), white ? p1 : p2);
      white = !white;
    }

    final top = size.height * 0.5;
    const cells = 16;
    final cw = size.width / cells;
    final ch = (size.height * 0.5) / cells;
    for (int y = 0; y < cells; y++) {
      for (int x = 0; x < cells; x++) {
        final isDark = (x + y).isEven;
        canvas.drawRect(
          Rect.fromLTWH(x * cw, top + y * ch, cw, ch),
          Paint()..color = isDark ? Colors.black : Colors.white.withValues(alpha: 0.9),
        );
      }
    }
  }

  void _gridLabels(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: 0.14)
      ..strokeWidth = 1;

    final step = size.shortestSide / 12;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
  }

  void _colorBars(Canvas canvas, Size size) {
    final barH = size.height * 0.66;
    final colors = <Color>[
      Colors.white,
      Colors.yellow,
      Colors.cyan,
      Colors.green,
      kMagenta,
      Colors.red,
      Colors.blue,
      Colors.black,
    ];
    final w = size.width / colors.length;

    for (int i = 0; i < colors.length; i++) {
      canvas.drawRect(Rect.fromLTWH(i * w, 0, w, barH), Paint()..color = colors[i]);
    }

    final rampRect = Rect.fromLTWH(0, barH, size.width, size.height - barH);
    final shader = ui.Gradient.linear(rampRect.topLeft, rampRect.topRight, const [Colors.black, Colors.white]);
    canvas.drawRect(rampRect, Paint()..shader = shader);
  }

  void _uniformity(Canvas canvas, Size size) {
    final w = size.width / 2;
    final h = size.height / 2;

    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), Paint()..color = Colors.white);
    canvas.drawRect(Rect.fromLTWH(w, 0, w, h), Paint()..color = const Color(0xFF808080));
    canvas.drawRect(Rect.fromLTWH(0, h, w, h), Paint()..color = Colors.red);
    canvas.drawRect(Rect.fromLTWH(w, h, w, h), Paint()..color = Colors.black);
  }

  void _tilesId(Canvas canvas, Size size) {
    final tw = tileWpx ?? 0;
    final th = tileHpx ?? 0;

    if (tw <= 0 || th <= 0) {
      _gridLabels(canvas, size);
      final t = _PaintUtil.text('Tile (px) manquant', size: size.shortestSide * 0.05, color: Colors.redAccent);
      t.paint(canvas, Offset(size.width * 0.05, size.height * 0.45));
      return;
    }

    final okW = (widthPx % tw) == 0;
    final okH = (heightPx % th) == 0;

    // ✅ tiles entières seulement (pas de tile coupée)
    final nx = widthPx ~/ tw;
    final ny = heightPx ~/ th;

    if (!okW || !okH) {
      _PaintUtil.warningTag(
        canvas,
        Rect.fromLTWH(0, 0, size.width, size.height),
        'MUR NON MULTIPLE DE TILES',
      );
    }

    double pxToCanvasX(double px) => (px / widthPx) * size.width;
    double pxToCanvasY(double px) => (px / heightPx) * size.height;

    final tileColors = <Color>[
      const Color(0xFF1E88E5),
      const Color(0xFF43A047),
      const Color(0xFFE53935),
      const Color(0xFFFDD835),
      const Color(0xFF8E24AA),
      const Color(0xFF00ACC1),
    ];

    final border = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int y = 0; y < ny; y++) {
      for (int x = 0; x < nx; x++) {
        final leftPx = x * tw;
        final topPx = y * th;
        final rightPx = (x + 1) * tw;
        final bottomPx = (y + 1) * th;

        final rect = Rect.fromLTRB(
          pxToCanvasX(leftPx.toDouble()),
          pxToCanvasY(topPx.toDouble()),
          pxToCanvasX(rightPx.toDouble()),
          pxToCanvasY(bottomPx.toDouble()),
        );

        final c = tileColors[(x + y) % tileColors.length].withValues(alpha: 0.20);
        canvas.drawRect(rect, Paint()..color = c);
        canvas.drawRect(rect, border);

        final id = y * nx + x + 1;

        final label = _PaintUtil.text(
          'T$id',
          size: math.max(12, rect.shortestSide * 0.18),
          weight: FontWeight.w800,
          color: Colors.white.withValues(alpha: 0.92),
        );
        label.paint(canvas, Offset(rect.left + 10, rect.top + 10));

        final sub = _PaintUtil.text(
          '$x,$y',
          size: math.max(10, rect.shortestSide * 0.12),
          weight: FontWeight.w700,
          color: Colors.white70,
        );
        sub.paint(canvas, Offset(rect.left + 10, rect.top + 10 + label.height + 2));
      }
    }
  }

  @override
  bool shouldRepaint(covariant LedMirePainter oldDelegate) {
    return oldDelegate.widthPx != widthPx ||
    oldDelegate.heightPx != heightPx ||
    oldDelegate.type != type ||
    oldDelegate.tileWpx != tileWpx ||
    oldDelegate.tileHpx != tileHpx ||
    oldDelegate.tileWcm != tileWcm ||
    oldDelegate.tileHcm != tileHcm ||
    oldDelegate.tilesX != tilesX ||
    oldDelegate.tilesY != tilesY;
  }
}
