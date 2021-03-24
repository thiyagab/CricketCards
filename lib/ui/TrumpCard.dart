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

  TrumpCard(this.player);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
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
                child: Row(
                  children: <Widget>[
                    playerInfoContainer(player, width),
                    playerStatisticsContainer(player)
                  ],
                ))));
  }

  Widget playerInfoContainer(Player player, width) {
    return Container(
      width: (width - (width / 5)) / 2 - 20,
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
                player.shortName,
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
    return Expanded(
        child: Container(
      margin: EdgeInsets.fromLTRB(0, 5, 5, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton('Runs', player.totalRuns, player.team.color1,
                  handleOnTapEvent),
              CustomButton('Matches', player.totalMatches.toString(),
                  player.team.color1, handleOnTapEvent),
              CustomButton('Avg., Score', player.battingAverage.toString(),
                  player.team.color1, handleOnTapEvent),
              CustomButton('Strike Rate', player.battingStrikeRate,
                  player.team.color1, handleOnTapEvent)
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton('Bw Strike', player.bowlingStrikeRate,
                  player.team.color1, handleOnTapEvent),
              CustomButton('Wickets', player.totalWickets, player.team.color1,
                  handleOnTapEvent),
              CustomButton('Bowling Avg.,', player.bowlingAverage,
                  player.team.color1, handleOnTapEvent),
              CustomButton('Economy', player.bowlingEconomy, player.team.color1,
                  handleOnTapEvent)
            ],
          )
        ],
      ),
    ));
  }

  handleOnTapEvent(String title, String value, BuildContext context) {
    TrumpModel model = Provider.of<TrumpModel>(context, listen: false);
    model.refreshBotAndScore();
    Timer(
        Duration(seconds: 2),
        () => {
              model.moveCard(),
            });
  }
}
