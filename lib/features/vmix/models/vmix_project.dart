import 'package:stream_control/features/vmix/models/vmix_input.dart';
import 'package:stream_control/features/vmix/models/vmix_overlay.dart';
import 'package:stream_control/features/vmix/models/vmix_streaming.dart';

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
}
