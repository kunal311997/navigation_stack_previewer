import 'package:flutter/material.dart';

import '../services/navigation_history_entry.dart';
import '../services/navigation_history_service.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import '../utils/stack_preview_config.dart';
import 'history_carousel_item.dart';
import 'history_list_item.dart';

class HistoryPanel extends StatelessWidget {
  final double height;
  final Function(int) onTap;
  final VoidCallback onClose;
  final NavigationHistoryService navigationService;

  const HistoryPanel({
    super.key,
    required this.height,
    required this.onTap,
    required this.onClose,
    required this.navigationService,
  });

  @override
  Widget build(BuildContext context) {
    final config = navigationService.config;
    final bool isTop = config.position == StackPreviewPosition.top;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: config.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: AppConstants.s10,
            offset: isTop ? AppConstants.boxShadowOffset : const Offset(4, -4),
          ),
        ],
        borderRadius: BorderRadius.vertical(
          top: isTop ? Radius.zero : const Radius.circular(AppConstants.s24),
          bottom: isTop ? const Radius.circular(AppConstants.s24) : Radius.zero,
        ),
      ),
      child: SafeArea(
        top: isTop,
        bottom: !isTop,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.s20, vertical: AppConstants.s8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    config.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: config.primaryColor,
                        ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: config.backgroundColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: AppConstants.s4,
                            offset: const Offset(2, 2),
                          ),
                        ]),
                    child: IconButton(
                      onPressed: onClose,
                      icon: const Icon(Icons.close),
                      color: config.primaryColor,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: navigationService,
                builder: (context, _) {
                  final entries = navigationService.historyEntries;
                  if (entries.isEmpty) {
                    return const Center(
                        child: Text(AppConstants.noHistoryMessage));
                  }

                  switch (config.layout) {
                    case StackPreviewLayout.list:
                      return _buildVerticalList(entries, config);
                    case StackPreviewLayout.carousel:
                    default:
                      return _buildCarousel(entries, config);
                  }
                },
              ),
            ),
            const SizedBox(height: AppConstants.s12),
          ],
        ),
      ),
    );
  }

  String _getPageTitle(Route route, int index, int total) {
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

  Widget _buildCarousel(
      List<NavigationHistoryEntry> entries, StackPreviewConfig config) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.s16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return HistoryCarouselItem(
          imageBytes: entry.screenshot,
          title: _getPageTitle(entry.route, index, entries.length),
          onTap: () => onTap(index),
          onRemove: () => navigationService.removeAt(index),
          isCurrent: index == 0,
          primaryColor: config.primaryColor,
        );
      },
    );
  }

  Widget _buildVerticalList(
      List<NavigationHistoryEntry> entries, StackPreviewConfig config) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.s16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return HistoryListItem(
          imageBytes: entry.screenshot,
          title: _getPageTitle(entry.route, index, entries.length),
          onTap: () => onTap(index),
          onRemove: () => navigationService.removeAt(index),
          isCurrent: index == 0,
          primaryColor: config.primaryColor,
        );
      },
    );
  }
}
