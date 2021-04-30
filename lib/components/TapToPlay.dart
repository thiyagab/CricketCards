import 'package:flutter/material.dart';
import 'package:ipltrumpcards/ui/CricketCardsTheme.dart';
// import 'package:ipltrumpcards/model/Team.dart';

final teamColors = Iterable.generate(7).map((i) => {
      'begin': CricketCardsAppTheme.teamDarkColors[i],
      'end': CricketCardsAppTheme.teamDarkColors[i + 1]
    });

//
// [
//   {
//     'begin': CricketCardsAppTheme.teamDarkColors[0],
//     'end': CricketCardsAppTheme.teamLightColors[0],
//   },
//   {
//     'begin': Colors.green,
//     'end': Colors.yellow,
//   },
//   {
//     'begin': Colors.yellow,
//     'end': Colors.pink,
//   },
//   {
//     'begin': Colors.pink,
//     'end': Colors.red,
//   },
//   {
//     'begin': Colors.red,
//     'end': Colors.orange,
//   },
//   {
//     'begin': Colors.orange,
//     'end': Colors.purple,
//   },
//   {
//     'begin': Colors.blue.shade500,
//     'end': Colors.blue.shade800,
//   },
// ];

class TapToPlay extends StatefulWidget {
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
    _controller.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;

    double fontSize = 25;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      child: Center(
        child: FittedBox(
          child: Stack(
            children: [
              AnimatedBuilder(
                  animation: _colorController,
                  builder: (context, child) {
                    return Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: background.evaluate(
                              AlwaysStoppedAnimation(_colorController.value)),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 6),
                              blurRadius: 20,
                              color: background.evaluate(AlwaysStoppedAnimation(
                                  _colorController.value)),
                            )
                          ]),
                      child: Center(
                          child: Text(
                        'Waiting...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: Colors.white,
                          // height: 1.5,
                          decoration: TextDecoration.none,
                        ),
                      )),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
