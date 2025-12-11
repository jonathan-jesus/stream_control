import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_control/features/panel/widgets/switcher_button.dart';
import 'package:stream_control/features/panel/widgets/sections/components/section_card.dart';
import 'package:stream_control/features/vmix/state/vmix_provider.dart';

class StreamActions extends ConsumerWidget {
  const StreamActions({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vmix = ref.watch(vmixProvider);
    final vmixNotifier = ref.read(vmixProvider.notifier);
    final project = vmix.project!;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicWidth(
            child: IntrinsicHeight(
              child: SectionCard(
                title: 'STREAM',
                centerTitle: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      for (int i = 0; i < 5; i++)
                        SwitcherButton(
                          width: 80,
                          height: 80,
                          isRectangleVariant: true,
                          label: (i + 1).toString().padLeft(2, "0"),
                          isActive: project.streaming.channels[i + 1] == true,
                          onTap: () {
                            if (project.streaming.channels[i + 1] == true) {
                              vmixNotifier.sendCommand("StopStreaming",
                                  value: '$i');
                            } else {
                              vmixNotifier.sendCommand("StartStreaming",
                                  value: '$i');
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
