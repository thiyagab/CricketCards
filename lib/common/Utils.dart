import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ipltrumpcards/model/Team.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';

class Utils {
  static Color color(hexCode) {
    return Color(int.parse('0xff$hexCode'));
  }

  //TODO #2 move this to a defined classes
  static Color textColor = Colors.white;

  static TrumpModel prepareGame(Teams team) {
    //TODO
    //1. build UI for player to choose team
    //2. UI to show bot selected opponent team
    //3. Shuffle the players and assign to bot and player
    TrumpModel trumpModel = TrumpModel();
    trumpModel.dummy();
    trumpModel.playerTeam = team;
    Random random = Random(8);
    int index = random.nextInt(8);
    trumpModel.botTeam = Teams.values[index];
    if (trumpModel.botTeam == trumpModel.playerTeam) {
      trumpModel.botTeam = Teams.values[(index + 1) % 1];
    }
    trumpModel.dummy();
    return trumpModel;
  }
}
