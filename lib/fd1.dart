import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/gestures.dart';

class CardContentBloc {
  final int count;

  CardContentBloc({this.count = 2});

  static CardContentBloc _instance;

  factory CardContentBloc.instance() {
    if (_instance == null) {
      _instance = CardContentBloc();
    }
    return _instance;
  }

  BehaviorSubject<int> _childCount = BehaviorSubject<int>.seeded(2);

  ValueObservable<int> get childCount => _childCount.stream;

  void updateByRadio(double radio) {
    _childCount.add((count * (1 - radio)).toInt());
  }

  void dispose() {
    _childCount.close();
  }
}

final pic =
    "https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1336539351,1159920997&fm=173&app=25&f=JPEG?w=640&h=360&s=CF822CC156F2C9CE442C211E0300C0C3";

class Values {
  static double _width;
  static double _height;
  static double _barHeight;
  static double _appBarHeight;
  static double _card_width;
  static double _card_overlap;

  static double get width {
    if (_width == null || _width <= 0) {
      _width = window.physicalSize.width / window.devicePixelRatio;
    }
    return _width;
  }

  static double get height {
    if (_height == null || _height <= 0) {
      _height = window.physicalSize.height / window.devicePixelRatio;
    }
    return _height;
  }

  static double get barHeight {
    if (_barHeight == null || _barHeight <= 0) {
      _barHeight = MediaQueryData.fromWindow(window).padding.top;
    }
    return _barHeight;
  }

  static double get appBarHeight {
    if (_appBarHeight == null || _appBarHeight <= 0) {
      _appBarHeight = barHeight + 56;
    }
    return _appBarHeight;
  }

  static double get headerExpandheight => 199;

  static double get card_height => 130;

  static double get card_width {
    if (_card_width == null || _card_width <= 0) {
      _card_width = Values.width - 20;
    }
    return _card_width;
  }

  static double get card_top_padding => 108;

  static double get card_overlap {
    if (_card_overlap == null || _card_overlap <= 0) {
      _card_overlap = card_height + card_top_padding - headerExpandheight;
    }
    return _card_overlap;
  }

  static double get avatar_size => 70;

  static double get avatar_top => 69;

  static double get tabber_height => 97;

  static double get tabbar_expaned_height => 48;

  // 可见最高高度
  static double get tabbar_visible_max_height => tabber_height;

  static double _needMove;

  static double get needMove {
    if (_needMove == null || _needMove <= 0) {
      _needMove = (headerExpandheight + tabber_height) -
          (appBarHeight + (tabber_height - tabbar_expaned_height));
    }
    return _needMove;
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<RelativeRect> animate;
  Animation<RelativeRect> tabbarAnimate;
  Animation<double> tabbarPaddingAnimate;
  Animation<double> avatarSizeAnimate;
  Animation<double> avatarTopAnimate;
  Animation<double> cardTopAnimate;
  Animation<double> cardSizeAnimate;
  Animation<Color> appbarColorAnimate;
  Animation<Color> appbarTitleColorAnimate;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      if (_controller.value <= 0) {
      } else if (_controller.value >= 1) {}
    });
    CurvedAnimation animation =
    CurvedAnimation(parent: _controller, curve: Curves.linear);
    RelativeRectTween doubleTween = RelativeRectTween(
        begin: RelativeRect.fromLTRB(
            0, Values.headerExpandheight + Values.tabber_height, 0, 0),
        end: RelativeRect.fromLTRB(
            0,
            Values.appBarHeight +
                (Values.tabber_height - Values.tabbar_expaned_height),
            0,
            0));
    // tabbar
    RelativeRectTween tabbarTween = RelativeRectTween(
        begin: RelativeRect.fromLTRB(0, Values.headerExpandheight, 0, 0),
        end: RelativeRect.fromLTRB(0, Values.appBarHeight, 0, 0));
    // tabbar padding
    Tween<double> paddingTween =
    Tween<double>(begin: Values.card_overlap, end: 0);
    // avatarSizeAnimate
    Tween<double> avatarSizeTween =
    Tween<double>(begin: Values.avatar_size, end: 0);
    Tween<double> avatarTopTween =
    Tween<double>(begin: Values.avatar_top, end: Values.appBarHeight);
    // card
    Tween<double> cartTopTween =
    Tween<double>(begin: Values.card_top_padding, end: Values.appBarHeight);
    Tween<double> cartSizeTween =
    Tween<double>(begin: Values.card_height, end: 0);
    // appbar
    ColorTween appbarColorTween =
    ColorTween(begin: Colors.transparent, end: Colors.white);
    ColorTween appbarTitleColorTween =
    ColorTween(begin: Colors.white, end: Colors.black);

    animate = _controller.drive(doubleTween);
    tabbarAnimate = _controller.drive(tabbarTween);
    tabbarPaddingAnimate = _controller.drive(paddingTween);
    avatarSizeAnimate = _controller.drive(avatarSizeTween);
    avatarTopAnimate = _controller.drive(avatarTopTween);
    cardTopAnimate = _controller.drive(cartTopTween);
    cardSizeAnimate = _controller.drive(cartSizeTween);
    appbarColorAnimate = _controller.drive(appbarColorTween);
    appbarTitleColorAnimate = _controller.drive(appbarTitleColorTween);
