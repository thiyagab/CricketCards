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
      Color.fromARGB(255, 99, 152, 231), //Mumbai
      Color.fromARGB(255, 120, 120, 120),
      Color.fromARGB(255, 227, 107, 107),
      Color.fromARGB(255, 247, 142, 114),
      Color.fromARGB(255, 150, 105, 225),
      Color.fromARGB(255, 100, 149, 235),
      Color.fromARGB(255, 89, 117, 225),
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
