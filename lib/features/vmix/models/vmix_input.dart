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
    return VmixInput(
      key: element.getAttribute('key') ?? '',
      number: int.tryParse(element.getAttribute('number') ?? '') ?? 0,
      title: element.getAttribute('title') ?? '',
      shortTitle: element.getAttribute('shortTitle') ?? '',
      type: element.getAttribute('type') ?? '',
      state: element.getAttribute('state') ?? '',
    );
  }
}
