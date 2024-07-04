import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterflow_ui/src/utils/flutter_flow_helpers.dart';
import 'package:flutterflow_ui/src/utils/form_field_controller.dart';
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
    super.key,
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
    this.disabledColor,
    this.wrapped = true,
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
  final Color? disabledColor;
  final bool wrapped;

  @override
  State<FlutterFlowChoiceChips> createState() => _FlutterFlowChoiceChipsState();
}

class _FlutterFlowChoiceChipsState extends State<FlutterFlowChoiceChips> {
  late List<String> choiceChipValues;
  List<String> get selectedValues => widget.controller.value ?? [];

  @override
  void initState() {
    super.initState();
    choiceChipValues = List.from(selectedValues);
    if (!widget.initialized && choiceChipValues.isNotEmpty) {
      SchedulerBinding.instance.addPostFrameCallback(
        (_) {
          if (widget.onChanged != null) {
            widget.onChanged!(choiceChipValues);
          }
        },
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.options.map<Widget>(
      (option) {
        final selected = selectedValues.contains(option.label);
        final style =
            selected ? widget.selectedChipStyle : widget.unselectedChipStyle;
        return Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: ChoiceChip(
            selected: selected,
            onSelected: widget.onChanged != null
                ? (isSelected) {
                    choiceChipValues = List.from(selectedValues);
                    if (isSelected) {
                      widget.multiselect
                          ? choiceChipValues.add(option.label)
                          : choiceChipValues = [option.label];
                      widget.controller.value = List.from(choiceChipValues);
                      setState(() {});
                    } else {
                      if (widget.multiselect) {
                        choiceChipValues.remove(option.label);
                        widget.controller.value = List.from(choiceChipValues);
                        setState(() {});
                      }
                    }
                    widget.onChanged!(choiceChipValues);
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
            disabledColor: widget.disabledColor,
            selectedColor:
                selected ? widget.selectedChipStyle.backgroundColor : null,
            backgroundColor:
                selected ? null : widget.unselectedChipStyle.backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: style.borderRadius ?? BorderRadius.circular(16),
              side: BorderSide(
                color: style.borderColor ?? Colors.transparent,
                width: style.borderWidth ?? 0,
              ),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        );
      },
    ).toList();

    if (widget.wrapped) {
      return Wrap(
        spacing: widget.chipSpacing,
        runSpacing: widget.rowSpacing,
        alignment: widget.alignment,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: children,
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children.divide(
            SizedBox(width: widget.chipSpacing),
          ),
        ),
      );
    }
  }
}
