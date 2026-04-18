import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../di/injection_container.dart';
import '../services/services.dart';
import '../utils/utils.dart';
import 'history_panel.dart';

/// A global wrapper that enables navigation stack previewing for the entire app.
///
/// Place this in the `builder` property of your `MaterialApp`.
class NavigationStackPreviewer extends StatefulWidget {
  final Widget child;
  final StackPreviewConfig config;

  const NavigationStackPreviewer({
    super.key,
    required this.child,
    this.config = const StackPreviewConfig(),
  });

  @override
  State<NavigationStackPreviewer> createState() =>
      _NavigationStackPreviewerState();
}

class _NavigationStackPreviewerState extends State<NavigationStackPreviewer> {
  final GlobalKey _globalKey = GlobalKey();
  final NavigationHistoryService _navigationService =
      sl<NavigationHistoryService>();

  double _dragStartPosition = 0;
  bool _isPanelOpen = false;
  StreamSubscription? _captureSubscription;

  @override
  void initState() {
    super.initState();
    _navigationService.updateConfig(widget.config);

    _captureSubscription = _navigationService.captureRequests.listen((_) {
      _captureScreenshot();
    });

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
      // Adding a small delay to ensure the screen content has fully settled
      await Future.delayed(AppConstants.captureDelay);

      if (!mounted) return;

      final boundary = _globalKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary == null) return;

      // Check if it's currently painting to avoid errors
      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 50));
        return _captureScreenshot();
      }

      final image =
          await boundary.toImage(pixelRatio: widget.config.pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        _navigationService.addScreenshot(byteData.buffer.asUint8List());
      }
    } catch (e) {
      debugPrint("NavigationStackPreviewer: Capture failed: $e");
    }
  }

  void _togglePanel(bool open) {
    if (_isPanelOpen == open) return;
    setState(() => _isPanelOpen = open);
  }

  void _onItemTap(int index) {
    _togglePanel(false);
    _navigationService.jumpTo(index);
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    final isTop = config.position == StackPreviewPosition.top;
    final offScreenPosition = -config.enlargedPanelHeight;

    return Stack(
      children: [
        RepaintBoundary(
          key: _globalKey,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragStart: (details) =>
                _dragStartPosition = details.localPosition.dy,
            onVerticalDragUpdate: (details) =>
                _handleDragUpdate(details, isTop),
            child: widget.child,
          ),
        ),
        _buildBackdrop(),
        _buildAnimatedPanel(isTop, offScreenPosition),
      ],
    );
  }

  void _handleDragUpdate(DragUpdateDetails details, bool isTop) {
    if (_isPanelOpen) return;

    final screenHeight = MediaQuery.of(context).size.height;
    const threshold = AppConstants.defaultSwipeThreshold;

    if (isTop) {
      if (_dragStartPosition < threshold && details.delta.dy > 5) {
        _togglePanel(true);
      }
    } else {
      if (_dragStartPosition > screenHeight - threshold &&
          details.delta.dy < -5) {
        _togglePanel(true);
      }
    }
  }

  Widget _buildBackdrop() {
    if (!_isPanelOpen) return const SizedBox.shrink();

    return Positioned.fill(
      child: GestureDetector(
        onTap: () => _togglePanel(false),
        child: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: AppConstants.backgroundBlurOffest,
              sigmaY: AppConstants.backgroundBlurOffest,
            ),
            child: Container(
              color:
                  Colors.black.withOpacity(AppConstants.backgroundBlurOpacity),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedPanel(bool isTop, double offScreenPosition) {
    return AnimatedPositioned(
      duration: widget.config.animationDuration,
      curve: widget.config.animationCurve,
      top: isTop ? (_isPanelOpen ? 0 : offScreenPosition) : null,
      bottom: !isTop ? (_isPanelOpen ? 0 : offScreenPosition) : null,
      left: 0,
      right: 0,
      child: HistoryPanel(
        onItemTap: _onItemTap,
        onClose: () => _togglePanel(false),
      ),
    );
  }
}
