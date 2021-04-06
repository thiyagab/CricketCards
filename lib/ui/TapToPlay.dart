import 'package:flutter/material.dart';

final teamColors = [
  {
    'begin': Colors.blue,
    'end': Colors.green,
  },
  {
    'begin': Colors.green,
    'end': Colors.pink,
  },
  {
    'begin': Colors.pink,
    'end': Colors.red,
  },
  {
    'begin': Colors.red,
    'end': Colors.orange,
  },
  {
    'begin': Colors.orange,
    'end': Colors.purple,
  },
  {
    'begin': Colors.blue.shade500,
    'end': Colors.blue.shade800,
  },
];

class TapToPlay extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  TapToPlay({Key key, this.animationController, this.animation})
      : super(key: key);
  @override
  _TapToPlayState createState() => _TapToPlayState();
}

class _TapToPlayState extends State<TapToPlay> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _colorController;
/* 
  Animatable<Color> background =
      TweenSequence<Color>(teamColors1.asMap().entries.map((entry) {
    int index = entry.key;
    Color startColor = teamColors1[index];
    Color endColor = startColor;
    if (teamColors2.length > index) {
      final shuffleList = [...teamColors2];
      shuffleList.shuffle();
      endColor = shuffleList[index];
    }

    return TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(begin: startColor, end: endColor),
    );
  }).toList()); */

  Animatable<Color> background = TweenSequence<Color>(teamColors
      .map((e) => TweenSequenceItem(
          weight: 1.0, tween: ColorTween(begin: e['begin'], end: e['end'])))
      .toList());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 5400));
    _colorController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _colorController.repeat(reverse: true);
    _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isDesktop = width > 768;
    double fontSize = !isDesktop ? 30 : 45;
    double scale = !isDesktop ? 0.32 : 0.35;
    return Padding(
      padding: const EdgeInsets.only(top: 14.0),
      child: AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) => FadeTransition(
              opacity: widget.animation,
              child: new Transform(
                  transform: new Matrix4.translationValues(
                      0, (-1000) * (1.0 - widget.animation.value), 0.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: AnimatedBuilder(
                        animation: _colorController,
                        builder: (context, child) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Container(
                              height: height * scale,
                              width: width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(22.0),
                                      bottomLeft: Radius.circular(22.0),
                                      bottomRight: Radius.circular(22.0),
                                      topRight: Radius.circular(22.0)),
                                  color: background.evaluate(
                                      AlwaysStoppedAnimation(
                                          _colorController.value)),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 6),
                                      blurRadius: 20,
                                      color: background.evaluate(
                                          AlwaysStoppedAnimation(
                                              _colorController.value)),
                                    )
                                  ]),
                              child: Center(
                                  child: Text(
                                'Waiting for\nplayer\'s move',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.white,
                                  height: 1.5,
                                  decoration: TextDecoration.none,
                                ),
                              )),
                            ),
                          );
                        }),
                  )))),
    );
  }
}
