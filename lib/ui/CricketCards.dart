import 'package:flutter/material.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart' show JsonMapper;
import '../models/game/game.dart';
import '../models/players/player.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class CricketCards extends StatefulWidget {
  @override
  _CricketCardsState createState() => _CricketCardsState();
}

class _CricketCardsState extends State<CricketCards> {
  Game game;

  loadJson() async {
    String data = await rootBundle.loadString('assets/gameData.json');
    runInAction(() {
      final testList = JsonMapper.deserialize<Game>(data);
      game
        ..teams = testList.teams
        ..setUserTeam(game.teams[0])
        ..setUserPlayers(game.userTeam.players)
        ..setBotPlayers(game.botTeam.players);
    });
  }

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<Game>(
        create: (_) {
          game = new Game();
          return game;
        },
        child: MaterialApp(
            home: SafeArea(
          child: Scaffold(body: Playground()),
        )));
  }
}

class Playground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: BotPlayers(),
            ),
            Expanded(
              flex: 6,
              child: SelectedPlayerCards(),
            ),
            Expanded(
              flex: 2,
              child: UserPlayers(),
            ),
          ],
        ),
      ],
    );
  }
}

class BotPlayers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final game = Provider.of<Game>(context);
    return Observer(
        builder: (_) => ListView(
            scrollDirection: Axis.horizontal,
            children: game.botPlayers
                .map((e) => TrumpCard('Bot card ${(e.id)}'))
                .toList()));
  }
}

class UserPlayers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final game = Provider.of<Game>(context);
    return Observer(
        builder: (_) => ListView(
            scrollDirection: Axis.horizontal,
            children: game.userPlayers
                .map((Player e) => GestureDetector(
                      child: TrumpCard('${(e.name)}'),
                      onTap: () => game.setUserPlayer(e),
                    ))
                .toList()));
  }
}

class SelectedPlayerCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Observer(builder: (_) {
        final game = Provider.of<Game>(context);
        bool landscape =
            MediaQuery.of(context).orientation == Orientation.landscape;
        List<Widget> _cardsList = [
          Expanded(child: PlayerCard(game.chosenBotPlayer, true)),
          Expanded(child: PlayerCard(game.chosenUserPlayer))
        ];
        return landscape == true
            ? Row(children: _cardsList)
            : Column(children: _cardsList);
      });
}

class TrumpCard extends StatelessWidget {
  TrumpCard(this.cardName);
  final String cardName;
  @override
  Widget build(BuildContext context) {
    bool landscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    double ratio = landscape == false ? 1 : 2;
    return AspectRatio(
        aspectRatio: ratio,
        child: Card(
          margin: EdgeInsets.all(10),
          child: Center(child: Text('${(this.cardName)}')),
        ));
  }
}

class PlayerCard extends StatelessWidget {
  PlayerCard(this.player, [this.isBot = false]);
  final Player player;
  final bool isBot;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _defaultPlayInfo = player == null && isBot == false
        ? [
            Text(
              'Tap on any player\n to play',
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.5),
            )
          ]
        : [];
    final List<Widget> _playerInfo = player != null
        ? [
            SizedBox(height: 10.0),
            Text('Player Name : ${player.name}'),
            SizedBox(height: 5.0),
            Text('Matched Played : ${player.nummatches}'),
            SizedBox(height: 5.0),
            Text('Batting Average : ${player.bataverage}'),
            SizedBox(height: 5.0),
            Text('No of 50\'s : ${player.num50s}'),
            SizedBox(height: 5.0),
            Text('No of 100\'s : ${player.num100s}'),
          ]
        : _defaultPlayInfo;
    return Card(
        elevation: 2,
        margin: EdgeInsets.all(10),
        color: isBot == true ? Colors.pink : Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: DefaultTextStyle(
            child: AspectRatio(
              aspectRatio: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(isBot == true ? 'Bot' : 'User',
                      style: TextStyle(fontSize: 25)),
                  SizedBox(height: 10.0),
                  ..._playerInfo
                ],
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ));
  }
}
