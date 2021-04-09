import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:social_share/social_share.dart';

import 'CircleProgressIndicator.dart';
import 'PlayerCard.dart';

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
    // Utils.testfirebase();
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
                        image: AssetImage("assets/images/background.png"),
                        // colorFilter: new ColorFilter.mode(
                        //     Colors.grey.withOpacity(0.4), BlendMode.srcATop),
                        fit: BoxFit.fill)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      !model.isGameOver()
                          ? PlayerCard(
                              animationController: animationController,
                              player: model.botCard,
                              parentHeight: this.height,
                              model: model)
                          : _winOrLose(model, context),
                      _scorePanel(context, model),
                      !model.isGameOver()
                          ? PlayerCard(
                              animationController: animationController,
                              player: model.playerCard,
                              parentHeight: this.height,
                              model: model)
                          : _controls(context),
                    ]))));
  }

  Widget _controls(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                width: 120,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5);
                        return null; // Use the component's default.
                      },
                    ),
                  ),
                  child: Text(
                    "Invite Friends",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () => {
                    if (kIsWeb)
                      {
                        SocialShare.shareOptions(
                            "Hi friends, play for our favorite team to top the points table.  https://ipl-trump-cards.web.app/")
                      }
                    else
                      Share.share(
                          "Hi friends, play for our favorite team to get to the top of points table.  https://play.google.com/store/apps/details?id=com.droidapps.cricketcards")
                  },
                )),
            Container(width: 50, height: 20),
            Container(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5);
                        return null; // Use the component's default.
                      },
                    ),
                  ),
                  child: Text(
                    "Play again",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () => {Navigator.pop(context)},
                ))
          ],
        ));
  }

  Widget _winOrLose(TrumpModel model, BuildContext context) {
    String displayText = "";
    bool playerWins = model.playerScore > model.botScore;
    if (playerWins) {
      displayText =
          'You Scored ${model.playerScore - model.botScore} point(s) for ${Utils.teamName(model.playerTeam)}';
    } else {
      displayText = 'You Lost';
    }
    return Column(children: [
      Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: Center(
              child: DefaultTextStyle(
                  style: new TextStyle(fontSize: 24, color: Utils.textColor),
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
      return model.playerScore > model.botScore ? 'WON' : 'LOST';
    }
    if (model.playerCard.score > model.botCard.score) {
      return 'Won';
    } else if (model.playerCard.score < model.botCard.score) {
      return 'Lost';
    }
    return "${model.selectedIndex}/11";
  }
}
