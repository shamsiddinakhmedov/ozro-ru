library highlighter_coachmark;

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// CoachMark blurs background of the whole screen and highlights target element.
/// It does this in Overlay. So the whole screen is covered by CoachMark's layer.
/// Methods [show] and [close] insert and remove coachMark's layer from the screen.
/// Tap anywhere on the screen closes CoachMark and calls callback onClose.
/// Even tap (any touch down) on the target element closes CoachMark. So it should
/// work with any gesture for target element.
/// Hints, usage explanations are provided by children Widgets. Internally they
/// are children of Stack. So it can be Positioned widgets.
/// If duration is provided then CoachMark automatically closes after
/// the given duration has passed. There is no difference for [close] -
/// was is close by timer or by user's touch.
///
/// ```dart
///  CoachMark coachMark = CoachMark();
///  RenderBox target = targetGlobalKey.currentContext.findRenderObject();
///  Rect markRect = target.localToGlobal(Offset.zero) & target.size;
///  markRect = Rect.fromCircle(center: markRect.center, radius: markRect.longestSide * 0.6);
///  coachMark.show(
///      targetContext: targetGlobalKey.currentContext,
///      markRect: markRect,
///      children: [
///        Positioned(
///            top: markRect.top + 5.0,
///            right: 10.0,
///            child: Text("Long tap on button to see options",
///                style: const TextStyle(
///                  fontSize: 24.0,
///                  fontStyle: FontStyle.italic,
///                  color: Colors.white,
///                )))
///      ],
///      duration: null,
///      onClose: () {
///         appState.setCoachMarkIsShown(true);
///      });
/// ```
class CoachMark {
  CoachMark({this.bgColor = const Color(0xB2212121)});

  /// Global key to get an access for CoachMark's State
  GlobalKey globalKey = GlobalKey<_HighlighterCoachMarkState>();

  /// Background color
  Color bgColor;

  /// State visibility of CoachMark
  bool _isVisible = false;

  /// Returns is CoachMark is visible at the moment
  bool get isVisible => _isVisible;

  /// Called when CoachMark is closed
  VoidCallback? _onClose;

  /// Contains OverlayEntry with CoachMark's Widget
  OverlayEntry? _overlayEntryBackground;

  /// Brings out CoachMark's widget with animation on the whole screen
  ///
  /// [targetContext] is a context for target element, for which CoachMark is needed
  ///
  /// [children] are children of Stack, they are hints and usage explanation
  ///
  /// marcRect is Rect for highlighted area. Usually is should be a bit bigger than
  /// Rect of target element. It can be achieved like this:
  /// ```dart
  /// Rect markRect = targetRenderBox.localToGlobal(Offset.zero) & target.size;
  /// var circleMarkRect = Rect.fromCircle(center: markRect.center, radius: markRect.longestSide * 0.6);
  /// //or like this
  /// var rectangleMarkRect = markRect.inflate(5.0);
  /// ```
  /// [markShape] is shape of highlighted area
  ///
  /// [duration] if provided then after it passes CoachMark is closed automatically
  ///
  /// Callback [onClose] is called when CoachMark is closed
  Future<void> show({
    required BuildContext targetContext,
    required List<Widget> children,
    required Rect markRect,
    BoxShape markShape = BoxShape.circle,
    required Duration duration,
    required VoidCallback onClose,
  }) async {
    // Prevent from showing multiple marks at the same time
    if (_isVisible) {
      return;
    }

    _isVisible = true;

    _onClose = _onClose ?? onClose;

    globalKey = globalKey; // ?? GlobalKey<_HighlighterCoachMarkState>();

    _overlayEntryBackground = _overlayEntryBackground ??
        OverlayEntry(
          builder: (context) => HighlighterCoachMarkWidget(
            key: globalKey,
            bgColor: bgColor,
            markRect: markRect,
            markShape: markShape,
            doClose: close,
            children: children,
          ),
        );

    final OverlayState overlayState = Overlay.of(targetContext);
    if (_overlayEntryBackground != null) {
      overlayState.insert(_overlayEntryBackground!);
    }

    await Future.delayed(duration, close);
  }

  /// Closes CoachMark and callback optional [_onClose]
  Future close() async {
    if (_isVisible) {
      await (globalKey.currentState as _HighlighterCoachMarkState?)?.reverse();
      _overlayEntryBackground?.remove();

      _isVisible = false;
      if (_onClose != null) {
        _onClose!();
      }
    }
  }
}

/// This widget creates dark blurred backgound with highlighted hole in place of
/// [markRect]
class HighlighterCoachMarkWidget extends StatefulWidget {
  const HighlighterCoachMarkWidget({
    super.key,
    required this.markRect,
    required this.markShape,
    required this.children,
    required this.doClose,
    required this.bgColor,
  });

  final Rect markRect;
  final BoxShape markShape;
  final List<Widget> children;
  final VoidCallback doClose;
  final Color bgColor;

  @override
  State<HighlighterCoachMarkWidget> createState() => _HighlighterCoachMarkState();
}

