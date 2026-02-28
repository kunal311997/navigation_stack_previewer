import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../utils/constants.dart';

class HistoryItem extends StatelessWidget {
  final Uint8List imageBytes;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final bool isCurrent;

  const HistoryItem({
    super.key,
    required this.imageBytes,
    required this.onTap,
    required this.onRemove,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: AppConstants.s12,
        bottom: AppConstants.s8,
      ),
      child: Stack(
        children: [
          GestureDetector(
            onTap: onTap,
            child: AspectRatio(
              aspectRatio: AppConstants.historyItemAspectRatio,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppConstants.historyItemBorderRadius),
                  border: Border.all(
                    color: isCurrent
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).dividerColor.withOpacity(0.1),
                    width: isCurrent ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: AppConstants.s4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isCurrent
                      ? AppConstants.historyItemBorderRadius - 2
                      : AppConstants.historyItemBorderRadius - 1),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(
                        imageBytes,
                        fit: BoxFit.cover,
                      ),
                      if (isCurrent)
                        Positioned(
                          top: AppConstants.s4,
                          left: AppConstants.s4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.currentLabelBorderRadius),
                            ),
                            child: Text(
                              AppConstants.currentLabel,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (!isCurrent)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
