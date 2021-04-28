import 'package:flutter/material.dart';

class CricketCardsAppTheme {
  CricketCardsAppTheme._();
  static const Color nearlyWhite = Color(0xFFFAFAFA);
  static const Color background = Color(0xFFF2F3F8);
  static const Color nearlyDarkBlue = Color(0xFF2633C5);
  static const Color lightText = Color(0xFF4A6572);
  static const Color textColor = Colors.white;

  static const Decoration background_img = BoxDecoration(
      image: DecorationImage(
          image: AssetImage("assets/images/background.png"), fit: BoxFit.fill));

  static const String fontName = 'Roboto';

  static const TextTheme textTheme = TextTheme(
    bodyText1: body1,
    bodyText2: body2,
    caption: caption,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: nearlyWhite,
  );

  static const TextStyle body1 = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    letterSpacing: -0.05,
    color: nearlyWhite,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );

  static const List<Color> teamLightColors = [
    Color.fromARGB(255, 245, 176, 65), //Chennai
    Color.fromARGB(255, 52, 152, 219), //Mumbai
    Color.fromARGB(255, 244, 112, 116), //Bengaluru
    Color.fromARGB(255, 227, 107, 107), // Punjab
    Color.fromARGB(255, 220, 118, 51), //Hyderabad
    Color.fromARGB(255, 150, 105, 225),
    Color.fromARGB(255, 89, 157, 225),
    Color.fromARGB(255, 235, 119, 184),
  ];

  static const List<Color> teamDarkColors = [
    Color.fromARGB(255, 230, 120, 16), //Chennai
    Color.fromARGB(255, 33, 97, 140), //Mumbai
    Color.fromARGB(255, 173, 14, 16), //Bengaluru
    Color.fromARGB(255, 102, 24, 16), //Punjab
    Color.fromARGB(255, 160, 64, 0), //Hyderabad
    Color.fromARGB(255, 60, 40, 90), //Kolkata
    Color.fromARGB(255, 38, 51, 96), //Delhi
    Color.fromARGB(255, 235, 24, 133), //rajasthan
  ];
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
