import 'package:flutter/material.dart';

import 'constants.dart';
import 'enums.dart';

/// Configuration for the Navigation Stack Previewer.
@immutable
class StackPreviewConfig {
  /// The maximum number of routes to keep in the history.
  final int maxRoutes;

  /// The height of the opened panel.
  final double panelHeight;

  /// The height of the enlarged panel.
  final double enlargedPanelHeight;

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
    this.maxRoutes = AppConstants.defaultMaxRoutes,
    this.panelHeight = AppConstants.defaultPanelHeight,
    this.enlargedPanelHeight = AppConstants.defaultEnlargedPanelHeight,
    this.pixelRatio = AppConstants.defaultPixelRatio,
    this.primaryColor = AppConstants.defaultPrimaryColor,
    this.backgroundColor = Colors.white,
    this.layout = StackPreviewLayout.carousel,
    this.animationDuration = AppConstants.defaultAnimationDuration,
    this.animationCurve = Curves.fastOutSlowIn,
    this.position = StackPreviewPosition.top,
    this.title = 'Navigation Stack',
  });

  StackPreviewConfig copyWith({
    int? maxRoutes,
    double? panelHeight,
    double? enlargedPanelHeight,
    double? pixelRatio,
    Color? primaryColor,
    Color? backgroundColor,
    StackPreviewLayout? layout,
    Duration? animationDuration,
    Curve? animationCurve,
    StackPreviewPosition? position,
    String? title,
  }) {
    return StackPreviewConfig(
      maxRoutes: maxRoutes ?? this.maxRoutes,
      panelHeight: panelHeight ?? this.panelHeight,
      enlargedPanelHeight: enlargedPanelHeight ?? this.enlargedPanelHeight,
      pixelRatio: pixelRatio ?? this.pixelRatio,
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      layout: layout ?? this.layout,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      position: position ?? this.position,
      title: title ?? this.title,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StackPreviewConfig &&
          runtimeType == other.runtimeType &&
          maxRoutes == other.maxRoutes &&
          panelHeight == other.panelHeight &&
          enlargedPanelHeight == other.enlargedPanelHeight &&
          pixelRatio == other.pixelRatio &&
          primaryColor == other.primaryColor &&
          backgroundColor == other.backgroundColor &&
          layout == other.layout &&
          animationDuration == other.animationDuration &&
          animationCurve == other.animationCurve &&
          position == other.position &&
          title == other.title;

  @override
  int get hashCode =>
      maxRoutes.hashCode ^
      panelHeight.hashCode ^
      enlargedPanelHeight.hashCode ^
      pixelRatio.hashCode ^
      primaryColor.hashCode ^
      backgroundColor.hashCode ^
      layout.hashCode ^
      animationDuration.hashCode ^
      animationCurve.hashCode ^
      position.hashCode ^
      title.hashCode;
}
