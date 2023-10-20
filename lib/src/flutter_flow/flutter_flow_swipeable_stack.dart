import 'dart:math';

import 'package:flutter/material.dart';
import 'package:swipeable_card_stack/swipeable_card_stack.dart';

class FlutterFlowSwipeableStack extends StatefulWidget {
  const FlutterFlowSwipeableStack({
    Key? key,
    required this.topCardHeightFraction,
    required this.middleCardHeightFraction,
    required this.bottomCardHeightFraction,
    required this.topCardWidthFraction,
    required this.middleCardWidthFraction,
    required this.bottomCardWidthFraction,
    required this.itemBuilder,
    required this.itemCount,
    required this.controller,
    required this.enableSwipeUp,
    required this.enableSwipeDown,
    required this.onSwipeFn,
    required this.onRightSwipe,
    required this.onLeftSwipe,
    required this.onUpSwipe,
    required this.onDownSwipe,
  }) : super(key: key);

  final double topCardHeightFraction;
  final double middleCardHeightFraction;
  final double topCardWidthFraction;
  final double bottomCardHeightFraction;
  final double middleCardWidthFraction;
  final double bottomCardWidthFraction;
  final Widget Function(BuildContext, int) itemBuilder;
  final SwipeableCardSectionController controller;
  final int itemCount;
  final bool enableSwipeUp;
  final bool enableSwipeDown;
  final Function(int) onSwipeFn;
  final Function(int) onRightSwipe;
  final Function(int) onLeftSwipe;
  final Function(int) onUpSwipe;
  final Function(int) onDownSwipe;

  @override
  _FFSwipeableStackState createState() => _FFSwipeableStackState();
}

List<Widget> getItems(int itemCount, BuildContext context,
    Widget Function(BuildContext, int) itemBuilder) {
  List<Widget> items = [];
  var limit = min(3, itemCount);
  for (int i = 0; i < limit; i++) {
    items.add(itemBuilder(context, i));
  }
  return items;
}

class _FFSwipeableStackState extends State<FlutterFlowSwipeableStack> {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          SwipeableCardsSection(
            cardController: widget.controller,
            context: context,
            cardWidthTopMul: widget.topCardWidthFraction,
            cardHeightTopMul: widget.topCardHeightFraction,
            cardWidthBottomMul: widget.bottomCardWidthFraction,
            cardHeightBottomMul: widget.bottomCardHeightFraction,
            cardWidthMiddleMul: widget.middleCardWidthFraction,
            cardHeightMiddleMul: widget.middleCardHeightFraction,
            items: getItems(widget.itemCount, context, widget.itemBuilder),
            onCardSwiped: (dir, int index, _) {
              if (index + 3 < widget.itemCount) {
                widget.controller
                    .addItem(widget.itemBuilder(context, index + 3));
              }
              widget.onSwipeFn(index);
              if (dir == Direction.left) {
                widget.onLeftSwipe(index);
              } else if (dir == Direction.right) {
                widget.onRightSwipe(index);
              } else if (dir == Direction.up) {
                widget.onUpSwipe(index);
              } else if (dir == Direction.down) {
                widget.onDownSwipe(index);
              }
            },
            enableSwipeUp: widget.enableSwipeUp,
            enableSwipeDown: widget.enableSwipeDown,
          ),
        ],
      );
}
