import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/model/Team.dart';
import 'package:ipltrumpcards/ui/twoplayer/TwoPlayerStart.dart';
import 'package:provider/provider.dart';

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

            return Container(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                decoration: CricketCardsAppTheme.background_img,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: teamList(context, snapshot.data.docs),
                ));
          },
        ));
  }

  List<Widget> teamList(
      BuildContext context, List<QueryDocumentSnapshot> docs) {
    List<Widget> widgets = Iterable<int>.generate(docs.length).map((index) {
      return row(context, fromDocument(docs[index]), index);
    }).toList();

    widgets.add(Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: DefaultTextStyle(
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
            child: Column(
                children: [Text("Play for your Team or with friends")]))));
    _addBottomWidgets(widgets, context);
    widgets.insert(0, header(context));
    return widgets;
  }

  Widget header(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        "Points Table",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 24,
            color: CricketCardsAppTheme.textColor,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Team fromDocument(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data();
    return Team(data['name'], data['plays'], data['wins'], data['score']);
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
        Expanded(
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
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
                                      team.score.toString() + " points",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color:
                                              CricketCardsAppTheme.textColor),
                                    ))
                              ]))
                    ]))),
        SvgPicture.asset(
          'assets/images/lb-${Utils.teamName(team.name).toLowerCase()}.svg',
          width: 50.0,
          allowDrawingOutsideViewBox: true,
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: Text(
              "   >",
              style: TextStyle(fontSize: 20),
            ))
      ],
    );
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
