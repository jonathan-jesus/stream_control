import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_control/features/panel/models/switcher_button_colors.dart';
import 'package:stream_control/features/panel/widgets/stream_actions.dart';
import 'package:stream_control/features/panel/widgets/switcher_button.dart';
import 'package:stream_control/features/panel/widgets/sections/components/section_card.dart';
import 'package:stream_control/features/vmix/state/vmix_provider.dart';

class OutputsSection extends ConsumerWidget {
  const OutputsSection({
    super.key,
    this.centerTitle = false,
    this.width = 180,
  });

  final double? width;
  final bool centerTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vmix = ref.watch(vmixProvider);
    final vmixNotifier = ref.watch(vmixProvider.notifier);
    final project = vmix.project;
    var isRectangle = true;

    handleStreamOptionsPressed() {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => const Dialog(
          // backgroundColor: Colors.black,
          child: StreamActions(),
        ),
      );
    }

    return SectionCard(
      title: 'OUTPUTS',
      centerTitle: centerTitle,
      child: Row(
        spacing: 20,
        children: [
          Flexible(
            child: SwitcherButton(
              label: "Record",
              isActive: project?.recording == true,
              isRectangleVariant: isRectangle,
              colorActive: SwitcherButtonColors.red,
              width: width,
              onTap: () {
                if (vmix.uri != null) {
                  vmixNotifier.sendCommand(vmix.project?.recording == true
                      ? "StopRecording"
                      : "StartRecording");
                }
              },
            ),
          ),
          Flexible(
            child: SwitcherButton(
              label: "External",
              isActive: project?.external == true,
              isRectangleVariant: isRectangle,
              colorActive: SwitcherButtonColors.red,
              width: width,
              onTap: () {
                if (vmix.uri != null) {
                  vmixNotifier.sendCommand(vmix.project?.recording == true
                      ? "StopExternal"
                      : "StartExternal");
                }
              },
            ),
          ),
          Flexible(
            child: SwitcherButton(
              label: "Stream",
              isActive: project?.streaming.isStreaming == true,
              isRectangleVariant: isRectangle,
              colorActive: SwitcherButtonColors.red,
              width: width,
              onTap: () {
                if (vmix.uri != null) {
                  vmixNotifier.sendCommand(
                      vmix.project?.streaming.isStreaming == true
                          ? "StopStreaming"
                          : "StartStreaming");
                }
              },
              onLongPress: handleStreamOptionsPressed,
            ),
          ),
        ],
      ),
    );
  }
}
