import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../utils/constants.dart';

class HistoryListItem extends StatelessWidget {
  final Uint8List imageBytes;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final Color primaryColor;
  final String title;
  final bool isCurrent;

  const HistoryListItem({
    super.key,
    required this.imageBytes,
    required this.onTap,
    required this.onRemove,
    required this.title,
    required this.primaryColor,
    this.isCurrent = false,
  });

  void _showEnlargedView(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.s12),
              child: Image.memory(
                imageBytes
               ),
            ),
            Positioned(
              top: AppConstants.s8,
              right: AppConstants.s8,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                style: IconButton.styleFrom(backgroundColor: Colors.black54),
              ),
            ),
            Positioned(
              bottom: AppConstants.s20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                color: isCurrent ? primaryColor : primaryColor.withAlpha(50),
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => _showEnlargedView(context),
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
