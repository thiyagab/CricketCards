import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:ipltrumpcards/model/Team.dart';

class TeamList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _teamlist(),
        ));
  }

  List<Widget> _teamlist() {
    List<Team> teams = fetchTeams();
    List<Widget> teamWidgets = [];

    teams.forEach((team) {
      teamWidgets.add(Expanded(
          child: GradientCard(
              gradient: Gradients.buildGradient(Alignment.topLeft,
                  Alignment.bottomRight, [team.name.color1, team.name.color2]),
              shadowColor: Gradients.tameer.colors.last.withOpacity(0.25),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: buildTeamWidget(team))));
    });
    return teamWidgets;
  }

  Widget buildTeamWidget(Team team) {
    return Center(
        child: Text(
      team.name.toString().substring(6) +
          ", Plays: " +
          team.totalPlays.toString() +
          ", Wins: " +
          team.totalWins.toString(),
      textAlign: TextAlign.center,
    ));
  }

  List<Team> fetchTeams() {
    //TODO build this team list from firebase with totalwins and total plays
    List<Team> teams = [];
    Random random = Random(1000);
    Teams.values.forEach((element) {
      teams.add(Team(element, random.nextInt(1000) + 500, random.nextInt(500)));
    });
    return teams;
  }
}
