import 'package:flutter/material.dart';
import 'default_typography.dart';
import 'flutter_flow_theme.dart';

mixin FFDarkModeTheme {
  Color get primary => const Color(0xFF4B39EF);
  Color get secondary => const Color(0xFF39D2C0);
  Color get tertiary => const Color(0xFFEE8B60);
  Color get alternate => const Color(0xFF262D34);
  Color get primaryText => const Color(0xFFFFFFFF);
  Color get secondaryText => const Color(0xFF95A1AC);
  Color get primaryBackground => const Color(0xFF1D2428);
  Color get secondaryBackground => const Color(0xFF14181B);
  Color get accent1 => const Color(0x4C4B39EF);
  Color get accent2 => const Color(0x4D39D2C0);
  Color get accent3 => const Color(0x4DEE8B60);
  Color get accent4 => const Color(0xB2262D34);
  Color get success => const Color(0xFF249689);
  Color get warning => const Color(0xFFF9CF58);
  Color get error => const Color(0xFFFF5963);
  Color get info => const Color(0xFFFFFFFF);
}

class FFDefaultDarkModeTheme extends FFThemeModel
    with FFDarkModeTheme, FFTypography {
  @override
  FFThemeModel get theme => this;
}