//    bgAnimate = _controller
    _createDelay();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    CardContentBloc.instance().dispose();
    _disposeDelay();
    super.dispose();
  }

  double _radio = 1.0;

  bool _onNotification(ScrollNotification n) {
    print("n.metrics.pixels ${n.metrics.pixels} ${Values.needMove}");
    if (n.metrics.pixels <= Values.needMove) {
      _radio = n.metrics.pixels / Values.needMove;

      _controller.animateTo(_radio, duration: Duration(milliseconds: 0));
      CardContentBloc.instance().updateByRadio(_radio);
    } else if (_radio < 1) {
      _radio = 1.0;
      _controller.animateTo(_radio, duration: Duration(milliseconds: 0));
      CardContentBloc.instance().updateByRadio(_radio);
    }
    return false;
  }

  bool _ig = false;

//  bool _ig = true;
  void _createDelay() {
//    Future.delayed(Duration(seconds: 4), () {
//      setState(() {
//        _ig = false;
//      });
//    });
    GestureRecognizer gr;
  }

  void _disposeDelay() {
//    _ig = true;
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: Stack(
            children: <Widget>[
              _BackgroundImg(cardSizeAnimate: cardSizeAnimate),
              _TabBar(
                  tabbarAnimate: tabbarAnimate,
                  paddingAnimate: tabbarPaddingAnimate),
              PositionedTransition(
                rect: animate,
                child: TabBarView(children: [
                  NotificationListener<ScrollNotification>(
                    onNotification: _onNotification,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          left: 0,
                          bottom: 0,
                          width: 60,
                          child: ListView.builder(
                            physics: ClampingScrollPhysics(),
                            padding: EdgeInsets.all(0),
                            itemBuilder: (context, index) {
                              return Container(
                                height: 30,
                                width: 60,
                                child: Center(child: Text("left_$index")),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.orange.withOpacity(0.3),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: 130,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          bottom: 0,
                          left: 60,
                          child: RawGestureDetector(
                            gestures: {
                              AllowMultipleVerticalDragGestureRecognizer:
                              GestureRecognizerFactoryWithHandlers<
                                  AllowMultipleVerticalDragGestureRecognizer>(
                                    () =>
                                    AllowMultipleVerticalDragGestureRecognizer(),
                                    (AllowMultipleVerticalDragGestureRecognizer
                                instance) {
                                  instance.onStart = (details) => print(
                                      "list start ${details.globalPosition.dy}");
                                  instance.onUpdate = (details) => print(
                                      "list update ${details.globalPosition.dy}");
                                  instance.onEnd = (details) => print(
                                      "list end ${details.velocity.pixelsPerSecond.dy}");
                                },
                              ),
                            },
                            child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              padding: EdgeInsets.all(0),
                              itemCount: 130,
                              itemBuilder: (context, index) {
                                return RawGestureDetector(
                                  gestures: {
                                    AllowMultipleVerticalDragGestureRecognizer:
                                    GestureRecognizerFactoryWithHandlers<
                                        AllowMultipleVerticalDragGestureRecognizer>(
                                          () =>
                                          AllowMultipleVerticalDragGestureRecognizer(
                                              reject: true),
                                          (AllowMultipleVerticalDragGestureRecognizer
                                      instance) {
                                        instance.onStart = (details) {};
                                        instance.onUpdate = (details) {};
                                        instance.onEnd = (details) {};
                                      },
                                    ),
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text("hello, jet")));
                                    },
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 40,
                                      child: Text("item_$index"),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.orangeAccent
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text("123")
                ]),
              ),
              _Card(
                  animation: cardTopAnimate, cardSizeAnimate: cardSizeAnimate),
              _Avatar(
                avatarSizeAnimate: avatarSizeAnimate,
                animation: avatarTopAnimate,
                onTap: () {
                  print("--=-=-");
                },
              ),
              _AppBar(
                appbarColorAnimate: appbarColorAnimate,
                appbarTitleColorAnimate: appbarTitleColorAnimate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final Animation<RelativeRect> tabbarAnimate;
  final Animation<double> paddingAnimate;

  const _TabBar({Key key, this.tabbarAnimate, this.paddingAnimate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PositionedTransition(
      rect: tabbarAnimate,
      child: AnimatedPaddingContainer(
        animation: paddingAnimate,
        child: Container(
          height: Values.tabbar_visible_max_height - Values.card_overlap,
          child: TabBar(
            isScrollable: true,
            tabs: <Widget>[Tab(text: "点菜"), Tab(text: "视频")],
          ),
        ),
      ),
    );
  }
}

class AnimatedPaddingContainer extends AnimatedWidget {
  final Widget child;

  AnimatedPaddingContainer({Key key, this.child, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Container(
      padding: EdgeInsets.only(top: animation.value),
      alignment: Alignment.topLeft,
      color: Colors.blueAccent,
      child: child,
    );
  }
}

class _Avatar extends AnimatedWidget {
  final VoidCallback onTap;
  final Animation<double> avatarSizeAnimate;

  _Avatar(
      {Key key,
        this.onTap,
        this.avatarSizeAnimate,
        Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Positioned(
      top: animation.value,
      left: 0,
      right: 0,
      height: avatarSizeAnimate.value,
      child: _AnimatedAvatar(animation: avatarSizeAnimate),
    );
  }
}

class _AnimatedAvatar extends AnimatedWidget {
  _AnimatedAvatar({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return AnimatedOpacity(
      opacity: animation.value / Values.avatar_size,
      duration: Duration(milliseconds: 0),
      child: Container(
        height: animation.value,
        width: Values.width,
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius:
          BorderRadius.all(Radius.circular(Values.avatar_size / 2)),
          child: CachedNetworkImage(
            imageUrl: pic,
            width: animation.value,
            height: animation.value,
          ),
        ),
      ),
    );
  }
}

class _Card extends AnimatedWidget {
  final Animation<double> cardSizeAnimate;

  _Card({
    Key key,
    Animation<double> animation,
    this.cardSizeAnimate,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Positioned(
      top: animation.value,
      left: 0,
      right: 0,
      height: cardSizeAnimate.value,
      child: AnimatedOpacity(
        opacity: cardSizeAnimate.value / Values.card_height,
        duration: const Duration(milliseconds: 0),
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: 40, left: 20, right: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            height: Values.card_height,
            width: Values.card_width,
            child: _CardContent(),
          ),
        ),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  List<Widget> _buildChildren(int count) {
    List<Widget> list = List<Widget>();
    if (count == 0) {
      list.add(Container(
        height: 0,
      ));
    }
    if (count > 0) {
      list.add(Expanded(child: Text("奥斯卡垃圾💩是的法律速度快放假后")));
    }
    if (count > 1) {
      list.add(Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: <Widget>[
            Text("奥斯卡打垃圾💩"),
            Text("奥斯卡打垃圾💩"),
          ],
        ),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        initialData: 2,
        stream: CardContentBloc.instance().childCount,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildChildren(snapshot.data),
          );
        });
  }
}

class _BackgroundImg extends AnimatedWidget {
  final Animation<double> cardSizeAnimate;

  _BackgroundImg({
    Key key,
    this.cardSizeAnimate,
  }) : super(key: key, listenable: cardSizeAnimate);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0 - (Values.card_height - cardSizeAnimate.value),
      left: 0,
      right: 0,
      child: Stack(
        children: <Widget>[
          Transform.scale(
            scale: (Values.card_height / cardSizeAnimate.value),
            child: CachedNetworkImage(
              imageUrl: pic,
              fit: BoxFit.cover,
              width: Values.width,
            ),
          ),
          BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: new Container(
              color: Colors.white.withOpacity(0.4),
              width: Values.width,
              height: Values.headerExpandheight * 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppBar extends AnimatedWidget {
  Animation<Color> appbarColorAnimate;
  Animation<Color> appbarTitleColorAnimate;

  _AppBar({
    Key key,
    this.appbarColorAnimate,
    this.appbarTitleColorAnimate,
  }) : super(key: key, listenable: appbarColorAnimate);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: Values.appBarHeight,
      child: Container(
        color: appbarColorAnimate.value,
        height: Values.appBarHeight,
        padding: EdgeInsets.only(top: Values.barHeight),
        child: Stack(
          children: <Widget>[
            Center(
              child: Text(
                "90后",
                style: TextStyle(
                  color: appbarTitleColorAnimate.value,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: appbarTitleColorAnimate.value,
                    ),
                    onPressed: () {}),
              ],
            ),
          ],
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
//    Future.delayed(Duration(seconds: 5), () {
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
