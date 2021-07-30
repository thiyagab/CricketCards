import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/components/TapToPlay.dart';
import 'package:ipltrumpcards/model/Team.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:ipltrumpcards/ui/CricketCardsTheme.dart';
import 'package:ipltrumpcards/ui/twoplayer/TwoPlayerCard.dart';
import 'package:play_games/play_games.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../components/CircleProgressIndicator.dart';
import 'PlayerCard.dart';

class GamePlay extends StatefulWidget {
  GamePlay({Key key}) : super(key: key);

  @override
  GamePlayState createState() => GamePlayState();
}

//TODO figure out a way to extract twoplayergame extending this, now its all messy inside
class GamePlayState extends State<GamePlay> with TickerProviderStateMixin {
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

    return Scaffold(
        body: Consumer<TrumpModel>(
            builder: (context, model, child) => SafeArea(
                child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/background.png"),
                            // colorFilter: new ColorFilter.mode(
                            //     Colors.grey.withOpacity(0.4), BlendMode.srcATop),
                            fit: BoxFit.fill)),
                    child: model.isGameOver()
                        ? _gameOverScreen(model, context)
                        : _gameScreen(model, context)))));
  }

  _gameScreen(TrumpModel model, BuildContext context) {
    model.attributeSelected = attributeSelected;
    return model.isSinglePlayer()
        ? _singlePlayer(model, context)
        : _twoPlayer(model, context);
  }

  _twoPlayer(TrumpModel model, BuildContext context) {
    if (model.gameState == TrumpModel.WAIT) {
      return Center(child: TapToPlay());
    } else if (model.gameState == TrumpModel.TWO) {
      return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TwoPlayerCard(
          animationController: animationController,
          player: model.botCard,
          model: model,
          itsme: false,
          attributeSelected: attributeSelected,
        ),
        _scorePanel(context, model),
        TwoPlayerCard(
          animationController: animationController,
          player: model.playerCard,
          model: model,
          itsme: true,
          attributeSelected: attributeSelected,
        )
      ]);
    }
  }

  _singlePlayer(TrumpModel model, BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      PlayerCard(
        animationController: animationController,
        player: model.botCard,
        model: model,
        itsme: false,
        attributeSelected: attributeSelected,
      ),
      _scorePanel(context, model),
      PlayerCard(
          animationController: animationController,
          player: model.playerCard,
          model: model,
          itsme: true,
          attributeSelected: attributeSelected)
    ]);
  }

  _gameOverScreen(TrumpModel model, BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      _winOrLose(model, context),
      Align(alignment: Alignment.center, child: _scorePanel(context, model)),
      _controls(model, context),
      Container(
        height: 20,
      ),
      if (model.isPlayingForTeam())
        Align(
            alignment: Alignment.bottomCenter,
            child: _instructionText(model, context))
    ]);
  }

  Widget _controls(TrumpModel model, BuildContext context) {
    String name = Utils.teamName(model.playerTeam);
    return Padding(
        padding: EdgeInsets.fromLTRB(30, 80, 30, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              controlButton(
                  "Play", Icons.sports_cricket, () => {Navigator.pop(context)},
                  width: 150),
              SizedBox(width: 10),
              controlButton(
                  "Share", Icons.share, () => {Share.share(Utils.SHARE_TEXT)},
                  width: 150)
            ]),
            Container(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              controlButton(
                  name,
                  Icons.leaderboard,
                  () => {
                        Utils.showLeaderboardForTeam(
                            name.toLowerCase(), context)
                      },
                  width: 160),
              SizedBox(width: 10),
              controlButton("Global", Icons.leaderboard,
                  () => {Utils.showLeaderboardForTeam(null, context)},
                  width: 160)
            ])
          ],
        ));
  }

  Widget controlButton(String text, IconData icon, Function action,
      {double width: 120}) {
    return Container(
        width: width,
        height: 50,
        child: ElevatedButton.icon(
          style: CricketCardsAppTheme.elevatedButtonStyle(context),
          label: Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
          icon: Icon(icon),
          onPressed: action,
        ));
  }

  Widget _winOrLose(TrumpModel model, BuildContext context) {
    String displayText = "";
    bool playerWins = model.playerScore > model.botScore;
    if (playerWins) {
      displayText = model.isPlayingForTeam()
          ? 'You Scored ${model.playerScore} point(s) for ${Utils.teamName(model.playerTeam)}'
          : 'You Won';
    } else if (model.playerScore == model.botScore) {
      displayText = "Match Drawn";
    } else {
      displayText = 'You Lost';
    }
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Center(
              child: DefaultTextStyle(
                  style: new TextStyle(
                      fontSize: 24, color: CricketCardsAppTheme.textColor),
                  child: new Text(displayText)))),
      SvgPicture.asset(
          playerWins ? 'assets/images/won.svg' : 'assets/images/lost.svg',
          width: 50,
          height: 50),
      Container(
        height: 40,
      )
    ]);
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
                    'You : ${model.playerScore.toString()} ',
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
                    '${model.isSinglePlayer() ? 'IPL11 : ' : 'Friend: '}${model.botScore.toString()}',
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
              radius: 100.0,
              backgroundColor: Colors.white,
              lineWidth: 9.5,
              animation: true,
              percent: (percentage),
              center: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  // constraints: BoxConstraints.(),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    getScorePanelText(model),
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

  String getScorePanelText(TrumpModel model) {
    if (model.isGameOver()) {
      return model.playerScore > model.botScore
          ? 'WON'
          : model.playerScore == model.botScore
              ? 'DRAW'
              : 'LOST';
    }
    if (model.botCard.open) {
      if (model.playerCard.score > model.botCard.score) {
        return 'Won';
      } else if (model.playerCard.score < model.botCard.score) {
        return 'Lost';
      } else if (model.playerCard.score == model.botCard.score) {
        return 'Draw';
      }
    }
    return "${model.selectedIndex}/11";
  }

  _instructionText1(TrumpModel model, BuildContext context) {
    CollectionReference teams = FirebaseFirestore.instance.collection('teams');
    return StreamBuilder<QuerySnapshot>(
      stream: teams.orderBy('weekscore', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return DefaultTextStyle(
              style: TextStyle(fontSize: 14), child: Text(""));
        }

        return DefaultTextStyle(
            style:
                TextStyle(fontSize: 16, color: CricketCardsAppTheme.textColor),
            textAlign: TextAlign.center,
            child: Text(
              checkAndConstructInstructionText(model, snapshot.data.docs),
            ));
      },
    );
  }

  _instructionText(TrumpModel model, BuildContext context) {
    CollectionReference teams = FirebaseFirestore.instance.collection('teams');
    return FutureBuilder<QuerySnapshot>(
      future: teams
          .orderBy('weekscore', descending: true)
          .get(GetOptions(source: Source.server)),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return DefaultTextStyle(
              style: TextStyle(fontSize: 14), child: Text(""));
        }
        docsToTeam(model, snapshot.data.docs, true);
        return DefaultTextStyle(
            style:
                TextStyle(fontSize: 16, color: CricketCardsAppTheme.textColor),
            textAlign: TextAlign.center,
            child: Text(
              checkAndConstructInstructionText(model, snapshot.data.docs),
            ));
      },
    );
  }

  String checkAndConstructInstructionText(
      TrumpModel model, List<QueryDocumentSnapshot> docs) {
    //TODO we should have a better way to sort and check which team is ahead of player's team,
    // The current logic is not realtime, and might be buggy
    List<Team> teams = docsToTeam(model, docs, true);
    sortTeamByWeekScore(teams);
    return constructInstructionText(model, teams);
  }

  List<Team> docsToTeam(
      TrumpModel model, List<QueryDocumentSnapshot> docs, bool updatescore) {
    List<Team> teams = [];
    docs.asMap().forEach((index, doc) {
      Team team = Team.fromDocument(doc);
      if (updatescore && team.name == model.playerTeam) {
        team.weekscore = team.weekscore + model.playerScore;
      }
      teams.add(team);
    });
    return teams;
  }

  sortTeamByWeekScore(List<Team> teams) {
    teams.sort((a, b) {
      return b.weekscore - a.weekscore;
    });
  }

  String constructInstructionText(TrumpModel model, List<Team> teams) {
    // return 'Chennai is ahead of Mumbai by 10 points.\nPlay more or invite friends to beat to the top';
    Team previousTeam;
    Team currentTeam;
    int playerPosition = 0;

    teams.asMap().forEach((index, team) {
      if (team.name == model.playerTeam) {
        playerPosition = index;
        currentTeam = team;
      }
    });
    String instructionText = '';
    if (playerPosition > 0 && currentTeam != null) {
      previousTeam = teams[playerPosition - 1];
      instructionText =
          '${Utils.teamName(previousTeam.name)} is ahead of your team ${Utils.teamName(currentTeam.name)} by ${previousTeam.weekscore - currentTeam.weekscore} point(s).\nPlay again or Invite friends to beat to the top';
    }
    return instructionText;
  }

  static bool waitForNext = false;
  attributeSelected(String attribute, TrumpModel model) {
    if (!waitForNext) {
      waitForNext = true;
      model.refreshBotAndScore(attribute);
      Timer(
          Duration(seconds: 2),
          () => {
                animationController.duration = Duration(milliseconds: 1000),
                animationController.reverse(),
              });
      Timer(
          Duration(milliseconds: 2500),
          () => {
                waitForNext = false,
                // animationController.reverse(from: 0.6),
                model.moveCard(),

                if (!model.isGameOver())
                  {
                    animationController.reset(),
                    animationController.duration = Duration(milliseconds: 1000),
                    animationController.forward(from: 0.0),
                  }
                else
                  {Utils.updateScore(context, model), updatePlayGames(model)}
              });
    }
  }

  updatePlayGames(TrumpModel model) async {
    SigninResult result = await PlayGames.getLastSignedInAccount();
    if (result != null && result.success) {
      Utils.updateLeaderboard(model);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return requestToSignInDialog(model);
        },
      );
    }
  }

  Dialog requestToSignInDialog(TrumpModel model) {
    return Dialog(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      "Connect with Google Play Games to join the Leaderboard.\n\nDisclaimer:\nThe Game DONOT process or store your signin info",
                      style: TextStyle(fontSize: 18, color: Colors.blue)),
                  SizedBox(height: 15),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          signInAndUpdate(model);
                        },
                        icon: Icon(Icons.login_outlined),
                        label: Text("Connect",
                            style: TextStyle(fontSize: 20, color: Colors.blue)))
                  ])
                ])));
  }

  void signInAndUpdate(TrumpModel model) async {
    await PlayGames.signIn();
    await Utils.updateLeaderboard(model);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Play Games connected")));
  }
}
