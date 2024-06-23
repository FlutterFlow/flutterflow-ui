import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:substring_highlight/substring_highlight.dart';

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

  final GlobalKey textFieldKey;
  final TextEditingController textController;
  final List<String> options;
  final Function(String) onSelected;
  final Color? optionHighlightColor;
  final Color? optionBackgroundColor;
  final TextStyle textStyle;
  final TextStyle? textHighlightStyle;
  final TextAlign textAlign;
  final double? maxHeight;
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
