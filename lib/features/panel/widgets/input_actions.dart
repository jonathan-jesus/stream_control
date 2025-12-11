import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_control/features/panel/models/switcher_button_colors.dart';
import 'package:stream_control/features/panel/widgets/switcher_button.dart';
import 'package:stream_control/features/panel/widgets/sections/components/section_card.dart';
import 'package:stream_control/features/vmix/state/vmix_provider.dart';

class InputActions extends ConsumerWidget {
  const InputActions({
    required this.inputNumber,
    super.key,
  });

  final int inputNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vmix = ref.watch(vmixProvider);
    final vmixNotifier = ref.read(vmixProvider.notifier);
    final project = vmix.project!;
    final input = project.inputs.where((i) => i.number == inputNumber).first;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        spacing: 10,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${input.number.toString().padLeft(2, "0")}-${input.title}'),
          IntrinsicWidth(
            child: IntrinsicHeight(
              child: SectionCard(
                title: 'ASSIGN TO OVERLAY',
                centerTitle: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                      for (int i = 0; i < 4; i++)
                        SwitcherButton(
                          width: 80,
                          height: 80,
                          isRectangleVariant: true,
                          color: project.overlays[i].input.isEmpty
                              ? SwitcherButtonColors.white
                              : SwitcherButtonColors.orange,
                          label: (i + 1).toString().padLeft(2, "0"),
                          isActive: project.overlays[i].input == '$inputNumber',
                          onTap: () {
                            if (project.overlays[i].input == '$inputNumber') {
                              vmixNotifier
                                  .sendCommand("OverlayInput${i + 1}Out");
                            } else {
                              vmixNotifier.sendCommand("OverlayInput${i + 1}In",
                                  input: '$inputNumber');
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
