import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_control/features/settings/models/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier(this.prefs)
      : super(AppSettings.fromValues(
          prefs.getInt(_keyThemeMode),
          prefs.getInt(_keyPollingSpeed),
        ));

  final SharedPreferences prefs;

  static const _keyThemeMode = 'themeMode';
  static const _keyPollingSpeed = 'pollingSpeed';

  Future<void> toggleThemeMode() async {
    final nextIndex = (state.themeMode.index + 1) % ThemeMode.values.length;
    final mode = ThemeMode.values[nextIndex];
    state = state.copyWith(themeMode: mode);
    await prefs.setInt(_keyThemeMode, mode.index);
  }

  Future<void> updatePollingSpeed(PollingSpeed speed) async {
    state = state.copyWith(pollingSpeed: speed);
    await prefs.setInt(_keyPollingSpeed, speed.index);
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AppSettingsNotifier(prefs);
});
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError("SharedPreferences not initialized");
});
