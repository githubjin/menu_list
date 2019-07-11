import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class JBApp extends StatefulWidget {
  @override
  _JBAppState createState() => _JBAppState();
}

class _JBAppState extends State<JBApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: RawGestureDetector(
          gestures: {
            AllowMultipleVerticalDragGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<
                AllowMultipleVerticalDragGestureRecognizer>(
                  () => AllowMultipleVerticalDragGestureRecognizer(),
                  (AllowMultipleVerticalDragGestureRecognizer instance) {
                instance.onStart = (details) => print("0 start ${details.globalPosition.dy}");
                instance.onEnd = (details) => print("0 end ${details.velocity.pixelsPerSecond.dy}");
              },
            ),
          },
          behavior: HitTestBehavior.opaque,
          child: NestedScrollView(
            headerSliverBuilder: (c, h) {
              return <Widget>[
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 180,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.blueAccent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: Colors.white,
                    ),
                  ),
                ),
              ];
            },
            body: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  width: 70,
                  child: RawGestureDetector(
                    gestures: {
                      AllowMultipleVerticalDragGestureRecognizer:
                      GestureRecognizerFactoryWithHandlers<
                          AllowMultipleVerticalDragGestureRecognizer>(
                            () => AllowMultipleVerticalDragGestureRecognizer(reject: true),
                            (AllowMultipleVerticalDragGestureRecognizer instance) {
                          instance.onStart = (details) => print("a start ${details.globalPosition.dy}");
                          instance.onEnd = (details) => print("a end ${details.velocity.pixelsPerSecond.dy}");
                        },
                      ),
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (c, i) {
                        return Container(
                          height: 30,
                          width: 70,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent.withOpacity(0.3),
                          ),
                          child: Text("Class $i"),
                        );
                      },
                      itemCount: 20,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 70,
                  bottom: 0,
                  right: 0,
                  child: RawGestureDetector(
                    gestures: {
                      AllowMultipleVerticalDragGestureRecognizer:
                      GestureRecognizerFactoryWithHandlers<
                          AllowMultipleVerticalDragGestureRecognizer>(
                            () => AllowMultipleVerticalDragGestureRecognizer(),
                            (AllowMultipleVerticalDragGestureRecognizer instance) {
                          instance.onStart = (details) => print("b start ${details.globalPosition.dy}");
                          instance.onEnd = (details) => print("b end ${details.velocity.pixelsPerSecond.dy}");
                        },
                      ),
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (c, i) {
                        return Container(
                          height: 70,
                          alignment: Alignment.center,
                          child: Text("Item $i"),
                          decoration: BoxDecoration(
                              color: Colors.lightGreenAccent.withOpacity(0.3)),
                        );
                      },
                      itemCount: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AllowMultipleVerticalDragGestureRecognizer
    extends VerticalDragGestureRecognizer {
  bool reject;

  AllowMultipleVerticalDragGestureRecognizer({
    this.reject = false,
    Object debugOwner,
    PointerDeviceKind kind,
  }) : super(debugOwner: debugOwner, kind: kind) {
    Future.delayed(Duration(seconds: 5), () {
      reject = false;
    });
  }

  @override
  void rejectGesture(int pointer) {
    if (reject) {
      print(
          "AllowMultipleVerticalDragGestureRecognizer:rejectGesture $reject $pointer");
      return;
    }
    print(
        "AllowMultipleVerticalDragGestureRecognizer:rejectGesture $reject $pointer");
    acceptGesture(pointer);
  }
}
