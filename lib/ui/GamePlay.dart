import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipltrumpcards/model_bkp/TrumpModel.dart';
import 'package:ipltrumpcards/model_bkp/player.dart';
import 'package:provider/provider.dart';

class GamePlay extends StatefulWidget {
  GamePlay({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GamePlayState createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> {
  var width, height;
  TrumpModel trumpModel;

  @override
  void initState() {
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
                color: Colors.white,
                child: Column(children: [
                  _cards(context, model.botCards, model),
                  _card(context, model.botCard, model),
                  _card(context, model.playerCard, model),
                  _cards(context, model.playerCards, model),
                ]))));
  }

  Widget _card(BuildContext context, Player player, TrumpModel model) {
    return Center(
        child: Container(
            height: this.height / 3,
            width: (this.width / 2),
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: player == null
                    ? Center(child: Text("Tap on card to play"))
                    : _buildPlayerDetails(player, model))));
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
    model.botCard = model.botCards[model.selectedIndex];
    //TODO now just comparing number of matches, need to build logic to compare the selected attribute
    // also score 0 is set explicitly to make the player already played, -1 is considered as unplayed
    if (model.botCard.nummatches > model.playerCard.nummatches) {
      model.botCard.score = 100;
      model.playerCard.score = 0;
    } else {
      model.playerCard.score = 100;
      model.botCard.score = 0;
    }
    model.refreshBotCard();
  }

  Widget _cards(context, List<Player> cards, TrumpModel model) {
    return Container(
      height: height / 8, // card height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        itemBuilder: (context, i) {
          return Container(
              width: this.width / 5,
              child: GestureDetector(
                  onTap: () {
                    //If the score is -1, then its not played,and for played cards, dont process tap
                    if (cards[i].score < 0) _cardSelected(model, i);
                  },
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    child: Center(
                      child: Text(
                        _cardState(cards[i], i),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  )));
        },
      ),
    );
  }

  void _cardSelected(TrumpModel model, int index) {
    model.setPlayerCard(index);
    model.botCard = null;
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
