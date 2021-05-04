import 'package:flutter/cupertino.dart';
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
      lastSelectedLabel = key;
      updateScore(key);
      notifyListeners();
    }
  }

  static final List<String> LOWER_FIRST_ATTRIBUTES = [
    'bowlingAverage',
    'bowlingEconomy',
    'bowlingStrikeRate',
  ];

  void updateScore(String key) {
    double playerWins = 0;
    String botValuestr = botCard.toJson()[key];
    String playerValuestr = playerCard.toJson()[key];

    if (key == 'bestBowlingFigure') {
      if (botValuestr == '') playerWins = 1;
      List<String> botValues = botValuestr.split("/");
      List<String> playerValues = playerValuestr.split("/");

      double botwickets = double.parse(botValues[0]);
      double playerwickets = double.parse(playerValues[0]);

      if (botwickets == playerwickets) {
        playerWins = double.parse(botValues[1]) - double.parse(playerValues[1]);
      } else {
        playerWins = playerwickets - botwickets;
      }
    } else {
      double botvalue = double.tryParse(botValuestr);
      botvalue = botvalue == null ? 0 : botvalue;

      double playervalue = double.tryParse(playerValuestr);
      playervalue = playervalue == null ? 0 : playervalue;

      playerWins = (LOWER_FIRST_ATTRIBUTES.contains(key) && botvalue > 0)
          ? botvalue - playervalue
          : playervalue - botvalue;
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
