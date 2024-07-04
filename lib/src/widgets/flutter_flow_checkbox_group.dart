import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterflow_ui/src/utils/form_field_controller.dart';

/// A group of checkboxes that allows the user to select multiple options.
class FlutterFlowCheckboxGroup extends StatefulWidget {
  /// Creates a [FlutterFlowCheckboxGroup].
  ///
  /// - [options] parameter is a list of strings representing the available options.
  /// - [onChanged] parameter is a callback function that is called when the selection changes.
  /// - [controller] parameter is a controller for the form field that holds the selected options.
  /// - [textStyle] parameter is the style of the text for the checkboxes.
  /// - [labelPadding] parameter is the padding around the checkbox labels.
  /// - [itemPadding] parameter is the padding around each checkbox item.
  /// - [activeColor] parameter is the color of the checkbox when it is selected.
  /// - [checkColor] parameter is the color of the check mark inside the checkbox.
  /// - [checkboxBorderRadius] parameter is the border radius of the checkbox.
  /// - [checkboxBorderColor] parameter is the color of the checkbox border.
  /// - [initialized] parameter indicates whether the checkbox group is initialized with a value.
  /// - [unselectedTextStyle] parameter is the style of the text for unselected checkboxes.
  const FlutterFlowCheckboxGroup({
    super.key,
    required this.options,
    required this.onChanged,
    required this.controller,
    required this.textStyle,
    this.labelPadding,
    this.itemPadding,
    required this.activeColor,
    required this.checkColor,
    this.checkboxBorderRadius,
    required this.checkboxBorderColor,
    this.initialized = true,
    this.unselectedTextStyle,
  });

  final List<String> options;
  final void Function(List<String>)? onChanged;
  final FormFieldController<List<String>> controller;
  final TextStyle textStyle;
  final EdgeInsetsGeometry? labelPadding;
  final EdgeInsetsGeometry? itemPadding;
  final Color activeColor;
  final Color checkColor;
  final BorderRadius? checkboxBorderRadius;
  final Color checkboxBorderColor;
  final bool initialized;
  final TextStyle? unselectedTextStyle;

  @override
  State<FlutterFlowCheckboxGroup> createState() =>
      _FlutterFlowCheckboxGroupState();
}

class _FlutterFlowCheckboxGroupState extends State<FlutterFlowCheckboxGroup> {
  late List<String> checkboxValues;
  late void Function() _selectedValueListener;
  ValueListenable<List<String>?> get changeSelectedValues => widget.controller;
  List<String> get selectedValues => widget.controller.value ?? [];

  @override
  void initState() {
    super.initState();
    checkboxValues = List.from(widget.controller.initialValue ?? []);
    if (!widget.initialized && checkboxValues.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) {
          if (widget.onChanged != null) {
            widget.onChanged!(checkboxValues);
          }
        },
      );
    }
    _selectedValueListener = () {
      if (!listEquals(checkboxValues, selectedValues)) {
        setState(() => checkboxValues = List.from(selectedValues));
      }
      if (widget.onChanged != null) {
        widget.onChanged!(selectedValues);
      }
    };
    changeSelectedValues.addListener(_selectedValueListener);
  }

  @override
  void dispose() {
    changeSelectedValues.removeListener(_selectedValueListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: widget.options.length,
        itemBuilder: (context, index) {
          final option = widget.options[index];
          final selected = selectedValues.contains(option);
          final unselectedTextStyle =
              widget.unselectedTextStyle ?? widget.textStyle;
          return Theme(
            data: ThemeData(unselectedWidgetColor: widget.checkboxBorderColor),
            child: Padding(
              padding: widget.itemPadding ?? EdgeInsets.zero,
              child: Row(
                children: [
                  Checkbox(
                    value: selected,
                    onChanged: widget.onChanged != null
                        ? (isSelected) {
                            if (isSelected == null) {
                              return;
                            }
                            isSelected
                                ? checkboxValues.add(option)
                                : checkboxValues.remove(option);
                            widget.controller.value = List.from(checkboxValues);
                            setState(() {});
                          }
                        : null,
                    activeColor: widget.activeColor,
                    checkColor: widget.checkColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          widget.checkboxBorderRadius ?? BorderRadius.zero,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  Expanded(
                    child: Padding(
                      padding: widget.labelPadding ?? EdgeInsets.zero,
                      child: Text(
                        widget.options[index],
                        style:
                            selected ? widget.textStyle : unselectedTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
