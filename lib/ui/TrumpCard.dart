import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/model/Team.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:ipltrumpcards/model/player.dart';
import 'package:ipltrumpcards/ui/CustomButton.dart';
import 'package:provider/provider.dart';

class TrumpCard extends StatelessWidget {
  final Player player;

  final ScrollController itemScrollController;

  TrumpCard(this.player, this.itemScrollController);
  double width;
  double height;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.width;
    width = MediaQuery.of(context).size.width;
    return Center(
        child: Container(
            height: height / 3,
            width: (width - 30),
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Card(
                color: player.team.color2,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: <Widget>[
                    playerInfoContainer(player, context),
                    playerStatisticsContainer(player)
                  ],
                ))));
  }

  Widget playerInfoContainer(Player player, BuildContext context) {
    return Container(
      width: (this.width - (this.width / 5)) / 2 - 20,
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     colorFilter: new ColorFilter.mode(
      //         player.team.color2.withOpacity(0.1), BlendMode.dstATop),
      //     image: AssetImage('assets/images/csk-logo.png'),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                player.shortName + "\n" + playerTotalScore(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Oswald',
                    fontSize: 32,
                    color: Utils.textColor.withOpacity(0.7)),
              )),
          Container(
              padding: EdgeInsets.fromLTRB(15, 0, 10, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Image(
                      image: AssetImage('assets/images/AUS.png'),
                      width: 50,
                      height: 40,
                      fit: BoxFit.fitWidth),
                  Image(
                      image: AssetImage('assets/images/all-rounder.png'),
                      width: 50,
                      height: 40)
                ],
              ))
        ],
      ),
    );
  }

  Widget playerStatisticsContainer(Player player) {
    Map<String, dynamic> playerJson = player.toJson();
    // List<String> attributes = player.role == "bowler"
    //     ? Player.BOWLING_ATTRIBUTES
    //     : Player.BATTING_ATTRIBUTES;
    return Expanded(
        child: Container(
      margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: Player.BATTING_ATTRIBUTES.sublist(0, 4).map((attribute) {
              return CustomButton(Player.DISPLAY_MAP[attribute], attribute,
                  playerJson[attribute], player.team.color1, handleOnTapEvent);
            }).toList(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //TODO this should be conditional, based on role
            children: Player.BOWLING_ATTRIBUTES.sublist(4).map((attribute) {
              return CustomButton(Player.DISPLAY_MAP[attribute], attribute,
                  playerJson[attribute], player.team.color1, handleOnTapEvent);
            }).toList(),
          )
        ],
      ),
    ));
  }

  String playerTotalScore(BuildContext context) {
    TrumpModel model = Provider.of<TrumpModel>(context, listen: false);

    return (model.playerTeam == player.team
            ? model.playerScore.toString()
            : model.botScore.toString()) +
        "/" +
        (model.playerScore + model.botScore).toString();
  }

  handleOnTapEvent(String key, String value, BuildContext context) {
    TrumpModel model = Provider.of<TrumpModel>(context, listen: false);
    model.refreshBotAndScore(key, value);
    Timer(
        Duration(seconds: 2),
        () => {
              model.moveCard(),
              if (model.selectedIndex < 7)
                itemScrollController.animateTo(
                    (this.width / 5) * model.selectedIndex,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease)
            });
  }
}
