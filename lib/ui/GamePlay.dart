import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:ipltrumpcards/model/Team.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:ipltrumpcards/model/player.dart';
import 'package:provider/provider.dart';

class GamePlay extends StatefulWidget {
  GamePlay({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GamePlayState createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> {
  var width, height;

  ScrollController _itemScrollController;

  @override
  void initState() {
    _itemScrollController = ScrollController();
    super.initState();
    _prepareGame(context);
  }

  void _prepareGame(BuildContext context) {
    //TODO
    //1. build UI for player to choose team
    //2. UI to show bot selected opponent team
    //3. Shuffle the players and assign to bot and player
    Provider.of<TrumpModel>(context, listen: false).dummy();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Consumer<TrumpModel>(
        builder: (context, model, child) => SafeArea(
                child: Container(
                    child: Column(children: [
              _cards(context, model.botCards, model, Teams.MUMBAI),
              _card(context, model.botCard, model, Teams.MUMBAI),
              _card(context, model.playerCard, model, Teams.CHENNAI),
              _cards(context, model.playerCards, model, Teams.CHENNAI),
            ]))));
  }

  Widget _card(
      BuildContext context, Player player, TrumpModel model, Teams team) {
    return Center(
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(0, 236, 182, 49),
              Color.fromARGB(0, 217, 94, 19)
            ])),
            height: this.height / 3,
            width: (this.width - 30),
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: GradientCard(
                gradient: Gradients.buildGradient(Alignment.topLeft,
                    Alignment.bottomRight, [team.color1, team.color2]),
                shadowColor: Gradients.tameer.colors.last.withOpacity(0.25),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: _checkStateAndRenderCard(player, model))));
  }

  Widget _checkStateAndRenderCard(Player player, TrumpModel model) {
    if (player == null) {
      return Center(
          child: GestureDetector(
              onTap: () => {model.moveCard()},
              child: Text("Tap on card to play")));
    } else if (model.isGameOver()) {
      return _endcard(model);
    } else {
      return _buildPlayerDetails(player, model);
    }
  }

  Widget _endcard(TrumpModel model) {
    return Center(
        child: Text("Bot: " +
            model.botScore.toString() +
            "\n" +
            "You: " +
            model.playerScore.toString()));
  }

  Widget _buildPlayerDetails(Player player, TrumpModel model) {
    List<Widget> playerDetails = [];
    playerDetails.add(Text(player.name, style: TextStyle(fontSize: 20)));
    playerDetails.add(SizedBox(height: 10));
    playerDetails.add(TextButton(
        onPressed: () => {_trumpCard(model)},
        child: Text("Matches: " + player.nummatches.toString(),
            style: TextStyle(fontSize: 15))));
    playerDetails.add(TextButton(
        child: Text("Average: " + player.bataverage.toString(),
            style: TextStyle(fontSize: 15))));
    return Container(
        padding: EdgeInsets.all(10), child: Column(children: playerDetails));
  }

  void _trumpCard(TrumpModel model) {
    model.refreshBotAndScore();
    Timer(
        Duration(seconds: 2),
        () => {
              model.moveCard(),
              if (model.selectedIndex < 7)
                _itemScrollController.animateTo(
                    (this.width / 5) * model.selectedIndex,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease)
            });
  }

  Widget _cards(context, List<Player> cards, TrumpModel model, Teams team) {
    List<Widget> cardWidgets = [];
    for (int i = 0; i < cards.length; i++) {
      cardWidgets.add(Container(
          width: this.width / 5,
          child: Card(
            color: team.color1,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
            child: Center(
              child: Text(
                _cardState(cards[i], i),
                style: TextStyle(fontSize: 12),
              ),
            ),
          )));
    }
    return Container(
      height: height / 8, // card height
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _itemScrollController,
        child: Row(children: cardWidgets),
      ),
    );
  }

  void _cardSelected(TrumpModel model, int index) {
    model.moveCard();
  }

  String _cardState(Player player, int index) {
    //See if the card is already played
    if (player.score > -1) {
      return player.name + "\n" + player.score.toString();
    } else {
      return (index + 1).toString();
    }
    return "";
  }
}
