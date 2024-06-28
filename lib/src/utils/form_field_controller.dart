import 'package:flutter/foundation.dart';

class FormFieldController<T> extends ValueNotifier<T?> {
  FormFieldController(this.initialValue) : super(initialValue);

  final T? initialValue;

  void reset() => value = initialValue;

  void update() => notifyListeners();
}

// If the initial value is a list (which it is for multiselect),
// we need to use this controller to avoid a pass by reference issue
// that can result in the initial value being modified.
class FormListFieldController<T> extends FormFieldController<List<T>> {
  FormListFieldController(super.initialValue)
      : _initialListValue = List<T>.from(initialValue ?? []);

  final List<T>? _initialListValue;

  @override
  void reset() => value = List<T>.from(_initialListValue ?? []);
}
