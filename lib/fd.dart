import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'fd/Item.dart';

///
/// 暂时可以不用了
///
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
    _instance = null;
  }
}

class Values {
  static double _width;
  static double _height;
  static double _barHeight;
  static double _appBarHeight;
  static double _card_width;
  static double _card_overlap;

  static set width(double value) {
    _width = value;
  }

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
  AnimationController _iconController;
  Animation<double> _iconAnimation;

  bool b = true;

  @override
  void initState() {
    _iconController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));
    final CurvedAnimation curve =
        new CurvedAnimation(parent: _iconController, curve: Curves.easeInOut);
    _iconAnimation = new Tween(begin: 0.0, end: 1.0).animate(curve);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Builder(builder: (context) {
            return FlatButton(
              onPressed: () {
                if (b) {
                  _iconController.forward();
                } else {
                  _iconController.reverse();
                }
                b = !b;
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => SecondPage()));
              },
              child: AnimatedIcon(
                icon: AnimatedIcons.event_add,
                progress: _iconAnimation,
                size: 70,
              ),
            );
          }),
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage>
    with SingleTickerProviderStateMixin {
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

  Map<int, double> pixels = Map();
  double pixcelsMovedTotal = 0;

  bool _onOverNotification(OverscrollNotification n) {
    if (n.overscroll > 0) {
      if (pixcelsMovedTotal >= Values.needMove) {
        return false;
      }
//      print("n.metrics.extentAfter ${n.metrics.extentAfter}");
//      return false;
    }
    print("overscroll = ${n.overscroll}");
    var hashCode = n.context.hashCode;
    if (pixels.containsKey(hashCode)) {
      pixcelsMovedTotal += n.overscroll;
    } else {
      return false;
    }

    ///
    _action(hashCode, n.metrics.pixels);
    return false;
  }

  bool _onNotification(ScrollNotification n) {
    //
    var hashCode = n.context.hashCode;
    if (pixels.containsKey(hashCode)) {
      var d = n.metrics.pixels - pixels[hashCode];
      print("n.metrics.pixels ${n.metrics.pixels} d = $d");
      if (n.metrics.pixels >= 0 && d <= 0) {
        return false;
      }
      pixcelsMovedTotal += (n.metrics.pixels - pixels[hashCode]);
    } else {
      pixcelsMovedTotal += n.metrics.pixels;
    }

    ///
    _action(hashCode, n.metrics.pixels);
    return false;
  }

  void _action(int hashCode, double ps) {
    if (pixcelsMovedTotal > Values.needMove) {
      pixcelsMovedTotal = Values.needMove;
    }
    if (pixcelsMovedTotal < 0) {
      pixcelsMovedTotal = 0;
    }
    if (hashCode != null || ps != null) {
      pixels[hashCode] = ps;
    }
    //
    if (pixcelsMovedTotal <= Values.needMove) {
      _radio = pixcelsMovedTotal / Values.needMove;

      _controller.animateTo(_radio, duration: Duration(milliseconds: 0));
      CardContentBloc.instance().updateByRadio(_radio);
    } else if (_radio < 1) {
      _radio = 1.0;
      _controller.animateTo(_radio, duration: Duration(milliseconds: 0));
      CardContentBloc.instance().updateByRadio(_radio);
    }
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

  num _count = 0;

  Widget build(BuildContext context) {
    Values.width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                NotificationListener<OverscrollNotification>(
                  onNotification: _onOverNotification,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _onNotification,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          left: 0,
                          bottom: 0,
                          width: 90,
                          child: ListView.builder(
                            physics: ClampingScrollPhysics(),
                            key: PageStorageKey<String>("menu"),
                            padding: EdgeInsets.all(0),
                            itemBuilder: (context, index) {
                              return Container(
                                height: 30,
                                width: 60,
                                child: Center(
                                    child: Text("${_count}_left_$index")),
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
                          left: 90,
                          child: CustomScrollView(
                            key: PageStorageKey<String>("subMenu"),
                            physics: const ClampingScrollPhysics(),
                            slivers: <Widget>[
                              SliverStickyHeader(
                                header: StickHeader("主食"),
                                sliver: SliverFixedExtentList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return SubItem(index);
                                    },
                                    childCount: 17,
                                  ),
                                  itemExtent: 40,
                                ),
                              ),
                              SliverStickyHeader(
                                header: StickHeader("小吃"),
                                sliver: SliverFixedExtentList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return SubItem(index);
                                    },
                                    childCount: 17,
                                  ),
                                  itemExtent: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _Tab2(_onOverNotification, _onNotification),
              ]),
            ),
            _Card(animation: cardTopAnimate, cardSizeAnimate: cardSizeAnimate),
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
        width: animation.value,
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(animation.value / 2)),
          child: Image.asset(
            "assets/pubspec.jpg",
            width: animation.value,
            height: animation.value,
            fit: BoxFit.cover,
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
  @override
  Widget build(BuildContext context) {
    /// in no time
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        Text("奥斯卡垃圾💩是的法律速度快放假后"),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            children: <Widget>[
              Text("奥斯卡打垃圾💩"),
              Text("奥斯卡打垃圾💩"),
            ],
          ),
        )
      ],
    );
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
            child: Image.asset(
              "assets/pubspec.jpg",
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
                "X餐厅",
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

class _Tab2 extends StatelessWidget {
  final NotificationListenerCallback<OverscrollNotification> onOverScroll;
  final NotificationListenerCallback<ScrollNotification> onScroll;

  _Tab2(this.onOverScroll, this.onScroll);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollNotification>(
      onNotification: onOverScroll,
      child: NotificationListener<ScrollNotification>(
        onNotification: onScroll,
        child: GridView.builder(
          key: PageStorageKey<String>("videos"),
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 90,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.7),
          itemBuilder: (c, i) {
            return Container(
              color: Colors.orangeAccent,
            );
          },
          itemCount: 20,
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
