import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

/// A widget that displays a stack of swipeable cards.
class FlutterFlowSwipeableStack extends StatefulWidget {
  /// Creates a [FlutterFlowSwipeableStack].
  ///
  /// - [itemBuilder] is a callback that builds the widget for each card in the stack.
  /// - [itemCount] is the total number of cards in the stack.
  /// - [controller] is the controller for the swipeable stack.
  /// - [onSwipeFn] is a callback that is called when a card is swiped.
  /// - [onRightSwipe] is a callback that is called when a card is swiped to the right.
  /// - [onLeftSwipe] is a callback that is called when a card is swiped to the left.
  /// - [onUpSwipe] is a callback that is called when a card is swiped up.
  /// - [onDownSwipe] is a callback that is called when a card is swiped down.
  /// - [loop] determines whether the stack should loop back to the beginning when the last card is swiped.
  /// - [cardDisplayCount] is the number of cards to display on the stack at a time.
  /// - [scale] is the scale factor for the cards in the stack.
  /// - [maxAngle] is the maximum rotation angle for the cards in the stack.
  /// - [threshold] is the swipe threshold for the cards in the stack.
  /// - [cardPadding] is the padding for each card in the stack.
  /// - [backCardOffset] is the offset for the back card in the stack.
  const FlutterFlowSwipeableStack({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    required this.controller,
    required this.onSwipeFn,
    required this.onRightSwipe,
    required this.onLeftSwipe,
    required this.onUpSwipe,
    required this.onDownSwipe,
    required this.loop,
    required this.cardDisplayCount,
    required this.scale,
    this.maxAngle,
    this.threshold,
    this.cardPadding,
    this.backCardOffset,
  });

  final Widget Function(BuildContext, int) itemBuilder;
  final CardSwiperController controller;
  final int itemCount;
  final Function(int) onSwipeFn;
  final Function(int) onRightSwipe;
  final Function(int) onLeftSwipe;
  final Function(int) onUpSwipe;
  final Function(int) onDownSwipe;
  final bool loop;
  final int cardDisplayCount;
  final double scale;
  final double? maxAngle;
  final double? threshold;
  final EdgeInsetsGeometry? cardPadding;
  final Offset? backCardOffset;

  @override
  State<FlutterFlowSwipeableStack> createState() => _FFSwipeableStackState();
}

class _FFSwipeableStackState extends State<FlutterFlowSwipeableStack> {
  @override
  Widget build(BuildContext context) {
    return CardSwiper(
      controller: widget.controller,
      onSwipe: (previousIndex, currentIndex, direction) {
        widget.onSwipeFn(previousIndex);
        if (direction == CardSwiperDirection.left) {
          widget.onLeftSwipe(previousIndex);
        } else if (direction == CardSwiperDirection.right) {
          widget.onRightSwipe(previousIndex);
        } else if (direction == CardSwiperDirection.top) {
          widget.onUpSwipe(previousIndex);
        } else if (direction == CardSwiperDirection.bottom) {
          widget.onDownSwipe(previousIndex);
        }
        return true;
      },
      cardsCount: widget.itemCount,
      cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
        return widget.itemBuilder(context, index);
      },
      isLoop: widget.loop,
      maxAngle: widget.maxAngle ?? 30,
      threshold:
          widget.threshold != null ? (100 * widget.threshold!).round() : 50,
      scale: widget.scale,
      padding: widget.cardPadding ??
          const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      backCardOffset: widget.backCardOffset ?? const Offset(0, 40),
      numberOfCardsDisplayed: min(widget.cardDisplayCount, widget.itemCount),
    );
  }
}
