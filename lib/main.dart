import 'package:flutter/material.dart';
import 'package:warofcards/model/TrumpModel.dart';
import 'package:warofcards/model/player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cricket Cards',
      theme: ThemeData(primarySwatch: Colors.blue, canvasColor: Colors.white),
      home: MyHomePage(title: 'Cricket Cards'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var width, height;
  TrumpModel trumpModel;

  @override
  void initState() {
    super.initState();
    _prepareGame(context);
  }

  void _prepareGame(BuildContext context) {
    //TODO
    //1. build UI for player to choose team
    //2. UI to show bot selected opponent team
    //3. Shuffle the players and assign to bot and player
    trumpModel = new TrumpModel();
    trumpModel.dummy();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Container(
            color: Colors.white,
            child: Column(children: [
              _cards(context, trumpModel.botCards),
              _card(context, trumpModel.botCard),
              _card(context, trumpModel.playerCard),
              _cards(context, trumpModel.playerCards),
            ])));
  }

  Widget _card(BuildContext context, Player card) {
    return Center(
        child: Container(
            height: this.height / 3,
            width: (this.width / 2),
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  "Card",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )));
  }

  Widget _cards(context, List<Player> playerCards) {
    return Container(
      height: height / 8, // card height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (_, i) {
          return Container(
              width: this.width / 4,
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3)),
                child: Center(
                  child: Text(
                    "Card ${i + 1}",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
