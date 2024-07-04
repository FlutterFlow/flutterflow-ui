import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../utils/form_field_controller.dart';

/// A dropdown widget that allows the user to select an option from a list of options.
class FlutterFlowDropDown<T> extends StatefulWidget {
  const FlutterFlowDropDown({
    super.key,
    this.controller,
    this.multiSelectController,
    this.hintText,
    this.searchHintText,
    required this.options,
    this.optionLabels,
    this.onChanged,
    this.onMultiSelectChanged,
    this.icon,
    this.width,
    this.height,
    this.maxHeight,
    this.fillColor,
    this.searchHintTextStyle,
    this.searchTextStyle,
    this.searchCursorColor,
    required this.textStyle,
    required this.elevation,
    required this.borderWidth,
    required this.borderRadius,
    required this.borderColor,
    required this.margin,
    this.hidesUnderline = false,
    this.disabled = false,
    this.isOverButton = false,
    this.menuOffset,
    this.isSearchable = false,
    this.isMultiSelect = false,
    this.labelText,
    this.labelTextStyle,
  }) : assert(
          isMultiSelect
              ? (controller == null &&
                  onChanged == null &&
                  multiSelectController != null &&
                  onMultiSelectChanged != null)
              : (controller != null &&
                  onChanged != null &&
                  multiSelectController == null &&
                  onMultiSelectChanged == null),
        );

  /// The controller for the dropdown field.
  final FormFieldController<T?>? controller;

  /// The controller for the multi-select dropdown field.
  final FormFieldController<List<T>?>? multiSelectController;

  /// The text to display as a hint when no option is selected.
  final String? hintText;

  /// The text to display as a hint in the search field.
  final String? searchHintText;

  /// The list of options to display in the dropdown.
  final List<T> options;

  /// The list of labels corresponding to the options.
  final List<String>? optionLabels;

  /// A callback function that is called when the selected option changes.
  final Function(T?)? onChanged;

  /// A callback function that is called when the selected options change in multi-select mode.
  final Function(List<T>?)? onMultiSelectChanged;

  /// The icon to display in the dropdown field.
  final Widget? icon;

  /// The width of the dropdown field.
  final double? width;

  /// The height of the dropdown field.
  final double? height;

  /// The maximum height of the dropdown menu.
  final double? maxHeight;

  /// The background color of the dropdown field.
  final Color? fillColor;

  /// The text style for the search hint text.
  final TextStyle? searchHintTextStyle;

  /// The text style for the search text.
  final TextStyle? searchTextStyle;

  /// The color of the search cursor.
  final Color? searchCursorColor;

  /// The text style for the dropdown field.
  final TextStyle textStyle;

  /// The elevation of the dropdown menu.
  final double elevation;

  /// The width of the dropdown field's border.
  final double borderWidth;

  /// The border radius of the dropdown field.
  final double borderRadius;

  /// The color of the dropdown field's border.
  final Color borderColor;

  /// The margin around the dropdown field.
  final EdgeInsetsGeometry margin;

  /// Whether to hide the underline of the dropdown field.
  final bool hidesUnderline;

  /// Whether the dropdown is disabled.
  final bool disabled;

  /// Whether the dropdown menu is displayed over the button.
  final bool isOverButton;

  /// The offset of the dropdown menu.
  final Offset? menuOffset;

  /// Whether the dropdown is searchable.
  final bool isSearchable;

  /// Whether the dropdown is in multi-select mode.
  final bool isMultiSelect;

  /// The label text for the dropdown field.
  final String? labelText;

  /// The text style for the label text.
  final TextStyle? labelTextStyle;

  @override
  State<FlutterFlowDropDown<T>> createState() => _FlutterFlowDropDownState<T>();
}

class _FlutterFlowDropDownState<T> extends State<FlutterFlowDropDown<T>> {
  bool get isMultiSelect => widget.isMultiSelect;
  FormFieldController<T?> get controller => widget.controller!;
  FormFieldController<List<T>?> get multiSelectController =>
      widget.multiSelectController!;

  T? get currentValue {
    final value = isMultiSelect
        ? multiSelectController.value?.firstOrNull
        : controller.value;
    return widget.options.contains(value) ? value : null;
  }

  Set<T> get currentValues {
    if (!isMultiSelect || multiSelectController.value == null) {
      return {};
    }
    return widget.options
        .toSet()
        .intersection(multiSelectController.value!.toSet());
  }

  Map<T, String> get optionLabels => Map.fromEntries(
        widget.options.asMap().entries.map(
              (option) => MapEntry(
                option.value,
                widget.optionLabels == null ||
                        widget.optionLabels!.length < option.key + 1
                    ? option.value.toString()
                    : widget.optionLabels![option.key],
              ),
            ),
      );

  EdgeInsetsGeometry get horizontalMargin => widget.margin.clamp(
        EdgeInsetsDirectional.zero,
        const EdgeInsetsDirectional.symmetric(horizontal: double.infinity),
      );

