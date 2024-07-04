import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FFButtonOptions {
  const FFButtonOptions({
    this.textAlign,
    this.textStyle,
    this.elevation,
    this.height,
    this.width,
    this.padding,
    this.color,
    this.disabledColor,
    this.disabledTextColor,
    this.splashColor,
    this.iconSize,
    this.iconColor,
    this.iconPadding,
    this.borderRadius,
    this.borderSide,
    this.hoverColor,
    this.hoverBorderSide,
    this.hoverTextColor,
    this.hoverElevation,
    this.maxLines,
  });

  /// The alignment of the button's text within its bounds.
  final TextAlign? textAlign;

  /// The style of the button's text.
  final TextStyle? textStyle;

  /// The elevation of the button.
  final double? elevation;

  /// The height of the button.
  final double? height;

  /// The width of the button.
  final double? width;

  /// The padding around the button's content.
  final EdgeInsetsGeometry? padding;

  /// The background color of the button.
  final Color? color;

  /// The background color of the button when it is disabled.
  final Color? disabledColor;

  /// The text color of the button when it is disabled.
  final Color? disabledTextColor;

  /// The maximum number of lines for the button's text.
  final int? maxLines;

  /// The color of the splash effect when the button is pressed.
  final Color? splashColor;

  /// The size of the button's icon.
  final double? iconSize;

  /// The color of the button's icon.
  final Color? iconColor;

  /// The padding around the button's icon.
  final EdgeInsetsGeometry? iconPadding;

  /// The border radius of the button.
  final BorderRadius? borderRadius;

  /// The border of the button.
  final BorderSide? borderSide;

  /// The background color of the button when it is hovered.
  final Color? hoverColor;

  /// The border of the button when it is hovered.
  final BorderSide? hoverBorderSide;

  /// The text color of the button when it is hovered.
  final Color? hoverTextColor;

  /// The elevation of the button when it is hovered.
  final double? hoverElevation;
}

/// A customizable button widget that can display text, an icon, and a loading indicator.
class FFButtonWidget extends StatefulWidget {
  /// Creates a [FFButtonWidget].
  ///
  /// - [text] parameter is required and specifies the text to be displayed on the button.
  /// - [onPressed] parameter is a callback function that will be called when the button is pressed.
  /// - [icon] parameter is an optional widget that can be used to display an icon alongside the text.
  /// - [iconData] parameter is an optional icon data that can be used to display an icon alongside the text.
  /// - [options] parameter is required and specifies the visual options for the button.
  /// - [showLoadingIndicator] parameter is an optional boolean value that determines whether to show a loading indicator when the button is pressed.
  const FFButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.iconData,
    required this.options,
    this.showLoadingIndicator = true,
  });

  final String text;
  final Widget? icon;
  final IconData? iconData;
  final Function()? onPressed;
  final FFButtonOptions options;
  final bool showLoadingIndicator;

  @override
  State<FFButtonWidget> createState() => _FFButtonWidgetState();
}

class _FFButtonWidgetState extends State<FFButtonWidget> {
  bool loading = false;

  int get maxLines => widget.options.maxLines ?? 1;

  String? get text =>
      widget.options.textStyle?.fontSize == 0 ? null : widget.text;

