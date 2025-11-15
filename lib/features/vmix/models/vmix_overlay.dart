import 'package:xml/xml.dart';

class VmixOverlay {
  final int number;
  final String input;

  VmixOverlay({required this.number, required this.input});

  factory VmixOverlay.fromXml(XmlElement e) {
    return VmixOverlay(
      number: int.tryParse(e.getAttribute('number') ?? '') ?? 0,
      input: e.innerText,
    );
  }
}
