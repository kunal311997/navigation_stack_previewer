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
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.s12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppConstants.s12),
            border: Border.all(
              color: isCurrent
                  ? config.primaryColor
                  : config.primaryColor.withOpacity(0.1),
              width: AppConstants.s2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppConstants.s16,
              vertical: AppConstants.s4,
            ),
            leading: _buildThumbnail(),
            title: _buildTitle(),
            trailing: _buildActions(),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.s8),
        color: config.primaryColor.withOpacity(0.05),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.s8),
        child: Image.memory(
          entry.screenshot,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.image_not_supported,
            size: 20,
            color: config.primaryColor.withOpacity(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFamily: AppConstants.fontFamily,
              package: AppConstants.packageName,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isCurrent) _buildCurrentBadge(),
      ],
    );
  }

  Widget _buildCurrentBadge() {
    return Container(
      margin: const EdgeInsets.only(left: AppConstants.s8),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.s8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: config.primaryColor,
        borderRadius: BorderRadius.circular(AppConstants.s4),
      ),
      child: const Text(
        AppConstants.currentLabel,
        style: TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          fontFamily: AppConstants.fontFamily,
          package: AppConstants.packageName,
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.zoom_in, size: 20),
          onPressed: onPreview,
          visualDensity: VisualDensity.compact,
          color: Colors.grey[700],
        ),
        if (!isCurrent)
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: onRemove,
            visualDensity: VisualDensity.compact,
            color: Colors.red[400],
          ),
      ],
    );
  }
}
