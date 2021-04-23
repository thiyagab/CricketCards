import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipltrumpcards/model/Team.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:ipltrumpcards/model/player.dart';
import 'package:provider/provider.dart';

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
        sortByRoleAndGet(teamPlayersMap[team.toString()], 6, 5);
    trumpModel.botCards = buildBotTeam(team);
    trumpModel.initMeta();
    trumpModel.gameState = TrumpModel.SINGLE;
    return trumpModel;
  }

  static TrumpModel prepareTwoPlayerGame() {
    debugPrint('Preparing two player');
    TrumpModel trumpModel = TrumpModel();
    List<Player> playersList = [];
    teamPlayersMap.forEach((key, value) {
      playersList.addAll(value);
    });
    playersList = sortByRoleAndGet(playersList, 12, 10);

    splitAndBuildTwoPlayers(trumpModel, playersList);
    trumpModel.initMeta();
    trumpModel.gameState = TrumpModel.WAIT;

    cancelSubscription();
    update2Players(
        playerIds: playersList.map<String>((player) => player.id).toList(),
        gameState: 0,
        selectedAttribute: null);

    return trumpModel;
  }

  static splitAndBuildTwoPlayers(
      TrumpModel trumpModel, List<Player> playersList,
      {bool reverse: false}) {
    trumpModel.playerCards = playersList.sublist(0, 6);
    trumpModel.playerCards.addAll(playersList.sublist(playersList.length - 5));

    trumpModel.botCards = playersList.sublist(6, 12);
    trumpModel.botCards.addAll(
        playersList.sublist(playersList.length - 10, playersList.length - 5));

    //Swap it,  the other logic of changing index above seems to be messy, this is easier
    if (reverse) {
      List tempList = trumpModel.playerCards;
      trumpModel.playerCards = trumpModel.botCards;
      trumpModel.botCards = tempList;
    }
  }

  static String teamName(Teams team) {
    String name = team.toString().substring(6).toLowerCase();
    return name.characters.first.toUpperCase() + name.substring(1);
  }

  static List<Player> buildBotTeam(Teams playerTeam) {
    List<Player> botPlayers = [];
    Teams.values.forEach((team) {
      if (team != playerTeam) {
        botPlayers.addAll(teamPlayersMap[team.toString()]);
      }
    });

    return sortByRoleAndGet(botPlayers, 6, 5);
  }

  static List<Player> sortByRoleAndGet(
      List<Player> players, int numBatsmen, int numBowlers) {
    players.shuffle();
    //Once sorted, batsman comes first and bowler next, so pick the top 6 and last 5.
    //For this logic to work, the list should have atleast 6 batsmand and 5 bowlers
    players.sort((a, b) => a.role.compareTo(b.role));
    List<Player> finalList = [];
    finalList.addAll(players.sublist(0, numBatsmen));
    finalList
        .addAll(players.sublist(players.length - numBowlers, players.length));
    return finalList;
  }

  static Map<String, List<Player>> teamPlayersMap = Map();
  static Map<String, Player> playersMap = Map();

  static Future<dynamic> initialize() async {
    Teams.values.forEach((team) async {
      String data = await rootBundle.loadString('assets/teams/' +
          team.toString().substring(6).toLowerCase() +
          ".json");
      List<dynamic> l = jsonDecode(data);
      List<Player> players = List<Player>.from(l.map<Player>((model) {
        Player player = Player.fromJson(model as Map);
        player.team = team;
        playersMap.putIfAbsent(player.id, () => player);
        return player;
      }));
      teamPlayersMap.putIfAbsent(team.toString(), () => players);
    });
    return Firebase.initializeApp();
  }

  static testfirebase() {
    int points = 10;

    DocumentReference teamReference =
        FirebaseFirestore.instance.collection('teams').doc('mumbai');
    //TODO Move this logic to cloud function and make it transactional, else we will end up with so many dirty updates
    teamReference.get().then((value) => {
          teamReference.update({
            "score": value.data()['score'] + points,
            "plays": value.data()['plays'] + 1,
            "wins": value.data()['wins'] + (points == 0 ? 0 : 1)
          }),
        });
  }

  static updateScore(TrumpModel model) {
    int points = 0;

    if (model.playerScore > model.botScore) {
      points = model.playerScore;
      // - model.botScore;
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

  static update2Players(
      {List<String> playerIds,
      int gameState: -1,
      String selectedAttribute,
      int selectedIndex: -1,
      String id}) {
    //TODO once we implement id generation, we can remove this
    if (id == null) {
      id = '1';
    }
    debugPrint('updating to firebase');
    DocumentReference teamReference =
        FirebaseFirestore.instance.collection('2players').doc(id);
    //TODO Move this logic to cloud function and make it transactional, else we will end up with so many dirty updates
    Map<String, dynamic> valuejson = {};
    teamReference.get().then((value) => {
          if (playerIds != null) {valuejson["playerIds"] = playerIds},
          if (gameState >= 0) {valuejson["gameState"] = gameState},
          // if (selectedAttribute != null)
          {valuejson["selectedAttribute"] = selectedAttribute},
          if (selectedIndex >= 0) {valuejson["selectedIndex"] = selectedIndex},
          teamReference.update(valuejson),
        });
  }

  static Future<TrumpModel> joinAndPrepareGame({String id: '1'}) async {
    DocumentReference teamReference =
        FirebaseFirestore.instance.collection('2players').doc(id);
    DocumentSnapshot snapshot = await teamReference.get();
    Map data = snapshot.data();
    List playerIds = data['playerIds'];
    List<Player> playersList = [];
    if (playerIds != null) {
      playerIds.forEach((id) {
        playersList.add(playersMap[id.toString()]);
      });
    }
    TrumpModel model = new TrumpModel();
    splitAndBuildTwoPlayers(model, playersList, reverse: true);
    model.initMeta();
    model.gameState = TrumpModel.WAIT;
    update2Players(gameState: TrumpModel.TWO);

    return model;
  }

  static StreamSubscription subscription;

  static cancelSubscription() {
    if (subscription != null) {
      subscription.cancel();
    }
  }

  static listen2Players(BuildContext context, Function attributeSelected,
      {String id: '1'}) {
    debugPrint('Listen...');
    cancelSubscription();
    DocumentReference teamReference =
        FirebaseFirestore.instance.collection('2players').doc(id);
    subscription = teamReference.snapshots().listen((event) {
      debugPrint(event.metadata.hasPendingWrites.toString() +
          ' ' +
          event.metadata.isFromCache.toString());
      debugPrint(event.data().toString());
      if (event.exists) {
        Map data = event.data();
        int gameState = data['gameState'];
        debugPrint('GameState: ' + gameState.toString());
        if (gameState > 0) {
          TrumpModel model = Provider.of<TrumpModel>(context, listen: false);
          model.checkAndStartTwoPlayerGame();
          if (data['selectedAttribute'] != null)
            attributeSelected(data['selectedAttribute'], model);
        }
      }
    });
  }

  static share() {
    if (!kIsWeb) {
      throw UnimplementedError('Share is only implemented on Web');
    }
    //TODO uncomment this for web deployment
    // var shareData = {
    //   "title": 'IPL Trump Cards',
    //   "text": 'Play and score for your favorite team to top the points table',
    //   "url": 'https://ipl-trump-cards.web.app',
    // };
    // window.navigator.share(shareData);
  }
}
