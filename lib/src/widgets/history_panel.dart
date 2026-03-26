import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:navigation_stack_previewer/src/widgets/screenshot_view.dart';

import '../services/services.dart';
import '../utils/utils.dart';
import 'history_carousel_item.dart';
import 'history_list_item.dart';

class HistoryPanel extends StatefulWidget {
  final Function(int) onItemTap;
  final VoidCallback onClose;
  final NavigationHistoryService navigationService;

  const HistoryPanel({
    super.key,
    required this.onItemTap,
    required this.onClose,
    required this.navigationService,
  });

  @override
  State<HistoryPanel> createState() => _HistoryPanelState();
}

class _HistoryPanelState extends State<HistoryPanel> {
  late double currentPanelHeight;
  bool isZoom = false;
  Uint8List? enlargedImage;
  String enlargedImageTitle = '';

  @override
  void initState() {
    currentPanelHeight = widget.navigationService.config.panelHeight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.navigationService.config;
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
        child: isZoom
            ? Column(
                // alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.s20,
                        vertical: AppConstants.s8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: AppConstants.s8),
                          child: Text(
                            'Preview'.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: config.primaryColor,
                                ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: config.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                isZoom = false;
                                currentPanelHeight =
                                    widget.navigationService.config.panelHeight;
                              });
                            },
                            icon: const Icon(Icons.close),
                            color: config.backgroundColor,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (enlargedImage != null)
                    ScreenshotView(
                      imageBytes: enlargedImage!,
                      title: enlargedImageTitle,
                      primaryColor: config.primaryColor,
                    ),
                  const SizedBox(height: AppConstants.s20)
                ],
              )
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
                          decoration: BoxDecoration(
                            color: config.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: widget.onClose,
                            icon: const Icon(Icons.close),
                            color: config.backgroundColor,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListenableBuilder(
                      listenable: widget.navigationService,
                      builder: (context, _) {
                        final entries = widget.navigationService.historyEntries;
                        if (entries.isEmpty) {
                          return const Center(
                              child: Text(AppConstants.noHistoryMessage));
                        }

                        switch (config.layout) {
                          case StackPreviewLayout.list:
                            return _buildVerticalList(entries, config);
                          case StackPreviewLayout.carousel:
                          default:
                            return _buildCarousel(entries, config);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: AppConstants.s12),
                ],
              ),
      ),
    );
  }

  Widget _buildCarousel(
      List<NavigationHistoryEntry> entries, StackPreviewConfig config) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.s16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final title = getPageTitle(entry.route, index, entries.length);
        return HistoryCarouselItem(
          isCurrent: index == 0,
          config: config,
          entry: entry,
          title: title,
          onTap: () => widget.onItemTap(index),
          onRemove: () => widget.navigationService.removeAt(index),
          onPreview: () => _onPreview(entry, index, title),
        );
      },
    );
  }

  void _onPreview(NavigationHistoryEntry entry, int index, String title) {
    setState(() {
      isZoom = true;
      currentPanelHeight = widget.navigationService.config.enlargedPanelHeight;
      enlargedImage = entry.screenshot;
      enlargedImageTitle = title;
    });
  }

  Widget _buildVerticalList(
      List<NavigationHistoryEntry> entries, StackPreviewConfig config) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.s16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final title = getPageTitle(entry.route, index, entries.length);
        return HistoryListItem(
          isCurrent: index == 0,
          config: config,
          entry: entry,
          title: title,
          onTap: () => widget.onItemTap(index),
          onRemove: () => widget.navigationService.removeAt(index),
          onPreview: () => _onPreview(entry, index, title),
        );
      },
    );
  }
}
