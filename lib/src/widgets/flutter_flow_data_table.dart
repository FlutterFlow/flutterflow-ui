import 'dart:math' as math;

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

export 'package:data_table_2/data_table_2.dart' show DataColumn2;

const _kDataTableHorizontalMargin = 48.0;
const kDefaultColumnSpacing = 56.0;
const _kMinRowsPerPage = 5;

typedef ColumnsBuilder<T> = List<DataColumn> Function(void Function(int, bool));
typedef DataRowBuilder<T> = DataRow? Function(
    T, int, bool, void Function(bool?)?);

class FlutterFlowDataTableController<T> extends DataTableSource {
  FlutterFlowDataTableController({
    List<T>? initialData,
    int? numRows,
    PaginatorController? paginatorController,
    bool selectable = false,
  }) {
    data = initialData?.toList() ?? [];
    numRows = numRows;
    this.paginatorController = paginatorController ?? PaginatorController();
    _selectable = selectable;
  }

  DataRowBuilder<T>? _dataRowBuilder;
  late PaginatorController paginatorController;
  List<T> data = [];
  int? _numRows;
  List<T> get selectedData =>
      selectedRows.where((i) => i < data.length).map(data.elementAt).toList();

  bool _selectable = false;
  final Set<int> selectedRows = {};

  int rowsPerPage = defaultRowsPerPage;
  int? sortColumnIndex;
  bool sortAscending = true;

  void init({
    DataRowBuilder<T>? dataRowBuilder,
    bool? selectable,
    List<T>? initialData,
    int? initialNumRows,
  }) {
    _dataRowBuilder = dataRowBuilder ?? _dataRowBuilder;
    _selectable = selectable ?? _selectable;
    data = initialData?.toList() ?? data;
    _numRows = initialNumRows;
  }

  void updateData({
    List<T>? data,
    int? numRows,
    bool notify = true,
  }) {
    this.data = data?.toList() ?? this.data;
    _numRows = numRows ?? _numRows;
    if (notify) {
      notifyListeners();
    }
  }

  void updateSort({
    required int columnIndex,
    required bool ascending,
    Function(int, bool)? onSortChanged,
  }) {
    sortColumnIndex = columnIndex;
    sortAscending = ascending;
    if (onSortChanged != null) {
      onSortChanged(columnIndex, ascending);
    }
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    final row = data.elementAtOrNull(index);
    return _dataRowBuilder != null && row != null
        ? _dataRowBuilder!(
            row,
            index,
            selectedRows.contains(index),
            _selectable
                ? (selected) {
                    if (selected == null) {
                      return;
                    }
                    selected
                        ? selectedRows.add(index)
                        : selectedRows.remove(index);
                    notifyListeners();
                  }
                : null,
          )
        : null;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _numRows ?? data.length;

  @override
  int get selectedRowCount => selectedRows.length;
}

class FlutterFlowDataTable<T> extends StatefulWidget {
  const FlutterFlowDataTable({
    super.key,
    required this.controller,
    required this.data,
    this.numRows,
    required this.columnsBuilder,
    required this.dataRowBuilder,
    this.emptyBuilder,
    this.onPageChanged,
    this.onSortChanged,
    this.onRowsPerPageChanged,
    this.paginated = true,
    this.selectable = false,
    this.hidePaginator = false,
    this.showFirstLastButtons = false,
    this.width,
    this.height,
    this.minWidth,
    this.headingRowHeight = 56,
    this.dataRowHeight = kMinInteractiveDimension,
    this.columnSpacing = kDefaultColumnSpacing,
    this.headingRowColor,
    this.sortIconColor,
    this.borderRadius,
    this.addHorizontalDivider = true,
    this.addTopAndBottomDivider = false,
    this.hideDefaultHorizontalDivider = false,
    this.addVerticalDivider = false,
    this.horizontalDividerColor,
    this.horizontalDividerThickness,
    this.verticalDividerColor,
    this.verticalDividerThickness,
    this.checkboxUnselectedFillColor,
    this.checkboxSelectedFillColor,
    this.checkboxUnselectedBorderColor,
    this.checkboxSelectedBorderColor,
    this.checkboxCheckColor,
  });

  final FlutterFlowDataTableController<T> controller;
  final List<T> data;
  final int? numRows;
  final ColumnsBuilder columnsBuilder;
  final DataRowBuilder<T> dataRowBuilder;
  final Widget? Function()? emptyBuilder;
  // Callback functions
  final Function(int)? onPageChanged;
  final Function(int, bool)? onSortChanged;
  final Function(int)? onRowsPerPageChanged;
  // Functionality options
  final bool paginated;
  final bool selectable;
  final bool showFirstLastButtons;
  final bool hidePaginator;
  // Size and shape options
  final double? width;
  final double? height;
  final double? minWidth;
  final double headingRowHeight;
  final double dataRowHeight;
  final double columnSpacing;
  // Table style options
  final Color? headingRowColor;
  final Color? sortIconColor;
  final BorderRadius? borderRadius;
  final bool addHorizontalDivider;
  final bool addTopAndBottomDivider;
  final bool hideDefaultHorizontalDivider;
  final Color? horizontalDividerColor;
  final double? horizontalDividerThickness;
  final bool addVerticalDivider;
  final Color? verticalDividerColor;
  final double? verticalDividerThickness;
  // Checkbox style options
  final Color? checkboxUnselectedFillColor;
  final Color? checkboxSelectedFillColor;
  final Color? checkboxUnselectedBorderColor;
  final Color? checkboxSelectedBorderColor;
  final Color? checkboxCheckColor;

