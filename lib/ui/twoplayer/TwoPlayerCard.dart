import 'package:flutter/cupertino.dart';
import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:ipltrumpcards/model/player.dart';
import 'package:ipltrumpcards/ui/PlayerCard.dart';

import '../CricketCardsTheme.dart';

class TwoPlayerCard extends PlayerCard {
  TwoPlayerCard(
      {Key key,
      AnimationController animationController,
      Animation animation,
      Player player,
      TrumpModel model,
      bool itsme,
      Function attributeSelected})
      : super(
            key: key,
            animationController: animationController,
            animation: animation,
            player: player,
            model: model,
            itsme: itsme,
            attributeSelected: attributeSelected);

  @override
  void handleOnTapEvent(String key) {
    Utils.updateTwoPlayers(
        selectedAttribute: key, selectedIndex: model.selectedIndex);
  }

  @override
  Widget waitForPlayer() {
    return Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: Text(
          model.itsMyTurn
              ? 'Your turn, make a move'
              : 'My turn, wait for my move',
          style: TextStyle(
            fontFamily: CricketCardsAppTheme.fontName,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            decoration: TextDecoration.none,
            color: CricketCardsAppTheme.nearlyWhite.withOpacity(0.8),
          ),
        ));
  }
}
