import 'package:flutter/widgets.dart';
import 'package:ipltrumpcards/common/Utils.dart';
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
  Teams botTeam;
  bool itsMyTurn = true;

  String lastSelectedLabel;

  int gameState = WAIT;

  static final int POINTS_PER_WIN = 1;
  static final int WAIT = 0;
  static final int SINGLE = 1;
  static final int TWO = 2;

  Function attributeSelected;
  String hostid;

  bool isGameOver() {
    return selectedIndex >= playerCards.length;
  }

  bool isBot(Player player) {
    return player != null && player.team != playerTeam;
  }

  bool isSinglePlayer() {
    return gameState == SINGLE;
  }

  bool isPlayingForTeam() {
    return isSinglePlayer() ||
        (playerTeam != null && playerTeam != Utils.IPL11);
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

  void initMeta() {
    this.selectedIndex = 0;
    this.playerCard = this.playerCards[0];
    if (botCards != null && botCards.length > 0) {
      this.botCard = this.botCards[0];
      this.botCard.open = false;
      this.playerCard.score = this.botCard.score = 0;
    }
  }

  void checkAndStartTwoPlayerGame() {
    if (gameState == 0) {
      debugPrint('Started.');
      gameState = 2;
      notifyListeners();
    }
  }

  void refreshBotAndScore(String key) {
    if (selectedIndex >= 0) {
      this.botCard.open = true;
      updateScore(key);
      lastSelectedLabel = key;
      notifyListeners();
    }
  }

  static final List<String> LOWER_FIRST_ATTRIBUTES = [
    'bowlingAverage',
    'bowlingEconomy',
    'bowlingStrikeRate',
  ];

  void updateScore(String key) {
    int playerWins = 0;
    String botValuestr = botCard.toJson()[key];
    String playerValuestr = playerCard.toJson()[key];

    if (key == 'bestBowlingFigure') {
      if (botValuestr == '') playerWins = 1;
      List<String> botValues = botValuestr.split("/");
      List<String> playerValues = playerValuestr.split("/");

      double botwickets = double.parse(botValues[0]);
      double playerwickets = double.parse(playerValues[0]);

      if (botwickets == playerwickets) {
        playerWins = double.parse(playerValues[1]) < double.parse(botValues[1])
            ? 1
            : double.parse(playerValues[1]) == double.parse(botValues[1])
                ? 0
                : -1;
      } else {
        playerWins = playerwickets > botwickets
            ? 1
            : playerwickets == botwickets
                ? 0
                : -1;
      }
    } else {
      double botvalue = (botValuestr == null || botValuestr.isEmpty)
          ? 0
          : double.parse(botValuestr);
      double playervalue = (playerValuestr == null || playerValuestr.isEmpty)
          ? 0
          : double.parse(playerValuestr);
      playerWins = (LOWER_FIRST_ATTRIBUTES.contains(key) && botvalue > 0)
          ? (botvalue > playervalue
              ? 1
              : botvalue == playervalue
                  ? 0
                  : -1)
          : (playervalue > botvalue
              ? 1
              : playervalue == botvalue
                  ? 0
                  : -1);
    }

    playerCard.score = 0;
    botCard.score = 0;
    if (playerWins > 0) {
      playerCard.score = POINTS_PER_WIN;
      botCard.score = 0;
      this.playerScore += POINTS_PER_WIN;
    } else if (playerWins < 0) {
      botCard.score = POINTS_PER_WIN;
      playerCard.score = 0;
      this.botScore += POINTS_PER_WIN;
    }

    itsMyTurn = playerWins == 0 ? !itsMyTurn : playerWins > 0;
  }

  void checkAndUpdateScore(String selectedAttribute, int selectedIndex) {}
}
