// // ignore_for_file: annotate_overrides, overridden_fields
//
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'constants.dart';
//
// export 'constants.dart';
//
// const kThemeModeKey = '__theme_mode__';
//
// // To make more searchable because I always forget the name:
// //   * FFLoadingIndicator
// //   * FFLoadingWidget
// class FFProgressIndicator extends StatelessWidget {
//   const FFProgressIndicator({
//     Key? key,
//     this.size,
//     this.color,
//     this.strokeWidth,
//   }) : super(key: key);
//
//   final double? size;
//   final Color? color;
//   final double? strokeWidth;
//
//   @override
//   Widget build(BuildContext context) {
//     final indicator = CircularProgressIndicator(
//       valueColor:
//       AlwaysStoppedAnimation<Color>(color ?? context.theme.primaryColor),
//       strokeWidth: strokeWidth ?? 4.0,
//     );
//     if (size == null) {
//       return indicator;
//     }
//     return Container(width: size, height: size, child: indicator);
//   }
// }
//
// class FFLinearProgressIndicator extends StatelessWidget {
//   const FFLinearProgressIndicator({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const LinearProgressIndicator(
//       backgroundColor: kGrey800,
//       valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
//     );
//   }
// }
//
// class RotatingFFIndicator extends StatelessWidget {
//   const RotatingFFIndicator({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) => Container(
//     height: kBaseSize120px,
//     width: kBaseSize120px,
//     child: Stack(
//       children: [
//         Center(
//           child: SpinKitPumpingHeart(
//             itemBuilder: (_, __) => Image.asset(
//               'web/images/logoMark_outlinePrimary@2x.png',
//               width: kBaseSize72px,
//               height: kBaseSize72px,
//             ),
//           ),
//         ),
//         Container(
//           width: kBaseSize120px,
//           height: kBaseSize120px,
//           child: const FFProgressIndicator(),
//         ),
//       ],
//     ),
//   );
// }
//
// const kTightDensity = VisualDensity(horizontal: -4, vertical: -4);
//
// TextStyle productSans(
//     BuildContext context, {
//       double size = kBaseSize16px,
//       Color? color,
//       FontWeight weight = FontWeight.normal,
//     }) =>
//     TextStyle(
//       fontFamily: 'Product Sans',
//       color: color ?? context.theme.primaryText,
//       fontSize: size,
//       fontWeight: weight,
//     );
//
// class ThemeNotifier extends ChangeNotifier {
//   static bool hasInitializedIsLightMode = false;
//
//   bool isLightMode = FlutterFlowTheme.prefs?.getBool(kThemeModeKey) ?? false;
//   bool isHolidayTheme = false;
//
//   ThemeMode get mode => isLightMode ? ThemeMode.light : ThemeMode.dark;
//
//   Color? get themeDataColor => isHolidayTheme ? kPrimaryColor : null;
//
//   void setIsLightMode(bool lightMode) {
//     if (lightMode != isLightMode) {
//       isLightMode = lightMode;
//       notifyListeners();
//     }
//   }
// }
//
// abstract class FlutterFlowTheme {
//   static SharedPreferences? prefs;
//
//   static Future initialize() async =>
//       prefs = await SharedPreferences.getInstance();
//
//   static FlutterFlowTheme of(BuildContext context) {
//     final theme = Theme.of(context);
//     final isLightMode = theme.brightness == Brightness.light;
//     return isLightMode ? LightModeTheme() : DarkModeTheme();
//   }
//
//   late bool isLightMode;
//   late bool isHolidayTheme;
//
//   String primaryFontFamily = 'Poppins';
//   String secondaryFontFamily = 'Roboto';
//
//   TextStyle get title1 => TextStyle(
//     fontFamily: 'Product Sans',
//     color: primaryText,
//     fontWeight: FontWeight.bold,
//     fontSize: kFontSize32px,
//   );
//
//   TextStyle get title2 => TextStyle(
//     fontFamily: 'Product Sans',
//     color: primaryText,
//     fontWeight: FontWeight.w500,
//     fontSize: kFontSize24px,
//   );
//
//   TextStyle get title3 => TextStyle(
//     fontFamily: 'Product Sans',
//     color: primaryText,
//     fontWeight: FontWeight.w500,
//     fontSize: kFontSize20px,
//   );
//
//   TextStyle get subtitle1 => TextStyle(
//     fontFamily: 'Product Sans',
//     color: primaryText,
//     fontWeight: FontWeight.normal,
//     fontSize: kFontSize16px,
//   );
//
//   TextStyle get subtitle2 => TextStyle(
//     fontFamily: 'Product Sans',
//     color: secondaryText,
//     fontWeight: FontWeight.normal,
//     fontSize: kFontSize14px,
//     overflow: TextOverflow.ellipsis,
//   );
//
//   TextStyle get bodyText1 => TextStyle(
//     fontFamily: 'Product Sans',
//     color: primaryText,
//     fontWeight: FontWeight.normal,
//     fontSize: kFontSize14px,
//   );
//
//   TextStyle get bodyText2 => TextStyle(
//     fontFamily: 'Product Sans',
//     color: secondaryText,
//     fontWeight: FontWeight.normal,
//     fontSize: kFontSize14px,
//   );
//
//   TextStyle get bodyTextSmall => TextStyle(
//     fontFamily: 'Product Sans',
//     color: secondaryText,
//     fontWeight: FontWeight.normal,
//     fontSize: kFontSize13px,
//   );
//
//   TextStyle get propertyGroupName => TextStyle(
//     fontFamily: 'Product Sans',
//     color: primaryText,
//     fontWeight: FontWeight.w500,
//     fontSize: kFontSize13px,
//   );
//
//   TextStyle get propertyName => TextStyle(
//     fontFamily: 'Product Sans',
//     color: panelGrey,
//     fontWeight: FontWeight.normal,
//     fontSize: kFontSize13px,
//   );
//
//   // Static colors
//   Color primaryColor = const Color(0xFF4B39EF);
//   Color primary600 = const Color(0xFF452fb7);
//   Color secondaryColor = const Color(0xFFEE8B60);
//   Color tertiaryColor = const Color(0xFF1D2429);
//   Color successToastColor = const Color(0xFF39D2C0);
//   Color errorColor = kErrorColor;
//   Color errorBorderColor = const Color(0xFFFF5963);
//   Color errorAccent = const Color(0x4cdf3f3f);
//   Color insertionIndexOverlayColor = Colors.red;
//   Color homeScreenBlue = const Color(0xFF3474E0);
//   Color buttonColor = const Color(0xFF4542e6);
//   Color titleColor = const Color(0xFFF1F4F8);
//   Color panelOrange = const Color(0xFFEE8B60);
//   Color panelPink = const Color(0xFFFF1493);
//   Color panelButtonGreen = const Color(0xFF39D2C0);
//   Color messageRed = const Color(0xFFDF3F3F);
//   Color greenAccent = const Color(0xFF31BFAE);
//   Color primaryAccent = const Color(0x4C4B39EF);
//   Color tooltip = const Color(0xFF57636C);
//   Color warningColor = const Color(0xFFFB8C00);
//   Color projectWarningsColor = const Color(0xFFFFA130);
//   Color overlayGreen = const Color(0xFF249689);
//   Color overlayBorderGreen = const Color(0xFF31BFAE);
//   Color accent1 = const Color(0x4c4b39ef);
//   Color accent2 = const Color(0x4d39d2c0);
//   Color accent3 = const Color(0x4dee8b60);
//
//   // Variable colors
//   late Color backgroundColor;
//   late Color primaryBackground;
//   late Color secondaryBackground;
//   late Color primaryText;
//   late Color secondaryText;
//   late Color primaryColorText;
//   late Color panelColor;
//   late Color navPanelColor;
//   late Color panelTextColor1;
//   late Color panelTextColor2;
//   late Color workspaceOptionsTextColor1;
//   late Color panelBorderColor;
//   late Color panelIconColor;
//   late Color workspaceButtonColor;
//   late Color panelGrey;
//   late Color dark200;
//   late Color dark300;
//   late Color dark400;
//   late Color dark600;
//   late Color dark800;
//   late Color white;
//   late Color toggleIconHighlight;
//   late Color lineColor;
//   late Color alternate;
//   late Color accent4;
//
//   Color candidateGradientColor(int generation) =>
//       temporaryOverlayGenerationColors[
//       generation % temporaryOverlayGenerationColors.length];
//
//   List<Color> get temporaryOverlayGenerationColors => [
//     Colors.red,
//     Colors.yellowAccent,
//     Colors.deepPurple,
//     Colors.blue,
//   ];
//
//   TextStyle titleTextStyle({
//     Color? color,
//     double fontSize = kFontSize24px,
//     FontWeight weight = FontWeight.bold,
//   }) =>
//       TextStyle(
//         fontFamily: 'Product Sans',
//         fontWeight: weight,
//         fontSize: fontSize,
//         color: color ?? white,
//       );
//
//   TextStyle panelTextStyle(Color color) => TextStyle(
//       fontFamily: 'Product Sans', fontSize: kFontSize12px, color: color);
//
//   TextStyle get panelTextStyle1 => panelTextStyle(panelTextColor1);
//
//   TextStyle get panelTextStyle2 => panelTextStyle(panelTextColor2);
//
//   InputDecoration searchFieldDecoration({
//     String? labelText,
//     String? hintText,
//   }) =>
//       InputDecoration(
//         labelText: labelText,
//         labelStyle: bodyText2.copyWith(
//           color: isLightMode ? primaryText : secondaryText,
//         ),
//         hintText: hintText,
//         hintStyle: bodyText2.copyWith(
//           color: isLightMode ? primaryText : white,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: dark300,
//             width: kLineWidth2px,
//           ),
//           borderRadius: BorderRadius.circular(kBorderRadius8px),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: dark300,
//             width: kLineWidth2px,
//           ),
//           borderRadius: BorderRadius.circular(kBorderRadius8px),
//         ),
//         filled: true,
//         fillColor: backgroundColor,
//         prefixIcon: Icon(
//           Icons.search_outlined,
//           color: isLightMode ? primaryText : Colors.white,
//         ),
//       );
//
//   InputDecoration textFieldDecoration({
//     required FocusNode focusNode,
//     String? hintText,
//     TextStyle? hintStyle,
//     Color? borderColor,
//     Color? focusedBorderColor,
//     Color? fillColor,
//     Icon? prefixIcon,
//   }) =>
//       InputDecoration(
//         hintText: hintText,
//         hintStyle: hintStyle ?? bodyText2,
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: borderColor ?? lineColor,
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: focusedBorderColor ?? primaryColor,
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//             color: Color(0x00000000),
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//             color: Color(0x00000000),
//             width: 2,
//           ),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         contentPadding: EdgeInsetsDirectional.fromSTEB(
//             prefixIcon != null ? 24 : 12, 12, 24, 12),
//         prefixIcon: prefixIcon,
//         filled: focusNode.hasFocus,
//         fillColor: fillColor ?? primaryColor.withOpacity(0.15),
//       );
//
//   List<BoxShadow> get panelBoxShadow => kBoxShadow8;
//
//   BoxDecoration panelDecoration({
//     bool hasShadow = true,
//     bool hasColor = true,
//   }) =>
//       BoxDecoration(
//         borderRadius: BorderRadius.circular(kBorderRadius8px),
//         color: hasColor ? panelColor : null,
//         boxShadow: hasShadow ? panelBoxShadow : null,
//         border: Border.all(color: panelBorderColor),
//       );
//
//   Widget standardPanel({
//     double? width,
//     double? height,
//     Function()? onClose,
//     EdgeInsetsGeometry contentPadding = const EdgeInsets.all(kPadding16px),
//     required Widget child,
//   }) =>
//       Container(
//         width: width,
//         height: height,
//         decoration: panelDecoration(),
//         child: Padding(
//           padding: contentPadding,
//           child: onClose == null
//               ? child
//               : Stack(
//             alignment: Alignment.topLeft,
//             children: [
//               Align(
//                 alignment: Alignment.topRight,
//                 child: InkWell(
//                   onTap: onClose,
//                   child: Icon(
//                     Icons.close,
//                     size: kIconSize24px,
//                     color: panelIconColor,
//                   ),
//                 ),
//               ),
//               child,
//             ],
//           ),
//         ),
//       );
// }
//
// class LightModeTheme extends FlutterFlowTheme {
//   @override
//   bool get isLightMode => true;
//
//   @override
//   bool get isHolidayTheme => false;
//
//   late Color backgroundColor = const Color(0xFFF1F4F8);
//   late Color primaryBackground = const Color(0xFFF1F4F8);
//   late Color secondaryBackground = Colors.white;
//   late Color primaryText = const Color(0xFF090F13);
//   late Color secondaryText = const Color(0xFF59636B);
//   late Color primaryColorText = const Color(0xFF4B39EF);
//   late Color panelColor = Colors.white;
//   late Color navPanelColor = Colors.white;
//   late Color panelTextColor1 = const Color(0xFF59636B);
//   late Color panelTextColor2 = const Color(0xFF59636B);
//   late Color workspaceOptionsTextColor1 = const Color(0xFF59636B);
//   late Color panelBorderColor = kGrey250;
//   late Color panelIconColor = const Color(0xFF59636B);
//   late Color workspaceButtonColor = const Color(0xFF59636B);
//   late Color panelGrey = const Color(0xFF59636B);
//   late Color dark200 = const Color(0xFFC4CDD6);
//   late Color dark300 = kGrey250;
//   late Color dark400 = const Color(0xFFF1F4F8);
//   late Color dark600 = Colors.white;
//   late Color dark800 = Colors.white;
//   late Color white = const Color(0xFF000000);
//   late Color toggleIconHighlight = kSecondaryColor;
//   late Color lineColor = const Color(0xFFE0E3E7);
//   late Color alternate = const Color(0xFFE0E3E7);
//   late Color accent4 = const Color(0xccffffff);
// }
//
// class DarkModeTheme extends FlutterFlowTheme {
//   @override
//   bool get isLightMode => false;
//
//   @override
//   bool get isHolidayTheme => false;
//
//   late Color backgroundColor = const Color(0xFF1E2428);
//   late Color primaryBackground = const Color(0xFF1E2428);
//   late Color secondaryBackground = const Color(0xFF14181B);
//   late Color primaryText = Colors.white;
//   late Color secondaryText = const Color(0xFF95A1AC);
//   late Color primaryColorText = const Color(0xFF786aff);
//   late Color panelColor = const Color(0xFF14181B);
//   late Color navPanelColor = const Color(0xFF101213);
//   late Color panelTextColor1 = const Color(0xFF7C8791);
//   late Color panelTextColor2 = const Color(0xFF9AA6B6);
//   late Color workspaceOptionsTextColor1 = const Color(0xFF8B97A2);
//   late Color panelBorderColor = const Color(0xFF323B45);
//   late Color panelIconColor = const Color(0xFF97A1AB);
//   late Color workspaceButtonColor = const Color(0xFFC8C8C8);
//   late Color panelGrey = const Color(0xFF95A1AC);
//   late Color dark200 = const Color(0xFF2d353d);
//   late Color dark300 = const Color(0xFF262d34);
//   late Color dark400 = const Color(0xFF1D2428);
//   late Color dark600 = const Color(0xFF14181B);
//   late Color dark800 = const Color(0xFF090F13);
//   late Color white = Colors.white;
//   late Color toggleIconHighlight = Colors.white;
//   late Color lineColor = const Color(0xFF323B45);
//   late Color alternate = const Color(0xFF323B45);
//   late Color accent4 = const Color(0xcb1a1f24);
// }
//
// class HolidayDarkModeTheme extends FlutterFlowTheme {
//   @override
//   bool get isLightMode => false;
//
//   @override
//   bool get isHolidayTheme => true;
//
//   // Static colors (differ for holiday only)
//   late Color primaryColor = const Color(0xFFBB8E3F);
//   late Color secondaryColor = const Color(0xFFFF5963);
//   late Color tertiaryColor = const Color(0xFF1D2429);
//   late Color successToastColor = const Color(0xFF4B986C);
//   late Color errorColor = const Color(0xFFFF5963);
//   late Color homeScreenBlue = const Color(0xFFFF5963);
//   late Color buttonColor = const Color(0xFF928163);
//   late Color titleColor = const Color(0xFFf1f4f8);
//   late Color panelOrange = const Color(0xFFFF5963);
//   late Color panelPink = const Color(0xFFC8424A);
//   late Color panelButtonGreen = const Color(0xFF4B986C);
//   late Color messageRed = const Color(0xFFFF5963);
//   late Color greenAccent = const Color(0xFF336A4A);
//   late Color tooltip = const Color(0xFF658593);
//
//   // Dynamic colors
//   late Color backgroundColor = const Color(0xFF17282E);
//   late Color primaryBackground = const Color(0xFF1E2428);
//   late Color secondaryBackground = const Color(0xFF14181B);
//   late Color primaryText = Colors.white;
//   late Color secondaryText = const Color(0xFF95A1AC);
//   late Color primaryColorText = const Color(0xFF786aff);
//   late Color panelColor = const Color(0xFF0B191E);
//   late Color navPanelColor = const Color(0xFF0B1519);
//   late Color panelTextColor1 = const Color(0xFF658593);
//   late Color panelTextColor2 = const Color(0xFF658593);
//   late Color workspaceOptionsTextColor1 = const Color(0xFF658593);
//   late Color panelBorderColor = const Color(0xFF1E353D);
//   late Color panelIconColor = const Color(0xFF658593);
//   late Color workspaceButtonColor = const Color(0xFFB8C7CE);
//   late Color panelGrey = const Color(0xFF658593);
//   late Color dark200 = const Color(0xFF1D2F35);
//   late Color dark300 = const Color(0xFF1E353D);
//   late Color dark400 = const Color(0xFF17282E);
//   late Color dark600 = const Color(0xFF0B191E);
//   late Color dark800 = const Color(0xFF0B1519);
//   late Color white = Colors.white;
//   late Color toggleIconHighlight = Colors.white;
//   late Color lineColor = const Color(0xFF323B45);
// }
//
// class HolidayLightModeTheme extends FlutterFlowTheme {
//   @override
//   bool get isLightMode => true;
//
//   @override
//   bool get isHolidayTheme => true;
//
//   // Static colors (differ for holiday only)
//   late Color primaryColor = const Color(0xFFBB8E3F);
//   late Color secondaryColor = const Color(0xFFFF5963);
//   late Color tertiaryColor = const Color(0xFF1D2429);
//   late Color successToastColor = const Color(0xFF4B986C);
//   late Color errorColor = const Color(0xFFFF5963);
//   late Color homeScreenBlue = const Color(0xFFFF5963);
//   late Color buttonColor = const Color(0xFF928163);
//   late Color titleColor = Colors.white;
//   late Color panelOrange = const Color(0xFFFF5963);
//   late Color panelPink = const Color(0xFFC8424A);
//   late Color panelButtonGreen = const Color(0xFF4B986C);
//   late Color messageRed = const Color(0xFFFF5963);
//   late Color greenAccent = const Color(0xFF336A4A);
//   late Color tooltip = const Color(0xFF658593);
//
//   // Dynamic colors
//   late Color backgroundColor = const Color(0xFFE1ECFB);
//   late Color primaryBackground = const Color(0xFFF1F4F8);
//   late Color secondaryBackground = Colors.white;
//   late Color primaryText = const Color(0xFF090F13);
//   late Color secondaryText = const Color(0xFF59636B);
//   late Color primaryColorText = const Color(0xFF4B39EF);
//   late Color panelColor = Colors.white;
//   late Color navPanelColor = Colors.white;
//   late Color panelTextColor1 = const Color(0xFF384E58);
//   late Color panelTextColor2 = const Color(0xFF384E58);
//   late Color workspaceOptionsTextColor1 = const Color(0xFF384E58);
//   late Color panelBorderColor = const Color(0xFFD1DDEE);
//   late Color panelIconColor = const Color(0xFF384E58);
//   late Color workspaceButtonColor = const Color(0xFF748891);
//   late Color panelGrey = const Color(0xFF384E58);
//   late Color dark200 = const Color(0xFFC8D7E4);
//   late Color dark300 = const Color(0xFFB6C1D0);
//   late Color dark400 = const Color(0xFFE1ECFB);
//   late Color dark600 = Colors.white;
//   late Color dark800 = Colors.white;
//   late Color white = const Color(0xFF000000);
//   late Color toggleIconHighlight = kSecondaryColor;
//   late Color lineColor = const Color(0xFFE0E3E7);
// }
//
// extension FlutterFlowThemeExtensions on BuildContext {
//   FlutterFlowTheme get theme => FlutterFlowTheme.of(this);
//
//   bool get isLightMode => theme.isLightMode;
// }
//
// extension TextStyleHelper on TextStyle {
//   TextStyle override({
//     String? fontFamily,
//     Color? color,
//     double? fontSize,
//     FontWeight? fontWeight,
//     FontStyle? fontStyle,
//     bool useGoogleFonts = true,
//     double? lineHeight,
//   }) =>
//       fontFamily != null && fontFamily != 'Product Sans' && useGoogleFonts
//           ? GoogleFonts.getFont(
//         fontFamily,
//         color: color ?? this.color,
//         fontSize: fontSize ?? this.fontSize,
//         fontWeight: fontWeight ?? this.fontWeight,
//         fontStyle: fontStyle ?? this.fontStyle,
//         height: lineHeight,
//       )
//           : copyWith(
//         fontFamily: fontFamily,
//         color: color,
//         fontSize: fontSize,
//         fontWeight: fontWeight,
//         fontStyle: fontStyle,
//         height: lineHeight,
//       );
// }
//
// ThemeData darkFlutterTheme(BuildContext context) =>
//     ThemeData.dark().copyWith(brightness: Theme.of(context).brightness);
//
// ThemeData dynamicFlutterTheme(BuildContext context) {
//   return context.theme.isLightMode
//       ? ThemeData.light().copyWith(brightness: Theme.of(context).brightness)
//       : ThemeData.dark().copyWith(brightness: Theme.of(context).brightness);
// }

// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kThemeModeKey = '__theme_mode__';

abstract class FlutterFlowTheme {
  static FlutterFlowTheme of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? DarkModeTheme()
        : LightModeTheme();
  }

  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary;
  late Color secondary;
  late Color tertiary;
  late Color alternate;
  late Color primaryText;
  late Color secondaryText;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color accent1;
  late Color accent2;
  late Color accent3;
  late Color accent4;
  late Color success;
  late Color warning;
  late Color error;
  late Color info;

  late Color primaryBtnText;
  late Color lineColor;

  @Deprecated('Use displaySmallFamily instead')
  String get title1Family => displaySmallFamily;
  @Deprecated('Use displaySmall instead')
  TextStyle get title1 => typography.displaySmall;
  @Deprecated('Use headlineMediumFamily instead')
  String get title2Family => typography.headlineMediumFamily;
  @Deprecated('Use headlineMedium instead')
  TextStyle get title2 => typography.headlineMedium;
  @Deprecated('Use headlineSmallFamily instead')
  String get title3Family => typography.headlineSmallFamily;
  @Deprecated('Use headlineSmall instead')
  TextStyle get title3 => typography.headlineSmall;
  @Deprecated('Use titleMediumFamily instead')
  String get subtitle1Family => typography.titleMediumFamily;
  @Deprecated('Use titleMedium instead')
  TextStyle get subtitle1 => typography.titleMedium;
  @Deprecated('Use titleSmallFamily instead')
  String get subtitle2Family => typography.titleSmallFamily;
  @Deprecated('Use titleSmall instead')
  TextStyle get subtitle2 => typography.titleSmall;
  @Deprecated('Use bodyMediumFamily instead')
  String get bodyText1Family => typography.bodyMediumFamily;
  @Deprecated('Use bodyMedium instead')
  TextStyle get bodyText1 => typography.bodyMedium;
  @Deprecated('Use bodySmallFamily instead')
  String get bodyText2Family => typography.bodySmallFamily;
  @Deprecated('Use bodySmall instead')
  TextStyle get bodyText2 => typography.bodySmall;

  String get displayLargeFamily => typography.displayLargeFamily;
  TextStyle get displayLarge => typography.displayLarge;
  String get displayMediumFamily => typography.displayMediumFamily;
  TextStyle get displayMedium => typography.displayMedium;
  String get displaySmallFamily => typography.displaySmallFamily;
  TextStyle get displaySmall => typography.displaySmall;
  String get headlineLargeFamily => typography.headlineLargeFamily;
  TextStyle get headlineLarge => typography.headlineLarge;
  String get headlineMediumFamily => typography.headlineMediumFamily;
  TextStyle get headlineMedium => typography.headlineMedium;
  String get headlineSmallFamily => typography.headlineSmallFamily;
  TextStyle get headlineSmall => typography.headlineSmall;
  String get titleLargeFamily => typography.titleLargeFamily;
  TextStyle get titleLarge => typography.titleLarge;
  String get titleMediumFamily => typography.titleMediumFamily;
  TextStyle get titleMedium => typography.titleMedium;
  String get titleSmallFamily => typography.titleSmallFamily;
  TextStyle get titleSmall => typography.titleSmall;
  String get labelLargeFamily => typography.labelLargeFamily;
  TextStyle get labelLarge => typography.labelLarge;
  String get labelMediumFamily => typography.labelMediumFamily;
  TextStyle get labelMedium => typography.labelMedium;
  String get labelSmallFamily => typography.labelSmallFamily;
  TextStyle get labelSmall => typography.labelSmall;
  String get bodyLargeFamily => typography.bodyLargeFamily;
  TextStyle get bodyLarge => typography.bodyLarge;
  String get bodyMediumFamily => typography.bodyMediumFamily;
  TextStyle get bodyMedium => typography.bodyMedium;
  String get bodySmallFamily => typography.bodySmallFamily;
  TextStyle get bodySmall => typography.bodySmall;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends FlutterFlowTheme {
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary = const Color(0xFF4B39EF);
  late Color secondary = const Color(0xFF39D2C0);
  late Color tertiary = const Color(0xFFEE8B60);
  late Color alternate = const Color(0xFFE0E3E7);
  late Color primaryText = const Color(0xFF14181B);
  late Color secondaryText = const Color(0xFF57636C);
  late Color primaryBackground = const Color(0xFFF1F4F8);
  late Color secondaryBackground = const Color(0xFFFFFFFF);
  late Color accent1 = const Color(0x4C4B39EF);
  late Color accent2 = const Color(0x4D39D2C0);
  late Color accent3 = const Color(0x4DEE8B60);
  late Color accent4 = const Color(0xCCFFFFFF);
  late Color success = const Color(0xFF249689);
  late Color warning = const Color(0xFFF9CF58);
  late Color error = const Color(0xFFFF5963);
  late Color info = const Color(0xFFFFFFFF);

  late Color primaryBtnText = Color(0xFFFFFFFF);
  late Color lineColor = Color(0xFFE0E3E7);
}

