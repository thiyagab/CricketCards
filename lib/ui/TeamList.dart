import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/model/Team.dart';
import 'package:provider/provider.dart';

import 'GamePlay.dart';

class TeamList extends StatelessWidget {
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('teams');

    return StreamBuilder<QuerySnapshot>(
      stream: users.orderBy('score', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: DefaultTextStyle(
                  style: TextStyle(fontSize: 32), child: Text("Loading")));
        }

        return Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.fill)),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: teamList(context, snapshot.data.docs),
            ));
      },
    );
  }

  List<Widget> teamList(
      BuildContext context, List<QueryDocumentSnapshot> docs) {
    List<Widget> widgets = Iterable<int>.generate(docs.length).map((index) {
      return row(context, fromDocument(docs[index]), index);
    }).toList();

    widgets.add(Padding(
        padding: EdgeInsets.only(top: 20),
        child: DefaultTextStyle(
            style: TextStyle(color: Colors.white54),
            child: Text("Play and Score for your Team"))));
    _addTwoPlayerControls(widgets, context);
    widgets.insert(
        0,
        Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: DefaultTextStyle(
                style: TextStyle(
                    fontSize: 24,
                    color: Utils.textColor,
                    fontWeight: FontWeight.bold),
                child: Text(
                  "Points Table",
                  textAlign: TextAlign.center,
                ))));
    return widgets;
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
                create: (context) => Utils.prepareGame(team.name),
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
                            fontWeight: FontWeight.bold, fontSize: 18),
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
                                      style: TextStyle(color: Utils.textColor),
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

  _addTwoPlayerControls(List<Widget> widgets, BuildContext context) {
    widgets.add(Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                return null; // Use the component's default.
              },
            ),
          ),
          child: Text(
            "Host",
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () => {_hostTwoPlayer(context)},
        ),
        Container(width: 20),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return Theme.of(context).colorScheme.primary.withOpacity(0.5);
                return null; // Use the component's default.
              },
            ),
          ),
          child: Text(
            "Join",
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () => {_joinTwoPlayer(context)},
        )
      ],
    )));
  }

  //TODO show loading
  _joinTwoPlayer(BuildContext context) {
    Utils.joinTwoPlayers().then((model) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => model, child: GamePlay()))));
  }

  _hostTwoPlayer(BuildContext context) {
    Utils.hostTwoPlayers().then((model) => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => model, child: GamePlay()))));
  }
}
