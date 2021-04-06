import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:ipltrumpcards/model/player.dart';
import 'package:provider/provider.dart';

import 'CircleProgressIndicator.dart';
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
        duration: Duration(milliseconds: 1500), vsync: this);
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
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/background.jpeg"),
                        colorFilter: new ColorFilter.mode(
                            Colors.grey.withOpacity(0.4), BlendMode.srcATop),
                        fit: BoxFit.fill)),
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
                          player: model.botCard,
                          parentHeight: this.height),
                      _scorePanel(context, model),
                      PlayerCard(
                        animation: Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController,
                                curve: Interval(0.1, 1.0,
                                    curve: Curves.fastOutSlowIn))),
                        animationController: animationController,
                        player: model.playerCard,
                        parentHeight: this.height,
                      ),
                    ]))));
  }

  Widget _scorePanel(BuildContext context, TrumpModel model) {
    final progress =
        (model.selectedIndex == 10 ? 9.5 : model.selectedIndex) * 0.1;
    final percentage = progress > 1.0 ? 1.0 : progress;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Row(children: [
            Container(
                width: (width / 2) - 24,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22.0),
                      bottomLeft: Radius.circular(22.0),
                      bottomRight: Radius.circular(22.0),
                      topRight:
                          Radius.circular(22.0)), //68.0 for right side curvy
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.blue,
                        offset: Offset(1.1, 4.0),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 22, 32, 22),
                  child: Text(
                    'Player : ${model.playerScore.toString()} ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: 16),
                  ),
                )),
            Container(
              width: (width / 2) - 24,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                    topRight:
                        Radius.circular(12.0)), //68.0 for right side curvy
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.red,
                      offset: Offset(1.1, 4.0),
                      blurRadius: 10.0),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(46.0, 22, 20, 22),
                  child: Text(
                    'IPL11 : ${model.botScore.toString()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          ]),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: CircularPercentIndicator(
              animateFromLastPercent: true,
              radius: 90.0,
              backgroundColor: Colors.white,
              lineWidth: 9.5,
              animation: true,
              percent: (percentage),
              center: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  alignment: Alignment.center,
                  // constraints: BoxConstraints.(),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "${model.selectedIndex}/11",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.greenAccent,
            ))
      ],
    );
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
