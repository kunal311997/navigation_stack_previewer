import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../navigation_stack_previewer.dart';
import '../di/injection_container.dart';
import '../services/navigation_history_service.dart';
import '../utils/constants.dart';
import 'history_panel.dart';

/// A wrapper that detects a swipe down from the top and shows a navigation history panel.
class SwipeDownWrapper extends StatefulWidget {
  final Widget child;
  final double swipeThreshold;
  final double panelHeight;
  final Duration animationDuration;

  const SwipeDownWrapper({
    super.key,
    required this.child,
    this.swipeThreshold = AppConstants.defaultSwipeThreshold,
    this.panelHeight = AppConstants.defaultPanelHeight,
    this.animationDuration = AppConstants.defaultAnimationDuration,
  });

  @override
  State<SwipeDownWrapper> createState() => _SwipeDownWrapperState();
}

class _SwipeDownWrapperState extends State<SwipeDownWrapper> {
  final GlobalKey _globalKey = GlobalKey();
  double _dragStartPosition = 0;
  bool _isPanelOpen = false;
  bool _hasCapturedCurrent = false;
  final NavigationHistoryService navigationHistory =
      sl<NavigationHistoryService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _captureScreenshot();
    });
  }

  Future<void> _captureScreenshot() async {
    if (_hasCapturedCurrent) return;

    try {
      // Adding a small delay to ensure the screen content has fully settled/animated in
      await Future.delayed(AppConstants.captureDelay);

      if (!mounted) return;

      final boundary = _globalKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final bytes = byteData.buffer.asUint8List();
      
      // The service now auto-detects if this was a replacement via NavigationStackObserver
      navigationHistory.addScreenshot(bytes);

      if (mounted) {
        _hasCapturedCurrent = true;
      }
    } catch (e) {
      debugPrint("Error capturing screenshot: $e");
    }
  }

  void _openPanel() {
    setState(() => _isPanelOpen = true);
  }

  void _closePanel() {
    setState(() => _isPanelOpen = false);
  }

  void _handleHistoryItemTap(int index) {
    if (index == 0) {
      _closePanel();
      return;
    }

    // Close panel before navigating
    _closePanel();

    // Pop the navigator 'index' times to reach the desired screen.
    // Tapping index 1 pops 1 screen, index 2 pops 2 screens, etc.
    for (int i = 0; i < index; i++) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }

    // Synchronously update the history service to remove the screenshots of popped pages.
    navigationHistory.removeRecent(index);
  }

  @override
  Widget build(BuildContext context) {
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
              if (_dragStartPosition < widget.swipeThreshold &&
                  details.delta.dy > 5 &&
                  !_isPanelOpen) {
                _openPanel();
                _dragStartPosition =
                    double.infinity; // Prevent multiple triggers
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
          duration: widget.animationDuration,
          curve: Curves.fastOutSlowIn,
          top: _isPanelOpen ? 0 : -widget.panelHeight,
          left: 0,
          right: 0,
          child: HistoryPanel(
            height: widget.panelHeight,
            onClose: _closePanel,
            onItemTap: _handleHistoryItemTap,
          ),
        ),
      ],
    );
  }
}
