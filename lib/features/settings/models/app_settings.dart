enum ThemeStyle { light, dark }

enum PollingSpeed {
  slow(Duration(seconds: 2)),
  normal(Duration(seconds: 1)),
  fast(Duration(milliseconds: 150));

  const PollingSpeed(this.duration);
  final Duration duration;
}

class AppSettings {
  final ThemeStyle themeStyle;
  final PollingSpeed pollingSpeed;

  const AppSettings({
    this.themeStyle = ThemeStyle.light,
    this.pollingSpeed = PollingSpeed.normal,
  });

  AppSettings copyWith({
    ThemeStyle? themeStyle,
    PollingSpeed? pollingSpeed,
  }) {
    return AppSettings(
      themeStyle: themeStyle ?? this.themeStyle,
      pollingSpeed: pollingSpeed ?? this.pollingSpeed,
    );
  }
}
