import 'package:json_annotation/json_annotation.dart';

import 'Team.dart';

part 'player.g.dart';

@JsonSerializable()
class Player {
  String shortName;
  String role;
  String totalMatches;
  String totalNotOuts;
  String totalRuns;
  String highestScore;
  String battingAverage;
  String totalBallsFaced;
  String battingStrikeRate;
  String totalFours;
  String totalSixes;
  String totalFifties;
  String totalBallsBowled;
  String totalRunsConceded;
  String totalWickets;
  String bowlingAverage;
  String bowlingEconomy;
  String bowlingStrikeRate;
  String bestBowlingFigure;
  String catchesTaken;

  Teams team;

  int score = -1;

  //Couldnt find a better place to have the open/close state of player cards, can be moved if we found one
  bool open = true;

  static final Map<String, String> DISPLAY_MAP = {
    'totalMatches': 'Matches',
    "totalNotOuts": "NotOuts",
    "totalRuns": "Runs",
    "highestScore": "H/S",
    "battingAverage": "Bat Avg",
    "totalBallsFaced": "Balls Faced",
    "battingStrikeRate": "Bt SR",
    "totalFours": "4s",
    "totalSixes": "6s",
    "totalFifties": "50s",
    "totalBallsBowled": "Balls Bwld",
    "totalRunsConceded": "Runs Given",
    "totalWickets": "Wickets",
    "bowlingAverage": "Bw Avg",
    "bowlingEconomy": "Economy",
    "bowlingStrikeRate": "Bw SR",
    "bestBowlingFigure": "BBF",
    "catchesTaken": "Catches"
  };

  static final List<String> BATTING_ATTRIBUTES = [
    "totalMatches",
    "battingAverage",
    "totalFours",
    "highestScore",
    "battingStrikeRate",
    "totalSixes",
    "totalFifties",
    "totalRuns"
  ];
  static final List<String> BOWLING_ATTRIBUTES = [
    "totalMatches",
    "totalWickets",
    "bowlingAverage",
    "bowlingEconomy",
    "bowlingStrikeRate",
    "bestBowlingFigure",
    "totalNotOuts",
    "totalRunsConceded",
    "totalBallsBowled",
  ];
  Player() {}

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}
