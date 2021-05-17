import 'dart:ui';

import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/ui/CricketCardsTheme.dart';

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
    this.name = teamsMap[team.toLowerCase()];
  }

  static Map<String, Teams> teamsMap = {
    "chennai": Teams.CHENNAI,
    "mumbai": Teams.MUMBAI,
    "bengaluru": Teams.BENGALURU,
    "punjab": Teams.PUNJAB,
    "hyderabad": Teams.HYDERABAD,
    "kolkata": Teams.KOLKATA,
    "delhi": Teams.DELHI,
    "rajasthan": Teams.RAJASTHAN
  };
  static Map<String, String> leaderBoardMap = {
    "chennai": "CgkIkZLiy8cDEAIQAw",
    "bengaluru": "CgkIkZLiy8cDEAIQBw",
    "mumbai": "CgkIkZLiy8cDEAIQBQ",
    "hyderabad": "CgkIkZLiy8cDEAIQBg",
    "rajasthan": "CgkIkZLiy8cDEAIQCA",
    "kolkata": "CgkIkZLiy8cDEAIQCQ",
    "delhi": "CgkIkZLiy8cDEAIQCg",
    "punjab": "CgkIkZLiy8cDEAIQCw",
    Utils.IPL11.toLowerCase(): "CgkIkZLiy8cDEAIQDA",
  };

  static final String GLOBAL_LEADERBOARD = "CgkIkZLiy8cDEAIQDQ";
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
    return CricketCardsAppTheme.teamLightColors[this.index];
  }

  Color get color2 {
    return CricketCardsAppTheme.teamDarkColors[this.index];
  }
}
