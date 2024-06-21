import 'package:flutter/material.dart';
import 'package:flutterflow_ui/src/themes/custom_color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'default_dark_theme.dart';
import 'default_light_theme.dart';

const kThemeModeKey = '__theme_mode__';
SharedPreferences? _preferences;

abstract class FFThemeModel {
  Color get primary;
  Color get secondary;
  Color get tertiary;
  Color get alternate;
  Color get primaryText;
  Color get secondaryText;
  Color get primaryBackground;
  Color get secondaryBackground;
  Color get accent1;
  Color get accent2;
  Color get accent3;
  Color get accent4;
  Color get success;
  Color get warning;
  Color get error;
  Color get info;

  String get displayLargeFamily;
  TextStyle get displayLarge;
  String get displayMediumFamily;
  TextStyle get displayMedium;
  String get displaySmallFamily;
  TextStyle get displaySmall;
  String get headlineLargeFamily;
  TextStyle get headlineLarge;
  String get headlineMediumFamily;
  TextStyle get headlineMedium;
  String get headlineSmallFamily;
  TextStyle get headlineSmall;
  String get titleLargeFamily;
  TextStyle get titleLarge;
  String get titleMediumFamily;
  TextStyle get titleMedium;
  String get titleSmallFamily;
  TextStyle get titleSmall;
  String get labelLargeFamily;
  TextStyle get labelLarge;
  String get labelMediumFamily;
  TextStyle get labelMedium;
  String get labelSmallFamily;
  TextStyle get labelSmall;
  String get bodyLargeFamily;
  TextStyle get bodyLarge;
  String get bodyMediumFamily;
  TextStyle get bodyMedium;
  String get bodySmallFamily;
  TextStyle get bodySmall;

  List<CustomColor> get customColors => [];
}

abstract class FFTheme {
  static Future<void> initialize() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? FFDefaultDarkModeTheme()
          : FFDefaultLightModeTheme();

  static void saveThemeMode(ThemeMode mode) {
    if (mode == ThemeMode.system) {
      _preferences?.remove(kThemeModeKey);
    } else {
      _preferences?.setBool(kThemeModeKey, mode == ThemeMode.dark);
    }
  }

  static ThemeMode get themeMode {
    final darkMode = _preferences?.getBool(kThemeModeKey);
    return darkMode == null
        ? ThemeMode.system
        : darkMode
            ? ThemeMode.dark
            : ThemeMode.light;
  }
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily!,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              letterSpacing: letterSpacing ?? this.letterSpacing,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              decoration: decoration,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              decoration: decoration,
              height: lineHeight,
            );
}
