import 'Team.dart';

class Player {
  int id;
  String name;
  String image;
  int nummatches;
  double bataverage;
  int num50s;
  int num100s;
  int totalruns;
  double strikerate;

  int score = -1;
  Teams team;

  Player(
      {this.id,
      this.name,
      this.image,
      this.nummatches,
      this.bataverage,
      this.num50s,
      this.num100s,
      this.team,
      this.totalruns});

  copy() {
    return Player(
        id: this.id,
        name: this.name,
        image: this.image,
        nummatches: this.nummatches,
        bataverage: this.bataverage,
        num50s: this.num50s,
        num100s: this.num100s,
        team: this.team,
        totalruns: this.totalruns);
  }

  List<Player> get playerData => [
        new Player(
            id: 1,
            name: "Dhoni",
            image: "assets/images/dhoni.jpg",
            nummatches: 200,
            bataverage: 46.5,
            num50s: 34,
            num100s: 11,
            team: Teams.CHENNAI),
        new Player(
            id: 2,
            name: "Kohli",
            image: "assets/images/kohli.jpg",
            nummatches: 190,
            bataverage: 48.2,
            num50s: 54,
            num100s: 32,
            team: Teams.CHENNAI),
        new Player(
            id: 3,
            name: "Pant",
            image: "assets/images/pant.png",
            nummatches: 64,
            bataverage: 27.4,
            num50s: 16,
            num100s: 2,
            team: Teams.CHENNAI),
        new Player(
            id: 4,
            name: "Rohit Sharma",
            image: "assets/images/dhoni.jpg",
            nummatches: 134,
            bataverage: 42.5,
            num50s: 25,
            num100s: 14,
            team: Teams.CHENNAI),
        new Player(
            id: 5,
            name: "KL Rahul",
            image: "assets/images/dhoni.jpg",
            nummatches: 54,
            bataverage: 49.5,
            num50s: 16,
            num100s: 5,
            team: Teams.CHENNAI),
        new Player(
            id: 6,
            name: "Ambati Rayudu",
            image: "assets/images/dhoni.jpg",
            nummatches: 25,
            bataverage: 34.5,
            num50s: 7,
            num100s: 2,
            team: Teams.CHENNAI),
        new Player(
            id: 7,
            name: "Imran Tahir",
            image: "assets/images/dhoni.jpg",
            nummatches: 230,
            bataverage: 16.5,
            num50s: 1,
            num100s: 0,
            team: Teams.CHENNAI),
        new Player(
            id: 8,
            name: "Josh Hazlewood",
            image: "assets/images/dhoni.jpg",
            nummatches: 54,
            bataverage: 21.5,
            num50s: 1,
            num100s: 1,
            team: Teams.CHENNAI),
        new Player(
            id: 9,
            name: "R Sai Kishore",
            image: "assets/images/dhoni.jpg",
            nummatches: 2,
            bataverage: 43.2,
            num50s: 2,
            num100s: 1,
            team: Teams.CHENNAI),
        new Player(
            id: 10,
            name: "Ravindra Jadeja",
            image: "assets/images/dhoni.jpg",
            nummatches: 212,
            bataverage: 36.2,
            num50s: 13,
            num100s: 3,
            team: Teams.CHENNAI),
        new Player(
            id: 11,
            name: "Suresh Raina",
            image: "assets/images/dhoni.jpg",
            nummatches: 189,
            bataverage: 54.2,
            num50s: 22,
            num100s: 12,
            team: Teams.CHENNAI),
      ];
}
