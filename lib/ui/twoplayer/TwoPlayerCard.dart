import 'package:flutter/cupertino.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:ipltrumpcards/model/player.dart';
import 'package:ipltrumpcards/ui/PlayerCard.dart';

class TwoPlayerCard extends PlayerCard {
  TwoPlayerCard(
      {Key key,
      AnimationController animationController,
      Animation animation,
      Player player,
      TrumpModel model})
      : super(
            key: key,
            animationController: animationController,
            animation: animation,
            player: player,
            model: model);

  Widget header() {
    return SizedBox(height: 20);
  }

  @override
  void handleOnTapEvent(String key, String value, BuildContext context) {
    // TODO: implement handleOnTapEvent
    super.handleOnTapEvent(key, value, context);
  }
}
