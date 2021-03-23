import 'package:json_annotation/json_annotation.dart';

import 'Team.dart';

part 'player.g.dart';

@JsonSerializable()
class Player {
  int id;
  String shortName;
  String totalMatches;
  String battingAverage;
  String totalFifties;
  String num100s;
  String totalRuns;
  String battingStrikeRate = '';
  int score = -1;
  Teams team;

  Player(
      {this.id,
      this.shortName,
      this.totalMatches,
      this.battingAverage,
      this.totalFifties,
      this.num100s,
      this.team,
      this.totalRuns});

  copy() {
    return Player(
        id: this.id,
        shortName: this.shortName,
        totalMatches: this.totalMatches,
        battingAverage: this.battingAverage,
        totalFifties: this.totalFifties,
        num100s: this.num100s,
        team: this.team,
        totalRuns: this.totalRuns);
  }

  // List<Player> get playerData => [
  //       new Player(
  //           id: 1,
  //           shortName: "Dhoni",
  //           totalMatches: "200",
  //           battingAverage: "46.5",
  //           totalFifties: "34",
  //           num100s: 11,
  //           team: Teams.CHENNAI),
  //       new Player(
  //           id: 2,
  //           shortName: "Kohli",
  //           image: "assets/images/kohli.jpg",
  //           totalMatches: 190,
  //           battingAverage: 48.2,
  //           totalFifties: 54,
  //           num100s: 32,
  //           team: Teams.CHENNAI),
  //       new Player(
  //           id: 3,
  //           shortName: "Pant",
  //           image: "assets/images/pant.png",
  //           totalMatches: 64,
  //           battingAverage: 27.4,
  //           totalFifties: 16,
  //           num100s: 2,
  //           team: Teams.CHENNAI),
  //       new Player(
  //           id: 4,
  //           shortName: "Rohit Sharma",
  //           image: "assets/images/dhoni.jpg",
  //           totalMatches: 134,
  //           battingAverage: 42.5,
  //           totalFifties: 25,
  //           num100s: 14,
  //           team: Teams.CHENNAI),
  //       new Player(
  //           id: 5,
  //           shortName: "KL Rahul",
  //           image: "assets/images/dhoni.jpg",
  //           totalMatches: 54,
  //           battingAverage: 49.5,
  //           totalFifties: 16,
  //           num100s: 5,
  //           team: Teams.CHENNAI),
  //       new Player(
  //           id: 6,
  //           shortName: "Ambati Rayudu",
  //           image: "assets/images/dhoni.jpg",
  //           totalMatches: 25,
  //           battingAverage: 34.5,
  //           totalFifties: 7,
  //           num100s: 2,
  //           team: Teams.CHENNAI),
  //       new Player(
  //           id: 7,
  //           shortName: "Imran Tahir",
  //           image: "assets/images/dhoni.jpg",
  //           totalMatches: 230,
  //           battingAverage: 16.5,
  //           totalFifties: 1,
  //           num100s: 0,
  //           team: Teams.CHENNAI),
  //       new Player(
  //           id: 8,
  //           shortName: "Josh Hazlewood",
  //           image: "assets/images/dhoni.jpg",
  //           totalMatches: 54,
  //           battingAverage: 21.5,
  //           totalFifties: 1,
  //           num100s: 1,
  //           team: Teams.CHENNAI),
  //       new Player(
  //           id: 9,
  //           shortName: "R Sai Kishore",
  //           image: "assets/images/dhoni.jpg",
  //           totalMatches: 2,
  //           battingAverage: 43.2,
  //           totalFifties: 2,
  //           num100s: 1,
  //           team: Teams.CHENNAI),
  //       new Player(
  //           id: 10,
  //           shortName: "Ravindra Jadeja",
  //           image: "assets/images/dhoni.jpg",
  //           totalMatches: 212,
  //           battingAverage: 36.2,
  //           totalFifties: 13,
  //           num100s: 3,
  //           team: Teams.CHENNAI),
  //       new Player(
  //           id: 11,
  //           shortName: "Suresh Raina",
  //           image: "assets/images/dhoni.jpg",
  //           totalMatches: 189,
  //           battingAverage: 54.2,
  //           totalFifties: 22,
  //           num100s: 12,
  //           team: Teams.CHENNAI),
  //     ];

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PlayerToJson(this);
}
