class AppSettings {
  String themeMode;
  String language;

  int wpmSpeed;
  int animationSpeed;
  int fontSize;

  String rsvpHighlightColor;

  AppSettings({
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
}