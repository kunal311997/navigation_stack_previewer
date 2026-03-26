import 'package:flutter/material.dart';
import 'package:navigation_stack_previewer/navigation_stack_previewer.dart';
import 'package:navigation_stack_previewer/src/widgets/screenshot_view.dart';

import '../services/navigation_history_entry.dart';
import '../utils/constants.dart';

class HistoryCarouselItem extends StatelessWidget {
  final bool isCurrent;
  final String title;
  final StackPreviewConfig config;
  final NavigationHistoryEntry entry;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onPreview;

  const HistoryCarouselItem({
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
    return Padding(
      padding: const EdgeInsets.only(right: AppConstants.s12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScreenshotView(
            imageBytes: entry.screenshot,
            title: title,
            onTap: onTap,
            onRemove: onRemove,
            isCurrent: isCurrent,
            primaryColor: config.primaryColor,
          ),
          const SizedBox(height: AppConstants.s4),
          GestureDetector(
            onTap: onPreview,
            child: const Padding(
              padding: EdgeInsets.all(AppConstants.s8),
              child: Row(
                children: [
                  Icon(Icons.remove_red_eye, size: 20),
                  SizedBox(width: AppConstants.s4),
                  Text(
                    'Preview',
                    style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 0,
                        color: Colors.black,
                        decoration: TextDecoration.none),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
