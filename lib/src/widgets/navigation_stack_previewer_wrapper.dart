import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../di/injection_container.dart';
import '../services/navigation_history_service.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import '../utils/stack_preview_config.dart';
import 'history_panel.dart';

/// A global wrapper that enables navigation stack previewing for the entire app.
///
/// Place this in the `builder` property of your `MaterialApp`.
class NavigationStackPreviewer extends StatefulWidget {
  final Widget child;
  final double panelHeight;
  final StackPreviewConfig config;

  const NavigationStackPreviewer({
    super.key,
    required this.child,
    this.panelHeight = AppConstants.defaultPanelHeight,
    this.config = const StackPreviewConfig(),
  });

  @override
  State<NavigationStackPreviewer> createState() =>
      _NavigationStackPreviewerState();
}

class _NavigationStackPreviewerState extends State<NavigationStackPreviewer> {
  final GlobalKey _globalKey = GlobalKey();
  double _dragStartPosition = 0;
  bool _isPanelOpen = false;
  StreamSubscription? _captureSubscription;
  final NavigationHistoryService _navigationService =
      sl<NavigationHistoryService>();

  @override
  void initState() {
    super.initState();
    // Update the service with the initial config
    _navigationService.updateConfig(widget.config);

    _captureSubscription = _navigationService.captureRequests.listen((_) {
      _captureScreenshot();
    });

    // Initial capture for the home screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _captureScreenshot();
    });
  }

  @override
  void didUpdateWidget(NavigationStackPreviewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _navigationService.updateConfig(widget.config);
    }
  }

  @override
  void dispose() {
    _captureSubscription?.cancel();
    super.dispose();
  }

  Future<void> _captureScreenshot() async {
    try {
      // Adding a small delay to ensure the screen content has fully settled/animated in
      await Future.delayed(AppConstants.captureDelay);

      if (!mounted) return;

      final boundary = _globalKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image =
          await boundary.toImage(pixelRatio: widget.config.pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final bytes = byteData.buffer.asUint8List();
      _navigationService.addScreenshot(bytes);
    } catch (e) {
      debugPrint("Error capturing screenshot: $e");
    }
  }

  void _openPanel() => setState(() => _isPanelOpen = true);

  void _closePanel() => setState(() => _isPanelOpen = false);

  void _onTap(int index) {
    _closePanel();
    _navigationService.jumpTo(index);
  }

  @override
  Widget build(BuildContext context) {
    final bool isTop = widget.config.position == StackPreviewPosition.top;
    final double offScreenPosition = -widget.panelHeight;

    return Stack(
      children: [
        RepaintBoundary(
          key: _globalKey,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragStart: (details) {
              _dragStartPosition = details.localPosition.dy;
            },
            onVerticalDragUpdate: (details) {
              final double screenHeight = MediaQuery.of(context).size.height;

              if (isTop) {
                // Top swipe down logic
                if (_dragStartPosition < AppConstants.defaultSwipeThreshold &&
                    details.delta.dy > 5 &&
                    !_isPanelOpen) {
                  _openPanel();
                  _dragStartPosition = double.infinity;
                }
              } else {
                // Bottom swipe up logic
                if (_dragStartPosition >
                        screenHeight - AppConstants.defaultSwipeThreshold &&
                    details.delta.dy < -5 &&
                    !_isPanelOpen) {
                  _openPanel();
                  _dragStartPosition = double.negativeInfinity;
                }
              }
            },
            child: widget.child,
          ),
        ),
        if (_isPanelOpen)
          GestureDetector(
            onTap: _closePanel,
            child: Container(color: Colors.black26),
          ),
        AnimatedPositioned(
          duration: widget.config.animationDuration,
          curve: widget.config.animationCurve,
          top: isTop ? (_isPanelOpen ? 0 : offScreenPosition) : null,
          bottom: !isTop ? (_isPanelOpen ? 0 : offScreenPosition) : null,
          left: 0,
          right: 0,
          child: HistoryPanel(
            height: widget.panelHeight,
            onClose: _closePanel,
            onTap: _onTap,
            navigationService: _navigationService,
          ),
        ),
      ],
    );
  }
}
