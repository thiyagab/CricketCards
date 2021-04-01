import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/model/Team.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:ipltrumpcards/model/player.dart';
import 'package:ipltrumpcards/ui/CustomButton.dart';
import 'package:provider/provider.dart';

class TrumpCard extends StatelessWidget {
  final Player player;
  final bool isPlayer;
  GlobalKey<FlipCardState> flipState;
  var width;

  TrumpCard(this.player, this.isPlayer);

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return card(context, player.open);
    // : FlipCard(
    //     // key: flipState,
    //     flipOnTouch: true,
    //     front: card(context, false),
    //     back: card(context, true));
  }

  Widget card(BuildContext context, bool open) {
    return Center(
        child: Container(
            height: 240,
            width: width - (width / 8),
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Card(
                color: player.team.color2,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: open
                    ? Row(
                        children: <Widget>[
                          playerInfoContainer(player, context),
                          playerStatisticsContainer(player)
                        ],
                      )
                    : Center(
                        child: Text(
                        Utils.teamName(player.team) + "\n" + player.role,
                        textAlign: TextAlign.center,
                      )))));
  }

  Widget playerInfoContainer(Player player, BuildContext context) {
    return Container(
      width: (this.width - (this.width / 5)) / 2 - 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                player.shortName,
                // + "\n" + playerTotalScore(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Oswald',
                    fontSize: 28,
                    color: Utils.textColor.withOpacity(0.7)),
              )),
          Container(
              padding: EdgeInsets.fromLTRB(15, 0, 10, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Image(
                  //     image: AssetImage('assets/images/AUS.png'),
                  //     width: 50,
                  //     height: 40,
                  //     fit: BoxFit.fitWidth),
                  Text(Utils.teamName(player.team),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Oswald',
                          fontSize: 12,
                          color: Utils.textColor.withOpacity(0.3))),
                  Image(
                      image: AssetImage(player.role == 'batsman'
                          ? 'assets/images/batsman.png'
                          : 'assets/images/bowler.png'),
                      width: 25,
                      height: 20)
                ],
              ))
        ],
      ),
    );
  }

  Widget playerStatisticsContainer(Player player) {
    Map<String, dynamic> playerJson = player.toJson();
    List<String> attributes = player.role == "bowler"
        ? Player.BOWLING_ATTRIBUTES
        : Player.BATTING_ATTRIBUTES;
    return Expanded(
        child: Container(
      margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: attributes.sublist(0, 4).map((attribute) {
              return CustomButton(Player.DISPLAY_MAP[attribute], attribute,
                  playerJson[attribute], player.team.color1, handleOnTapEvent);
            }).toList(),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //TODO this should be conditional, based on role
            children: attributes.sublist(4).map((attribute) {
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
        : model.botScore.toString());
    // + "/" +
    // (model.playerScore + model.botScore).toString();
  }

  handleOnTapEvent(String key, String value, BuildContext context) {
    TrumpModel model = Provider.of<TrumpModel>(context, listen: false);
    if (flipState != null) flipState.currentState.toggleCard();
    model.refreshBotAndScore(key, value);

    Timer(
        Duration(seconds: 1),
        () => {
              model.moveCard(),
              if (model.selectedIndex >= model.playerCards.length)
                {showScoreDialog(context, model)}
            });
  }

  String displayText;
  showScoreDialog(BuildContext context, final TrumpModel model) {
    Utils.updateScore(model);
    displayText = Utils.teamName(model.playerTeam) +
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
}
