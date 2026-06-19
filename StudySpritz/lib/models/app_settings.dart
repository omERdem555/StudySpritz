class AppSettings {
  final String themeMode;
  final String language;

  final int wpmSpeed;
  final int animationSpeed;
  final int fontSize;

  final String rsvpHighlightColor;

  const AppSettings({
    required this.themeMode,
    required this.language,
    required this.wpmSpeed,
    required this.animationSpeed,
    required this.fontSize,
    required this.rsvpHighlightColor,
  });

  AppSettings copyWith({
    String? themeMode,
    String? language,
    int? wpmSpeed,
    int? animationSpeed,
    int? fontSize,
    String? rsvpHighlightColor,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      wpmSpeed: wpmSpeed ?? this.wpmSpeed,
      animationSpeed: animationSpeed ?? this.animationSpeed,
      fontSize: fontSize ?? this.fontSize,
      rsvpHighlightColor: rsvpHighlightColor ?? this.rsvpHighlightColor,
    );
  }

  factory AppSettings.defaults() {
    return const AppSettings(
      themeMode: "system",
      language: "en",
      wpmSpeed: 250,
      animationSpeed: 3,
      fontSize: 16,
      rsvpHighlightColor: "yellow",
    );
  }
}