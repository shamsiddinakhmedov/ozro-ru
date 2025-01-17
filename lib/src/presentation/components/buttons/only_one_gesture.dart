import 'package:flutter/gestures.dart'
    show OneSequenceGestureRecognizer, PointerDownEvent, GestureDisposition, PointerEvent;
import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        RawGestureDetector,
        GestureRecognizerFactory,
        GestureRecognizerFactoryWithHandlers;

class OnlyOnePointerRecognizer extends OneSequenceGestureRecognizer {
  int _p = 0;

  @override
  void addPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer);

    if (_p == 0) {
      resolve(GestureDisposition.rejected);
      _p = event.pointer;
    } else {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  String get debugDescription => 'only one pointer recognizer';

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {
    if (!event.down && event.pointer == _p) {
      _p = 0;
    }
  }
}

class OnlyOnePointerRecognizerWidget extends StatelessWidget {
  const OnlyOnePointerRecognizerWidget({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) => RawGestureDetector(gestures: <Type, GestureRecognizerFactory>{
        OnlyOnePointerRecognizer:
            GestureRecognizerFactoryWithHandlers<OnlyOnePointerRecognizer>(OnlyOnePointerRecognizer.new, (instance) {})
      }, child: child);
}
