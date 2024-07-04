import 'package:flutter/material.dart';

/// A widget that represents a toggle icon.
class ToggleIcon extends StatelessWidget {
  /// Creates a [ToggleIcon].
  ///
  /// - [value] parameter specifies whether the icon is currently toggled on or off.
  /// - [onPressed] parameter is a callback function that is called when the icon is pressed.
  /// - [onIcon] parameter specifies the widget to display when the icon is toggled on.
  /// - [offIcon] parameter specifies the widget to display when the icon is toggled off.
  const ToggleIcon({
    super.key,
    required this.value,
    required this.onPressed,
    required this.onIcon,
    required this.offIcon,
  });

  /// Whether the icon is currently toggled on or off.
  final bool value;

  /// A callback function that is called when the icon is pressed.
  final Function() onPressed;

  /// The widget to display when the icon is toggled on.
  final Widget onIcon;

  /// The widget to display when the icon is toggled off.
  final Widget offIcon;

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: onPressed,
        icon: value ? onIcon : offIcon,
      );
}
