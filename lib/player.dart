class Player {
  final int id;
  final String name;
  final String image;
  final int nummatches;
  final double bataverage;
  final int num50s;
  final int num100s;

  Player(
      {this.id,
      this.name,
      this.image,
      this.nummatches,
      this.bataverage,
      this.num50s,
      this.num100s});

  List<Player> get playerData => [
        new Player(
            id: 1,
            name: "Dhoni",
            image: "assets/images/dhoni.jpg",
            nummatches: 200,
            bataverage: 46.5,
            num50s: 34,
            num100s:11),
        new Player(
            id: 2,
            name: "Kohli",
            image: "assets/images/kohli.jpg",
            nummatches: 190,
            bataverage: 48.2,
            num50s: 54,
            num100s:32),
        new Player(
            id: 3,
            name: "Pant",
            image: "assets/images/pant.png",
            nummatches: 64,
            bataverage: 27.4,
            num50s: 16,
            num100s:2),
      ];
}
