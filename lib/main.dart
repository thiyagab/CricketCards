import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/ui/TeamList.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //TODO The state model is completely pulled up to the root, if we build more complex ui, think of pushing it down
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  MyApp() {
    analytics.logAppOpen();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    precacheImage(AssetImage('assets/images/background.png'), context);

    return FutureBuilder(
      // Initialize FlutterFire:
      future: Utils.initialize(),
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
                // primarySwatch: Colors.blue,
                canvasColor: Colors.blue[900],
                textTheme:
                    TextTheme(bodyText1: TextStyle(), bodyText2: TextStyle())
                        .apply(
                            bodyColor: Colors.white,
                            displayColor: Colors.white)),
            home: TeamList(),
            navigatorObservers: <NavigatorObserver>[observer],
            // GamePlay(title: 'Cricket Cards'),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return DefaultTextStyle(
            style: TextStyle(fontSize: 30),
            child: Text(
              "Loading...",
              textDirection: TextDirection.ltr,
            ));
      },
    );
  }
}
