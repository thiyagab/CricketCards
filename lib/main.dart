import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ipltrumpcards/ui/TeamList.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //TODO The state model is completely pulled up to the root, if we build more complex ui, think of pushing it down
  runApp(MyApp());
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
          return Center(child: Text("Error"));
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
            home: TeamList(),
            // GamePlay(title: 'Cricket Cards'),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(child: Text("Loading..."));
      },
    );
  }
}
