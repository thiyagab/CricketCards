import 'package:flutter/material.dart';

class GradientCard extends StatelessWidget {
  final startColor;
  final endColor;
  final Widget child;

  GradientCard({this.startColor, this.endColor, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22.0),
              bottomLeft: Radius.circular(22.0),
              bottomRight: Radius.circular(22.0),
              topRight: Radius.circular(22.0)), //68.0 for right side curvy
          gradient: LinearGradient(
            colors: [
              startColor,
              endColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: endColor.withOpacity(0.6),
                offset: Offset(1.1, 4.0),
                blurRadius: 10.0),
          ],
        ),
        child: this.child);
  }
}
