import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/stack_preview_config.dart';
import '../utils/string_extensions.dart';
import 'navigation_history_entry.dart';

/// A service that manages the navigation history by storing screenshots and routes.
class NavigationHistoryService extends ChangeNotifier {
  Route? _activeRoute;
  bool _isLastOperationReplacement = false;

  /// The configuration for the navigation stack previewer.
  StackPreviewConfig _config = const StackPreviewConfig();

  /// Current configuration.
  StackPreviewConfig get config => _config;

  /// Update the configuration of the service.
  void updateConfig(StackPreviewConfig config) {
    if (_config != config) {
      _config = config;
      notifyListeners();
    }
  }

  final List<NavigationHistoryEntry> _history = [];

  /// Returns an unmodifiable list of history entries, newest first.
  UnmodifiableListView<NavigationHistoryEntry> get historyEntries =>
      UnmodifiableListView(_history.reversed);

  // Stream to notify the UI to capture a screenshot
  final _captureRequestController = StreamController<void>.broadcast();

  /// A stream of capture requests that the UI should listen to.
  Stream<void> get captureRequests => _captureRequestController.stream;

  /// Request a screenshot capture from the UI.
  void requestCapture() {
    _captureRequestController.add(null);
  }

  /// Sets the active route that will be associated with the next screenshot.
  void setActiveRoute(Route? route, {bool isReplacement = false}) {
    if (_activeRoute == route && _isLastOperationReplacement == isReplacement) return;
    
    _activeRoute = route;
    _isLastOperationReplacement = isReplacement;
    if (route != null) {
      requestCapture();
    }
  }

  /// Adds a new screenshot to the history, associated with the current active route.
  void addScreenshot(Uint8List bytes) {
    final route = _activeRoute;
    if (route == null) return;

    // Check if we already have a screenshot for this specific route instance
    if (_history.isNotEmpty && _history.last.route == route) {
      return;
    }

    if (_isLastOperationReplacement && _history.isNotEmpty) {
      _history.removeLast();
    } 
    
    while (_history.length >= _config.maxRoutes) {
      _history.removeAt(0);
    }

    _history.add(NavigationHistoryEntry(
      screenshot: bytes,
      route: route,
      isDeepLink: isDeepLinkPath(route.settings.name),
    ));

    _isLastOperationReplacement = false;
    notifyListeners();
  }

  /// Navigates back to a specific index in the history.
  void jumpTo(int index) {
    if (index <= 0 || index >= _history.length) return;

    final NavigatorState? navigator = _history.last.route.navigator;
    if (navigator == null) return;

    for (int i = 0; i < index; i++) {
      if (navigator.canPop()) {
        navigator.pop();
      }
    }
  }

  /// Removes a history item at the given index.
  void removeAt(int index) {
    int absoluteIndex = _history.length - 1 - index;
    if (absoluteIndex >= 0 && absoluteIndex < _history.length) {
      final entry = _history[absoluteIndex];
      final route = entry.route;

      if (route.navigator != null) {
        // Navigator will notify the observer, which calls handleRoutePopped.
        // We don't remove it manually here to avoid double removal.
        route.navigator!.removeRoute(route);
      } else {
        _history.removeAt(absoluteIndex);
        notifyListeners();
      }
    }
  }

  /// Internal method to remove an entry when a route is popped or removed (Navigator 2.0).
  void handleRoutePopped(Route route) {
    final index = _history.indexWhere((e) => e.route == route);
    if (index != -1) {
      _history.removeAt(index);
      notifyListeners();
    }
  }

  /// Clears all items from the navigation history.
  void clear() {
    if (_history.isEmpty && _activeRoute == null) return;
    _history.clear();
    _activeRoute = null;
    _isLastOperationReplacement = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _captureRequestController.close();
    super.dispose();
  }
}
