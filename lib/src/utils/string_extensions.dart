import 'package:flutter/material.dart';

String getPageTitle(Route route, int index, int total) {
  final name = route.settings.name;

  if (name == null || name.isEmpty || name == '/') {
    return name == '/' ? 'Home' : 'Page ${total - index}';
  }

  // Handle common deep link patterns (query parameters)
  String cleanName = name;
  if (name.contains('?')) {
    cleanName = name.split('?').first;
  }

  // Extract last segment and clean up
  return cleanName
      .split('/')
      .last
      .replaceAll(RegExp(r'[-_]'), ' ')
      .split(' ')
      .where((s) => s.isNotEmpty)
      .map((s) => s[0].toUpperCase() + s.substring(1))
      .join(' ');
}

/// Checks if a route name represents a deep link structure
bool isDeepLinkPath(String? name) {
  if (name == null) return false;
  // Common deep link indicators: query params or nested paths
  return name.contains('?') || (name.contains('/') && name.length > 1);
}
