import 'package:xml/xml.dart';

class VmixStreaming {
  final bool isStreaming;
  final Map<int, bool> channels;

  const VmixStreaming({
    required this.isStreaming,
    required this.channels,
  });

  factory VmixStreaming.fromXml(XmlElement element) {
    final isStreaming = element.innerText.toLowerCase() == 'true';

    final channels = <int, bool>{};
    for (var i = 1; i <= 5; i++) {
      final hasAttr = element.getAttribute('channel$i') != null;
      channels[i] = hasAttr;
    }

    return VmixStreaming(isStreaming: isStreaming, channels: channels);
  }

  @override
  String toString() => 'Streaming(active: $isStreaming, channels: $channels)';
}
