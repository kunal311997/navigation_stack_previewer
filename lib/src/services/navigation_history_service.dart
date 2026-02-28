import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../di/injection_container.dart';

/// Represents an entry in the navigation history.
class NavigationHistoryEntry {
  final Uint8List screenshot;
  final Route route;

  NavigationHistoryEntry({required this.screenshot, required this.route});
}

/// A service that manages the navigation history by storing screenshots and routes.
class NavigationHistoryService extends ChangeNotifier {
  final int maxHistoryItems;
  final List<NavigationHistoryEntry> _history = [];
  
  Route? _activeRoute;
  bool _isLastOperationReplacement = false;

  // Stream to notify the UI to capture a screenshot
  final _captureRequestController = StreamController<void>.broadcast();
  Stream<void> get captureRequests => _captureRequestController.stream;

  NavigationHistoryService({this.maxHistoryItems = 5});

  /// Returns an unmodifiable list of history entries, newest first.
  UnmodifiableListView<NavigationHistoryEntry> get historyEntries =>
      UnmodifiableListView(_history.reversed);

  /// Helper to get just the screenshots, newest first.
  UnmodifiableListView<Uint8List> get history =>
      UnmodifiableListView(_history.reversed.map((e) => e.screenshot).toList());

  /// Request a screenshot capture from the UI.
  void requestCapture() {
    _captureRequestController.add(null);
  }

  /// Sets the active route that will be associated with the next screenshot.
  void setActiveRoute(Route? route, {bool isReplacement = false}) {
    _activeRoute = route;
    _isLastOperationReplacement = isReplacement;
    if (route != null) {
      requestCapture();
    }
  }

  /// Adds a new screenshot to the history, associated with the current active route.
  void addScreenshot(Uint8List bytes) {
    if (_activeRoute == null) return;

    // Check if we already have a screenshot for this specific route instance
    if (_history.isNotEmpty && _history.last.route == _activeRoute) {
      return; 
    }

    if (_isLastOperationReplacement && _history.isNotEmpty) {
      _history.removeLast();
    } else if (_history.length >= maxHistoryItems) {
      _history.removeAt(0);
    }
    
    _history.add(NavigationHistoryEntry(
      screenshot: bytes,
      route: _activeRoute!,
    ));
    
    _isLastOperationReplacement = false;
    notifyListeners();
  }

  /// Navigates back to a specific index in the history.
  /// index 0 is current, index 1 is the previous screen, etc.
  void jumpTo(int index) {
    if (index <= 0 || index >= _history.length) return;

    final NavigatorState? navigator = _history.last.route.navigator;
    if (navigator == null) return;

    for (int i = 0; i < index; i++) {
      if (navigator.canPop()) {
        navigator.pop();
      }
    }
    
    // The NavigationStackObserver.didPop will handle history cleanup
  }

  /// Removes the specified number of most recent history items.
  void removeRecent(int count) {
    for (int i = 0; i < count; i++) {
      if (_history.isNotEmpty) {
        _history.removeLast();
      }
    }
    notifyListeners();
  }

  /// Removes a history item at the given index (relative to newest first list).
  /// Also attempts to remove the associated route from the navigator.
  void removeAt(int index) {
    int actualIndex = _history.length - 1 - index;
    if (actualIndex >= 0 && actualIndex < _history.length) {
      final entry = _history[actualIndex];
      
      // If it's the current screen, we pop it. 
      // If it's a screen below, we remove it from the stack.
      if (index == 0) {
        entry.route.navigator?.pop();
      } else {
        entry.route.navigator?.removeRoute(entry.route);
        // Since removeRoute doesn't trigger didPop, we remove it manually
        _history.removeAt(actualIndex);
        notifyListeners();
      }
    }
  }

  /// Internal method to remove an entry when a route is popped.
  void handleRoutePopped(Route route) {
    if (_history.isNotEmpty && _history.last.route == route) {
      _history.removeLast();
      notifyListeners();
    }
  }

  void clear() {
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

/// A NavigatorObserver that updates the [NavigationHistoryService] about navigation events.
class NavigationStackObserver extends NavigatorObserver {
  final NavigationHistoryService _service;

  NavigationStackObserver([NavigationHistoryService? service]) 
      : _service = service ?? sl<NavigationHistoryService>();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _service.setActiveRoute(route, isReplacement: false);
    });
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _service.setActiveRoute(newRoute, isReplacement: true);
      });
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _service.handleRoutePopped(route);
  }
}
