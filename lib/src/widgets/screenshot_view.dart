import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../utils/constants.dart';

class ScreenshotView extends StatelessWidget {
  final Uint8List imageBytes;
  final VoidCallback onTap;
  final VoidCallback? onRemove;
  final Color primaryColor;
  final String title;
  final bool isCurrent;

  const ScreenshotView({
    super.key,
    required this.imageBytes,
    required this.onTap,
    this.onRemove,
    required this.title,
    required this.primaryColor,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                      color: Colors.black.withAlpha(30),
                      blurRadius: AppConstants.s4,
                      offset: const Offset(6.0, 6.0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.s8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(
                        imageBytes,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: AppConstants.s24,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.s8,
                            vertical: AppConstants.s4,
                          ),
                          color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!isCurrent)
                                const SizedBox(width: AppConstants.s16),
                              Expanded(
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    decoration: TextDecoration.none,
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              if (isCurrent)
                                const SizedBox(height: AppConstants.s20),
                              if (!isCurrent && onRemove != null)
                                GestureDetector(
                                  onTap: onRemove,
                                  child: const Icon(
                                    Icons.close,
                                    size: AppConstants.s16,
                                    color: Colors.white,
                                  ),
                                )
                            ],
                          ),
                        ),
                      ),
                      if (isCurrent)
                        Positioned(
                          bottom: AppConstants.s4,
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
        ],
      ),
    );
  }
}
