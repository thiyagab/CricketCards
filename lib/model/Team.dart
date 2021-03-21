import 'dart:ui';

class Team {
  final Teams name;
  final int totalPlays;
  final int totalWins;
  List<Color> colors;

  Team(this.name, this.totalPlays, this.totalWins);
}

enum Teams {
  CHENNAI,
  MUMBAI,
  BENGALURU,
  PUNJAB,
  HYDERABAD,
  KOLKATA,
  DELHI,
  RAJASTHAN
}

extension TeamColors on Teams {
  Color get color1 {
    return [
      Color.fromARGB(255, 236, 182, 49),
      Color.fromARGB(255, 52, 93, 154),
      Color.fromARGB(255, 1, 1, 1),
      Color.fromARGB(255, 146, 69, 69),
      Color.fromARGB(255, 218, 98, 66),
      Color.fromARGB(255, 100, 69, 137),
      Color.fromARGB(255, 44, 78, 145),
      Color.fromARGB(255, 58, 77, 151),
    ][this.index];
  }

  Color get color2 {
    return [
      Color.fromARGB(255, 217, 94, 19),
      Color.fromARGB(255, 35, 62, 100),
      Color.fromARGB(255, 70, 70, 70),
      Color.fromARGB(255, 102, 24, 16), //Punjab
      Color.fromARGB(255, 160, 36, 42),
      Color.fromARGB(255, 60, 40, 90),
      Color.fromARGB(255, 50, 88, 162),
      Color.fromARGB(255, 38, 51, 96),
    ][this.index];
  }
}
