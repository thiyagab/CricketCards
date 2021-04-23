import 'package:flutter/cupertino.dart';
import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:ipltrumpcards/model/player.dart';
import 'package:ipltrumpcards/ui/PlayerCard.dart';

class TwoPlayerCard extends PlayerCard {
  TwoPlayerCard(
      {Key key,
      AnimationController animationController,
      Animation animation,
      Player player,
      TrumpModel model,
      Function attributeSelected})
      : super(
            key: key,
            animationController: animationController,
            animation: animation,
            player: player,
            model: model,
            attributeSelected: attributeSelected);

  // Widget header() {
  //   return SizedBox(height: 20);
  // }

  @override
  void handleOnTapEvent(String key) {
    Utils.update2Players(
        selectedAttribute: key, selectedIndex: model.selectedIndex);
  }
}
