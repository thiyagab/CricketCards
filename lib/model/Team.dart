import 'dart:ui';

class Team {
  Teams name;
  final int totalPlays;
  final int totalWins;
  final int score;

  // Team(this.name, this.totalPlays, this.totalWins, this.score);

  Team(String name, this.totalPlays, this.totalWins, this.score) {
    team(name);
  }

  team(String team) {
    this.name = teamsMap[team];
  }

  Map<String, Teams> teamsMap = {
    "chennai": Teams.CHENNAI,
    "mumbai": Teams.MUMBAI,
    "bengaluru": Teams.BENGALURU,
    "punjab": Teams.PUNJAB,
    "hyderabad": Teams.HYDERABAD,
    "kolkata": Teams.KOLKATA,
    "delhi": Teams.DELHI,
    "rajasthan": Teams.RAJASTHAN
  };
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
      Color.fromARGB(255, 236, 182, 49), //Chennai
      Color.fromARGB(255, 52, 93, 154), //Mumbai
      Color.fromARGB(255, 70, 70, 70),
      Color.fromARGB(255, 146, 69, 69),
      Color.fromARGB(255, 218, 98, 66),
      Color.fromARGB(255, 100, 69, 137),
      Color.fromARGB(255, 50, 88, 162),
      Color.fromARGB(255, 58, 77, 151),
    ][this.index];
  }

  // Chennai - yellow
  // Bengaluru- Meroon
  // Mumbai - Blue
  // Delhi - navy blue
  // Punjab - Red
  // Rajasthan - pink
  // Kolkata -  dark purple
  // Hyderabad - orange

  Color get color2 {
    return [
      Color.fromARGB(255, 217, 94, 19),
      Color.fromARGB(255, 35, 62, 100),
      Color.fromARGB(255, 1, 1, 1), //Bengaluru
      Color.fromARGB(255, 102, 24, 16), //Punjab
      Color.fromARGB(255, 160, 36, 42),
      Color.fromARGB(255, 60, 40, 90),
      Color.fromARGB(255, 44, 78, 145),
      Color.fromARGB(255, 38, 51, 96),
    ][this.index];
  }
}
