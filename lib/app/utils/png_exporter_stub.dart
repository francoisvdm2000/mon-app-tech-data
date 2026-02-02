import 'dart:typed_data';

Future<void> exportPngBytes(Uint8List bytes, String filename) async {
  // Plateforme non supportée (rare)
  throw UnsupportedError('PNG export not supported on this platform');
}
