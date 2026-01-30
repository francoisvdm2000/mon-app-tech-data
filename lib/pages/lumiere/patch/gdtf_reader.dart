import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

/// Lecteur GDTF minimal :
/// - ouvre un .gdtf (ZIP)
/// - lit description.xml
/// - cherche un DMXMode par nom
/// - retourne le nombre de DMXChannel de ce mode
class GdtfReader {
  final Map<String, int> _footprintCache = <String, int>{};

  int? footprintForMode({
    required Uint8List gdtfBytes,
    required String modeName,
  }) {
    final mode = modeName.trim();
    if (mode.isEmpty) return null;

    final cacheKey = '${gdtfBytes.lengthInBytes}::$mode'.toLowerCase();
    final cached = _footprintCache[cacheKey];
    if (cached != null) return cached;

    final xml = _extractDescriptionXml(gdtfBytes);
    if (xml == null || xml.trim().isEmpty) return null;

    try {
      final doc = XmlDocument.parse(xml);

      // DMXModes/DMXMode
      final modes = doc.descendants.whereType<XmlElement>().where((e) {
        return e.name.local.toLowerCase() == 'dmxmode';
      }).toList();

      if (modes.isEmpty) return null;

      XmlElement? selected;

      // 1) match Name exact (case-insensitive)
      for (final m in modes) {
        final n = m.getAttribute('Name') ?? m.getAttribute('name') ?? '';
        if (n.trim().toLowerCase() == mode.toLowerCase()) {
          selected = m;
          break;
        }
      }

      // 2) fallback : match partiel (si le MVR donne "Mode 26" et GDTF "Mode 26ch")
      selected ??= modes.firstWhere(
        (m) {
          final n = (m.getAttribute('Name') ?? m.getAttribute('name') ?? '').trim();
          if (n.isEmpty) return false;
          final nl = n.toLowerCase();
          final ml = mode.toLowerCase();
          return nl.contains(ml) || ml.contains(nl);
        },
        orElse: () => modes.first,
      );

      final footprint = _countDmxChannels(selected);
      if (footprint == null || footprint < 1) return null;

      _footprintCache[cacheKey] = footprint;
      return footprint;
    } catch (_) {
      return null;
    }
  }

  String? _extractDescriptionXml(Uint8List gdtfBytes) {
    try {
      final archive = ZipDecoder().decodeBytes(gdtfBytes, verify: true);

      ArchiveFile? best;

      // description.xml est le fichier principal dans un GDTF
      for (final f in archive.files) {
        if (!f.isFile) continue;
        final name = f.name.toLowerCase();
        if (name == 'description.xml' || name.endsWith('/description.xml')) {
          best = f;
          break;
        }
      }

      // fallback : premier .xml trouvé
      best ??= archive.files.cast<ArchiveFile?>().firstWhere(
            (f) => f != null && f.isFile && f.name.toLowerCase().endsWith('.xml'),
            orElse: () => null,
          );

      if (best == null) return null;
      final content = best.content;
      if (content is! List<int>) return null;

      return utf8.decode(content, allowMalformed: true);
    } catch (_) {
      return null;
    }
  }

  int? _countDmxChannels(XmlElement dmxModeElement) {
    // Dans un GDTF : DMXMode -> DMXChannels -> DMXChannel*
    final channelsContainers = dmxModeElement.findElements('DMXChannels');
    if (channelsContainers.isEmpty) {
      // Certains GDTF peuvent être en namespaces : on tente une recherche globale locale-name
      final container = dmxModeElement.descendants.whereType<XmlElement>().firstWhere(
            (e) => e.name.local.toLowerCase() == 'dmxchannels',
            orElse: () => dmxModeElement,
          );
      return _countDmxChannelChildren(container);
    }

    return _countDmxChannelChildren(channelsContainers.first);
  }

  int? _countDmxChannelChildren(XmlElement container) {
    int count = 0;

    // Compte les éléments DMXChannel (local-name insensitive)
    for (final e in container.descendants.whereType<XmlElement>()) {
      if (e.name.local.toLowerCase() == 'dmxchannel') {
        count++;
      }
    }

    return count >= 1 ? count : null;
  }
}
