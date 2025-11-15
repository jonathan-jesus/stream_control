import 'package:stream_control/features/vmix/models/vmix_error_type.dart';
import 'package:stream_control/features/vmix/models/vmix_input.dart';
import 'package:stream_control/features/vmix/models/vmix_overlay.dart';
import 'package:stream_control/features/vmix/models/vmix_streaming.dart';
import 'package:xml/xml.dart';

class VmixProject {
  final String version;
  final int active;
  final int preview;
  final List<VmixInput> inputs;
  final List<VmixOverlay> overlays;
  final bool recording;
  final bool external;
  final VmixStreaming streaming;
  // final bool playlist;
  // final bool multicorder;
  // final bool fullscreen;
  final bool fadeToBlack;

  VmixProject({
    required this.version,
    required this.active,
    required this.preview,
    required this.inputs,
    required this.overlays,
    required this.recording,
    required this.external,
    required this.streaming,
    required this.fadeToBlack,
  });

  factory VmixProject.fromXmlString(String xml) {
    final doc = XmlDocument.parse(xml);
    final root = doc.getElement('vmix');
    if (root == null) {
      throw VmixErrorType.invalidXml;
    }

    final inputs =
        root.findAllElements('input').map(VmixInput.fromXml).toList();

    final overlays = root
        .findAllElements('overlays')
        .expand((e) => e.findElements('overlay'))
        .map(VmixOverlay.fromXml)
        .toList();

    int parseBool(String? value) => (value?.toLowerCase() == 'true') ? 1 : 0;

    final streamingElement = root.getElement('streaming');

    return VmixProject(
      version: root.getElement('version')?.innerText ?? '',
      active: int.tryParse(root.getElement('active')?.innerText ?? '') ?? 0,
      preview: int.tryParse(root.getElement('preview')?.innerText ?? '') ?? 0,
      inputs: inputs,
      overlays: overlays,
      recording: parseBool(root.getElement('recording')?.innerText) == 1,
      external: parseBool(root.getElement('external')?.innerText) == 1,
      streaming: streamingElement != null
          ? VmixStreaming.fromXml(streamingElement)
          : const VmixStreaming(isStreaming: false, channels: {}),
      fadeToBlack: parseBool(root.getElement('fadeToBlack')?.innerText) == 1,
    );
  }
}
