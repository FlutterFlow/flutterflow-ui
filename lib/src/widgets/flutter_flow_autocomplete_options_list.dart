import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:substring_highlight/substring_highlight.dart';

/// A widget that displays a list of autocomplete options for a text field.
class AutocompleteOptionsList extends StatelessWidget {
  const AutocompleteOptionsList({
    super.key,
    required this.textFieldKey,
    required this.textController,
    required this.options,
    required this.onSelected,
    required this.textStyle,
    this.textAlign = TextAlign.start,
    this.optionBackgroundColor,
    this.optionHighlightColor,
    this.textHighlightStyle,
    this.maxHeight,
    this.elevation = 4.0,
  });

  /// The key of the text field associated with the autocomplete options list.
  final GlobalKey textFieldKey;

  /// The controller for the text field.
  final TextEditingController textController;

  /// The list of autocomplete options.
  final List<String> options;

  /// The callback function that is called when an option is selected.
  final Function(String) onSelected;

  /// The color used to highlight the selected option.
  final Color? optionHighlightColor;

  /// The background color of the options.
  final Color? optionBackgroundColor;

  /// The style of the text in the options.
  final TextStyle textStyle;

  /// The style of the highlighted text in the options.
  final TextStyle? textHighlightStyle;

  /// The alignment of the text in the options.
  final TextAlign textAlign;

  /// The maximum height of the options list.
  final double? maxHeight;

  /// The elevation of the options list.
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final textFieldBox =
        textFieldKey.currentContext!.findRenderObject() as RenderBox;
    final textFieldWidth = textFieldBox.size.width;
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: elevation,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: textFieldWidth,
            maxHeight: maxHeight ?? 200,
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options.elementAt(index);
              return InkWell(
                onTap: () => onSelected(option),
                child: Builder(builder: (context) {
                  final bool highlight =
                      AutocompleteHighlightedOption.of(context) == index;
                  if (highlight) {
                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                      Scrollable.ensureVisible(context, alignment: 0.5);
                    });
                  }
                  return Container(
                    color: highlight
                        ? optionHighlightColor ?? Theme.of(context).focusColor
                        : optionBackgroundColor,
                    padding: const EdgeInsets.all(16.0),
                    child: SubstringHighlight(
                      text: option,
                      term: textController.text,
                      textStyle: textStyle,
                      textAlign: textAlign,
                      textStyleHighlight: textHighlightStyle ?? textStyle,
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
