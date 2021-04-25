import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/model/Team.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:ipltrumpcards/model/player.dart';

import '../components/AnimatedButton.dart';
import '../components/GradientCard.dart';
import 'CricketCardsTheme.dart';

class PlayerCard extends StatelessWidget {
  AnimationController animationController;
  Animation animation;
  Color startColor;
  Color endColor;
  final Player player;
  TrumpModel model;
  Function attributeSelected;
  final bool itsme;

  PlayerCard(
      {Key key,
      this.animationController,
      this.animation,
      this.player,
      this.model,
      this.itsme,
      this.attributeSelected})
      : super(key: key) {
    this.animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn)));
    this.startColor = player.team.color2;
    this.endColor = player.team.color1;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0, (itsme ? 1000 : -1000) * (1.0 - animation.value), 0.0),
            child: card(context),
          ),
        );
      },
    );
  }

  Widget card(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
      child: GradientCard(
          startColor: this.startColor,
          endColor: this.endColor,
          child: Column(
            children: <Widget>[
              header(),
              separator(),
              content(context),
            ],
          )),
    );
  }

  Widget _addFadeAnim(Widget child) {
    return FadeTransition(
        opacity: animation,
        child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, (itsme ? 1500 : -1500) * (1.0 - animation.value), 0.0),
            child: child));
  }

  Widget _add3DButton(
      String attribute, String value, double buttonHeight, double buttonWidth) {
    String attributeName = Player.DISPLAY_MAP[attribute];
    double parsedValue = 0;
    bool isNumberVal = false;
    try {
      parsedValue = double.parse(value);
    } catch (e) {
      isNumberVal = false;
    }

    bool enableAttribute = isEnableAttribute(attribute);

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) => Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: _addFadeAnim(AnimatedButton(
            enabled: enableAttribute,
            height: buttonHeight, // This is for vasanth SE phone
            width: buttonWidth,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$attributeName',
                    style: TextStyle(
                        fontSize: 10,
                        color: enableAttribute ? Colors.white : Colors.white54,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      (isNumberVal
                          ? '${(parsedValue * animation.value).toInt()}'
                          : '$value'),
                      style: TextStyle(
                          fontSize: 18,
                          color:
                              enableAttribute ? Colors.white : Colors.white54,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ],
              ),
            ),
            onPressed: () {
              this.handleOnTapEvent(attribute);
            },
            shadowDegree: ShadowDegree.dark,
            color: endColor)),
      ),
    );
  }

  bool isEnableAttribute(String attribute) {
    if (model.isSinglePlayer()) {
      return model.lastSelectedLabel == null ||
          model.lastSelectedLabel == attribute;
    } else {
      return model.lastSelectedLabel == null
          ? model.itsMyTurn
          : model.lastSelectedLabel == attribute;
    }
  }

  void handleOnTapEvent(String key) {
    this.attributeSelected(key, model);
  }

  Widget _addAttributesRow(Map<String, dynamic> playerData,
      List<String> playerAttributes, double buttonHeight, double buttonWidth) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: playerAttributes.map((attribute) {
            return _add3DButton(
                attribute, playerData[attribute], buttonHeight, buttonWidth);
          }).toList()),
    );
  }

  Widget header() {
    final playerIcon =
        player.role != "bowler" ? 'batsman_Icon.svg' : 'bowler.svg';
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 10),
      child: _addFadeAnim(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/$playerIcon',
              height: 40.0,
              width: 40.0,
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
                      color: CricketCardsAppTheme.nearlyWhite.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget separator() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
      child: Container(
        height: 2,
        decoration: BoxDecoration(
          color: CricketCardsAppTheme.background,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
    );
  }

  Widget content(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double contentHeight = 180;
    if (height < 640) {
      contentHeight = 120;
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(children: <Widget>[
        Expanded(
            child: Container(
                height: contentHeight,
                child: Center(
                    child: player.open
                        ? playerAttributes((contentHeight / 2) - 10, 85)
                        : waitForPlayer())))
      ]),
    );
  }

  Widget playerAttributes(double buttonHeight, double buttonWidth) {
    final Map<String, dynamic> playerJson = player.toJson();

    final List<String> attributes = player.role == "bowler"
        ? Player.BOWLING_ATTRIBUTES
        : Player.BATTING_ATTRIBUTES;

    return Column(children: [
      _addAttributesRow(
          playerJson, attributes.sublist(0, 3), buttonHeight, buttonWidth),
      _addAttributesRow(
          playerJson, attributes.sublist(3, 6), buttonHeight, buttonWidth),
    ]);
  }

  Widget waitForPlayer() {
    return Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: Text(
          'Waiting for player\'s move',
          style: TextStyle(
            fontFamily: CricketCardsAppTheme.fontName,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            decoration: TextDecoration.none,
            color: CricketCardsAppTheme.nearlyWhite.withOpacity(0.8),
          ),
        ));
  }
}
