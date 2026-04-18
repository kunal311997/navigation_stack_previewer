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
  final NavigationHistoryService _navigationService =
      sl<NavigationHistoryService>();

  bool _isZoom = false;
  String _selectedImageTitle = '';
  Uint8List? _selectedImageBytes;

  void _onPreview(NavigationHistoryEntry entry, String title) {
    setState(() {
      _isZoom = true;
      _selectedImageTitle = title;
      _selectedImageBytes = entry.screenshot;
    });
  }

  void _closeZoom() {
    setState(() {
      _isZoom = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _navigationService,
      builder: (context, _) {
        final config = _navigationService.config;
        final bool isTop = config.position == StackPreviewPosition.top;
        final double panelHeight =
            _isZoom ? config.enlargedPanelHeight : config.panelHeight;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          height: panelHeight,
          decoration: BoxDecoration(
            color: config.backgroundColor,
            borderRadius: BorderRadius.vertical(
              top:
                  isTop ? Radius.zero : const Radius.circular(AppConstants.s24),
              bottom:
                  isTop ? const Radius.circular(AppConstants.s24) : Radius.zero,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: Offset(0, isTop ? 5 : -5),
              ),
            ],
          ),
          child: SafeArea(
            top: isTop,
            bottom: !isTop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(config),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.95, end: 1.0)
                              .animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _isZoom && _selectedImageBytes != null
                        ? ZoomView(
                            key: const ValueKey('zoom_view'),
                            config: config,
                            title: _selectedImageTitle,
                            imageBytes: _selectedImageBytes!,
                            onClose: () {
                              _closeZoom();
                              widget.onClose();
                            },
                            onPreviewClose: _closeZoom,
                          )
                        : Padding(
                            key: const ValueKey('history_list'),
                            padding:
                                const EdgeInsets.only(bottom: AppConstants.s16),
                            child: _buildHistoryList(config),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(StackPreviewConfig config) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.s20, vertical: AppConstants.s10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: AppConstants.s28),
          Text(
            config.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: config.primaryColor,
                  fontFamily: AppConstants.fontFamily,
                  package: AppConstants.packageName,
                ),
          ),
          GestureDetector(
            onTap: widget.onClose,
            child: Container(
              height: AppConstants.s28,
              width: AppConstants.s28,
              decoration: BoxDecoration(
                color: config.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: AppConstants.s20,
                color: config.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList(StackPreviewConfig config) {
    final entries = _navigationService.historyEntries;
    final isCarousel = config.layout == StackPreviewLayout.carousel;

    return ListView.builder(
      scrollDirection: isCarousel ? Axis.horizontal : Axis.vertical,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.s16),
      physics: const BouncingScrollPhysics(),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final title = getPageTitle(entry.route, index, entries.length);

        if (isCarousel) {
          return HistoryCarouselItem(
            isCurrent: index == 0,
            primaryColor: config.primaryColor,
            imageBytes: entry.screenshot,
            title: title,
            onTap: () => widget.onItemTap(index),
            onRemove: () => _navigationService.removeAt(index),
            onPreview: () => _onPreview(entry, title),
          );
        }

        return HistoryListItem(
          isCurrent: index == 0,
          config: config,
          entry: entry,
          title: title,
          onTap: () => widget.onItemTap(index),
          onRemove: () => _navigationService.removeAt(index),
          onPreview: () => _onPreview(entry, title),
        );
      },
    );
  }
}
