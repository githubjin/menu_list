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
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (c, h) {
              return <Widget>[
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 180,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.purple.withOpacity(0.3),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: Colors.transparent,
                    ),
                  ),
                  bottom: TabBar(
                    isScrollable: true,
                    tabs: <Widget>[
                      Text("A"),
                      Text("B"),
                    ],
                  ),
                ),
              ];
            },
            body: Builder(builder: (c) {
              return TabBarView(children: <Widget>[
                Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      width: 70,
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
                    Positioned(
                      top: 0,
                      left: 70,
                      bottom: 0,
                      right: 0,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (c, i) {
                          return Container(
                            height: 70,
                            alignment: Alignment.center,
                            child: Text("Item $i"),
                            decoration: BoxDecoration(
                                color:
                                    Colors.lightGreenAccent.withOpacity(0.3)),
                          );
                        },
                        itemCount: 100,
                      ),
                    ),
                  ],
                ),
                Container(
                  color: Colors.blue.withOpacity(0.3),
                ),
              ]);
            }),
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
//    Future.delayed(Duration(seconds: 15), () {
//      reject = false;
//    });
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
