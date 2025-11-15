import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_control/features/panel/widgets/switcher_button.dart';
import 'package:stream_control/features/panel/widgets/sections/components/section_card.dart';
import 'package:stream_control/features/vmix/models/vmix_overlay.dart';
import 'package:stream_control/features/vmix/state/vmix_provider.dart';

class OverlayChannelSection extends ConsumerWidget {
  const OverlayChannelSection({
    this.spacing = 20,
    this.width = 100,
    this.centerTitle = false,
    this.use8channels = false,
    super.key,
  });

  final bool centerTitle;
  final bool use8channels;
  final double spacing;
  final double width;

  @override
  Widget build(BuildContext contex, WidgetRef ref) {
    final vmix = ref.watch(vmixProvider);
    final vmixNotifier = ref.watch(vmixProvider.notifier);
    final project = vmix.project;
    List<VmixOverlay> overlays = project?.overlays ?? [];

    if (use8channels) {
      return SectionCard(
        title: 'OVERLAY CHANNELS',
        centerTitle: centerTitle,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: spacing,
            children: [
              for (int i = 0; i < 8; i++)
                SwitcherButton(
                  width: width,
                  isRectangleVariant: true,
                  label: (i + 1).toString().padLeft(2, "0"),
                  isActive: overlays[i].input.isNotEmpty,
                  onTap: () {
                    if (overlays[i].input.isNotEmpty) {
                      vmixNotifier
                          .sendCommand("OverlayInput${overlays[i].number}Out");
                    } else {
                      vmixNotifier
                          .sendCommand("OverlayInput${overlays[i].number}In");
                    }
                  },
                ),
            ],
          ),
        ),
      );
    }
    return SectionCard(
      title: 'OVERLAY CHANNELS',
      centerTitle: centerTitle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (int i = 0; i < 4; i++)
            SwitcherButton(
              width: width,
              isRectangleVariant: true,
              label: (i + 1).toString().padLeft(2, "0"),
              isActive: overlays[i].input.isNotEmpty,
              onTap: () {
                if (overlays[i].input.isNotEmpty) {
                  vmixNotifier
                      .sendCommand("OverlayInput${overlays[i].number}Out");
                } else {
                  vmixNotifier
                      .sendCommand("OverlayInput${overlays[i].number}In");
                }
              },
            ),
        ],
      ),
    );
  }
}
