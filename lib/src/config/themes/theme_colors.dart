part of 'themes.dart';

/// A set of colors for the entire app.
const colorLightScheme = ColorScheme.light(
  primary: Color(0xFF0EA5E9),
  // surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF020000),
  secondary: Color(0xFF605C71),
  onSecondary: Color(0xFF020000),
  error: Color(0xFFFF2C2F),
);

///
const colorDarkScheme = ColorScheme.dark(
  primary: Color(0xFF0EA5E9),
  surface: Color(0xFFFFFFFF),
  secondary: Color(0xFF69D7C7),
  error: Color(0xFFFF2C2F),
);

class ThemeColors extends ThemeExtension<ThemeColors> {
  const ThemeColors({
    required this.cardColor,
    required this.white,
    required this.black,
    required this.black10,
    required this.disabled,
    required this.disabledText,
    required this.midGrey4,
    required this.midGrey5,
    required this.darkGrey2,
    required this.darkGrey3,
    required this.darkGrey5,
    required this.orange,
    required this.midGrey,
    required this.darkGrey,
    required this.lightGrey4,
    required this.midGrey2,
    required this.purple,
    required this.lightGrey,
    required this.lightGrey2,
    required this.lightGrey3,
    required this.iconColor,
    required this.red,
    required this.green,
    required this.yellow,
    required this.background,
  });

  final Color cardColor;
  final Color white;
  final Color black;
  final Color black10;
  final Color disabled;
  final Color disabledText;
  final Color midGrey4;
  final Color midGrey5;
  final Color darkGrey2;
  final Color darkGrey3;
  final Color darkGrey5;
  final Color orange;
  final Color midGrey;
  final Color darkGrey;
  final Color lightGrey4;
  final Color midGrey2;
  final Color purple;
  final Color lightGrey;
  final Color lightGrey2;
  final Color lightGrey3;
  final Color iconColor;
  final Color red;
  final Color green;
  final Color yellow;
  final Color background;

  static const ThemeColors light = ThemeColors(
    darkGrey: Color(0xFF1A2024),
    cardColor: Color(0xFFFDFDFD),
    white: Colors.white,
    black: Colors.black,
    black10: Color(0x1A000000),
    disabled: Color(0xFFF5F5F5),
    disabledText: Color(0xFFB0BABF),
    midGrey4: Color(0xFF9AA6AC),
    midGrey5: Color(0xFFB0BABF),
    darkGrey2: Color(0xFF252C32),
    darkGrey3: Color(0xFF303940),
    darkGrey5: Color(0xFF48535B),
    orange: Color(0xFFF6921E),
    midGrey: Color(0xFF5B6871),
    lightGrey4: Color(0xFFF5F5F5),
    midGrey2: Color(0xFF9AA6AC),
    purple: Color(0xFF6472FF),
    lightGrey: Color(0xFFD5DADD),
    lightGrey2: Color(0xFFEEEEEE),
    lightGrey3: Color(0xFFF1F1F1),
    iconColor: Color(0xFF48535B),
    red: Color(0xFFF76659),
    green: Color(0xFF22C348),
    yellow: Color(0xFFF8C51B),
    background: Color(0xFFF4F4F4),
  );
  static const ThemeColors dark = ThemeColors(
    darkGrey: Color(0xFF1A2024),
    cardColor: Color(0xFF1E1E1E),
    white: Colors.black,
    black10: Color(0x1A000000),
    black: Colors.white,
    disabled: Color(0xFFF5F5F5),
    disabledText: Color(0xFFB0BABF),
    midGrey4: Color(0xFF9AA6AC),
    midGrey5: Color(0xFFB0BABF),
    darkGrey2: Color(0xFF252C32),
    darkGrey3: Color(0xFF303940),
    darkGrey5: Color(0xFF48535B),
    orange: Color(0xFFF6921E),
    midGrey: Color(0xFF5B6871),
    lightGrey4: Color(0xFFF5F5F5),
    midGrey2: Color(0xFF9AA6AC),
    purple: Color(0xFF6472FF),
    lightGrey: Color(0xFFD5DADD),
    lightGrey2: Color(0xFFEEEEEE),
    lightGrey3: Color(0xFFF1F1F1),
    iconColor: Color(0xFF48535B),
    red: Color(0xFFF76659),
    green: Color(0xFF22C348),
    yellow: Color(0xFFF8C51B),
    background: Color(0xFFF4F4F4),
  );

