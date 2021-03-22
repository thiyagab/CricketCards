import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:ipltrumpcards/ui/GamePlay.dart';
import 'package:ipltrumpcards/ui/TeamList.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => TrumpModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text("Error", textDirection: TextDirection.ltr));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Cricket Cards',
            theme: ThemeData(
                primarySwatch: Colors.blue,
                canvasColor: Colors.white,
                textTheme:
                    TextTheme(bodyText1: TextStyle(), bodyText2: TextStyle())
                        .apply(
                            bodyColor: Colors.white,
                            displayColor: Colors.white)),
            home: GamePlay(),
            // GamePlay(title: 'Cricket Cards'),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(
            child: Text("Loading...", textDirection: TextDirection.ltr));
      },
    );
  }
}
