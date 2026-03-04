import 'package:flutter/material.dart';

import '../../navigation_stack_previewer.dart';
import 'navigation_history_service.dart';

/// A NavigatorObserver that updates the [NavigationHistoryService] about navigation events.
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _service.setActiveRoute(route, isReplacement: false);
      });
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null && _shouldTrack(newRoute)) {
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
