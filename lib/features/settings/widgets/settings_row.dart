import 'package:stream_control/core/utils/extensions.dart';
import 'package:stream_control/features/settings/models/app_settings.dart';
import 'package:stream_control/features/settings/state/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsRow extends ConsumerWidget {
  const SettingsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);
    final tooltipColor = Theme.of(context).colorScheme.onSurface;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          spacing: 20,
          children: [
            const Text('Theme Mode:'),
            IconButton.outlined(
              onPressed: () => notifier.toggleThemeMode(),
              icon: Icon([
                Icons.settings_brightness,
                Icons.light_mode_outlined,
                Icons.dark_mode_outlined
              ][settings.themeMode.index]),
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              message: 'Choose light, dark, or system theme.',
              showDuration: const Duration(seconds: 5),
              child: Icon(
                Icons.help_outline,
                color: tooltipColor.withAlpha(100),
              ),
            )
          ],
        ),
        Row(
          spacing: 20,
          children: [
            const Text('Polling Speed:'),
            DropdownMenu<PollingSpeed>(
              dropdownMenuEntries: PollingSpeed.values.map((speed) {
                return DropdownMenuEntry<PollingSpeed>(
                  value: speed,
                  label: speed.name.capitalizeFirst(),
                );
              }).toList(),
              initialSelection: settings.pollingSpeed,
              onSelected: (value) {
                if (value != null) notifier.updatePollingSpeed(value);
              },
            ),
            Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              message: '''
Frequency of update:
Fast: 150 miliseconds
Normal: 1 second
Slow: 2 seconds''',
              showDuration: const Duration(seconds: 5),
              child: Icon(
                Icons.help_outline,
                color: tooltipColor.withAlpha(100),
              ),
            )
          ],
        ),
      ],
    );
  }
}
