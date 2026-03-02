import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../utils/constants.dart';

class HistoryItem extends StatelessWidget {
  final Uint8List imageBytes;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final bool isCurrent;
  final Color primaryColor;

  const HistoryItem({
    super.key,
    required this.imageBytes,
    required this.onTap,
    required this.onRemove,
    this.isCurrent = false,
    required this.primaryColor,
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
                  borderRadius: BorderRadius.circular(AppConstants.s12),
                  border: Border.all(
                    color:
                        isCurrent ? primaryColor : primaryColor.withAlpha(50),
                    width: AppConstants.s2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: AppConstants.s4,
                      offset: const Offset(6.0, 6.0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.s12),
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
                              horizontal: AppConstants.s8,
                              vertical: AppConstants.s4,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor,
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
                ),
              ),
            ),
          ),
          if (!isCurrent)
            Positioned(
              top: AppConstants.s4,
              right: AppConstants.s4,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.s4),
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: AppConstants.s16,
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
