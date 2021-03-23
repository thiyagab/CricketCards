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
  Teams botTeam;
  Teams playerTeam;

  void dummy() {
    playerCards = Player().playerData;
    botCards = [];
    playerCards.forEach((player) {
      player.team = playerTeam;
      Player botPlayer = player.copy();
      botPlayer.team = botTeam;
      botCards.add(botPlayer);
    });

    botCards.shuffle();
    // botCard=botCards[0];
    // playerCard=playerCards[0];

    // playerCard = playerCards.first;
    // botCard = botCards.first;
  }

  bool isGameOver() {
    return selectedIndex >= playerCards.length;
  }

  void moveCard() {
    if (++selectedIndex < playerCards.length) {
      this.playerCard = playerCards[selectedIndex];
    }
    botCard = null;
    notifyListeners();
  }

  void refreshBotAndScore() {
    if (selectedIndex >= 0) {
      this.botCard = botCards[selectedIndex];
      updateScore();
      notifyListeners();
    }
  }

  //TODO now just comparing number of matches, need to build logic to compare the selected attribute
  // also score 0 is set explicitly to make the player already played, -1 is considered as unplayed
  void updateScore() {
    if (botCard.nummatches > playerCard.nummatches) {
      botCard.score = 100;
      playerCard.score = 0;
      this.botScore += 100;
    } else {
      playerCard.score = 100;
      botCard.score = 0;
      this.playerScore += 100;
    }
  }
}
