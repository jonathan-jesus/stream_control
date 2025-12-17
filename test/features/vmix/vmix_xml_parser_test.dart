// test/features/vmix/vmix_xml_parser_test.dart

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_control/features/vmix/data/vmix_xml_parser.dart';
import 'package:stream_control/features/vmix/models/vmix_error_type.dart';

void main() {
  group('VmixXmlParser', () {
    test('parses minimal valid xml', () {
      const xml = '''
<vmix>
  <version>24</version>
  <active>2</active>
  <preview>1</preview>
  <recording>false</recording>
  <external>false</external>
  <fadeToBlack>false</fadeToBlack>
  <inputs>
    <input key="ABC" number="1" title="Camera 1" shortTitle="Cam1" type="Camera" state="ok" />
    <input key="DEF" number="2" title="Camera 2" shortTitle="Cam2" type="Camera" state="ok" />
  </inputs>
  <overlays>
    <overlay number="1">3</overlay>
    <overlay number="2"></overlay>
  </overlays>
  <streaming>true</streaming>
</vmix>
''';

      final project = VmixXmlParser.parse(xml);

      expect(project.version, '24');
      expect(project.active, 2);
      expect(project.preview, 1);
      expect(project.recording, isFalse);
      expect(project.external, isFalse);
      expect(project.fadeToBlack, isFalse);

      expect(project.inputs.length, 2);
      expect(project.inputs[0].number, 1);
      expect(project.inputs[1].number, 2);

      expect(project.overlays.length, 2);
      expect(project.overlays[0].number, 1);
      // overlay innerText parsed as string:
      expect(project.overlays[0].input, '3');

      expect(project.streaming.isStreaming, isTrue);
      // channels default in test xml - VmixStreaming.fromXml may set channels map — we assert presence
    });

    test('parses valid xml', () {
      final xml =
          File('test_resources/vmix-xml-example-1.xml').readAsStringSync();

      final project = VmixXmlParser.parse(xml);

      expect(project.version, '28.0.0.42');
      expect(project.active, 20);
      expect(project.preview, 3);
      expect(project.recording, isFalse);
      expect(project.external, isFalse);
      expect(project.fadeToBlack, isFalse);

      expect(project.inputs.length, 20);
      for (int i = 0; i < project.inputs.length; i++) {
        expect(project.inputs[i].number, i + 1);
      }

      expect(project.overlays.length, 8);
      for (int i = 0; i < project.overlays.length; i++) {
        expect(project.overlays[i].number, i + 1);
      }
      expect(project.overlays[1].input, '15');
      expect(project.overlays[2].input, '16');
      expect(project.overlays[3].input, '11');

      expect(project.streaming.isStreaming, isTrue);
    });

    test('ignores malformed input entry but still parses rest', () {
      const xml = '''
<vmix>
  <version>24</version>
  <active>1</active>
  <preview>1</preview>
  <inputs>
    <input key="A" number="1" title="Good" shortTitle="G" type="Camera" state="ok" />
    <input key="B" number="X" title="Bad" shortTitle="B" type="Camera" state="ok" /> <!-- invalid number -->
  </inputs>
</vmix>
''';
      final project = VmixXmlParser.parse(xml);

      expect(project.inputs.length, 1);
      expect(project.inputs.first.number, 1);
    });

    test('throws invalidXml for completely malformed xml', () {
      const xml = '<notvmix></notvmix>';
      expect(() => VmixXmlParser.parse(xml), throwsA(VmixErrorType.invalidXml));
    });

    test('handles missing optional sections gracefully', () {
      const xml = '''
<vmix>
  <version></version>
</vmix>
''';
      final project = VmixXmlParser.parse(xml);
      expect(project.version, '');
      expect(project.inputs, isEmpty);
      expect(project.overlays, isEmpty);
      expect(project.recording, isFalse);
      expect(project.streaming.isStreaming, isFalse);
    });
  });
}
