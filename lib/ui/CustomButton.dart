import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ipltrumpcards/common/Utils.dart';

class CustomButton extends StatelessWidget {
  final String btnTitle;
  final String btnValue;
  final String btnKey;
  final Color btnColor;
  Function(String title, String value, BuildContext context) handleOnTapEvent;

  CustomButton(this.btnTitle, this.btnKey, this.btnValue, this.btnColor,
      this.handleOnTapEvent);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
            onTap: () =>
                {this.handleOnTapEvent(this.btnKey, this.btnValue, context)},
            child: Container(
              width: 85,
              height: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: this.btnColor),
              child: Column(children: <Widget>[
                this.cardFieldGenerator(this.btnTitle, 12,
                    EdgeInsets.only(top: 2), FontWeight.normal),
                this.cardFieldGenerator(
                    this.btnValue, 16, EdgeInsets.all(0), FontWeight.bold),
              ]),
            )));
  }

  Widget cardFieldGenerator(
      String txt, double size, EdgeInsets padding, FontWeight weight) {
    return Padding(
        padding: padding,
        child: Text(
          txt,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Oswald',
              fontSize: size,
              fontWeight: weight,
              color: Utils.textColor.withOpacity(0.7)),
        ));
  }
}
