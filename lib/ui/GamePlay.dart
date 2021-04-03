import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipltrumpcards/model/Team.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:ipltrumpcards/model/player.dart';
import 'package:provider/provider.dart';

import 'PlayerCard.dart';
import 'TrumpCard.dart';

class GamePlay extends StatefulWidget {
  GamePlay({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GamePlayState createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> with TickerProviderStateMixin {
  AnimationController animationController;
  var width, height;

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    super.initState();
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    // GlobalKey<FlipCardState> flipState = new GlobalKey();
    return Consumer<TrumpModel>(
        builder: (context, model, child) => SafeArea(
            child: Container(
                color: Colors.white70,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PlayerCard(
                        animation: Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController,
                                curve: Interval(0.1, 1.0,
                                    curve: Curves.fastOutSlowIn))),
                        animationController: animationController,
                        startColor: model.botCard.team.color1,
                        endColor: model.botCard.team.color2,
                        player: model.botCard,
                      ),
                      // _cards(context, model.botCards, model, false),
                      _scorePanel(context, model),
                      PlayerCard(
                        animation: Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController,
                                curve: Interval(0.1, 1.0,
                                    curve: Curves.fastOutSlowIn))),
                        animationController: animationController,
                        startColor: model.playerTeam.color1,
                        endColor: model.playerTeam.color2,
                        player: model.playerCard,
                      ),
                    ]))));
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

  //TODO this _cards method is not used yet,
  // should be implemented to show the cards in stack and add animations for change and removal
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
    }

    return Container(
        // card height
        height: 50,
        child: AnimatedList(
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
}
