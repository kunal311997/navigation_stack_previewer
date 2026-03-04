import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Represents an entry in the navigation history.
class NavigationHistoryEntry {
  /// The screenshot of the screen.
  final Uint8List screenshot;

  /// The route associated with the screen.
  final Route route;

  /// Creates a new navigation history entry.
  NavigationHistoryEntry({required this.screenshot, required this.route});
}
