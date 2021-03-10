import 'package:flutter/widgets.dart';
import 'package:warofcards/model/player.dart';

class TrumpModel extends ChangeNotifier {
  List<Player> botCards;
  List<Player> playerCards;
  int botScore;
  int playerScore;
  Player botCard;
  Player playerCard;

  void dummy() {
    playerCards = Player().playerData;
    botCards = Player().playerData.toList();
    botCards.shuffle();
  }
}
