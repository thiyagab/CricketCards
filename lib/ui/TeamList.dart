import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/model/Team.dart';
import 'package:ipltrumpcards/ui/GamePlay.dart';
import 'package:provider/provider.dart';

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
          return Text("Loading");
        }

        return Container(
            padding: EdgeInsets.fromLTRB(10, 50, 10, 50),
            color: Colors.white70,
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
        padding: EdgeInsets.only(top: 30),
        child:
            DefaultTextStyle(style: TextStyle(), child: Text("Version: 0.3"))));
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
                // shadowColor: Gradients.tameer.colors.last.withOpacity(0.25),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2)),
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
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/images/cup.svg',
                                    width: 10,
                                    height: 10,
                                    color: Colors.orangeAccent),
                                Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      team.score.toString() + " points",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color:
                                              Utils.textColor.withOpacity(0.5)),
                                    ))
                              ]))
                    ]))),
        SvgPicture.asset(
          'assets/images/lb-${position + 1}.svg',
          width: 80.0,
          allowDrawingOutsideViewBox: true,
          color: Colors.white60,
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
}
