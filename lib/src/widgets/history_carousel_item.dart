import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:navigation_stack_previewer/src/widgets/screenshot_view.dart';

import '../utils/constants.dart';

class HistoryCarouselItem extends StatelessWidget {
  final Uint8List imageBytes;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final Color primaryColor;
  final Color backgroundColor;
  final String title;
  final bool isCurrent;

  const HistoryCarouselItem({
    super.key,
    required this.imageBytes,
    required this.onTap,
    required this.onRemove,
    required this.title,
    required this.primaryColor,
    required this.backgroundColor,
    this.isCurrent = false,
  });

  void _showEnlargedView(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(AppConstants.s20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ScreenshotView(
                imageBytes: imageBytes,
                title: title,
                onTap: onTap,
                isCurrent: isCurrent,
                primaryColor: primaryColor,
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(20),
                            blurRadius: AppConstants.s4,
                            offset: const Offset(2, 2),
                          ),
                        ]),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      color: primaryColor,
                      visualDensity: VisualDensity.compact,
                    ),
                  ))
            ],
          ),
          // child: Stack(
          //   alignment: Alignment.center,
          //   children: [
          //     ClipRRect(
          //       borderRadius: BorderRadius.circular(AppConstants.s12),
          //       child: Image.memory(
          //         imageBytes,
          //         fit: BoxFit.contain,
          //       ),
          //     ),
          //     Positioned(
          //       top: AppConstants.s8,
          //       right: AppConstants.s8,
          //       child: Container(
          //         decoration: BoxDecoration(
          //             // color: backgroundColor,
          //             shape: BoxShape.circle,
          //             boxShadow: [
          //               BoxShadow(
          //                 color: Colors.black.withAlpha(20),
          //                 blurRadius: AppConstants.s4,
          //                 offset: const Offset(2, 2),
          //               ),
          //             ]),
          //         child: IconButton(
          //           onPressed: () => Navigator.of(context).pop(),
          //           icon: const Icon(
          //             Icons.close,
          //             size: 20,
          //           ),
          //           color: primaryColor,
          //           visualDensity: VisualDensity.compact,
          //         ),
          //       ),
          //     ),
          //     Positioned(
          //       bottom: AppConstants.s20,
          //       child: Container(
          //         padding:
          //             const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //         decoration: BoxDecoration(
          //           color: Colors.black54,
          //           borderRadius: BorderRadius.circular(20),
          //         ),
          //         child: Text(
          //           title,
          //           style: const TextStyle(
          //               color: Colors.white, fontWeight: FontWeight.bold),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppConstants.s12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScreenshotView(
            imageBytes: imageBytes,
            title: title,
            onTap: onTap,
            onRemove: onRemove,
            isCurrent: isCurrent,
            primaryColor: primaryColor,
          ),
          const SizedBox(height: AppConstants.s4),
          GestureDetector(
            onTap: () => _showEnlargedView(context),
            child: const Row(
              children: [
                Icon(Icons.remove_red_eye, size: 20),
                SizedBox(width: AppConstants.s4),
                Text('Preview',
                    style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 0,
                        color: Colors.black,
                        decoration: TextDecoration.none))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
