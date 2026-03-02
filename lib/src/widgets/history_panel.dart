import 'package:flutter/material.dart';

import '../services/navigation_history_service.dart';
import '../utils/constants.dart';
import 'history_item.dart';

class HistoryPanel extends StatelessWidget {
  final double height;
  final Function(int) onTap;
  final VoidCallback onClose;
  final Color primaryColor;
  final Color backgroundColor;
  final NavigationHistoryService navigationService;

  const HistoryPanel({
    super.key,
    required this.height,
    required this.onTap,
    required this.onClose,
    required this.primaryColor,
    required this.backgroundColor,
    required this.navigationService,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: AppConstants.s10,
                offset: AppConstants.boxShadowOffset,
              ),
            ],
            borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppConstants.s24)),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.s20, vertical: AppConstants.s8),
                  child: Text(
                    AppConstants.historyTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: ListenableBuilder(
                    listenable: navigationService,
                    builder: (context, _) {
                      final history = navigationService.history;
                      if (history.isEmpty) {
                        return const Center(
                            child: Text(AppConstants.noHistoryMessage));
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.s16),
                        itemCount: history.length,
                        itemBuilder: (context, index) => HistoryItem(
                          imageBytes: history[index],
                          onTap: () => onTap(index),
                          onRemove: () => navigationService.removeAt(index),
                          isCurrent: index == 0,
                          primaryColor: primaryColor,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppConstants.s12),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppConstants.s8),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: AppConstants.s10,
                    offset: AppConstants.boxShadowOffset,
                  ),
                ]),
            child: IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close),
              color: Colors.black,
              visualDensity: VisualDensity.compact,
            ),
          ),
        )
      ],
    );
  }
}
