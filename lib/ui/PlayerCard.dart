import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/model/Team.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:ipltrumpcards/model/player.dart';
import 'package:ipltrumpcards/ui/GradientCard.dart';
import 'package:provider/provider.dart';

import 'CricketCardsTheme.dart';
import 'animatedPressButton.dart';

class PlayerCard extends StatelessWidget {
  AnimationController animationController;
  Animation animation;
  Color startColor;
  Color endColor;
  final Player player;
  double parentHeight;
  TrumpModel model;

  PlayerCard(
      {Key key,
      this.animationController,
      this.animation,
      this.player,
      this.parentHeight,
      this.model})
      : super(key: key) {
    this.animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn)));
    this.startColor = player.team.color2;
    this.endColor = player.team.color1;
  }

  Widget _addFadeAnim(Widget child) {
    return FadeTransition(
        opacity: animation,
        child: new Transform(
            transform: new Matrix4.translationValues(
                0.0,
                (model.isBot(player) ? -1500 : 1500) * (1.0 - animation.value),
                0.0),
            child: child));
  }

  Widget _add3DButton(String attribute, String value) {
    String attributeName = Player.DISPLAY_MAP[attribute];
    double parsedValue = 0;
    bool isNumberVal = false;
    try {
      parsedValue = double.parse(value);
    } catch (e) {
      isNumberVal = false;
      // debugPrint(
      //     'Couldn\'t parse double for $attributeName with $value, error $e');
    }
    bool isUnSelectedAttribute = (player.score >= 0 &&
        model.lastSelectedLabel != null &&
        model.lastSelectedLabel != attribute);
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) => Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: _addFadeAnim(AnimatedButton(
            enabled: !isUnSelectedAttribute,
            height:
                parentHeight > 640 ? 80.0 : 50, // This is for vasanth SE phone
            width: 85.0,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    player.open ? '$attributeName' : '',
                    style: TextStyle(
                        fontSize: 10,
                        color: isUnSelectedAttribute
                            ? Colors.white54
                            : Colors.white,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      player.open
                          ? (isNumberVal
                              ? '${(parsedValue * animation.value).toInt()}'
                              : '$value')
                          : '',
                      style: TextStyle(
                          fontSize: 18,
                          color: isUnSelectedAttribute
                              ? Colors.white54
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ],
              ),
            ),
            onPressed: () {
              this.handleOnTapEvent(attribute, value, context);
            },
            shadowDegree: ShadowDegree.dark,
            color: endColor)),
      ),
    );
  }

  Widget _addAttributesRow(
      Map<String, dynamic> playerData, List<String> playerAttributes) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: playerAttributes.map((attribute) {
            return _add3DButton(attribute, playerData[attribute]);
          }).toList()),
    );
  }

  static bool waitForNext = false;

  void handleOnTapEvent(String key, String value, BuildContext context) {
    TrumpModel model = Provider.of<TrumpModel>(context, listen: false);
    if (!waitForNext) {
      waitForNext = true;
      model.refreshBotAndScore(key, value);
      Timer(
          Duration(seconds: 2),
          () => {
                animationController.duration = Duration(milliseconds: 1000),
                animationController.reverse(),
              });
      Timer(
          Duration(milliseconds: 2500),
          () => {
                waitForNext = false,
                // animationController.reverse(from: 0.6),
                model.moveCard(),

                if (!model.isGameOver())
                  // {showScoreDialog(context, model)}
                  // else
                  {
                    animationController.reset(),
                    animationController.duration = Duration(milliseconds: 1000),
                    animationController.forward(from: 0.0),
                  }
                else
                  {Utils.updateScore(model)}
              });
    }
  }

  void showScoreDialog(BuildContext context, final TrumpModel model) {
    Utils.updateScore(model);
    String displayText = Utils.teamName(model.playerTeam) +
        (model.playerScore > model.botScore ? " Won" : " Lost");
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(displayText),

              // backgroundColor: model.playerTeam.color1,
              actions: [
                TextButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: Text("Ok"))
              ]);
        }).then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('Name: ${player.shortName}');
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0,
                (model.isBot(player) ? -1000 : 1000) * (1.0 - animation.value),
                0.0),
            child: _buildCard(context),
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context) {
    final Map<String, dynamic> playerJson = player.toJson();
    final isBowler = player.role == "bowler";
    final List<String> attributes =
        isBowler ? Player.BOWLING_ATTRIBUTES : Player.BATTING_ATTRIBUTES;
    final playerIcon = !isBowler ? 'batsman_Icon.svg' : 'bowler.svg';
    final playerAttributeRows = [
      _addAttributesRow(playerJson, attributes.sublist(0, 3)),
      _addAttributesRow(playerJson, attributes.sublist(3, 6)),
      // _addAttributesRow(
      //     playerJson, attributes.sublist(6, 8))
    ];
    final List<Widget> CardContent = player.open
        ? playerAttributeRows
        : [
            Stack(
              alignment: Alignment.center,
              children: [
                FadeTransition(
                  opacity: animation,
                  child: Center(
                      child: Text(
                    'Waiting for player\'s move',
                    style: TextStyle(
                      fontFamily: CricketCardsAppTheme.fontName,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      decoration: TextDecoration.none,
                      color: CricketCardsAppTheme.nearlyWhite.withOpacity(0.8),
                    ),
                  )),
                ),
                Opacity(
                    opacity: 0, child: Column(children: playerAttributeRows))
              ],
            )
          ];
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
      child: GradientCard(
          startColor: this.startColor,
          endColor: this.endColor,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 8, bottom: 10),
                child: _addFadeAnim(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/$playerIcon',
                        height: 40.0,
                        width: 40.0,
                        // color: Colors.white,
                        allowDrawingOutsideViewBox: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.open ? player.shortName : '',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: CricketCardsAppTheme.fontName,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                letterSpacing: 0.2,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Team : ' + Utils.teamName(player.team),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: CricketCardsAppTheme.fontName,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                decoration: TextDecoration.none,
                                color: CricketCardsAppTheme.nearlyWhite
                                    .withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 0, bottom: 0),
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: CricketCardsAppTheme.background,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      children: CardContent,
                    )),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