  @override
  State<FlutterFlowDataTable<T>> createState() =>
      _FlutterFlowDataTableState<T>();
}

class _FlutterFlowDataTableState<T> extends State<FlutterFlowDataTable<T>> {
  FlutterFlowDataTableController<T> get controller => widget.controller;
  int get rowCount => controller.rowCount;

  int get initialRowsPerPage =>
      rowCount > _kMinRowsPerPage ? defaultRowsPerPage : _kMinRowsPerPage;

  @override
  void initState() {
    super.initState();
    dataTableShowLogs = false; // Disables noisy DataTable2 debug statements.
    controller.init(
      dataRowBuilder: widget.dataRowBuilder,
      selectable: widget.selectable,
      initialData: widget.data,
      initialNumRows: widget.numRows,
    );
    // ignore: cascade_invocations
    controller.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(FlutterFlowDataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    controller.updateData(
      data: widget.data,
      numRows: widget.numRows,
      notify: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final columns = widget.columnsBuilder(
      (index, ascending) {
        controller.updateSort(
          columnIndex: index,
          ascending: ascending,
          onSortChanged: widget.onSortChanged,
        );
        setState(() {});
      },
    );

    final checkboxThemeData = CheckboxThemeData(
      checkColor: MaterialStateProperty.all(
        widget.checkboxCheckColor ?? Colors.black54,
      ),
      fillColor: MaterialStateProperty.resolveWith(
        (states) => states.contains(MaterialState.selected)
            ? widget.checkboxSelectedFillColor ?? Colors.white.withOpacity(0.01)
            : widget.checkboxUnselectedFillColor ??
                Colors.white.withOpacity(0.01),
      ),
      side: MaterialStateBorderSide.resolveWith(
        (states) => BorderSide(
          width: 2.0,
          color: states.contains(MaterialState.selected)
              ? widget.checkboxSelectedBorderColor ?? Colors.black54
              : widget.checkboxUnselectedBorderColor ?? Colors.black54,
        ),
      ),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
    );

    final horizontalBorder = widget.addHorizontalDivider
        ? BorderSide(
            color: widget.horizontalDividerColor ?? Colors.transparent,
            width: widget.horizontalDividerThickness ?? 1.0,
          )
        : BorderSide.none;

    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: widget.sortIconColor != null
                ? IconThemeData(color: widget.sortIconColor)
                : null,
          ),
          child: PaginatedDataTable2(
            source: controller,
            controller:
                widget.paginated ? controller.paginatorController : null,
            rowsPerPage: widget.paginated ? initialRowsPerPage : rowCount,
            availableRowsPerPage: const [5, 10, 25, 50, 100],
            onPageChanged: widget.onPageChanged != null
                ? (index) => widget.onPageChanged!(index)
                : null,
            columnSpacing: widget.columnSpacing,
            onRowsPerPageChanged: widget.paginated
                ? (value) {
                    controller.rowsPerPage = value ?? initialRowsPerPage;
                    if (widget.onRowsPerPageChanged != null) {
                      widget.onRowsPerPageChanged!(controller.rowsPerPage);
                    }
                  }
                : null,
            columns: columns,
            empty: widget.emptyBuilder != null ? widget.emptyBuilder!() : null,
            sortColumnIndex: controller.sortColumnIndex,
            sortAscending: controller.sortAscending,
            showCheckboxColumn: widget.selectable,
            datarowCheckboxTheme: checkboxThemeData,
            headingCheckboxTheme: checkboxThemeData,
            hidePaginator: !widget.paginated || widget.hidePaginator,
            wrapInCard: false,
            renderEmptyRowsInTheEnd: false,
            border: TableBorder(
              horizontalInside: horizontalBorder,
              verticalInside: widget.addVerticalDivider
                  ? BorderSide(
                      color: widget.verticalDividerColor ?? Colors.transparent,
                      width: widget.verticalDividerThickness ?? 1.0,
                    )
                  : BorderSide.none,
              bottom: widget.addTopAndBottomDivider
                  ? horizontalBorder
                  : BorderSide.none,
            ),
            dividerThickness: widget.hideDefaultHorizontalDivider ? 0.0 : null,
            headingRowColor: MaterialStateProperty.all(widget.headingRowColor),
            headingRowHeight: widget.headingRowHeight,
            dataRowHeight: widget.dataRowHeight,
            showFirstLastButtons: widget.showFirstLastButtons,
            minWidth: math.max(widget.minWidth ?? 0, _getColumnsWidth(columns)),
          ),
        ),
      ),
    );
  }

  // Return the total fixed width of all columns that have a specified width,
  // plus one to make the data table scrollable if there is insufficient space.
  double _getColumnsWidth(List<DataColumn> columns) =>
      columns.where((c) => c is DataColumn2 && c.fixedWidth != null).fold(
            ((widget.selectable ? 2 : 1) * _kDataTableHorizontalMargin) + 1,
            (sum, col) => sum + (col as DataColumn2).fixedWidth!,
          );
}
