import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_control/core/utils/device_type.dart';
import 'package:stream_control/features/panel/widgets/input_actions.dart';
import 'package:stream_control/features/panel/models/switcher_button_colors.dart';
import 'package:stream_control/features/panel/widgets/switcher_button.dart';
import 'package:stream_control/features/panel/widgets/sections/components/section_card.dart';
import 'package:stream_control/features/vmix/state/vmix_provider.dart';

class InputsSection extends ConsumerWidget {
  final bool centerTitle;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  const InputsSection({
    super.key,
    this.centerTitle = false,
    this.crossAxisSpacing = 15,
    this.mainAxisSpacing = 15,
  });

  int _columnsForWidth(double w, BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final deviceType = getDeviceType(context);
    int offset = deviceType == DeviceType.tablet ? 0 : 1;
    offset +=
        deviceType == DeviceType.phone && orientation == Orientation.landscape
            ? 3
            : 0;
    if (w >= 1200) return 10 + offset;
    if (w >= 900) return 8 + offset;
    if (w >= 700) return 6 + offset;
    return 4 + offset;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vmix = ref.watch(vmixProvider);
    final vmixNotifier = ref.watch(vmixProvider.notifier);
    final project = vmix.project;
    final inputs = vmix.project?.inputs ?? [];

    final colorScheme = Theme.of(context).colorScheme;

    handleInputOptionsPressed(int inputNumber) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
          // backgroundColor: Colors.black,
          child: InputActions(inputNumber: inputNumber),
        ),
      );
    }

    return SectionCard(
      title: 'INPUTS',
      centerTitle: centerTitle,
      child: LayoutBuilder(builder: (context, constraints) {
        final isUnbounded = constraints.maxHeight == double.infinity;

        return GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _columnsForWidth(constraints.maxWidth, context),
              crossAxisSpacing: crossAxisSpacing,
              mainAxisSpacing: mainAxisSpacing,
              childAspectRatio: .95),
          shrinkWrap: isUnbounded,
          physics: isUnbounded
              ? const NeverScrollableScrollPhysics()
              : const AlwaysScrollableScrollPhysics(),
          children: [
            for (var input in inputs)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 4,
                children: [
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: SwitcherButton(
                        label: input.number.toString().padLeft(2, '0'),
                        isActive: input.number == project!.active ||
                            input.number == project.preview,
                        colorActive: input.number == project.active
                            ? SwitcherButtonColors.red
                            : SwitcherButtonColors.green,
                        width: 100,
                        onTap: () => vmixNotifier.sendCommand("PreviewInput",
                            input: '${input.number}'),
                        onDoubleTap: () => vmixNotifier.sendCommand("CutDirect",
                            input: '${input.number}'),
                        onLongPress: () =>
                            handleInputOptionsPressed(input.number),
                        height: 100,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4),
                      ),
                      border: Border.all(color: colorScheme.outline),
                      color: colorScheme.primary,
                    ),
                    child: Center(
                      child: Text(
                        input.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              )
          ],
        );
      }),
    );
  }
}
