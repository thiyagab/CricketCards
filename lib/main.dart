import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:ipltrumpcards/ui/GamePlay.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => TrumpModel(),
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cricket Cards',
      theme: ThemeData(primarySwatch: Colors.blue, canvasColor: Colors.white),
      home: GamePlay(title: 'Cricket Cards'),
    );
  }
}
