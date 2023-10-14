// Copyright 2023 To Mohamed Okaily (mo.okaily01@gmail.com)
// (www.mokaily.com). All rights reserved.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mouse_follower/mouse_follower.dart';

// Represents the state of the MouseFollower widget.
class MouseFollowerState {
  const MouseFollowerState({
    this.offset = Offset.zero,
    this.size = const Size(15, 15),
    this.decoration = kDefaultDecoration,
    this.customMouseCursor = MouseCursor.defer,
    this.alignment = Alignment.center,
    this.isHover = false,
    this.customDecoration,
    this.child,
    this.latency,
    this.animationDuration,
    this.animationCurve,
    this.customOnHoverMouseStylesStack,
    this.opacity,
  });

  // Default decoration for the animated mouse follower.
  static const BoxDecoration kDefaultDecoration = BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.blue,
  );

  final BoxDecoration decoration; // The decoration for the follower.
  final BoxDecoration? customDecoration; // The decoration for the follower.
  final MouseCursor? customMouseCursor; // The decoration for the follower.
  final Offset offset; // The offset of the follower.
  final Size? size; // The size of the follower.
  final Widget? child; // The size of the follower.
  final bool isHover; // Indicates if the mouse is hovering over the follower.
  final Duration?
      latency; // Indicates if the mouse is hovering over the follower.
  final Alignment?
      alignment; // Indicates if the mouse is hovering over the follower.
  final List<MouseStyle>?
      customOnHoverMouseStylesStack; // Indicates if the mouse is hovering over the follower.
  final Duration? animationDuration;
  final Curve? animationCurve;
  final double? opacity;
}

// Provides the state management for the MouseFollower widget.
class MouseFollowerProvider extends ChangeNotifier {
  MouseFollowerProvider();

  MouseFollowerState state = const MouseFollowerState();

  // Changes the cursor appearance and position based on the pointer hover event.
  void changeCursor(GlobalKey key,
      {BoxDecoration? decoration,
      Duration? animationDuration,
      Curve? animationCurve,
      MouseCursor? mouseCursor,
      List<MouseStyle>? customOnHoverMouseStylesStack,
      Alignment? alignment,
      Size? size,
      Widget? mouseChild,
      double? opacity,
      Duration? latency,
      required PointerHoverEvent event}) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    // Update the state to reflect the cursor change.
    state = MouseFollowerState(
      animationCurve: animationCurve,
      animationDuration: animationDuration,
      customDecoration: decoration,
      customMouseCursor: mouseCursor,
      customOnHoverMouseStylesStack: customOnHoverMouseStylesStack,
      size: size,
      alignment: alignment,
      isHover: true,
      opacity: opacity,
      child: mouseChild,
      latency: latency,
      offset: renderBox
          .localToGlobal(Offset.zero)
          .translate(event.localPosition.dx, event.localPosition.dy),
      decoration: MouseFollowerState.kDefaultDecoration
          .copyWith(color: Colors.blue.withAlpha(80), shape: BoxShape.circle),
    );
    notifyListeners();
  }

  // Resets the cursor appearance to its default state.
  void resetCursor() {
    state = const MouseFollowerState();
    notifyListeners();
  }

  // Updates the cursor position.
  void updateCursorPosition(Offset pos) {
    state = MouseFollowerState(offset: pos);
    notifyListeners();
  }
}
