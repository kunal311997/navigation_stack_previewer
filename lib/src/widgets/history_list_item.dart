import 'package:flutter/material.dart';
import 'package:navigation_stack_previewer/navigation_stack_previewer.dart';

import '../services/navigation_history_entry.dart';
import '../utils/constants.dart';

class HistoryListItem extends StatelessWidget {
  final bool isCurrent;
  final String title;
  final StackPreviewConfig config;
  final NavigationHistoryEntry entry;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onPreview;

  const HistoryListItem({
    super.key,
    this.isCurrent = false,
    required this.title,
    required this.config,
    required this.entry,
    required this.onTap,
    required this.onRemove,
    required this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppConstants.s8),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.s8),
              border: Border.all(
                color: isCurrent
                    ? config.primaryColor
                    : config.primaryColor.withAlpha(50),
                width: AppConstants.s2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(30),
                  blurRadius: AppConstants.s4,
                  offset: const Offset(6.0, 6.0),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.screenshot, color: Colors.black),
                  title: Row(
                    children: [
                      Text(title),
                      if (isCurrent)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.s8,
                              vertical: AppConstants.s4,
                            ),
                            decoration: BoxDecoration(
                              color: config.primaryColor,
                              borderRadius:
                                  BorderRadius.circular(AppConstants.s8),
                            ),
                            child: const Text(
                              AppConstants.currentLabel,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: onPreview,
                        child: const Icon(Icons.remove_red_eye,
                            color: Colors.black),
                      ),
                      const SizedBox(width: AppConstants.s12),
                      if (!isCurrent)
                        GestureDetector(
                          onTap: onRemove,
                          child: const Icon(Icons.close, color: Colors.black),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
