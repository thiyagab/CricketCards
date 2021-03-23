import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/model/Team.dart';
import 'package:ipltrumpcards/ui/GamePlay.dart';
import 'package:provider/provider.dart';

class TeamList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _teamlist(context),
        ));
  }

  List<Widget> _teamlist(BuildContext context) {
    List<Team> teams = Utils.fetchTeams();
    List<Widget> teamWidgets = [];

    teams.forEach((team) {
      teamWidgets.add(Expanded(
          child: GestureDetector(
              onTap: () => _navigateToGamePlay(context, team),
              child: GradientCard(
                  gradient: Gradients.buildGradient(
                      Alignment.topLeft,
                      Alignment.bottomRight,
                      [team.name.color1, team.name.color2]),
                  shadowColor: Gradients.tameer.colors.last.withOpacity(0.25),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: buildTeamWidget(team)))));
    });
    return teamWidgets;
  }

  _navigateToGamePlay(BuildContext context, Team team) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                create: (context) => Utils.prepareGame(team.name),
                child: GamePlay())));
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
}
