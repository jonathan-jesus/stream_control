import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_control/features/settings/models/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  static const _keyPanelStyle = 'panelStyle';
  static const _keyPollingSpeed = 'pollingSpeed';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final panelStyleIndex = prefs.getInt(_keyPanelStyle);
    final pollingSpeedIndex = prefs.getInt(_keyPollingSpeed);

    state = AppSettings(
      themeStyle: ThemeStyle.values[panelStyleIndex ?? ThemeStyle.light.index],
      pollingSpeed:
          PollingSpeed.values[pollingSpeedIndex ?? PollingSpeed.normal.index],
    );
  }

  Future<void> updatePanelStyle(ThemeStyle style) async {
    state = state.copyWith(themeStyle: style);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyPanelStyle, style.index);
  }

  Future<void> togglePanelStyle() async {
    state = state.copyWith(
        themeStyle: state.themeStyle == ThemeStyle.light
            ? ThemeStyle.dark
            : ThemeStyle.light);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyPanelStyle, state.themeStyle.index);
  }

  Future<void> updatePollingSpeed(PollingSpeed speed) async {
    state = state.copyWith(pollingSpeed: speed);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyPollingSpeed, speed.index);
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});
