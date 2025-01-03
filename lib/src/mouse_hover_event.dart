// Copyright 2023 To Mohamed Okaily (mo.okaily01@gmail.com)
// (www.mokaily.com). All rights reserved.

import 'package:flutter/material.dart';
import 'package:mouse_follower/mouse_follower.dart';
import 'package:provider/provider.dart';

import 'controller/animated_mouse_follower_controller.dart';

/// A widget that adds animated cursor effects to its child within a mouse region.
class MouseOnHoverEvent extends StatefulWidget {
  /// Creates an [MouseOnHoverEvent] with the specified [child].
  const MouseOnHoverEvent(
      {super.key,
      required this.child,
      this.decoration,
      this.size,
      this.mouseChild,
      this.onHoverMouseCursor,
      this.customOnHoverMouseStylesStack,
      this.animationCurve,
      this.animationDuration,
      this.opacity,
      this.alignment,
      this.latency});

  /// The widget that is wrapped with the animated cursor mouse region.
  final Widget child;

  /// By adding [decoration] it will override the styles of [onHoverMouseStylesStack].
  /// if you used decoration to add [color] it will replace the color only not the whole decoration.
  final BoxDecoration? decoration;

  /// By adding [size] it will override the main size of [onHoverMouseStylesStack].
  final Size? size;

  /// You can add child to the mouse style but you can't add [MouseStyle()].
  final Widget? mouseChild;

  /// By adding [latency] it will override the latency duration of [onHoverMouseStylesStack].
  final Duration? latency;

  final MouseCursor? onHoverMouseCursor;
  final List<MouseStyle>? customOnHoverMouseStylesStack;

  final Duration? animationDuration;
  final Curve? animationCurve;
  final Alignment? alignment;
  final double? opacity;

  @override
  MouseOnHoverEventState createState() => MouseOnHoverEventState();
}

/// The state of the [MouseOnHoverEvent] widget.
class MouseOnHoverEventState extends State<MouseOnHoverEvent> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final provider = context.read<MouseFollowerProvider>();

    return MouseRegion(
      key: _key,
      opaque: false,
      onHover: (event) => provider.changeCursor(_key,
          latency: widget.latency,
          mouseCursor: widget.onHoverMouseCursor,
          decoration: widget.decoration,
          mouseChild: widget.mouseChild,
          customOnHoverMouseStylesStack: widget.customOnHoverMouseStylesStack,
          size: widget.size,
          animationCurve: widget.animationCurve,
          animationDuration: widget.animationDuration,
          alignment: widget.alignment,
          opacity: widget.opacity,
          event: event),
      onExit: (_) => provider.resetCursor(),
      child: widget.child,
    );
  }
}
