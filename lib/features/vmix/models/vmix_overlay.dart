import 'package:xml/xml.dart';

class VmixOverlay {
  final int number;
  final String input;

  VmixOverlay({required this.number, required this.input});

  factory VmixOverlay.fromXml(XmlElement element) {
    final numberAttr = element.getAttribute('number');
    if (numberAttr == null) {
      throw const FormatException('Missing overlay number attribute');
    }

    final number = int.parse(numberAttr);
    return VmixOverlay(
      number: number,
      input: element.innerText,
    );
  }
}
