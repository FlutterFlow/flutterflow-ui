import 'package:flutter/material.dart';

class KeepAliveWidgetWrapper extends StatefulWidget {
  const KeepAliveWidgetWrapper({
    super.key,
    required this.builder,
  });

  final WidgetBuilder builder;

  @override
  State<KeepAliveWidgetWrapper> createState() => _KeepAliveWidgetWrapperState();
}

class _KeepAliveWidgetWrapperState extends State<KeepAliveWidgetWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.builder(context);
  }
}
