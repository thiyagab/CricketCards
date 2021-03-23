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

class _GamePlayState extends State<GamePlay>
    with SingleTickerProviderStateMixin {
  double width, height;

  Size _size = Size(0, 0);
  Offset _position = Offset.zero;
  GlobalKey miniPlayerCard;

  int selectedPlayerIndex = -1;
  bool nextPlayer = false;

  Animation<double> _animation;
  AnimationController _controller;

  ScrollController _itemScrollController;

  @override
  void initState() {
    _itemScrollController = ScrollController();
    super.initState();
    _prepareGame(context);
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    // #enddocregion AnimationController, tweens
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateSizeAndPositions({bool reverse = false}) {
    final miniCardContext = miniPlayerCard.currentContext;
    if (miniCardContext != null) {
      final RenderBox box = miniCardContext.findRenderObject();
      final positions = box.localToGlobal(Offset.zero);
      print('box $box');
      // final RenderBox renderBox = context.findRenderObject();
      Size viewSize = Size(box.size.width, box.size.height);
      Offset viewPosition = Offset(0, positions.dy);
      print('updateSizeAndPositions $viewSize $viewPosition');
      setState(() {
        _position = viewPosition;
        _size = viewSize;
      });
      if (!reverse) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    } else {
      debugPrint('Couldn\'t find the card context');
    }
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
    return Consumer<TrumpModel>(builder: (context, model, child) {
      final isPlayerSelected = model.playerCard != null;
      return SafeArea(
          child: Stack(
        children: [
          Column(
            children: [
              _cards(context, model.botCards, model, Teams.MUMBAI, true),
              if (isPlayerSelected && !model.isGameOver())
                _card(context, model.botCard, model, Teams.MUMBAI, true, true),
              _card(context, model.playerCard, model, Teams.CHENNAI,
                  isPlayerSelected),
              _cards(context, model.playerCards, model, Teams.CHENNAI)
            ],
          ),
          if (model.playerCard != null)
            AnimatedCard(
                size: _size,
                screenHeight: height,
                screenWidth: width,
                position: _position,
                team: Teams.CHENNAI,
                player: model.playerCard,
                model: model,
                updateSizeAndPositions: updateSizeAndPositions,
                animationController: _controller,
                scrollController: _itemScrollController,
                animation: _animation)
        ],
      ));
    });
  }

  Widget _card(
      BuildContext context, Player player, TrumpModel model, Teams team,
      [bool isPlayerSelected = false, isBotCard = false]) {
    final dividerRatio = isPlayerSelected ? 3 : 1.5;
    return Center(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(0, 236, 182, 49),
          Color.fromARGB(0, 217, 94, 19)
        ])),
        height: (this.height / dividerRatio) - 5,
        width: (this.width - 30),
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: GradientCard(
            gradient: Gradients.buildGradient(Alignment.topLeft,
                Alignment.bottomRight, [team.color1, team.color2]),
            shadowColor: Gradients.tameer.colors.last.withOpacity(0.25),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: GestureDetector(
                onTap: () {
                  model.moveCard();
                  updateSizeAndPositions();
                },
                child: _checkStateAndRenderCard(
                    isPlayerSelected, model, isBotCard))),
      ),
    );
  }

  Widget _checkStateAndRenderCard(
      bool isPlayerSelected, TrumpModel model, isBotCard) {
    if (!isPlayerSelected) {
      return Center(child: Text("Tap on card to play"));
    } else if (model.isGameOver()) {
      return _endcard(model);
    } else {
      return Center(
        child: Text(!isBotCard ? 'Player Zone' : 'Bot Zone'),
      );
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

  /* Widget _buildPlayerDetails(Player player, TrumpModel model) {
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
  } */

  Widget _cards(context, List<Player> cards, TrumpModel model, Teams team,
      [bool isBot = false]) {
    List<Widget> cardWidgets = [];
    for (int i = 0; i < cards.length; i++) {
      GlobalKey cardKey;
      if (i == 0) {
        if (!isBot) {
          miniPlayerCard = GlobalKey();
          cardKey = miniPlayerCard;
        }
      }
      cardWidgets.add(Container(
          key: cardKey,
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
  }
}

class AnimatedCard extends AnimatedWidget {
  // Make the Tweens static because they don't change.
  final Size size;
  final double screenHeight;
  final double screenWidth;
  final Offset position;
  final Teams team;
  final Player player;
  final TrumpModel model;
  final ScrollController scrollController;
  final AnimationController animationController;
  final Function updateSizeAndPositions;

  AnimatedCard(
      {this.size,
      this.position,
      this.screenHeight,
      this.screenWidth,
      this.team,
      this.scrollController,
      this.player,
      this.model,
      this.animationController,
      this.updateSizeAndPositions,
      Key key,
      Animation<double> animation})
      : super(key: key, listenable: animation);

  void _trumpCard(TrumpModel model) {
    model.refreshBotAndScore();
    Timer(
        Duration(seconds: 2),
        () => {
              print('Moving '),
              model.moveCard(),
              if (model.selectedIndex < 7)
                scrollController.animateTo(
                    (this.screenWidth / 5) * model.selectedIndex,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease)
            });
  }

  Widget _buildPlayerDetails(Player player, TrumpModel model) {
    List<Widget> playerDetails = [];
    playerDetails.add(Text(player.name, style: TextStyle(fontSize: 20)));
    playerDetails.add(SizedBox(height: 10));
    playerDetails.add(TextButton(
        onPressed: () {
          updateSizeAndPositions(reverse: true);
          animationController.addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              _trumpCard(model);
              if (!model.isGameOver()) {
                Future.delayed(
                    Duration(seconds: 2), () => updateSizeAndPositions());
              }
            }
          });
        },
        child: Text("Matches: " + player.nummatches.toString(),
            style: TextStyle(fontSize: 15))));
    playerDetails.add(TextButton(
        child: Text("Average: " + player.bataverage.toString(),
            style: TextStyle(fontSize: 15))));
    return Container(
        padding: EdgeInsets.all(10), child: Column(children: playerDetails));
  }

  Widget build(BuildContext context) {
    Tween _bottomPositionTween =
        Tween<double>(begin: 0, end: this.screenHeight / 8);
    Tween _leftPositionTween = Tween<double>(begin: position.dx, end: 16);
    print(
        'position from AnimatedCard is ${_bottomPositionTween.begin} ${_bottomPositionTween.end}');

    Tween _sizeHeightTween =
        Tween<double>(begin: size.height + 10, end: this.screenHeight / 3);
    Tween _sizeWidthTween =
        Tween<double>(begin: size.width, end: screenWidth - 30);
    final animation = listenable as Animation<double>;
    final isReverseAnim = animationController.status == AnimationStatus.reverse;
    Tween _opacityTween =
        Tween<double>(begin: isReverseAnim ? 1 : 0, end: isReverseAnim ? 0 : 1);
    return Positioned(
        bottom: _bottomPositionTween.evaluate(animation),
        left: _leftPositionTween.evaluate(animation),
        child: Opacity(
          opacity: _opacityTween.evaluate(animation),
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromARGB(0, 236, 182, 49),
                Color.fromARGB(0, 217, 94, 19)
              ])),
              height: _sizeHeightTween.evaluate(animation),
              width: _sizeWidthTween.evaluate(animation),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: GradientCard(
                  gradient: Gradients.buildGradient(Alignment.topLeft,
                      Alignment.bottomRight, [team.color1, team.color2]),
                  shadowColor: Gradients.tameer.colors.last.withOpacity(0.25),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      if (animationController.status ==
                          AnimationStatus.completed)
                        _buildPlayerDetails(player, model)
                    ],
                  ))),
        ));
  }
}
