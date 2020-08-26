import 'dart:math';
import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class Decorations {
  static BoxDecoration BORDER_UP_BOTTOM({Color borderColor = Colors.black87}) =>
      BoxDecoration(border: Border.symmetric(vertical: BorderSide(color: borderColor, width: 0.1)));
  static ThemeData THEME = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: Color.alphaBlend(Colors.black87, Colors.white),
    primaryColor: Color.fromARGB(255, 255, 30, 30),
    accentColor: Color.fromARGB(255, 255, 70, 70),
    scaffoldBackgroundColor: Color.alphaBlend(Colors.black87, Colors.white),
    toggleButtonsTheme: ToggleButtonsThemeData(
      fillColor: Color.fromARGB(120, 255, 70, 70),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: Color.fromARGB(180, 255, 70, 70),
      inactiveTrackColor: Color.fromARGB(120, 255, 70, 70),
      activeTickMarkColor: Colors.white,
      inactiveTickMarkColor: Colors.white38,
      thumbColor: Color.fromARGB(255, 150, 40, 40),
      overlayColor: Color.fromARGB(120, 200, 70, 70),
      valueIndicatorColor: Color.fromARGB(255, 200, 70, 70),
    ),
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 96, color: Colors.white),
      headline2: TextStyle(fontSize: 60, color: Colors.white),
      subtitle1: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
      subtitle2: TextStyle(fontSize: 20, color: Colors.white),
      bodyText1: TextStyle(fontSize: 22, color: Colors.white),
      bodyText2: TextStyle(fontSize: 16, color: Colors.white),
    ),
  );
}

class Utils {
  static dynamic popDialogFromBottom(BuildContext context, List<Widget> Function(Function(Function()), BuildContext) builder,
      {bool isDismissible = true}) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0.0,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          child: CustomDraggableScrollableSheet(builder),
        ),
      ),
    );
  }
}

class CustomDraggableScrollableSheet extends StatefulWidget {
  final List<Widget> Function(Function(Function()), BuildContext context) builder;
  final double max;
  final double min;
  final double init;
  final bool expand;
  final Decoration decoration;
  final bool dismissOnLoseFocus;
  final Function(DraggableScrollableNotification) onTouch;

  CustomDraggableScrollableSheet(this.builder,
      {this.dismissOnLoseFocus = false, this.decoration, this.expand = false, this.max = 1, this.min = 0.1, this.init = 0.1, this.onTouch, Key key})
      : super(key: key);

  @override
  _CustomDraggableScrollableSheetState createState() => _CustomDraggableScrollableSheetState();
}

class _CustomDraggableScrollableSheetState extends State<CustomDraggableScrollableSheet> {
  @override
  Widget build(BuildContext buildContext) {
    return ScrollConfiguration(
        behavior: _BottomSheetListViewBehaviour(),
        child: NotificationListener<DraggableScrollableNotification>(
            onNotification: (draggableScrollNotification) {
              widget.onTouch?.call(draggableScrollNotification);
              return true;
            },
            child: DraggableScrollableActuator(
                child: DraggableScrollableSheet(
                    initialChildSize: widget.init,
                    maxChildSize: widget.max,
                    minChildSize: widget.min,
                    expand: widget.expand,
                    builder: (context, scrollController) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(16, 24, 16, 0),
                        child: Container(
                          decoration: widget.decoration,
                          child: ListView(
                            controller: scrollController,
                            children: widget.builder((Function() callback) {
                              setState(() {
                                callback();
                              });
                            }, context),
                          ),
                        ),
                      );
                    }))));
  }
}

class _BottomSheetListViewBehaviour extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) => ClampingScrollPhysics();

  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) => child;
}

class _Background extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.white38;
    paint.strokeWidth = 75;
    paint.isAntiAlias = true;
    canvas.drawLine(Offset(-100, size.height * 0.8), Offset(size.width + 100, size.height * 0.35), paint);
    paint.color = Colors.white60;
    canvas.drawLine(Offset(-100, size.height * 0.8 - 100), Offset(size.width + 100, size.height * 0.35 - 100), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class StripeBackground extends StatelessWidget {
  final Widget child;
  StripeBackground({this.child, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _Background(),
      child: child,
    );
  }
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({this.page})
      : super(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                page,
            transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) => SlideTransition(
                position: animation.drive(Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.linearToEaseOut))),
                child: child));
}

class InkWellRow extends StatelessWidget {
  final GestureTapCallback onTap;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final EdgeInsets padding;
  InkWellRow({Key key, this.onTap, this.children, this.padding, this.mainAxisSize = MainAxisSize.max, this.mainAxisAlignment = MainAxisAlignment.start})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding ?? EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            children: children,
          ),
        ));
  }
}

class ExpandedSection extends StatefulWidget {
  final Widget child;
  final bool isExpanded;
  ExpandedSection({this.isExpanded = false, this.child});

