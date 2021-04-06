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
    trumpModel.playerCards =
        sortByRoleAndGetEleven(playersMap[team.toString()]);
    trumpModel.botCards = buildBotTeam(team);
    trumpModel.selectedIndex = 0;
    trumpModel.playerCard = trumpModel.playerCards[0];
    trumpModel.botCard = trumpModel.botCards[0];
    trumpModel.botCard.open = false;
    return trumpModel;
  }

  static String teamName(Teams team) {
    String name = team.toString().substring(6).toLowerCase();
    return name.characters.first.toUpperCase() + name.substring(1);
  }

  static List<Player> buildBotTeam(Teams playerTeam) {
    List<Player> botPlayers = [];
    Teams.values.forEach((team) {
      if (team != playerTeam) {
        botPlayers.addAll(playersMap[team.toString()]);
      }
    });

    return sortByRoleAndGetEleven(botPlayers);
  }

  static List<Player> sortByRoleAndGetEleven(List<Player> players) {
    players.shuffle();
    //Once sorted, batsman comes first and bowler next, so pick the top 6 and last 5.
    //For this logic to work, the list should have atleast 6 batsmand and 5 bowlers
    players.sort((a, b) => a.role.compareTo(b.role));
    List<Player> finalList = [];
    finalList.addAll(players.sublist(0, 6));
    finalList.addAll(players.sublist(players.length - 5, players.length));
    return finalList;
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
