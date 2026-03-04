import 'package:flutter/material.dart';

class AppConstants {
  // Sizing & Spacing
  static const double s2 = 2.0;
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s10 = 10.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;

  // Strings
  static const String noHistoryMessage = 'No history items yet.';
  static const String currentLabel = 'Current';

  // Behavior & Durations
  static const double defaultSwipeThreshold = 100.0;
  static const double defaultPanelHeight = 400.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 400);
  static const Duration captureDelay = Duration(milliseconds: 300);

  // Ratios & Radii
  static const double historyItemAspectRatio = 9 / 16;
  static const Offset boxShadowOffset = Offset(4, 4);

  // Color
  static const Color defaultPrimaryColor = Color(0xFFc03463);
}
