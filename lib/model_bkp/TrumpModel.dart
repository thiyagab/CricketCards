import 'package:flutter/widgets.dart';
import 'package:ipltrumpcards/model_bkp/player.dart';

class TrumpModel extends ChangeNotifier {
  List<Player> botCards;
  List<Player> playerCards;
  int botScore;
  int playerScore;
  Player botCard;
  Player playerCard;
  int selectedIndex = -1;

  void dummy() {
    playerCards = Player().playerData;
    botCards = Player().playerData.toList();
    botCards.shuffle();
    // playerCard = playerCards.first;
    // botCard = botCards.first;
  }

  void setPlayerCard(int index) {
    this.selectedIndex = index;
    this.playerCard = playerCards[index];
    notifyListeners();
  }

  void refreshBotCard() {
    if (selectedIndex >= 0) {
      this.botCard = botCards[selectedIndex];
      notifyListeners();
    }
  }
}
