// Copyright 2023 To Mohamed Okaily (mo.okaily01@gmail.com)
// (www.mokaily.com). All rights reserved.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/animated_mouse_follower_controller.dart';

/// A widget that adds animated cursor effects to its child within a mouse region.
class MouseFollower extends StatelessWidget {
  /// The widget to be wrapped with animated cursor effects.
  /// wrap the widget by the main app widget to avoid any problems
  final Widget child;

  /// List of mouse styles to apply.
  final List<MouseStyle>? mouseStylesStack;

  /// List of mouse styles to apply on hover only.
  final List<MouseStyle>? onHoverMouseStylesStack;

  /// Whether to show the default mouse cursor when the styles are empty.
  /// default value is 'true'.
  final bool showDefaultMouseStyle;

  /// The mouse follower will disappear when the screen width size is less than [mobileWidth].
  /// [mobileWidth] default size is '750'.
  final bool? isVisible;

  final MouseCursor defaultMouseCursor;
  final MouseCursor onHoverMouseCursor;

  const MouseFollower({
    Key? key,
    required this.child,
    this.mouseStylesStack,
    this.onHoverMouseStylesStack,
    this.showDefaultMouseStyle = true,
    this.isVisible,
    this.defaultMouseCursor = MouseCursor.defer,
    this.onHoverMouseCursor = MouseCursor.defer,
  }) : super(key: key);

  void _onCursorUpdate(PointerEvent event, BuildContext context) => context
      .read<MouseFollowerProvider>()
      .updateCursorPosition(event.position);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MouseFollowerProvider(),
      child: Consumer<MouseFollowerProvider>(
        child: child,
        builder: (context, provider, c) {
          final state = provider.state;
          final bool visibility;

          Widget ccc = MouseRegion(
            cursor: state.isHover ? state.customMouseCursor ?? onHoverMouseCursor : defaultMouseCursor,
            child: child,
          );

          if (isVisible == null) {
            visibility = kIsWeb || MediaQuery.of(context).size.width > 750;
          } else {
            visibility = isVisible!;
          }

          // Generate mouse styles lists.
          List<MouseStyle> generatedMouseStylesStack = [];
          List<MouseStyle> generatedOnHoverMouseStylesStack = [];

          if (mouseStylesStack != null && mouseStylesStack!.isNotEmpty) {
            generatedMouseStylesStack = mouseStylesStack!
                .map((item) => MouseStyle.copy(item,
                    showVisibleOnHover: item.visibleOnHover))
                .toList();
          } else if (showDefaultMouseStyle) {
            generatedMouseStylesStack.add(MouseStyle(
                decoration: state.decoration.copyWith(
                    color: Theme.of(context).primaryColor.withOpacity(0.2)),
                visibleOnHover: false));
          }

          if (state.isHover && state.customOnHoverMouseStylesStack != null) {
            generatedOnHoverMouseStylesStack = state
                .customOnHoverMouseStylesStack!
                .map((item) => MouseStyle.copy(item, showVisibleOnHover: true))
                .toList();
          } else if (onHoverMouseStylesStack != null &&
              onHoverMouseStylesStack!.isNotEmpty) {
            generatedOnHoverMouseStylesStack = onHoverMouseStylesStack!
                .map((item) => MouseStyle.copy(item, showVisibleOnHover: true))
                .toList();
          } else if (showDefaultMouseStyle) {
            generatedOnHoverMouseStylesStack.add(MouseStyle(
                size: const Size(36, 36),
                decoration: state.decoration.copyWith(
                    color: Theme.of(context).primaryColor.withOpacity(0.2)),
                visibleOnHover: true));
          }

          List<Widget> defaultList = [
            if (c != null) ccc,
            Positioned.fill(
              child: MouseRegion(
                opaque: false,
                onHover: (e) => _onCursorUpdate(e, context),
              ),
            ),
          ];

          // Generate widgets lists.
          List<Widget> mouseStyleListBackground = !state.isHover
              ? defaultList + generatedMouseStylesStack
              : defaultList +
                  generatedMouseStylesStack
                      .where((element) => element.visibleOnHover == true)
                      .toList() +
                  generatedOnHoverMouseStylesStack;

          return visibility
              ? Stack(
                  alignment: AlignmentDirectional.topStart,
                  textDirection: TextDirection.ltr,
                  children: mouseStyleListBackground,
                )
              : ccc;
        },
      ),
    );
  }
}

/// A widget representing a specific mouse cursor style.
class MouseStyle extends StatelessWidget {
  final Widget? child;
  final Size size;
  final BoxDecoration? decoration;
  final Duration latency;
  final Alignment? alignment;
  final bool opaque;
  final Duration animationDuration;
  final Curve? animationCurve;
  final Matrix4? transform;
  final bool visibleOnHover;
  final double opacity;

