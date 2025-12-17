import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_control/features/panel/models/switcher_button_colors.dart';
import 'package:stream_control/features/panel/widgets/switcher_button.dart';
import 'package:stream_control/features/panel/widgets/sections/components/section_card.dart';
import 'package:stream_control/features/vmix/state/vmix_provider.dart';

class TransitionSection extends ConsumerWidget {
  const TransitionSection({
    super.key,
    required this.axis,
    this.buttonsWidth = 180,
    this.buttonsHeight = 100,
    this.spacing = 0,
  });

  final Axis axis;
  final double buttonsWidth;
  final double buttonsHeight;
  final double spacing;

  Widget _buildButton(
      {required String label,
      required VoidCallback onTap,
      bool isActive = false}) {
    return SwitcherButton(
      label: label,
      colorActive: SwitcherButtonColors.red,
      isActive: isActive,
      isRectangleVariant: true,
      width: buttonsWidth,
      height: buttonsHeight,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vmix = ref.watch(vmixProvider);
    final vmixNotifier = ref.read(vmixProvider.notifier);

    sendTrasitionCommand(String function) => vmixNotifier.sendCommand(function);

    var buttons = <Widget>[
      _buildButton(
        label: "Cut",
        onTap: () => sendTrasitionCommand('Cut'),
      ),
      _buildButton(
        label: "Fade",
        onTap: () => sendTrasitionCommand('Fade'),
      ),
      _buildButton(
        label: "FTB",
        isActive: vmix.project!.fadeToBlack,
        onTap: () => sendTrasitionCommand('FadeToBlack'),
      )
    ];

    return SectionCard(
      title: 'TRANSITION',
      centerTitle: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (axis == Axis.vertical) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: spacing,
              children: buttons,
            );
          } else {
            return Row(
              spacing: spacing,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buttons,
            );
          }
        },
      ),
    );
  }
}
