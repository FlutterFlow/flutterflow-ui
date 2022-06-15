import 'dart:math';
import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

enum AnimationTrigger {
  onPageLoad,
  onActionTrigger,
}

class AnimationState {
  AnimationState({
    this.offset = const Offset(0, 0),
    this.opacity = 1,
    this.scale = 1,
  });
  final Offset offset;
  final double opacity;
  final double scale;
}

class AnimationInfo {
  AnimationInfo({
    this.curve = Curves.easeInOut,
    required this.trigger,
    required this.duration,
    this.delay = 0,
    this.fadeIn = false,
    required this.initialState,
    required this.finalState,
  });

  final Curve curve;
  final AnimationTrigger trigger;
  final int duration;
  final int delay;
  final bool fadeIn;
  final AnimationState initialState;
  final AnimationState finalState;
  late CurvedAnimation curvedAnimation;
}

void createAnimation(AnimationInfo animation, TickerProvider vsync) {
  animation.curvedAnimation = CurvedAnimation(
    parent: AnimationController(
      duration: Duration(milliseconds: animation.duration),
      vsync: vsync,
    ),
    curve: animation.curve,
  );
}

void startPageLoadAnimations(
    Iterable<AnimationInfo> animations, TickerProvider vsync) {
  animations.forEach((animation) async {
    createAnimation(animation, vsync);
    await Future.delayed(
      Duration(milliseconds: animation.delay),
      () => (animation.curvedAnimation.parent as AnimationController)
          .forward(from: 0.0),
    );
  });
}

void setupTriggerAnimations(
    Iterable<AnimationInfo> animations, TickerProvider vsync) {
  animations.forEach((animation) {
    createAnimation(animation, vsync);
  });
}

extension AnimatedWidgetExtension on Widget {
  Widget animated(Iterable<AnimationInfo> animationInfos) {
    final animationInfo = animationInfos.first;
    return AnimatedBuilder(
      animation: animationInfo.curvedAnimation,
      builder: (context, child) {
        if (child == null) {
          return Container();
        }
        // On Action Trigger animations are in this state when
        // they are first loaded, but before they are triggered.
        // The widget should remain as it is.
        if (animationInfo.curvedAnimation.status == AnimationStatus.dismissed) {
          return child;
        }
        var returnedWidget = child;
        if (animationInfo.initialState.offset.dx != 0 ||
            animationInfo.initialState.offset.dy != 0 ||
            animationInfo.finalState.offset.dx != 0 ||
            animationInfo.finalState.offset.dy != 0) {
          final xRange = animationInfo.finalState.offset.dx -
              animationInfo.initialState.offset.dx;
          final yRange = animationInfo.finalState.offset.dy -
              animationInfo.initialState.offset.dy;
          final xDelta = xRange * animationInfo.curvedAnimation.value;
          final yDelta = yRange * animationInfo.curvedAnimation.value;
          returnedWidget = Transform.translate(
            offset: Offset(
              animationInfo.initialState.offset.dx + xDelta,
              animationInfo.initialState.offset.dy + yDelta,
            ),
            child: returnedWidget,
          );
        }
        if (animationInfo.initialState.scale != 1 ||
            animationInfo.finalState.scale != 1) {
          final range =
              animationInfo.finalState.scale - animationInfo.initialState.scale;
          final delta = range * animationInfo.curvedAnimation.value;
          final scale = animationInfo.initialState.scale + delta;

          returnedWidget = Transform.scale(
            scale: scale,
            child: returnedWidget,
          );
        }
        if (animationInfo.fadeIn) {
          final opacityRange = animationInfo.finalState.opacity -
              animationInfo.initialState.opacity;
          final opacityDelta =
              animationInfo.curvedAnimation.value * opacityRange;
          final opacity = animationInfo.initialState.opacity + opacityDelta;

          returnedWidget = Opacity(
            // In cases where the child tree has a Material widget with elevation,
            // opacity animations may result in sudden box shadow "glitches"
            // To prevent this, opacity is animated up to but NOT including 1.0.
            // It is impossible to tell the difference between 0.998 and 1.0 opacity.
            opacity: min(0.998, opacity),
            child: returnedWidget,
          );
        }
        return returnedWidget;
      },
      child:
          animationInfos.length > 1 ? animated(animationInfos.skip(1)) : this,
    );
  }
}
