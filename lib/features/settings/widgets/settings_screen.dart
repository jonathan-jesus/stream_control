import 'package:stream_control/common/constants.dart';
import 'package:stream_control/features/settings/models/app_settings.dart';
import 'package:stream_control/features/settings/state/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorDark,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Panel Style'),
                trailing: DropdownButton<ThemeStyle>(
                  value: settings.themeStyle,
                  items: ThemeStyle.values.map((style) {
                    return DropdownMenuItem(
                      value: style,
                      child: Text(style.name.capitalizeFirst()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) notifier.updatePanelStyle(value);
                  },
                ),
              ),
              const Divider(),
              ListTile(
                title: const Text('Polling Speed'),
                trailing: DropdownButton<PollingSpeed>(
                  value: settings.pollingSpeed,
                  items: PollingSpeed.values.map((speed) {
                    return DropdownMenuItem(
                      value: speed,
                      child: Text(speed.name.capitalizeFirst()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) notifier.updatePollingSpeed(value);
                  },
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
