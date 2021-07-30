import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/model/Team.dart';
import 'package:ipltrumpcards/ui/twoplayer/TwoPlayerStart.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CricketCardsTheme.dart';
import 'GamePlay.dart';

class TeamList extends StatelessWidget {
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('teams');

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: StreamBuilder<QuerySnapshot>(
          stream: users.orderBy('score', descending: true).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: DefaultTextStyle(
                      style: TextStyle(fontSize: 32),
                      child: Text("IPL Trump Cards")));
            }

            return TeamListContainer(snapshot.data.docs);
          },
        ));
  }
}

class TeamListContainer extends StatefulWidget {
  List<QueryDocumentSnapshot> docs;
  TeamListContainer(this.docs);

  @override
  State<StatefulWidget> createState() {
    return TeamListContainerState();
  }
}

class TeamListContainerState extends State<TeamListContainer> {
  bool isWeek = true;

  Widget build(BuildContext context) {
    widget.docs.sort((a, b) {
      return isWeek
          ? (b['weekscore'] - a['weekscore'])
          : b['score'] - a['score'];
    });
    return Container(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        decoration: CricketCardsAppTheme.background_img,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: teamList(context, widget.docs),
        ));
  }

  List<Widget> teamList(
      BuildContext context, List<QueryDocumentSnapshot> docs) {
    List<Widget> widgets = Iterable<int>.generate(docs.length).map((index) {
      return row(context, Team.fromDocument(docs[index]), index);
    }).toList();
    widgets.insert(0, header(context));
    widgets.add(instruction());
    _addBottomWidgets(widgets, context);

    return widgets;
  }

  Widget instruction() {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: !isWeek
            ? Text(
                "Play and score for your team",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 15),
              )
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(
                  Icons.star_border_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                Text(" Total championships    ",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white)),
                Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 18,
                ),
                Text(" Last week champion",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white))
              ]));
  }

  String days2go() {
    //TODO construct the days2go string
    // DateTime.now().add(Duration(days: 1))
  }

  Widget header2(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        isWeek ? "Weekly Tournament" : "Points Table",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18,
            color: CricketCardsAppTheme.textColor,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget header(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
              onPressed: () {
                showInfo(context);
              },
              icon: Icon(
                Icons.info_sharp,
                color: Colors.white70,
              )),
          Expanded(
              child: isWeek
                  ? CountDownWidget()
                  : Text("Points Table",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 22,
                          color: CricketCardsAppTheme.textColor,
                          fontWeight: FontWeight.bold))),
          Switch(
            value: isWeek,
            activeColor: Colors.white,
            onChanged: (value) {
              setState(() {
                isWeek = value;
              });
            },
          )
        ]));
  }

  String getDaysToGoText() {
    if (isWeek) {
      DateTime datetime = DateTime.now();
      int diff = 7 - datetime.weekday;
      if (diff == 1)
        return '\n( Finals tomorrow )';
      else if (diff == 0)
        return '\n( Finals today )';
      else
        return "\n(" + (7 - datetime.weekday).toString() + " days to go )";
    } else {
      return "";
    }
  }

  Widget row(BuildContext context, Team team, int position) {
    return Expanded(
        child: GestureDetector(
            onTap: () => _navigateToGamePlay(context, team),
            child: GradientCard(
                gradient: Gradients.buildGradient(
                    Alignment.topLeft,
                    Alignment.bottomRight,
                    [team.name.color2, team.name.color1]),
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                child: buildTeamWidget(team, position))));
  }

  _navigateToGamePlay(BuildContext context, Team team) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => Utils.singlePlayer(team.name),
                child: GamePlay())));
  }

  Widget buildTeamWidget(Team team, int position) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text(
              '${(position + 1)}',
              style: TextStyle(fontSize: 24),
            )),
        nameAndPoints(team, position),
        (isWeek && team.championships > 0) ? star(team) : SizedBox(width: 1),
        SvgPicture.asset(
          'assets/images/lb-${Utils.teamName(team.name).toLowerCase()}.svg',
          width: 50.0,
          allowDrawingOutsideViewBox: true,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: Icon(
            Icons.keyboard_arrow_right_sharp,
            color: Colors.white54,
          ),
        )
      ],
    );
  }

  Widget star(Team team) {
    return Wrap(
      direction: Axis.vertical,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(team.champion ? Icons.star_rate : Icons.star_outline,
            color: Colors.white54),
        Text(
          team.championships.toString(),
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  Widget nameAndPoints(Team team, int position) {
    return Expanded(
        flex: 2,
        child: Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.teamName(team.name),
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/images/cup.svg',
                                width: 12,
                                height: 12,
                                color: Colors.orangeAccent),
                            Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  (isWeek
                                          ? team.weekscore.toString()
                                          : team.score.toString()) +
                                      " points",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      color: CricketCardsAppTheme.textColor),
                                ))
                          ]))
                ])));
  }

  Widget _addBottomWidgets(List<Widget> widgets, BuildContext context) {
    widgets.add(Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            iconButton("  Play with Friends    ", Icons.sports_cricket,
                () => _twoPlayer(context)),
            SizedBox(
              width: 10,
            ),
            iconButton("Leaderboard", Icons.leaderboard, () {
              Utils.showLeaderboard(context);
            }),
          ],
        )));
  }

  showInfo(BuildContext context) {
    // String icon = String.fromCharCode(0xea69);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("IPL Trump Cards"),
        content: RichText(
            text: TextSpan(
          text: 'Game Play:',
          style: TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(
                text:
                    '\n\n1. Its a simple trump cards play, where you bet with your player attributes\n2. Play and score for your team, you can play against IPL11 or with your friends',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
            TextSpan(
                text: '\n\nWeekly Tournament',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextSpan(
                text: '\n\n1. The tournament goes from Monday to Sunday, and the score resets every week exactly at Sunday midnight\n2. ' +
                    'The winner of the week gets championship star\n3. The Shaded star is the last week champion\n\nHave feedback?\nWant to correct/add stats?\nFound issues?\nJoin our team?\n ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
            TextSpan(
              text: 'mail us @ 99products.in@gmail.com',
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              recognizer: TapGestureRecognizer()..onTap = followLink,
            )
          ],
        )),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  followLink() {
    launch('mailto:99products.in@gmail.com');
  }

  Widget iconButton(String text, IconData icon, Function action) {
    return ElevatedButton.icon(
        onPressed: action,
        style: ElevatedButton.styleFrom(
            minimumSize: Size(60, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            elevation: 10,
            primary: CricketCardsAppTheme.nearlyDarkBlue),
        icon: Icon(icon, color: Colors.white),
        label: Text(text));
  }

  Widget _twoPlayerControls(BuildContext context) {
    return GestureDetector(
        onTap: () => _twoPlayer(context),
        child: Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Play with friends',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset('assets/images/cup.svg',
                                width: 12,
                                height: 12,
                                color: Colors.orangeAccent),
                            Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: FutureBuilder(
                                    future: Utils.getTotalPointsScored(),
                                    builder: (context, snapshot) {
                                      return Text(
                                        snapshot.data.toString() + " points",
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color:
                                                CricketCardsAppTheme.textColor),
                                      );
                                    }))
                          ]))
                ])));
  }

  _addTwoPlayerControls(List<Widget> widgets, BuildContext context) {
    widgets.add(Expanded(
        child: GradientCard(
            gradient: Gradients.buildGradient(
                Alignment.topLeft, Alignment.bottomRight, [
              CricketCardsAppTheme.nearlyDarkBlue.withBlue(120),
              CricketCardsAppTheme.nearlyDarkBlue,
            ]),
            elevation: 10,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Row(children: [
              Expanded(child: _twoPlayerControls(context)),
              IconButton(
                  icon: Icon(
                    Icons.leaderboard,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Utils.showLeaderboard(context);
                  })
            ]))));
  }

  _twoPlayer(BuildContext context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => TwoPlayerStart()));
  }
}

class CountDownWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CountDownWidgetState();
  }
}

class CountDownWidgetState extends State<CountDownWidget> {
  Timer timer;

  @override
  void dispose() {
    clearTimer();
    super.dispose();
  }

  clearTimer() {
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "Weekly Tournament",
          style: TextStyle(
              fontSize: 22,
              color: CricketCardsAppTheme.textColor,
              fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(
                text: getDaysToGoText(),
                style: TextStyle(
                    color: CricketCardsAppTheme.textColor.withAlpha(240),
                    fontSize: 12,
                    fontWeight: FontWeight.w300)),
          ],
        ));
  }

  String getDaysToGoText() {
    DateTime datetime = DateTime.now();
    int diff = 7 - datetime.weekday;
    if (diff == 1)
      return '\n( Score resets tomorrow midnight)';
    else if (diff == 0) {
      clearTimer();
      timer = Timer(Duration(seconds: 1), () {
        setState(() {});
      });
      return '\n( Score resets in ' + getHoursSecsText(datetime) + ')';
    } else
      return "\n( Score resets in " +
          (7 - datetime.weekday).toString() +
          " days )";
  }

  String getHoursSecsText(DateTime dateTime) {
    int hour = 23 - dateTime.hour;
    int minutes = 59 - dateTime.minute;
    int seconds = 59 - dateTime.second;
    return appendZero(hour) +
        ":" +
        appendZero(minutes) +
        ":" +
        appendZero(seconds);
  }

  String appendZero(int value) {
    return value < 10 ? '0' + value.toString() : value.toString();
  }
}