  @override
  Widget build(BuildContext context) {
    Widget textWidget = loading
        ? SizedBox(
            width: widget.options.width == null
                ? _getTextWidth(text, widget.options.textStyle, maxLines)
                : null,
            child: Center(
              child: SizedBox(
                width: 23,
                height: 23,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.options.textStyle?.color ?? Colors.white,
                  ),
                ),
              ),
            ),
          )
        : AutoSizeText(
            text ?? '',
            style:
                text == null ? null : widget.options.textStyle?.withoutColor(),
            textAlign: widget.options.textAlign,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          );

    final onPressed = widget.onPressed != null
        ? (widget.showLoadingIndicator
            ? () async {
                if (loading) {
                  return;
                }
                setState(() => loading = true);
                try {
                  await widget.onPressed!();
                } finally {
                  if (mounted) {
                    setState(() => loading = false);
                  }
                }
              }
            : () => widget.onPressed!())
        : null;

    ButtonStyle style = ButtonStyle(
      shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
        (states) {
          if (states.contains(WidgetState.hovered) &&
              widget.options.hoverBorderSide != null) {
            return RoundedRectangleBorder(
              borderRadius:
                  widget.options.borderRadius ?? BorderRadius.circular(8),
              side: widget.options.hoverBorderSide!,
            );
          }
          return RoundedRectangleBorder(
            borderRadius:
                widget.options.borderRadius ?? BorderRadius.circular(8),
            side: widget.options.borderSide ?? BorderSide.none,
          );
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.disabled) &&
              widget.options.disabledTextColor != null) {
            return widget.options.disabledTextColor;
          }
          if (states.contains(WidgetState.hovered) &&
              widget.options.hoverTextColor != null) {
            return widget.options.hoverTextColor;
          }
          return widget.options.textStyle?.color ?? Colors.white;
        },
      ),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.disabled) &&
              widget.options.disabledColor != null) {
            return widget.options.disabledColor;
          }
          if (states.contains(WidgetState.hovered) &&
              widget.options.hoverColor != null) {
            return widget.options.hoverColor;
          }
          return widget.options.color;
        },
      ),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return widget.options.splashColor;
        }
        return widget.options.hoverColor == null ? null : Colors.transparent;
      }),
      padding: WidgetStateProperty.all(widget.options.padding ??
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0)),
      elevation: WidgetStateProperty.resolveWith<double?>(
        (states) {
          if (states.contains(WidgetState.hovered) &&
              widget.options.hoverElevation != null) {
            return widget.options.hoverElevation!;
          }
          return widget.options.elevation ?? 2.0;
        },
      ),
    );

    if ((widget.icon != null || widget.iconData != null) && !loading) {
      Widget icon = widget.icon ??
          FaIcon(
            widget.iconData!,
            size: widget.options.iconSize,
            color: widget.options.iconColor,
          );

      if (text == null) {
        return Container(
          height: widget.options.height,
          width: widget.options.width,
          decoration: BoxDecoration(
            border: Border.fromBorderSide(
              widget.options.borderSide ?? BorderSide.none,
            ),
            borderRadius:
                widget.options.borderRadius ?? BorderRadius.circular(8),
          ),
          child: IconButton(
            splashRadius: 1.0,
            icon: Padding(
              padding: widget.options.iconPadding ?? EdgeInsets.zero,
              child: icon,
            ),
            onPressed: onPressed,
            style: style,
          ),
        );
      }
      return SizedBox(
        height: widget.options.height,
        width: widget.options.width,
        child: ElevatedButton.icon(
          icon: Padding(
            padding: widget.options.iconPadding ?? EdgeInsets.zero,
            child: icon,
          ),
          label: textWidget,
          onPressed: onPressed,
          style: style,
        ),
      );
    }

    return SizedBox(
      height: widget.options.height,
      width: widget.options.width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: textWidget,
      ),
    );
  }
}

/// Extension on [TextStyle] to create a new [TextStyle] without the color property.
/// This extension method returns a new [TextStyle] object with all properties of the original [TextStyle] except for the color property, which is set to null.
///
/// Example usage:
/// ```dart
/// TextStyle myTextStyle = TextStyle(color: Colors.red, fontSize: 16);
/// TextStyle newTextStyle = myTextStyle.withoutColor();
/// ```
extension _WithoutColorExtension on TextStyle {
  /// Returns a new [TextStyle] object without the color property.
  TextStyle withoutColor() => TextStyle(
        inherit: inherit,
        color: null,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        height: height,
        leadingDistribution: leadingDistribution,
        locale: locale,
        foreground: foreground,
        background: background,
        shadows: shadows,
        fontFeatures: fontFeatures,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        debugLabel: debugLabel,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        overflow: overflow,
      );
}

// Slightly hacky method of getting the layout width of the provided text.
double? _getTextWidth(String? text, TextStyle? style, int maxLines) =>
    text != null
        ? (TextPainter(
            text: TextSpan(text: text, style: style),
            textDirection: TextDirection.ltr,
            maxLines: maxLines,
          )..layout())
            .size
            .width
        : null;
