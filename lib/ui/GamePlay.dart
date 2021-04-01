import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/model/Team.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:ipltrumpcards/model/player.dart';
import 'package:provider/provider.dart';

import 'TrumpCard.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    GlobalKey<FlipCardState> flipState = new GlobalKey();
    return Consumer<TrumpModel>(
        builder: (context, model, child) => SafeArea(
            child: Container(
                color: Colors.white70,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TrumpCard(model.botCard, false),
                      // _cards(context, model.botCards, model, false),
                      _scorePanel(context, model),
                      TrumpCard(model.playerCard, true),
                      // _cards(context, model.playerCards, model, false),
                    ]))));
  }

  Teams botCardTeam(TrumpModel model) {
    return model
        .botCards[model.selectedIndex == -1 ||
                model.selectedIndex == model.botCards.length
            ? 0
            : model.selectedIndex]
        .team;
  }

  Widget _scorePanel(BuildContext context, TrumpModel model) {
    return Container(
        child: RichText(
            text: TextSpan(children: <TextSpan>[
      TextSpan(
          text: model.playerScore.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
      TextSpan(text: '      vs      ', style: TextStyle()),
      TextSpan(
          text: model.botScore.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
    ])));
  }

  //TODO This can be moved into TrumpCard
  Widget _card(BuildContext context, TrumpModel model, Teams team) {
    return Center(
        child: Container(
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
                child: _checkStateAndRenderCard(model))));
  }

  Widget _checkStateAndRenderCard(TrumpModel model) {
    if (model.isGameOver()) {
      Utils.updateScore(model);
      return _endcard(model);
    } else {
      return Center(
          child: GestureDetector(
              onTap: () => {model.moveCard()},
              child: Text(Utils.teamName(model.playerTeam) +
                  ": " +
                  model.playerScore.toString() +
                  "      ipl11: " +
                  model.botScore.toString() +
                  "\n\nTap on an attribute to play")));
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
    playerDetails.add(Text(player.shortName, style: TextStyle(fontSize: 20)));
    playerDetails.add(SizedBox(height: 10));
    playerDetails.add(TextButton(
        onPressed: () => {_trumpCard(model)},
        child: Text("Matches: " + player.totalMatches.toString(),
            style: TextStyle(fontSize: 15))));
    playerDetails.add(TextButton(
        child: Text("Average: " + player.battingAverage.toString(),
            style: TextStyle(fontSize: 15))));
    return Container(
        padding: EdgeInsets.all(10), child: Column(children: playerDetails));
  }

  void _trumpCard(TrumpModel model) {
    // model.refreshBotAndScore();
    // Timer(
    //     Duration(seconds: 2),
    //     () => {
    //           model.moveCard(),
    //           if (model.selectedIndex < 7)
    //             _itemScrollController.animateTo(
    //                 (this.width / 5) * model.selectedIndex,
    //                 duration: Duration(milliseconds: 500),
    //                 curve: Curves.ease)
    //         });
  }

  Widget _cards(context, List<Player> cards, TrumpModel model, bool isPlayer) {
    Tween<Offset> _offset =
        Tween(begin: Offset(-1, isPlayer ? -1 : 1), end: Offset(0, 0));

    final GlobalKey<AnimatedListState> _listKey =
        GlobalKey<AnimatedListState>();
    List<Widget> miniCardList = [];

    if (model.playerScore == 0 && model.botScore == 0) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Future ft = Future(() {});
        cards.asMap().forEach((index, elements) {
          ft = ft.then((value) {
            return Future.delayed(const Duration(milliseconds: 100), () {
              miniCardList.add(this.miniCard(context, cards[index], isPlayer));
              _listKey.currentState.insertItem(miniCardList.length - 1);
            });
          });
        });
      });
    } else {
      cards.asMap().forEach((index, elements) {
        return miniCardList.add(this.miniCard(context, cards[index], isPlayer));
      });
      // miniCardList.removeAt(model.selectedIndex);
      // _listKey.currentState
      //     .removeItem(model.selectedIndex, (context, animation) => null);
    }

    return Container(
        // card height
        height: 50,
        child:
            // Row(children: [
            // Padding(
            //     padding: EdgeInsets.only(left: 40),
            //     child: DefaultTextStyle(
            //         textAlign: TextAlign.end,
            //         style:
            //             TextStyle(color: model.playerTeam.color1, fontSize: 20),
            //         child: Text("0 Points"))),
            AnimatedList(
                key: _listKey,
                reverse: true,
                scrollDirection: Axis.vertical,
                initialItemCount: miniCardList.length,
                itemBuilder: (context, index, animation) {
                  return SlideTransition(
                    position: animation.drive(_offset),
                    child: miniCardList[index],
                  );
                })
        // ])
        );
  }

  Widget miniCard(BuildContext context, Player player, bool isPlayer) {
    return Align(
      // alignment: Alignment.topRight,
      heightFactor: 0.01,
      child: TrumpCard(player, isPlayer),
    );
  }

  void _cardSelected(TrumpModel model) {
    model.moveCard();
  }

  String _cardState(Player player, int index) {
    //See if the card is already played
    if (player.score != null && player.score > -1) {
      return player.shortName + "\n" + player.score.toString();
    } else {
      return (index + 1).toString();
    }
    return "";
  }
}
