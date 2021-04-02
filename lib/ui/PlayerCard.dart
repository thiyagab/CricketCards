import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:ipltrumpcards/model/player.dart';
import 'package:ipltrumpcards/ui/GradientCard.dart';
import 'package:provider/provider.dart';

import 'CricketCardsTheme.dart';
import 'animatedPressButton.dart';

class PlayerCard extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  final Color startColor;
  final Color endColor;
  final Player player;

  const PlayerCard(
      {Key key,
      this.animationController,
      this.animation,
      this.startColor,
      this.endColor,
      this.player})
      : super(key: key);

  Widget _addFadeAnim(Widget child) {
    return FadeTransition(
        opacity: animation,
        child: new Transform(
            transform: new Matrix4.translationValues(0, 0.0, 0.0),
            child: child));
  }

  Widget _add3DButton(String attribute, String value) {
    String attributeName = Player.DISPLAY_MAP[attribute];
    double parsedValue = 0; // Variable name should start with small letter
    bool isNumberVal = false;
    try {
      parsedValue = double.parse(value);
    } catch (e) {
      isNumberVal = false;
      debugPrint(
          'Couldn\'t parse double for $attributeName with $value, error $e');
    }
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) => Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: _addFadeAnim(AnimatedButton(
            height: 80.0,
            width: 80.0,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    player.open ? '$attributeName' : '',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
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
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
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

  void handleOnTapEvent(String key, String value, BuildContext context) {
    TrumpModel model = Provider.of<TrumpModel>(context, listen: false);
    model.refreshBotAndScore(key, value);
    debugPrint('It worked');
    Timer(
        Duration(seconds: 3),
        () => {
              model.moveCard(),
              if (model.selectedIndex >= model.playerCards.length)
                {showScoreDialog(context, model)}
            });
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
    TrumpModel model = Provider.of<TrumpModel>(context, listen: false);
    final Map<String, dynamic> playerJson = player.toJson();
    final List<String> attributes = player.role == "bowler"
        ? Player.BOWLING_ATTRIBUTES
        : Player.BATTING_ATTRIBUTES;

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(0.0, 0.0, 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: GradientCard(
                  startColor: this.startColor,
                  endColor: this.endColor,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, top: 8, bottom: 16),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: _addFadeAnim(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/batsman_Icon.svg',
                                    height: 50.0,
                                    width: 50.0,
                                    allowDrawingOutsideViewBox: true,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          player.open ? player.shortName : '',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily:
                                                CricketCardsAppTheme.fontName,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            letterSpacing: 0.2,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          'Team : ' +
                                              Utils.teamName(player.team),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontFamily:
                                                CricketCardsAppTheme.fontName,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            decoration: TextDecoration.none,
                                            color: CricketCardsAppTheme
                                                .nearlyWhite
                                                .withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, top: 0, bottom: 8),
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: CricketCardsAppTheme.background,
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Column(
                              children: [
                                _addAttributesRow(
                                    playerJson, attributes.sublist(0, 3)),
                                _addAttributesRow(
                                    playerJson, attributes.sublist(3, 6)),
                                // _addAttributesRow(
                                //     playerJson, attributes.sublist(6, 8))
                              ],
                            )),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}
