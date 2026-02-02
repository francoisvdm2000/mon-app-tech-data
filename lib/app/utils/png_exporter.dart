import 'dart:typed_data';

export 'png_exporter.dart' if (dart.library.html) 'png_exporter_web.dart' if (dart.library.io) 'png_exporter_io.dart';

/// API unique (web + mobile/desktop).
Future<void> exportPngBytes(Uint8List bytes, String filename) async {
  // La vraie impl est fournie par les fichiers exportés conditionnellement.
  // Cette version ne devrait jamais être appelée.
  throw UnsupportedError('exportPngBytes: plateforme non supportée');
}
