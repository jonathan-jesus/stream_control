import 'package:flutter/material.dart';

enum ThemeStyle { light, dark }

enum PollingSpeed {
  slow(Duration(seconds: 2)),
  normal(Duration(seconds: 1)),
  fast(Duration(milliseconds: 150));

  const PollingSpeed(this.duration);
  final Duration duration;
}

class AppSettings {
  final ThemeMode themeMode;
  final PollingSpeed pollingSpeed;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.pollingSpeed = PollingSpeed.normal,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    PollingSpeed? pollingSpeed,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      pollingSpeed: pollingSpeed ?? this.pollingSpeed,
    );
  }

  factory AppSettings.fromValues(int? themeModeIndex, int? pollingSpeedIndex) {
    ThemeMode themeModeFromPrefs(int? index) {
      if (index == null || index < 0 || index >= ThemeMode.values.length) {
        return ThemeMode.system;
      }
      return ThemeMode.values[index];
    }

    PollingSpeed pollingSpeedFromPrefs(int? index) {
      if (index == null || index < 0 || index >= PollingSpeed.values.length) {
        return PollingSpeed.normal;
      }
      return PollingSpeed.values[index];
    }

    return AppSettings(
      themeMode: themeModeFromPrefs(themeModeIndex),
      pollingSpeed: pollingSpeedFromPrefs(pollingSpeedIndex),
    );
  }
}
