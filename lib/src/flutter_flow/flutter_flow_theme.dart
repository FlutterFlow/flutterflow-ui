// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';

const kThemeModeKey = '__theme_mode__';
SharedPreferences? _prefs;

abstract class FlutterFlowTheme {
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static ThemeMode get themeMode {
    final darkMode = _prefs?.getBool(kThemeModeKey);
    return darkMode == null
        ? ThemeMode.system
        : darkMode
            ? ThemeMode.dark
            : ThemeMode.light;
  }

  static void saveThemeMode(ThemeMode mode) => mode == ThemeMode.system
      ? _prefs?.remove(kThemeModeKey)
      : _prefs?.setBool(kThemeModeKey, mode == ThemeMode.dark);

  static FlutterFlowTheme of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? DarkModeTheme()
          : LightModeTheme();

  /// [PrimaryColor] is the main color of the app, used for buttons, icons, etc.
  late Color primary;
  late Color onPrimary;
  late Color primaryContainer;
  late Color onPrimaryContainer;
  late Color inversePrimary;
  late Color onInversePrimary;

  /// [SecondaryColor] is used for buttons, icons, etc. that are not as important
  late Color secondaryColor;
  late Color onSecondaryColor;
  late Color secondaryContainer;
  late Color onSecondaryContainer;

  /// [TertiaryColor] is used for buttons, icons, etc. that are not as important
  late Color tertiaryColor;
  late Color onTertiaryColor;
  late Color tertiaryContainer;
  late Color onTertiaryContainer;

  /// [ErrorColor] is used for buttons, icons, etc. that are related to UI errors
  late Color error;
  late Color onError;
  late Color errorContainer;
  late Color onErrorContainer;

  /// [SurfaceColor] is used for buttons, icons, etc. that are not as important
  late Color surface;
  late Color onSurface;
  late Color inverseSurface;
  late Color onInverseSurface;
  late Color surfaceTint;

  /// [BackgroundColor] is used for page backgrounds
  late Color background;
  late Color onBackground;

  /// [ControlColors] are used for controls
  late Color floatingActionButton;
  late Color onFloatingActionButton;
  late Color toolTip;
  late Color circleAvatar;
  late Color chips;

  TextStyle get title1 => GoogleFonts.getFont(
        'Poppins',
        color: primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      );
  TextStyle get title2 => GoogleFonts.getFont(
        'Poppins',
        color: secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 22,
      );
  TextStyle get title3 => GoogleFonts.getFont(
        'Poppins',
        color: primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      );
  TextStyle get subtitle1 => GoogleFonts.getFont(
        'Poppins',
        color: primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      );
  TextStyle get subtitle2 => GoogleFonts.getFont(
        'Poppins',
        color: secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      );
  TextStyle get bodyText1 => GoogleFonts.getFont(
        'Poppins',
        color: primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      );
  TextStyle get bodyText2 => GoogleFonts.getFont(
        'Poppins',
        color: secondaryText,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      );
}

class LightModeTheme extends FlutterFlowTheme {
  Color primary = const Color(0xFF6750a4);
  Color onPrimary = const Color(0xFFffffff);
  Color primaryContainer = const Color(0xFFeaddff);
  Color onPrimaryContainer = const Color(0xff272528);
  Color inversePrimary = const Color(0xFFf0e9ff);
  Color onInversePrimary = const Color(0xFF272528);
  Color secondaryColor = const Color(0xFF625b71);
  Color onSecondaryColor = const Color(0xFFffffff);
  Color secondaryContainer = const Color(0xFFe8def8);
  Color onSecondaryContainer = const Color(0xFF272528);
  Color tertiaryColor = const Color(0xFF7d5260);
  Color onTertiaryColor = const Color(0xFFffffff);
  Color tertiaryContainer = const Color(0xFFffd8e4);
  Color onTertiaryContainer = const Color(0xFF410002);
  Color error = const Color(0xFFba1a1a);
  Color onError = const Color(0xFFFfffff);
  Color errorContainer = const Color(0xFFffdad6);
  Color onErrorContainer = const Color(0xFF410002);
  Color surface = const Color(0xFFf9f8fb);
  Color onSurface = const Color(0xFF090909);
  Color inverseSurface = const Color(0xFF141316);
  Color onInverseSurface = const Color(0xFFf5f5f5);
  Color surfaceTint = const Color(0xFF6750a4);
  Color background = const Color(0xFFf3f1f7);
  Color onBackground = const Color(0xFF131213);
  Color floatingActionButton = const Color(0xFF625b71);
  Color onFloatingActionButton = const Color(0xFF272528);
  Color toolTip = const Color(0xf2372d52);
  Color circleAvatar = const Color(0xFF3d3062);
  Color chips = const Color(0xFFdbd6e9);
}

class DarkModeTheme extends FlutterFlowTheme {
  Color primary = const Color(0xFFd0bcff);
  Color onPrimary = const Color(0xFF1e1c1e);
  Color primaryContainer = const Color(0xFF4f378b);
  Color onPrimaryContainer = const Color(0xffe2ddf0);
  Color inversePrimary = const Color(0xFF655d73);
  Color onInversePrimary = const Color(0xFFe2ddf0);
  Color secondaryColor = const Color(0xFFccc2dc);
  Color onSecondaryColor = const Color(0xFF1e1c1e);
  Color secondaryContainer = const Color(0xFF4a4458);
  Color onSecondaryContainer = const Color(0xFFe1e0e4);
  Color tertiaryColor = const Color(0xFFefb8c8);
  Color onTertiaryColor = const Color(0xFF1e1b1d);
  Color tertiaryContainer = const Color(0xFF633b48);
  Color onTertiaryContainer = const Color(0xFFe7dee1);
  Color error = const Color(0xFFffb4ab);
  Color onError = const Color(0xFF690005);
  Color errorContainer = const Color(0xFF93000a);
  Color onErrorContainer = const Color(0xFFffb4ab);
  Color surface = const Color(0xFF161517);
  Color onSurface = const Color(0xFFf1f1f1);
  Color inverseSurface = const Color(0xFFfdfdff);
  Color onInverseSurface = const Color(0xFF0e0e0f);
  Color surfaceTint = const Color(0xFFd0bcff);
  Color background = const Color(0xFF1c1b1f);
  Color onBackground = const Color(0xFFe4e4e4);
  Color floatingActionButton = const Color(0xFFccc2dc);
  Color onFloatingActionButton = const Color(0xFF1e1c1e);
  Color toolTip = const Color(0xf2ece4ff);
  Color circleAvatar = const Color(0xFFe0d3ff);
  Color chips = const Color(0xFF3b3645);
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
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
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              decoration: decoration,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              decoration: decoration,
              height: lineHeight,
            );
}
