import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../utils/constants.dart';

class HistoryCarouselItem extends StatelessWidget {
  final bool isCurrent;
  final String title;
  final Uint8List imageBytes;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onPreview;
  final Color primaryColor;

  const HistoryCarouselItem({
    super.key,
    this.isCurrent = false,
    required this.title,
    required this.imageBytes,
    required this.onTap,
    required this.onRemove,
    required this.onPreview,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppConstants.s20),
      child: GestureDetector(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: AppConstants.historyItemAspectRatio,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.s12),
              border: Border.all(
                color: isCurrent ? primaryColor : primaryColor.withAlpha(50),
                width: AppConstants.s2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(30),
                  blurRadius: AppConstants.s4,
                  offset: const Offset(4.0, 4.0),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.s10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.memory(
                    imageBytes,
                    fit: BoxFit.cover,
                  ),
                  _buildHeader(),
                  if (isCurrent) _buildCurrentBadge(),
                  _buildZoomButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: AppConstants.s24,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.s8,
          vertical: AppConstants.s4,
        ),
        color: Colors.black.withOpacity(0.7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isCurrent) const SizedBox(width: AppConstants.s16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.white,
                  fontSize: AppConstants.s14,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.fontFamily,
                  package: AppConstants.packageName,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            if (!isCurrent)
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
    );
  }

  Widget _buildCurrentBadge() {
    return Positioned(
      bottom: AppConstants.s4,
      left: AppConstants.s4,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.s8,
          vertical: AppConstants.s2,
        ),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(AppConstants.s4),
        ),
        child: const Text(
          AppConstants.currentLabel,
          style: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.white,
            fontSize: AppConstants.s12,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontFamily,
            package: AppConstants.packageName,
          ),
        ),
      ),
    );
  }

  Widget _buildZoomButton() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: GestureDetector(
        onTap: onPreview,
        child: Container(
          padding: const EdgeInsets.all(AppConstants.s8),
          child: const Icon(
            Icons.zoom_out_map,
            size: AppConstants.s24,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
