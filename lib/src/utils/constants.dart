import 'package:flutter/material.dart';

class AppConstants {
  // Behavior & Durations
  static const double defaultSwipeThreshold = 100.0;
  static const double defaultPanelHeight = 320.0;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 400);
  static const Duration captureDelay = Duration(milliseconds: 300);

  // Ratios & Radii
  static const double historyItemAspectRatio = 9 / 16;
  static const double historyPanelBorderRadius = 24.0;
  static const double historyItemBorderRadius = 12.0;
  static const double currentLabelBorderRadius = 8.0;

  // Sizing & Spacing
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;

  static const double listHorizontalPadding = s16;
  static const double panelBottomSpacing = s12;

  static const double headerLeftPadding = s20;
  static const double headerVerticalPadding = s8;
  static const double headerRightPadding = s8;

  static const double boxShadowBlurRadius = 10.0;
  static const double boxShadowOpacity = 0.1;
  static const Offset boxShadowOffset = Offset(0, 4);

  // Strings
  static const String historyTitle = 'Navigation History';
  static const String noHistoryMessage = 'No history items yet.';
  static const String currentLabel = 'Current';
}
