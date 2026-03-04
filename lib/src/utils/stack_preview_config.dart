import 'package:flutter/material.dart';

import 'constants.dart';
import 'enums.dart';

/// Configuration for the Navigation Stack Previewer.
class StackPreviewConfig {
  /// The maximum number of routes to keep in the history.
  final int maxRoutes;

  /// The pixel ratio to use for thumbnail capture.
  /// Lower values save memory.
  final double pixelRatio;

  /// The primary color used for borders, labels, and icons in the history panel.
  final Color primaryColor;

  /// The background color of the history panel.
  final Color backgroundColor;

  /// The layout to use for the history preview.
  final StackPreviewLayout layout;

  /// The duration of the open/close animation.
  final Duration animationDuration;

  /// The curve of the open/close animation.
  final Curve animationCurve;

  /// The position from which the panel opens.
  final StackPreviewPosition position;

  /// The title shown in the history panel.
  final String title;

  /// Creates a new navigation stack previewer configuration.
  const StackPreviewConfig({
    this.maxRoutes = 5,
    this.pixelRatio = 0.5,
    this.primaryColor = AppConstants.defaultPrimaryColor,
    this.backgroundColor = Colors.white,
    this.layout = StackPreviewLayout.carousel,
    this.animationDuration = AppConstants.defaultAnimationDuration,
    this.animationCurve = Curves.fastOutSlowIn,
    this.position = StackPreviewPosition.top,
    this.title = '',
  });
}