  const MouseStyle({
    super.key,
    this.child,
    this.size = const Size(15, 15),
    this.decoration,
    this.latency = const Duration(milliseconds: 25),
    this.alignment = Alignment.center,
    this.opacity = 1.0,
    this.opaque = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutExpo,
    this.transform,
    this.visibleOnHover = false,
  });

  // Add a copy constructor to create a deep copy of the object
  MouseStyle.copy(MouseStyle other,
      {super.key, required bool showVisibleOnHover})
      : visibleOnHover = showVisibleOnHover,
        size = other.size,
        latency = other.latency,
        child = other.child,
        decoration = other.decoration,
        alignment = other.alignment,
        animationDuration = other.animationDuration,
        animationCurve = other.animationCurve,
        opacity = other.opacity,
        opaque = other.opaque,
        transform = other.transform;

  @override
  Widget build(BuildContext context) {
    // Access the MouseFollowerProvider to get the current state
    final provider = context.read<MouseFollowerProvider>();
    final state = provider.state;

    // Determine if the widget is being hovered over
    final isHovering = state.isHover;

    // Calculate the width based on whether there is a custom size or a default width
    double w;
    // Calculate the height based on whether there is a custom size or a default height
    double h;

    if (isHovering && state.size != null) {
      w = state.size?.width ?? size.width;
      h = state.size?.height ?? size.height;
    } else {
      w = size.width;
      h = size.height;
    }

    // Determine whether the widget should be shown
    final shouldShow = visibleOnHover == true ? true : !isHovering;

    BoxDecoration? dec;
    if (isHovering) {
      dec = state.customDecoration ?? decoration;
    } else {
      dec = decoration;
    }

    Alignment cursorAlignment;
    if (isHovering && state.alignment != null) {
      cursorAlignment = state.alignment ?? alignment ?? Alignment.center;
    } else {
      cursorAlignment = alignment ?? Alignment.center;
    }

    double? t;
    double? l;
    if (cursorAlignment == Alignment.center) {
      t = state.offset.dy - h / 2;
      l = state.offset.dx - w / 2;
    } else if (alignment == Alignment.centerRight) {
      t = state.offset.dy - h / 2;
      l = state.offset.dx;
    } else if (alignment == Alignment.centerLeft) {
      t = state.offset.dy - h / 2;
      l = state.offset.dx - w;
    } else if (alignment == Alignment.bottomCenter) {
      t = state.offset.dy;
      l = state.offset.dx - w / 2;
    } else if (alignment == Alignment.bottomRight) {
      t = state.offset.dy;
      l = state.offset.dx;
    } else if (alignment == Alignment.bottomLeft) {
      t = state.offset.dy;
      l = state.offset.dx - w;
    } else if (alignment == Alignment.topCenter) {
      t = state.offset.dy - h;
      l = state.offset.dx - w / 2;
    } else if (alignment == Alignment.topRight) {
      t = state.offset.dy - h;
      l = state.offset.dx;
    } else if (alignment == Alignment.topLeft) {
      t = state.offset.dy - h;
      l = state.offset.dx - w;
    } else {
      t = state.offset.dy - h / 2;
      l = state.offset.dx - w / 2;
    }

    Duration mouseLatency;
    if (isHovering && state.latency != null) {
      mouseLatency = state.latency ?? latency;
    } else {
      mouseLatency = latency;
    }

    Duration? animatedDuration;
    if (isHovering && state.animationDuration != null) {
      animatedDuration = state.animationDuration;
    } else {
      animatedDuration = animatedDuration;
    }

    Curve? animatedCurve;
    if (isHovering && state.animationCurve != null) {
      animatedCurve = state.animationCurve;
    } else {
      animatedCurve = animationCurve;
    }

    double? customOpacity;
    if (isHovering && state.opacity != null) {
      customOpacity = state.opacity;
    } else {
      customOpacity = opacity;
    }

    return Visibility(
      visible: shouldShow,
      child: AnimatedPositioned(
        // Position the widget based on the offset and calculated width and height
        top: t,
        left: l,
        width: w,
        height: h,
        // Use the provided latencyDuration or a default duration
        duration: mouseLatency,
        child: IgnorePointer(
            child: Opacity(
              opacity: customOpacity ?? 1.0, // Set the opacity value (0.0 = fully transparent, 1.0 = fully opaque)
              child: AnimatedContainer(
                transform: transform,
                alignment: Alignment.center,
                clipBehavior:
                    dec == null ? Clip.none : Clip.antiAliasWithSaveLayer,
                decoration: dec,
                duration: animatedDuration ?? const Duration(milliseconds: 300),
                curve: animatedCurve ?? Curves.easeOutExpo,
                child: (isHovering &&
                        state.child != null &&
                        state.child.runtimeType != MouseStyle)
                    ? state.child
                    : child,
              ),
            ),
        ),
      ),
    );
  }
}
