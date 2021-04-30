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
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static final String IPL11 = 'IPL 11';
  static TrumpModel singlePlayer(Teams team) {
    TrumpModel trumpModel = TrumpModel();
    trumpModel.playerTeam = team;
    trumpModel.playerCards = sortByRoleAndGet(
        players: teamPlayersMap[team.toString()], numBatsmen: 6, numBowlers: 5);
    trumpModel.botCards = buildBotTeam(team);
    trumpModel.initMeta();
    trumpModel.gameState = TrumpModel.SINGLE;
    return trumpModel;
  }

  static List<Player> randomPlayerList(Teams team) {
    List<Player> playersList = [];
    if (team == null)
      teamPlayersMap.forEach((key, value) {
        playersList.addAll(value);
      });
    else
      playersList = teamPlayersMap[team.toString()];

    playersList =
        sortByRoleAndGet(players: playersList, numBatsmen: 6, numBowlers: 5);

    return playersList;
  }

  static Future<TrumpModel> hostTwoPlayers(Teams team, String id) async {
    debugPrint('hosting two player');
    await cancelSubscription();
    TrumpModel trumpModel = TrumpModel();

    List<Player> playersList = randomPlayerList(team);

    trumpModel.playerCards = playersList;
    trumpModel.playerTeam = team;
    trumpModel.gameState = TrumpModel.WAIT;
    trumpModel.itsMyTurn = true;
    trumpModel.hostid = id;
    await createOrupdateGameSession(
        id: id,
        hostPlayerIds: playersList.map<String>((player) => player.id).toList(),
        gameState: 0,
        hostTeam: team,
        selectedIndex: -1,
        selectedAttribute: null);

    return trumpModel;
  }

  static Future<QuerySnapshot> getGameSession(int code) async {
    Query query = FirebaseFirestore.instance
        .collection('2players')
        .where('code', isEqualTo: code);
    return await query.get();
  }

  static Future<TrumpModel> joinTwoPlayers(Teams team, {int code}) async {
    await cancelSubscription();

    QuerySnapshot snapshot = await getGameSession(code);

    Map data = snapshot.docs.first.data();

    String id = snapshot.docs.first.id;

    TrumpModel model = new TrumpModel();
    model.botCards = playerList(data['hostPlayerIds']);
    model.botTeam = Team.teamsMap[data['joinedTeam'].toString().toLowerCase()];
    //TODO if host team is IPL 11, then we need to make sure the same players are not picked while picking random
    //Ippodhaiku interest illa.. only if the game crosses 1000 downloads will fix this
    model.playerCards = randomPlayerList(team);
    model.playerTeam = team;

    model.initMeta();
    model.gameState = TrumpModel.WAIT;
    model.itsMyTurn = false;
    model.hostid = id;
    await createOrupdateGameSession(
        id: id,
        gameState: TrumpModel.TWO,
        joinedTeam: team,
        selectedIndex: 0,
        joinedPlayerIds: model.playerCards.map((e) => e.id).toList());

    return model;
  }

  static List<Player> playerList(List playerIds) {
    List<Player> playersList = [];
    if (playerIds != null) {
      playerIds.forEach((id) {
        playersList.add(playersMap[id.toString()]);
      });
    }
    return playersList;
  }

  static Future<dynamic> increaseAndCreateHost() async {
    CollectionReference reference =
        FirebaseFirestore.instance.collection('2players');

    QuerySnapshot value =
        await reference.orderBy('code', descending: true).limit(1).get();
    return createNewGameSession(value.docs[0].data()['code']);
  }

  static Future<dynamic> clearGameSession(String id, int code) async {
    DocumentReference reference =
        FirebaseFirestore.instance.collection('2players').doc(id);

    await reference.set({'code': code}, SetOptions(merge: false));
  }

  static Future<dynamic> createNewGameSession(int lastCode) async {
    int newcode = lastCode + 1;
    DocumentReference teamReference =
        FirebaseFirestore.instance.collection('2players').doc();
    await teamReference.set({'code': newcode});
    return [newcode, teamReference.id];
  }

  static createOrupdateGameSession(
      {List<String> hostPlayerIds,
      List<String> joinedPlayerIds,
      int gameState: -1,
      Teams hostTeam,
      Teams joinedTeam,
      String selectedAttribute,
      int selectedIndex: -1,
      String id}) async {
    debugPrint('updating to firebase');
    DocumentReference documentReference =
        await FirebaseFirestore.instance.collection('2players').doc(id);

    Map<String, dynamic> valuejson = {};
    // DocumentSnapshot value = await teamReference.get();
    if (hostPlayerIds != null) {
      valuejson["hostPlayerIds"] = hostPlayerIds;
    }
    if (joinedPlayerIds != null) {
      valuejson["joinedPlayerIds"] = joinedPlayerIds;
    }
    if (gameState >= 0) {
      valuejson["gameState"] = gameState;
    }
    if (hostTeam != null) {
      valuejson['hostTeam'] = Utils.teamName(hostTeam).toLowerCase();
    }
    if (joinedTeam != null) {
      valuejson['joinedTeam'] = Utils.teamName(joinedTeam).toLowerCase();
    }
    valuejson["selectedAttribute"] = selectedAttribute;
    valuejson["selectedIndex"] = selectedIndex;
    return documentReference.set(valuejson, SetOptions(merge: true));
  }

  static listenTwoPlayers(BuildContext context, bool host, {String id}) async {
    debugPrint('Listen...');
    await cancelSubscription();
    DocumentReference teamReference =
        FirebaseFirestore.instance.collection('2players').doc(id);

    subscription = teamReference.snapshots().listen((event) {
      debugPrint('Event');
      if (event.exists) {
        Map data = event.data();
        int gameState = data['gameState'];
        debugPrint('GameState: ' + gameState.toString());
        if (gameState == 2) {
          TrumpModel model = Provider.of<TrumpModel>(context, listen: false);
          if (host) {
            model.botCards = playerList(data['joinedPlayerIds']);
            if (data['joinedTeam'] != null) {
              model.botTeam = Team.teamsMap[data['joinedTeam']];
            }
          }
          if (data['selectedIndex'] != null && data['selectedIndex'] == 0)
            model.initMeta();
          if (!model.isSinglePlayer()) {
            model.checkAndStartTwoPlayerGame();
            if (data['selectedAttribute'] != null)
              model.attributeSelected(data['selectedAttribute'], model);
          }
        }
      }
    });
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
    if (team == null) return IPL11;
    String name = team.toString().substring(6).toLowerCase();
    return camelCase(name);
  }

  static String camelCase(String text) {
    return text.characters.first.toUpperCase() + text.substring(1);
  }

  static List<Player> buildBotTeam(Teams playerTeam) {
    List<Player> botPlayers = [];
    Teams.values.forEach((team) {
      if (team != playerTeam) {
        botPlayers.addAll(teamPlayersMap[team.toString()]);
      }
    });

    return sortByRoleAndGet(players: botPlayers, numBatsmen: 6, numBowlers: 5);
  }

  static List<Player> sortByRoleAndGet(
      {List<Player> players, int numBatsmen, int numBowlers}) {
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
      updatePointsLocal(points);
      if (model.isPlayingForTeam()) {
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
  }

  static updatePointsLocal(int scoredPoints) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int points = prefs.getInt('points');
    if (points == null) points = 0;
    points = points + scoredPoints;
    prefs.setInt('points', points);
  }

  static getTotalPointsScored() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int points = prefs.getInt('points');
    return points == null ? 0 : points;
  }

  static StreamSubscription subscription;

  static cancelSubscription() async {
    if (subscription != null) {
      await subscription.cancel();
      subscription = null;
    }
  }

  static share() {
    if (kIsWeb) {
      throw UnimplementedError('Share is only implemented on android');
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