abstract class Typography {
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
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final FlutterFlowTheme theme;

  String get displayLargeFamily => 'Outfit';
  TextStyle get displayLarge => GoogleFonts.getFont(
        'Outfit',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 64.0,
      );
  String get displayMediumFamily => 'Outfit';
  TextStyle get displayMedium => GoogleFonts.getFont(
        'Outfit',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 44.0,
      );
  String get displaySmallFamily => 'Outfit';
  TextStyle get displaySmall => GoogleFonts.getFont(
        'Outfit',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 36.0,
      );
  String get headlineLargeFamily => 'Outfit';
  TextStyle get headlineLarge => GoogleFonts.getFont(
        'Outfit',
        color: theme.primaryText,
        fontWeight: FontWeight.w600,
        fontSize: 32.0,
      );
  String get headlineMediumFamily => 'Outfit';
  TextStyle get headlineMedium => GoogleFonts.getFont(
        'Outfit',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 24.0,
      );
  String get headlineSmallFamily => 'Outfit';
  TextStyle get headlineSmall => GoogleFonts.getFont(
        'Outfit',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 24.0,
      );
  String get titleLargeFamily => 'Outfit';
  TextStyle get titleLarge => GoogleFonts.getFont(
        'Outfit',
        color: theme.primaryText,
        fontWeight: FontWeight.w500,
        fontSize: 22.0,
      );
  String get titleMediumFamily => 'Readex Pro';
  TextStyle get titleMedium => GoogleFonts.getFont(
        'Readex Pro',
        color: theme.info,
        fontWeight: FontWeight.normal,
        fontSize: 18.0,
      );
  String get titleSmallFamily => 'Readex Pro';
  TextStyle get titleSmall => GoogleFonts.getFont(
        'Readex Pro',
        color: theme.info,
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      );
  String get labelLargeFamily => 'Readex Pro';
  TextStyle get labelLarge => GoogleFonts.getFont(
        'Readex Pro',
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
      );
  String get labelMediumFamily => 'Readex Pro';
  TextStyle get labelMedium => GoogleFonts.getFont(
        'Readex Pro',
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
      );
  String get labelSmallFamily => 'Readex Pro';
  TextStyle get labelSmall => GoogleFonts.getFont(
        'Readex Pro',
        color: theme.secondaryText,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
      );
  String get bodyLargeFamily => 'Readex Pro';
  TextStyle get bodyLarge => GoogleFonts.getFont(
        'Readex Pro',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
      );
  String get bodyMediumFamily => 'Readex Pro';
  TextStyle get bodyMedium => GoogleFonts.getFont(
        'Readex Pro',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 14.0,
      );
  String get bodySmallFamily => 'Readex Pro';
  TextStyle get bodySmall => GoogleFonts.getFont(
        'Readex Pro',
        color: theme.primaryText,
        fontWeight: FontWeight.normal,
        fontSize: 12.0,
      );
}

