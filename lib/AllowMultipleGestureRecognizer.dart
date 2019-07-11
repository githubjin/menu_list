import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class GApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DemoApp(),
      ),
    );
  }
}

//   Simple demo app which consists of two containers. The goal is to allow multiple gestures into the arena.
//  Everything is handled manually with the use of `RawGestureDetector` and a custom `GestureRecognizer`(It extends `TapGestureRecognizer`).
//  The custom GestureRecognizer, `AllowMultipleGestureRecognizer` is added to the gesture list and creates a `GestureRecognizerFactoryWithHandlers` of type `AllowMultipleGestureRecognizer`.
//  It creates a gesture recognizer factory with the given callbacks, in this case, an `onTap`.
//  It listens for an instance of `onTap` then prints text to the console when it is called. Note that the `RawGestureDetector` code is the same for both
//  containers. The only difference being the text that is printed(Used as a way to identify the widget)

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        AllowMultipleGestureRecognizer: GestureRecognizerFactoryWithHandlers<
            AllowMultipleGestureRecognizer>(
          () => AllowMultipleGestureRecognizer(),
          (AllowMultipleGestureRecognizer instance) {
            instance.onTap =
                () => print('Episode 4 is best! (parent container) ');
          },
        ),
        AllowMultipleVerticalDragGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<
                    AllowMultipleVerticalDragGestureRecognizer>(
                () => AllowMultipleVerticalDragGestureRecognizer(),
                (AllowMultipleVerticalDragGestureRecognizer instance) {
          instance.onStart = (details) =>
              print("Episode 4 is move start ${details.globalPosition}");
          instance.onEnd = (details) => print(
              "Episode 4 is move end ${details.velocity.pixelsPerSecond.dy}");
        }),
      },
      behavior: HitTestBehavior.opaque,
      //Parent Container
      child: Container(
        color: Colors.blueAccent,
        child: Center(
          //Wraps the second container in RawGestureDetector
          child: Container(
            color: Colors.yellowAccent,
            width: 300.0,
            height: 400.0,
            child: RawGestureDetector(
              gestures: {
                AllowMultipleGestureRecognizer:
                    GestureRecognizerFactoryWithHandlers<
                        AllowMultipleGestureRecognizer>(
                  () => AllowMultipleGestureRecognizer(), //constructor
                  (AllowMultipleGestureRecognizer instance) {
                    //initializer
                    instance.onTap =
                        () => print('Episode 8 is best! (nested container)');
                  },
                ),
                AllowMultipleVerticalDragGestureRecognizer:
                    GestureRecognizerFactoryWithHandlers<
                            AllowMultipleVerticalDragGestureRecognizer>(
                        () => AllowMultipleVerticalDragGestureRecognizer(
                            reject: true),
                        (AllowMultipleVerticalDragGestureRecognizer instance) {
                  instance.onStart = (details) => print(
                      "Episode 8 is move start ${details.globalPosition}");
                  instance.onEnd = (details) => print(
                      "Episode 8 is move end ${details.velocity.pixelsPerSecond.dy}");
                }),
              },
              behavior: HitTestBehavior.opaque,
              //Creates the nested container within the first.
              child: ListView.builder(
                  itemBuilder: (c, i) {
                    return Container(
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          border: const Border(
                              bottom: const BorderSide(color: Colors.purple))),
                    );
                  },
                  itemCount: 100),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Gesture Recognizer.
// rejectGesture() is overridden. When a gesture is rejected, this is the function that is called. By default, it disposes of the
// Recognizer and runs clean up. However we modified it so that instead the Recognizer is disposed of, it is actually manually added.
// The result is instead you have one Recognizer winning the Arena, you have two. It is a win-win.
class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    acceptGesture(pointer);
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
