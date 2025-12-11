import 'package:xml/xml.dart';
import 'package:stream_control/features/vmix/models/vmix_error_type.dart';
import 'package:stream_control/features/vmix/models/vmix_input.dart';
import 'package:stream_control/features/vmix/models/vmix_overlay.dart';
import 'package:stream_control/features/vmix/models/vmix_streaming.dart';
import 'package:stream_control/features/vmix/models/vmix_project.dart';

/// Defensive parser for vMix XML returned by the vMix HTTP API.
class VmixXmlParser {
  /// Parse the full xml string into a [VmixProject].
  /// Throws [VmixErrorType.invalidXml] on malformed or unexpected xml.
  static VmixProject parse(String xml) {
    try {
      final document = XmlDocument.parse(xml);
      final root = document.getElement('vmix');
      if (root == null) {
        throw VmixErrorType.invalidXml;
      }

      // Inputs: find all <input .../> elements
      final inputs = root
          .findAllElements('input')
          .map((e) {
            try {
              return VmixInput.fromXml(e);
            } catch (_) {
              // If an input fails to parse, skip it (defensive)
              return null;
            }
          })
          .where((e) => e != null)
          .cast<VmixInput>()
          .toList()
        ..sort((a, b) => a.number.compareTo(b.number));

      // Overlays: <overlays><overlay ...>innerText</overlay>...</overlays>
      final overlays = <VmixOverlay>[];
      try {
        final overlaysContainers = root.findAllElements('overlays');
        for (final oc in overlaysContainers) {
          for (final oe in oc.findElements('overlay')) {
            try {
              overlays.add(VmixOverlay.fromXml(oe));
            } catch (_) {
              // skip malformed overlay entry
            }
          }
        }
      } catch (_) {
        // ignore, overlays will be empty
      }

      // streaming: optional - attempt to build VmixStreaming
      VmixStreaming streaming;
      final streamingElement = root.getElement('streaming');
      if (streamingElement != null) {
        // Reuse your existing VmixStreaming.fromXml but be defensive:
        try {
          streaming = VmixStreaming.fromXml(streamingElement);
        } catch (_) {
          // fallback
          streaming = const VmixStreaming(isStreaming: false, channels: {});
        }
      } else {
        streaming = const VmixStreaming(isStreaming: false, channels: {});
      }

      // Parse simple values (defensive)
      final version = root.getElement('version')?.innerText ?? '';
      final active = _parseInt(root.getElement('active')?.innerText);
      final preview = _parseInt(root.getElement('preview')?.innerText);

      final recording = _parseBool(root.getElement('recording')?.innerText);
      final external = _parseBool(root.getElement('external')?.innerText);
      final fadeToBlack = _parseBool(root.getElement('fadeToBlack')?.innerText);

      return VmixProject(
        version: version,
        active: active,
        preview: preview,
        inputs: inputs,
        overlays: overlays,
        recording: recording,
        external: external,
        streaming: streaming,
        fadeToBlack: fadeToBlack,
      );
    } on XmlParserException {
      throw VmixErrorType.invalidXml;
    } on VmixErrorType {
      rethrow;
    } catch (_) {
      throw VmixErrorType.invalidXml;
    }
  }

  // Helper parsing functions
  static int _parseInt(String? s) => int.tryParse(s ?? '') ?? 0;

  static bool _parseBool(String? s) {
    if (s == null) return false;
    final v = s.trim().toLowerCase();
    return v == 'true' || v == '1';
  }
}