class _HighlighterCoachMarkState extends State<HighlighterCoachMarkWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blurAnimation;
  late Animation<double> _opacityAnimation;

  //Does reverse animation, called when coachMark is closing.
  Future reverse() => _controller.reverse();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _blurAnimation = Tween<double>(begin: 0, end: 3).animate(
      CurveTween(
        curve: const Interval(
          0.5,
          1,
          curve: Curves.ease,
        ),
      ).animate(_controller),
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 0.8).animate(
      CurveTween(
          curve: const Interval(
        0,
        1,
        curve: Curves.ease,
      )).animate(_controller),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Rect position = widget.markRect;
    final clipper = _CoachMarkClipper(position);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Stack(
        children: <Widget>[
          ClipPath(
            clipper: clipper,
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: _blurAnimation.value, sigmaY: _blurAnimation.value),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          _CoachMarkLayer(
            behavior: HitTestBehavior.translucent,
            onPointerDown: _onPointer,
            onPointerMove: _onPointer,
            onPointerUp: _onPointer,
            onPointerCancel: _onPointer,
            markPosition: position,
            child: CustomPaint(
              painter: _CoachMarkPainter(
                rect: position,
                shadow: BoxShadow(color: widget.bgColor.withOpacity(_opacityAnimation.value), blurRadius: 8),
                clipper: clipper,
                coachMarkShape: widget.markShape,
              ),
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Material(
                  type: MaterialType.transparency,
                  child: Stack(
                    fit: StackFit.expand,
                    children: widget.children,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onPointer(PointerEvent p) {
    widget.doClose();
  }
}

/// This widget creates _RenderPointerListenerWithExceptRegion which
/// overrides a special hitTest
class _CoachMarkLayer extends Listener {
  const _CoachMarkLayer({
    super.onPointerDown,
    super.onPointerMove,
    super.onPointerUp,
    super.onPointerCancel,
    super.behavior,
    required this.markPosition,
    super.child,
  });

  final Rect markPosition;

  @override
  RenderPointerListener createRenderObject(BuildContext context) => _RenderPointerListenerWithExceptRegion(
        onPointerDown: onPointerDown,
        onPointerMove: onPointerMove,
        onPointerUp: onPointerUp,
        onPointerCancel: onPointerCancel,
        behavior: behavior,
        exceptRegion: markPosition,
      );

  @override
  void updateRenderObject(BuildContext context, RenderPointerListener renderObject) {
    renderObject
      ..onPointerDown = onPointerDown
      ..onPointerMove = onPointerMove
      ..onPointerUp = onPointerUp
      ..onPointerCancel = onPointerCancel
      ..behavior = behavior;
  }
}

/// It overrides [hitTest] in a way that if position of touch is inside of
/// Rect [exceptRegion], this class is added to [HitTestResult] and return false,
/// so framework continues traverse the tree. It makes possible for CoachMark
/// to process touch (to close itself) and for targetElement to process touch.
class _RenderPointerListenerWithExceptRegion extends RenderPointerListener {
  _RenderPointerListenerWithExceptRegion({
    super.onPointerDown,
    super.onPointerMove,
    super.onPointerUp,
    super.onPointerCancel,
    super.behavior,
    required this.exceptRegion,
  });

  final Rect exceptRegion;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    bool hitTarget = false;
    if (exceptRegion.contains(position)) {
      result.add(BoxHitTestEntry(this, position));
      return false;
    }
    if (size.contains(position)) {
      hitTarget = hitTestChildren(result, position: position) || hitTestSelf(position);
      if (hitTarget || behavior == HitTestBehavior.translucent) result.add(BoxHitTestEntry(this, position));
    }
    return hitTarget;
  }
}

class _CoachMarkClipper extends CustomClipper<Path> {
  _CoachMarkClipper(this.rect);

  final Rect rect;

  @override
  Path getClip(Size size) =>
      Path.combine(ui.PathOperation.difference, Path()..addRect(Offset.zero & size), Path()..addOval(rect));

  @override
  bool shouldReclip(_CoachMarkClipper old) => rect != old.rect;
}

///This class makes edges of hole blurred.
class _CoachMarkPainter extends CustomPainter {
  _CoachMarkPainter({
    required this.rect,
    required this.shadow,
    required this.clipper,
    this.coachMarkShape = BoxShape.circle,
  });

  final Rect rect;
  final BoxShadow shadow;
  final _CoachMarkClipper clipper;
  final BoxShape coachMarkShape;

  @override
  void paint(Canvas canvas, Size size) {
    final circle = rect.inflate(shadow.spreadRadius);
    canvas
      ..saveLayer(Offset.zero & size, Paint())
      ..drawColor(shadow.color, BlendMode.dstATop);
    final paint = shadow.toPaint()..blendMode = BlendMode.clear;

    switch (coachMarkShape) {
      case BoxShape.rectangle:
        canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(circle.width * 0.3)), paint);
      case BoxShape.circle:
      default:
        canvas.drawCircle(circle.center, circle.longestSide * 0.5, paint);
        break;
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CoachMarkPainter old) => old.rect != rect;

  @override
  bool shouldRebuildSemantics(_CoachMarkPainter oldDelegate) => false;
}
