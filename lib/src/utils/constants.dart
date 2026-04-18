import 'package:flutter/material.dart';

class AppConstants {
  // Sizing & Spacing
  static const double s2 = 2.0;
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s10 = 10.0;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s28 = 28.0;

  // Strings
  static const String noHistoryMessage = 'No history items yet.';
  static const String currentLabel = 'Current';

  // Behavior & Durations
  static const Duration captureDelay = Duration(milliseconds: 350);
  static const double defaultSwipeThreshold = 80.0;
  static const int defaultMaxRoutes = 10;
  static const double defaultPanelHeight = 350.0;
  static const double defaultEnlargedPanelHeight = 700.0;
  static const double defaultPixelRatio = 0.5;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);

  // Ratios & Radii
  static const double backgroundBlurOffest = 4.0;
  static const double backgroundBlurOpacity = 0.3;
  static const double historyItemAspectRatio = 9 / 16;
  static const Offset boxShadowOffset = Offset(2, 2);

  // Color
  static const Color defaultPrimaryColor = Color(0xFFc03463);

  // Package & Font
  static const String packageName = 'navigation_stack_previewer';
  static const String fontFamily = 'avenirltstd';
}
