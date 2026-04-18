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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.s20, vertical: AppConstants.s8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: AppConstants.s8),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: config.primaryColor,
                      fontFamily: 'avenirltstd',
                      package: 'navigation_stack_previewer'),
                ),
              ),
              Container(
                height: AppConstants.s24,
                width: AppConstants.s24,
                decoration: BoxDecoration(
                  color: config.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: onClose,
                  child: Icon(Icons.close,
                      size: AppConstants.s20, color: config.backgroundColor),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.s16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppConstants.s12),
                      border: Border.all(
                        color: config.primaryColor,
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
                      child: Image.memory(
                        imageBytes,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: AppConstants.s4,
                right: AppConstants.s4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.s20,
                    vertical: AppConstants.s20,
                  ),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: GestureDetector(
                    onTap: onPreviewClose,
                    child: const Icon(
                      Icons.zoom_out_map_outlined,
                      size: AppConstants.s24,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),

        // const SizedBox(height: AppConstants.s20)
      ],
    );
  }
}