class DarkModeTheme extends FlutterFlowTheme {
  @Deprecated('Use primary instead')
  Color get primaryColor => primary;
  @Deprecated('Use secondary instead')
  Color get secondaryColor => secondary;
  @Deprecated('Use tertiary instead')
  Color get tertiaryColor => tertiary;

  late Color primary = const Color(0xFF4B39EF);
  late Color secondary = const Color(0xFF39D2C0);
  late Color tertiary = const Color(0xFFEE8B60);
  late Color alternate = const Color(0xFF262D34);
  late Color primaryText = const Color(0xFFFFFFFF);
  late Color secondaryText = const Color(0xFF95A1AC);
  late Color primaryBackground = const Color(0xFF1D2428);
  late Color secondaryBackground = const Color(0xFF14181B);
  late Color accent1 = const Color(0x4C4B39EF);
  late Color accent2 = const Color(0x4D39D2C0);
  late Color accent3 = const Color(0x4DEE8B60);
  late Color accent4 = const Color(0xB2262D34);
  late Color success = const Color(0xFF249689);
  late Color warning = const Color(0xFFF9CF58);
  late Color error = const Color(0xFFFF5963);
  late Color info = const Color(0xFFFFFFFF);

  late Color primaryBtnText = Color(0xFFFFFFFF);
  late Color lineColor = Color(0xFF22282F);
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