  @override
  ThemeExtension<ThemeColors> copyWith({
    Color? cardColor,
    Color? white,
    Color? black,
    Color? black10,
    Color? disabled,
    Color? disabledText,
    Color? midGrey4,
    Color? midGrey5,
    Color? darkGrey2,
    Color? darkGrey3,
    Color? darkGrey5,
    Color? orange,
    Color? midGrey,
    Color? darkGrey,
    Color? lightGrey4,
    Color? midGrey2,
    Color? purple,
    Color? lightGrey,
    Color? lightGrey2,
    Color? lightGrey3,
    Color? iconColor,
    Color? red,
    Color? green,
    Color? yellow,
    Color? background,
  }) =>
      ThemeColors(
        cardColor: cardColor ?? this.cardColor,
        white: white ?? this.white,
        black: black ?? this.black,
        black10: black10 ?? this.black10,
        disabled: disabled ?? this.disabled,
        disabledText: disabledText ?? this.disabledText,
        midGrey4: midGrey4 ?? this.midGrey4,
        midGrey5: midGrey5 ?? this.midGrey5,
        darkGrey2: darkGrey2 ?? this.darkGrey2,
        darkGrey3: darkGrey3 ?? this.darkGrey3,
        darkGrey5: darkGrey5 ?? this.darkGrey5,
        orange: orange ?? this.orange,
        midGrey: midGrey ?? this.midGrey,
        darkGrey: darkGrey ?? this.darkGrey,
        lightGrey4: lightGrey4 ?? this.lightGrey4,
        midGrey2: midGrey2 ?? this.midGrey2,
        purple: purple ?? this.purple,
        lightGrey: lightGrey ?? this.lightGrey,
        lightGrey2: lightGrey2 ?? this.lightGrey2,
        lightGrey3: lightGrey3 ?? this.lightGrey3,
        iconColor: iconColor ?? this.iconColor,
        red: red ?? this.red,
        green: green ?? this.green,
        yellow: yellow ?? this.yellow,
        background: background ?? this.background,
      );

  @override
  ThemeExtension<ThemeColors> lerp(ThemeExtension<ThemeColors>? other, double t) {
    if (other is! ThemeColors) {
      return this;
    }
    return ThemeColors(
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      white: Color.lerp(white, other.white, t)!,
      black: Color.lerp(black, other.black, t)!,
      black10: Color.lerp(black10, other.black10, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      disabledText: Color.lerp(disabledText, other.disabledText, t)!,
      midGrey4: Color.lerp(midGrey4, other.midGrey4, t)!,
      midGrey5: Color.lerp(midGrey5, other.midGrey5, t)!,
      darkGrey2: Color.lerp(darkGrey2, other.darkGrey2, t)!,
      darkGrey3: Color.lerp(darkGrey3, other.darkGrey3, t)!,
      darkGrey5: Color.lerp(darkGrey5, other.darkGrey5, t)!,
      orange: Color.lerp(orange, other.orange, t)!,
      midGrey: Color.lerp(midGrey, other.midGrey, t)!,
      darkGrey: Color.lerp(darkGrey, other.darkGrey, t)!,
      lightGrey4: Color.lerp(lightGrey4, other.lightGrey4, t)!,
      midGrey2: Color.lerp(midGrey2, other.midGrey2, t)!,
      purple: Color.lerp(purple, other.purple, t)!,
      lightGrey: Color.lerp(lightGrey, other.lightGrey, t)!,
      lightGrey2: Color.lerp(lightGrey2, other.lightGrey2, t)!,
      lightGrey3: Color.lerp(lightGrey3, other.lightGrey3, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      red: Color.lerp(red, other.red, t)!,
      green: Color.lerp(green, other.green, t)!,
      yellow: Color.lerp(yellow, other.yellow, t)!,
      background: Color.lerp(background, other.background, t)!,
    );
  }
}
