import 'form_field_controller.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChipData {
  const ChipData(this.label, [this.iconData]);
  final String label;
  final IconData? iconData;
}

class ChipStyle {
  const ChipStyle({
    this.backgroundColor,
    this.textStyle,
    this.iconColor,
    this.iconSize,
    this.labelPadding,
    this.elevation,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
  });
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsetsGeometry? labelPadding;
  final double? elevation;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
}

class FlutterFlowChoiceChips extends StatefulWidget {
  const FlutterFlowChoiceChips({
    required this.options,
    required this.onChanged,
    required this.controller,
    required this.selectedChipStyle,
    required this.unselectedChipStyle,
    required this.chipSpacing,
    this.rowSpacing = 0.0,
    required this.multiselect,
    this.initialized = true,
    this.alignment = WrapAlignment.start,
  });

  final List<ChipData> options;
  final void Function(List<String>?)? onChanged;
  final FormFieldController<List<String>> controller;
  final ChipStyle selectedChipStyle;
  final ChipStyle unselectedChipStyle;
  final double chipSpacing;
  final double rowSpacing;
  final bool multiselect;
  final bool initialized;
  final WrapAlignment alignment;

  @override
  State<FlutterFlowChoiceChips> createState() => _FlutterFlowChoiceChipsState();
}

class _FlutterFlowChoiceChipsState extends State<FlutterFlowChoiceChips> {
  late List<String> choiceChipValues;
  ValueListenable<List<String>?> get changeSelectedValues => widget.controller;
  List<String> get selectedValues => widget.controller.value ?? [];

  @override
  void initState() {
    super.initState();
    choiceChipValues = List.from(widget.controller.initialValue ?? []);
    if (!widget.initialized && choiceChipValues.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) {
          if (widget.onChanged != null) {
            widget.onChanged!(choiceChipValues);
          }
        },
      );
    }
    changeSelectedValues.addListener(() {
      if (!listEquals(choiceChipValues, selectedValues)) {
        setState(() => choiceChipValues = List.from(selectedValues));
      }
      if (widget.onChanged != null) {
        widget.onChanged!(selectedValues);
      }
    });
  }

  @override
  void dispose() {
    changeSelectedValues.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: widget.chipSpacing,
        runSpacing: widget.rowSpacing,
        alignment: widget.alignment,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ...widget.options.map(
            (option) {
              final selected = choiceChipValues.contains(option.label);
              final style = selected
                  ? widget.selectedChipStyle
                  : widget.unselectedChipStyle;
              return ChoiceChip(
                selected: selected,
                onSelected: widget.onChanged != null
                    ? (isSelected) {
                        if (isSelected) {
                          widget.multiselect
                              ? choiceChipValues.add(option.label)
                              : choiceChipValues = [option.label];
                          widget.controller.value = List.from(choiceChipValues);
                          setState(() {});
                        } else {
                          if (widget.multiselect) {
                            choiceChipValues.remove(option.label);
                            widget.controller.value =
                                List.from(choiceChipValues);
                            setState(() {});
                          }
                        }
                      }
                    : null,
                label: Text(
                  option.label,
                  style: style.textStyle,
                ),
                labelPadding: style.labelPadding,
                avatar: option.iconData != null
                    ? FaIcon(
                        option.iconData,
                        size: style.iconSize,
                        color: style.iconColor,
                      )
                    : null,
                elevation: style.elevation,
                selectedColor:
                    selected ? widget.selectedChipStyle.backgroundColor : null,
                backgroundColor: selected
                    ? null
                    : widget.unselectedChipStyle.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: style.borderRadius ?? BorderRadius.circular(16),
                  side: BorderSide(
                    color: style.borderColor ?? Colors.transparent,
                    width: style.borderWidth ?? 0,
                  ),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            },
          ).toList(),
        ],
      );
}
