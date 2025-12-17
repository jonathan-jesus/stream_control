import 'package:xml/xml.dart';

class VmixInput {
  final String key;
  final int number;
  final String title;
  final String shortTitle;
  final String type;
  final String state;

  VmixInput({
    required this.key,
    required this.number,
    required this.title,
    required this.shortTitle,
    required this.type,
    required this.state,
  });

  factory VmixInput.fromXml(XmlElement element) {
    final numberAttr = element.getAttribute('number');
    if (numberAttr == null) {
      throw const FormatException('Missing input number attribute');
    }

    final number = int.parse(numberAttr);
    return VmixInput(
      key: element.getAttribute('key') ?? '',
      number: number,
      title: element.getAttribute('title') ?? '',
      shortTitle: element.getAttribute('shortTitle') ?? '',
      type: element.getAttribute('type') ?? '',
      state: element.getAttribute('state') ?? '',
    );
  }
}
