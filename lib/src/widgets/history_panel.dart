import 'package:flutter/material.dart';

import '../di/injection_container.dart';
import '../services/navigation_history_service.dart';
import '../utils/constants.dart';
import 'history_item.dart';

class HistoryPanel extends StatelessWidget {
  final double height;
  final NavigationHistoryService navigationHistory =
      sl<NavigationHistoryService>();
  final VoidCallback onClose;
  final Function(int) onItemTap;

  HistoryPanel({
    super.key,
    required this.height,
    required this.onClose,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(AppConstants.boxShadowOpacity),
            blurRadius: AppConstants.boxShadowBlurRadius,
            offset: AppConstants.boxShadowOffset,
          ),
        ],
        borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(AppConstants.historyPanelBorderRadius)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListenableBuilder(
                listenable: navigationHistory,
                builder: (context, _) {
                  final history = navigationHistory.history;
                  if (history.isEmpty) {
                    return const Center(
                        child: Text(AppConstants.noHistoryMessage));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.listHorizontalPadding),
                    itemCount: history.length,
                    itemBuilder: (context, index) => HistoryItem(
                      imageBytes: history[index],
                      onTap: () => onItemTap(index),
                      onRemove: () => navigationHistory.removeAt(index),
                      isCurrent: index == 0,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppConstants.panelBottomSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.headerLeftPadding,
        AppConstants.headerVerticalPadding,
        AppConstants.headerRightPadding,
        AppConstants.headerVerticalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppConstants.historyTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}