  late void Function() _listener;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (isMultiSelect) {
      _listener =
          () => widget.onMultiSelectChanged!(multiSelectController.value);
      multiSelectController.addListener(_listener);
    } else {
      _listener = () => widget.onChanged!(controller.value);
      controller.addListener(_listener);
    }
  }

  @override
  void dispose() {
    if (isMultiSelect) {
      multiSelectController.removeListener(_listener);
    } else {
      controller.removeListener(_listener);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dropdownWidget = _buildDropdownWidget();
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
          color: widget.fillColor,
        ),
        child: Padding(
          padding: _useDropdown2() ? EdgeInsets.zero : widget.margin,
          child: widget.hidesUnderline
              ? DropdownButtonHideUnderline(child: dropdownWidget)
              : dropdownWidget,
        ),
      ),
    );
  }

  bool _useDropdown2() =>
      widget.isMultiSelect ||
      widget.isSearchable ||
      !widget.isOverButton ||
      widget.maxHeight != null;

  Widget _buildDropdownWidget() =>
      _useDropdown2() ? _buildDropdown() : _buildLegacyDropdown();

  Widget _buildLegacyDropdown() {
    return DropdownButtonFormField<T>(
      value: currentValue,
      hint: _createHintText(),
      items: _createMenuItems(),
      elevation: widget.elevation.toInt(),
      onChanged: widget.disabled ? null : (value) => controller.value = value,
      icon: widget.icon,
      isExpanded: true,
      dropdownColor: widget.fillColor,
      focusColor: Colors.transparent,
      decoration: InputDecoration(
        labelText: widget.labelText == null || widget.labelText!.isEmpty
            ? null
            : widget.labelText,
        labelStyle: widget.labelTextStyle,
        border: widget.hidesUnderline
            ? InputBorder.none
            : const UnderlineInputBorder(),
      ),
    );
  }

  Text? _createHintText() => widget.hintText != null
      ? Text(widget.hintText!, style: widget.textStyle)
      : null;

  List<DropdownMenuItem<T>> _createMenuItems() => widget.options
      .map(
        (option) => DropdownMenuItem<T>(
          value: option,
          child: Padding(
            padding: _useDropdown2() ? horizontalMargin : EdgeInsets.zero,
            child: Text(optionLabels[option] ?? '', style: widget.textStyle),
          ),
        ),
      )
      .toList();

  List<DropdownMenuItem<T>> _createMultiselectMenuItems() => widget.options
      .map(
        (item) => DropdownMenuItem<T>(
          value: item,
          // Disable default onTap to avoid closing menu when selecting an item
          enabled: false,
          child: StatefulBuilder(
            builder: (context, menuSetState) {
              final isSelected =
                  multiSelectController.value?.contains(item) ?? false;
              return InkWell(
                onTap: () {
                  multiSelectController.value ??= [];
                  isSelected
                      ? multiSelectController.value!.remove(item)
                      : multiSelectController.value!.add(item);
                  multiSelectController.update();
                  // This rebuilds the StatefulWidget to update the button's text.
                  setState(() {});
                  // This rebuilds the dropdownMenu Widget to update the check mark.
                  menuSetState(() {});
                },
                child: Container(
                  height: double.infinity,
                  padding: horizontalMargin,
                  child: Row(
                    children: [
                      if (isSelected)
                        const Icon(Icons.check_box_outlined)
                      else
                        const Icon(Icons.check_box_outline_blank),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          optionLabels[item]!,
                          style: widget.textStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      )
      .toList();

  Widget _buildDropdown() {
    final overlayColor = WidgetStateProperty.resolveWith<Color?>((states) =>
        states.contains(WidgetState.focused) ? Colors.transparent : null);
    final iconStyleData = widget.icon != null
        ? IconStyleData(icon: widget.icon!)
        : const IconStyleData();
    return DropdownButton2<T>(
      value: currentValue,
      hint: _createHintText(),
      items: isMultiSelect ? _createMultiselectMenuItems() : _createMenuItems(),
      iconStyleData: iconStyleData,
      buttonStyleData: ButtonStyleData(
        elevation: widget.elevation.toInt(),
        overlayColor: overlayColor,
        padding: widget.margin,
      ),
      menuItemStyleData: MenuItemStyleData(
        overlayColor: overlayColor,
        padding: EdgeInsets.zero,
      ),
      dropdownStyleData: DropdownStyleData(
        elevation: widget.elevation.toInt(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: widget.fillColor,
        ),
        isOverButton: widget.isOverButton,
        offset: widget.menuOffset ?? Offset.zero,
        maxHeight: widget.maxHeight,
        padding: EdgeInsets.zero,
      ),
      onChanged: widget.disabled
          ? null
          : (isMultiSelect ? (_) {} : (val) => widget.controller!.value = val),
      isExpanded: true,
      selectedItemBuilder: (context) => widget.options
          .map(
            (item) => Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                isMultiSelect
                    ? currentValues
                        .where((v) => optionLabels.containsKey(v))
                        .map((v) => optionLabels[v])
                        .join(', ')
                    : optionLabels[item]!,
                style: widget.textStyle,
                maxLines: 1,
              ),
            ),
          )
          .toList(),
      dropdownSearchData: widget.isSearchable
          ? DropdownSearchData<T>(
              searchController: _textEditingController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Container(
                height: 50,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  controller: _textEditingController,
                  cursorColor: widget.searchCursorColor,
                  style: widget.searchTextStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: widget.searchHintText,
                    hintStyle: widget.searchHintTextStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return (optionLabels[item.value] ?? '')
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            )
          : null,
      // This is to clear the search value when you close the menu
      onMenuStateChange: widget.isSearchable
          ? (isOpen) {
              if (!isOpen) {
                _textEditingController.clear();
              }
            }
          : null,
    );
  }
}
