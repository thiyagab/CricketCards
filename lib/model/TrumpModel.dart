import 'package:flutter/widgets.dart';
import 'package:ipltrumpcards/model/player.dart';

import 'Team.dart';

class TrumpModel extends ChangeNotifier {
  List<Player> botCards;
  List<Player> playerCards;
  int botScore = 0;
  int playerScore = 0;
  Player botCard;
  Player playerCard;
  int selectedIndex = -1;
  Teams playerTeam;

  String lastSelectedLabel;

  final int POINTS_PER_WIN = 1;

  bool isGameOver() {
    return selectedIndex >= playerCards.length;
  }

  void moveCard() {
    if (++selectedIndex < playerCards.length) {
      this.playerCard = playerCards[selectedIndex];
      this.botCard = botCards[selectedIndex];
      this.botCard.open = false;
      lastSelectedLabel = null;
    }

    notifyListeners();
  }

  void refreshBotAndScore(String key, String value) {
    if (selectedIndex >= 0) {
      this.botCard.open = true;
      updateScore(key, value);
      lastSelectedLabel = key;
      notifyListeners();
    }
  }

  static final List<String> LOWER_FIRST_ATTRIBUTES = [
    'bowlingAverage',
    'bowlingEconomy',
    'bowlingStrikeRate',
  ];

  //TODO @vasanth now just comparing number of matches, need to build logic to compare the selected attribute
  // also score 0 is set explicitly to make the player already played, -1 is considered as unplayed
  void updateScore(String key, String value) {
    bool playerWins = false;
    String botValuestr = botCard.toJson()[key];

    if (key == 'bestBowlingFigure') {
      if (botValuestr == '') playerWins = true;
      List<String> botValues = botValuestr.split("/");
      List<String> playerValues = value.split("/");

      double botwickets = double.parse(botValues[0]);
      double playerwickets = double.parse(playerValues[0]);

      if (botwickets == playerwickets) {
        playerWins = double.parse(playerValues[1]) < double.parse(botValues[1]);
      } else {
        playerWins = playerwickets > botwickets;
      }
    } else {
      double botvalue = (botValuestr == null || botValuestr.isEmpty)
          ? 0
          : double.parse(botValuestr);
      double playervalue =
          (value == null || value.isEmpty) ? 0 : double.parse(value);
      playerWins = (LOWER_FIRST_ATTRIBUTES.contains(key) && botvalue > 0)
          ? botvalue > playervalue
          : playervalue > botvalue;
    }

    if (playerWins) {
      playerCard.score = POINTS_PER_WIN;
      botCard.score = 0;
      this.playerScore += POINTS_PER_WIN;
    } else {
      botCard.score = POINTS_PER_WIN;
      playerCard.score = 0;
      this.botScore += POINTS_PER_WIN;
    }
  }
}
