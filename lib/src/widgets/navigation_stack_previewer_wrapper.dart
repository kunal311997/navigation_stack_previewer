import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../di/injection_container.dart';
import '../services/navigation_history_service.dart';
import '../utils/constants.dart';
import 'history_panel.dart';

/// A global wrapper that enables navigation stack previewing for the entire app.
/// 
/// Place this in the `builder` property of your `MaterialApp`.
class NavigationStackPreviewer extends StatefulWidget {
  final Widget child;
  final double swipeThreshold;
  final double panelHeight;
  final Duration animationDuration;

  const NavigationStackPreviewer({
    super.key,
    required this.child,
    this.swipeThreshold = AppConstants.defaultSwipeThreshold,
    this.panelHeight = AppConstants.defaultPanelHeight,
    this.animationDuration = AppConstants.defaultAnimationDuration,
  });

  @override
  State<NavigationStackPreviewer> createState() => _NavigationStackPreviewerState();
}

class _NavigationStackPreviewerState extends State<NavigationStackPreviewer> {
  final GlobalKey _globalKey = GlobalKey();
  double _dragStartPosition = 0;
  bool _isPanelOpen = false;
  final NavigationHistoryService _navigationHistory = sl<NavigationHistoryService>();
  StreamSubscription? _captureSubscription;

  @override
  void initState() {
    super.initState();
    _captureSubscription = _navigationHistory.captureRequests.listen((_) {
      _captureScreenshot();
    });
    
    // Initial capture for the home screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _captureScreenshot();
    });
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

      final image = await boundary.toImage(pixelRatio: 2.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final bytes = byteData.buffer.asUint8List();
      _navigationHistory.addScreenshot(bytes);
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
    _closePanel();
    _navigationHistory.jumpTo(index);
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