  @override
  State<StatefulWidget> createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection> with SingleTickerProviderStateMixin {
  AnimationController _expandController;
  Animation<double> _animation;

  void _prepareAnimations() {
    _expandController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _animation = CurvedAnimation(parent: _expandController, curve: Curves.fastOutSlowIn);
  }

  void _runExpanded() {
    if (widget.isExpanded)
      _expandController.forward();
    else
      _expandController.reverse();
  }

  @override
  void initState() {
    super.initState();
    _prepareAnimations();
    _runExpanded();
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpanded();
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: 1.0,
      sizeFactor: _animation,
      child: widget.child,
    );
  }
}

class FlipAnimation extends StatefulWidget {
  final Widget front;
  final Widget back;
  final Function(AnimationStatus) callback;
  final AnimationController animationController;
  final bool enabledFlip;

  FlipAnimation(this.animationController, {this.enabledFlip = true, this.front, this.back, this.callback, Key key}) : super(key: key);

  @override
  _FlipAnimationState createState() => _FlipAnimationState();
}

class _FlipAnimationState extends State<FlipAnimation> with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _animation = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOutCubic)).animate(widget.animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        widget.callback?.call(status);
        _animationStatus = status;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.002)
          ..rotateY(pi * _animation.value),
        child: GestureDetector(
          onTap: () {
            if (!widget.enabledFlip) return;
            if (_animationStatus == AnimationStatus.dismissed)
              widget.animationController.forward();
            else if (_animationStatus == AnimationStatus.completed) widget.animationController.reverse();
          },
          child: _animation.value > 0.5 ? widget.back : widget.front,
        ));
  }
}

class ScaleTranslateAnimation extends StatefulWidget {
  final Offset beginPosition;
  final Offset endPosition;
  final double beginScale;
  final double endScale;
  final Widget child;

  final AnimationController animationController;

  ScaleTranslateAnimation(this.animationController,
      {this.child, this.beginPosition = Offset.zero, this.endPosition = Offset.zero, this.beginScale = 1, this.endScale = 2, Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScaleTranslateAnimationState();
}

class _ScaleTranslateAnimationState extends State<ScaleTranslateAnimation> {
  Animation _scaleAnimation;
  Animation _translateAnimation;
  AnimationStatus _scaleAnimationStatus;
  AnimationStatus _translateAnimationStatus;

  @override
  void initState() {
    super.initState();
    _scaleAnimationStatus = AnimationStatus.dismissed;
    _translateAnimationStatus = AnimationStatus.dismissed;
    _scaleAnimation = Tween(begin: widget.beginScale, end: widget.endScale).chain(CurveTween(curve: Curves.easeOutSine)).animate(widget.animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _scaleAnimationStatus = status;
      });
    _translateAnimation =
        Tween(begin: widget.beginPosition, end: widget.endPosition).chain(CurveTween(curve: Curves.fastOutSlowIn)).animate(widget.animationController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            _translateAnimationStatus = status;
          });
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setFromTranslationRotationScale(vector.Vector3(_translateAnimation.value.dx, _translateAnimation.value.dy, 0), vector.Quaternion.identity(),
            vector.Vector3.all(_scaleAnimation.value)),
      child: widget.child,
    );
  }
}

class OpacityAnimation extends StatefulWidget {
  final double beginOpacity;
  final double endOpacity;
  final Function(AnimationStatus) callback;
  final Widget Function(AnimationController) builder;
  final AnimationController animationController;

  OpacityAnimation(this.animationController, {this.builder, this.beginOpacity, this.endOpacity, this.callback, Key key}) : super(key: key);

  @override
  State<OpacityAnimation> createState() => _OpacityAnimationState();
}

class _OpacityAnimationState extends State<OpacityAnimation> {
  Animation _animation;
  AnimationStatus _animationStatus;

  @override
  void initState() {
    super.initState();
    _animationStatus = AnimationStatus.dismissed;
    _animation = Tween(begin: widget.beginOpacity, end: widget.endOpacity).animate(widget.animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _animationStatus = status;
        widget.callback?.call(status);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _animation.value,
      child: widget.builder(widget.animationController),
    );
  }
}

class TextWithBulletPoint extends StatelessWidget {
  final String bulletPoint;
  final String text;
  final TextStyle bulletPointStyle;
  final TextStyle style;

  TextWithBulletPoint(this.bulletPoint, this.text, {this.bulletPointStyle, this.style});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Text(
          bulletPoint,
          style: bulletPointStyle ?? style,
        ),
        Expanded(
          child: Text(
            text,
            style: style,
          ),
        ),
      ],
    );
  }
}

class TapLink extends StatelessWidget {
  final Widget child;
  final PageRouteBuilder route;
  TapLink({this.child, this.route, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWellRow(
      onTap: () {
        Navigator.of(context).push(route);
      },
      mainAxisAlignment: MainAxisAlignment.start,
      padding: EdgeInsets.symmetric(vertical: 4),
      children: <Widget>[
        child,
      ],
    );
  }
}

class TextDisplayPage extends StatelessWidget {
  final String text;
  TextDisplayPage(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            for(int i = 0; i < text.length; i++)
              Text(
                text[i],
                style: TextStyle(fontSize: 160, color: Colors.white),
             ),
          ],
        ),
      ),
    );
  }
}
