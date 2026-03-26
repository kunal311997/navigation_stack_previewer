import 'package:flutter/material.dart';

String getPageTitle(Route route, int index, int total) {
  final settings = route.settings;
  String? name = settings.name;

  if (name == null || name.isEmpty) {
    return 'Page ${total - index}';
  }

  if (name == '/') return 'Page 1';

  String cleaned = name;
  if (cleaned.startsWith('/')) {
    cleaned = cleaned.substring(1);
  }

  if (cleaned.contains('/')) {
    cleaned = cleaned.split('/').last;
  }

  cleaned = cleaned.replaceAll('_', ' ').replaceAll('-', ' ');

  if (cleaned.isNotEmpty) {
    return cleaned.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  return 'Page ${total - index}';
}
