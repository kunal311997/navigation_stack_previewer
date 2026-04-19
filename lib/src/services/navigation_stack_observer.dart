import 'package:flutter/material.dart';

import '../../navigation_stack_previewer.dart';
import 'navigation_history_service.dart';

/// A NavigatorObserver that updates the [NavigationHistoryService] about navigation events.
///
/// This observer handles both Navigator 1.0 (imperative) and 2.0 (declarative) events.
class NavigationStackObserver extends NavigatorObserver {
  final NavigationHistoryService _service;

  NavigationStackObserver({NavigationHistoryService? service})
      : _service = service ?? sl<NavigationHistoryService>();

  bool _shouldTrack(Route<dynamic> route) {
    // 1. Check for 'preview: false' in RouteSettings arguments
    final settings = route.settings;
    if (settings.arguments is Map &&
        (settings.arguments as Map)['preview'] == false) {
      return false;
    }

    // 2. By default, only track PageRoutes (actual screens, not dialogs/menus)
    return route is PageRoute;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (_shouldTrack(route)) {
      _scheduleScreenshot(route, isReplacement: false);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null && _shouldTrack(newRoute)) {
      _scheduleScreenshot(newRoute, isReplacement: true);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _service.handleRoutePopped(route);
  }

  /// Support for Navigator 2.0 / Router API
  /// Many declarative routers call [didRemove] when the stack is rebuilt.
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _service.handleRoutePopped(route);
  }

  void _scheduleScreenshot(Route<dynamic> route, {required bool isReplacement}) {
    // We use a post-frame callback to ensure the new route is fully mounted
    // and ready to be captured by RepaintBoundary.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _service.setActiveRoute(route, isReplacement: isReplacement);
    });
  }
}
