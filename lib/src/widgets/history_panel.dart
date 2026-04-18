import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:navigation_stack_previewer/src/widgets/zoom_view.dart';

import '../../navigation_stack_previewer.dart';
import '../services/services.dart';
import '../utils/utils.dart';
import 'history_carousel_item.dart';
import 'history_list_item.dart';

class HistoryPanel extends StatefulWidget {
  final Function(int) onItemTap;
  final VoidCallback onClose;

  const HistoryPanel({
    super.key,
    required this.onItemTap,
    required this.onClose,
  });

  @override
  State<HistoryPanel> createState() => _HistoryPanelState();
}

class _HistoryPanelState extends State<HistoryPanel> {
  final NavigationHistoryService navigationService =
      sl<NavigationHistoryService>();
  bool isZoom = false;
  String selectedImageTitle = '';
  Uint8List? selectedImageBytes;
  late double currentPanelHeight;

  @override
  void initState() {
    currentPanelHeight = navigationService.config.panelHeight;
    super.initState();
  }

  void _onPreview(NavigationHistoryEntry entry, int index, String title) {
    setState(() {
      isZoom = true;
      selectedImageTitle = title;
      selectedImageBytes = entry.screenshot;
      currentPanelHeight = navigationService.config.enlargedPanelHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = navigationService.config;
    final bool isTop = config.position == StackPreviewPosition.top;

    return Container(
      height: currentPanelHeight,
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.vertical(
          top: isTop ? Radius.zero : const Radius.circular(AppConstants.s24),
          bottom: isTop ? const Radius.circular(AppConstants.s24) : Radius.zero,
        ),
      ),
      child: SafeArea(
        top: isTop,
        bottom: !isTop,
        child: (isZoom && selectedImageBytes != null)
            ? ZoomView(
                config: config,
                title: selectedImageTitle,
                imageBytes: selectedImageBytes!,
                onClose: () {
                  isZoom = false;
                  currentPanelHeight = config.panelHeight;
                  widget.onClose();
                },
                onPreviewClose: () {
                  setState(() {
                    isZoom = false;
                    currentPanelHeight = config.panelHeight;
                  });
                })
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.s20,
                        vertical: AppConstants.s8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          config.title,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: config.primaryColor,
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
                            onTap: widget.onClose,
                            child: Icon(Icons.close,
                                size: AppConstants.s20,
                                color: config.backgroundColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListenableBuilder(
                      listenable: navigationService,
                      builder: (context, _) {
                        final entries = navigationService.historyEntries;
                        final config = navigationService.config;

                        if (entries.isEmpty) {
                          return const Center(
                              child: Text(AppConstants.noHistoryMessage));
                        }

                        final isCarousel =
                            config.layout == StackPreviewLayout.carousel;

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.s16),
                          itemCount: entries.length,
                          itemBuilder: (context, index) {
                            final entry = entries[index];
                            final title = getPageTitle(
                                entry.route, index, entries.length);
                            return isCarousel
                                ? HistoryCarouselItem(
                                    isCurrent: index == 0,
                                    primaryColor: config.primaryColor,
                                    imageBytes: entry.screenshot,
                                    title: title,
                                    onTap: () => widget.onItemTap(index),
                                    onRemove: () =>
                                        navigationService.removeAt(index),
                                    onPreview: () =>
                                        _onPreview(entry, index, title),
                                  )
                                : HistoryListItem(
                                    isCurrent: index == 0,
                                    config: config,
                                    entry: entry,
                                    title: title,
                                    onTap: () => widget.onItemTap(index),
                                    onRemove: () =>
                                        navigationService.removeAt(index),
                                    onPreview: () =>
                                        _onPreview(entry, index, title),
                                  );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppConstants.s24),
                ],
              ),
      ),
    );
  }
}
