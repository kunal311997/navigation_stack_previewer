import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:navigation_stack_previewer/navigation_stack_previewer.dart';

import '../utils/constants.dart';

class ZoomView extends StatelessWidget {
  final StackPreviewConfig config;
  final String title;
  final Uint8List imageBytes;
  final VoidCallback onClose;
  final VoidCallback onPreviewClose;

  const ZoomView({
    super.key,
    required this.config,
    required this.title,
    required this.imageBytes,
    required this.onClose,
    required this.onPreviewClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.s16,
              0,
              AppConstants.s16,
              AppConstants.s16,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppConstants.s12),
                border: Border.all(
                  color: config.primaryColor,
                  width: AppConstants.s2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppConstants.s10),
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.contain,
                  //backgroundColor: Colors.black12,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: AppConstants.s24,
          right: AppConstants.s24,
          child: FloatingActionButton.small(
            onPressed: onPreviewClose,
            backgroundColor: config.primaryColor,
            elevation: 4,
            child: Icon(Icons.zoom_in_map, color: config.backgroundColor),
          ),
        )
      ],
    );
  }
}
