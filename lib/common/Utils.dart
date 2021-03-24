import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipltrumpcards/model/Team.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:ipltrumpcards/model/player.dart';

class Utils {
  static Color color(hexCode) {
    return Color(int.parse('0xff$hexCode'));
  }

  //TODO #2 move this to a defined classes
  static Color textColor = Colors.white;

  static TrumpModel prepareGame(Teams team) {
    TrumpModel trumpModel = TrumpModel();
    trumpModel.playerTeam = team;
    trumpModel.playerCards = playersMap[team.toString()];
    trumpModel.playerCards.shuffle();
    trumpModel.playerCards = trumpModel.playerCards.sublist(0, 11);
    trumpModel.botCards = buildBotTeam(team);

    return trumpModel;
  }

  static List<Player> buildBotTeam(Teams playerTeam) {
    List<Player> botPlayers = [];
    Teams.values.forEach((team) {
      if (team != playerTeam) {
        botPlayers.addAll(playersMap[team.toString()]);
      }
    });
    botPlayers.shuffle();
    //TODO search and add exact 6 batsman and bowlers in order
    return botPlayers.sublist(0, 11);
  }

  static Map<String, List<Player>> playersMap = new Map();

  static Future<dynamic> initialize() async {
    Teams.values.forEach((team) async {
      String data = await rootBundle.loadString('assets/teams/' +
          team.toString().substring(6).toLowerCase() +
          ".json");
      List<dynamic> l = jsonDecode(data);
      List<Player> players = List<Player>.from(l.map<Player>((model) {
        Player player = Player.fromJson(model as Map);
        player.team = team;
        return player;
      }));
      playersMap.putIfAbsent(team.toString(), () => players);
    });
    return Firebase.initializeApp();
  }

  static updateScore(TrumpModel model) {
    int points = 0;

    if (model.playerScore > model.botScore) {
      points = model.playerScore - model.botScore;
    }
    String team = model.playerTeam.toString().substring(6).toLowerCase();
    DocumentReference teamReference =
        FirebaseFirestore.instance.collection('teams').doc(team);
    //TODO Move this logic to cloud function and make it transactional, else we will end up with so many dirty updates
    teamReference.get().then((value) => {
          teamReference.update({
            "score": value.data()['score'] + points,
            "plays": value.data()['plays'] + 1,
            "wins": value.data()['wins'] + (points == 0 ? 0 : 1)
          }),
        });
  }
}
