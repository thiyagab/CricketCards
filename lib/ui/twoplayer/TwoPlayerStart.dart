import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ipltrumpcards/common/Utils.dart';
import 'package:ipltrumpcards/model/Team.dart';
import 'package:ipltrumpcards/model/TrumpModel.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../CricketCardsTheme.dart';
import '../GamePlay.dart';

class TwoPlayerStart extends StatefulWidget {
  TwoPlayerStart();

  @override
  State<StatefulWidget> createState() {
    return _TwoPlayerStartState();
  }
}

class _TwoPlayerStartState extends State<TwoPlayerStart> {
  bool host = true;
  String selectedTeam = Utils.IPL11;
  final textController = TextEditingController();

  int hostcode;
  String hostid;

  //TODO the whole UI should be revamped, now looks very amateruish, again will do after some traction
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: CricketCardsAppTheme.background_img,
            child: Container(
                // color: Colors.black54.withAlpha(200),
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          hostOrJoinControls(context),
                          instructionText(context),
                        ])))));
  }

  Widget instructionText(BuildContext context) {
    return Text(
        '\n\nNote: You can select your favorite team and score points for them or select IPL11 (mix of all players) for a casual play\n\nPlease make sure both are in latest version',
        style: TextStyle(fontSize: 12, color: CricketCardsAppTheme.textColor));
  }

  Widget hostOrJoinControls(BuildContext context) {
    return Container(
        // color: CricketCardsAppTheme.lightText,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: CricketCardsAppTheme.lightText,
            border: Border.all(color: CricketCardsAppTheme.lightText)),
        // .withAlpha(220),
        child: Padding(
            padding: EdgeInsets.only(left: 30, right: 30, top: 20),
            child: Column(children: [
              SwitchListTile(
                title: Text(
                  'Host or Join',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 25, color: CricketCardsAppTheme.textColor),
                ),
                subtitle: host
                    ? Text('Share code and host. Toggle to join',
                        style: TextStyle(
                            fontSize: 12,
                            color: CricketCardsAppTheme.textColor))
                    : Text('Enter code and join. Toggle to host',
                        style: TextStyle(
                            fontSize: 12,
                            color: CricketCardsAppTheme.textColor)),
                value: host,
                activeColor: Colors.white,
                // activeTrackColor: Colors.white,
                onChanged: (value) {
                  setState(() {
                    host = value;
                  });
                },
              ),
              SizedBox(height: 10),
              Container(
                  height: 100,
                  child: host
                      ? FutureBuilder(
                          future: checkHostId(),
                          builder: (context, snapshot) =>
                              snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? Center(child: Text('Generating'))
                                  : Row(children: [
                                      Text('Code: '),
                                      Text(snapshot.data.toString(),
                                          style: TextStyle(fontSize: 40)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Share.share(
                                              "Play for your favourite team against me in IPL Trump cards  https://play.google.com/store/apps/details?id=com.droidapps.cricketcards.  Use code: ${snapshot.data.toString()}");
                                        },
                                        icon: Icon(
                                          Icons.share,
                                          color: Colors.white,
                                        ),
                                      )
                                    ]))
                      : TextField(
                          controller: textController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Code'),
                        )),
              DropdownButtonFormField(
                  onChanged: (value) {
                    selectedTeam = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  dropdownColor: CricketCardsAppTheme.nearlyWhite,
                  value: selectedTeam,
                  items: teamList()
                      .map((team) => DropdownMenuItem<String>(
                          value: team, child: Text(Utils.camelCase(team))))
                      .toList()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate returns true if the form is valid, or false otherwise.
                    validate(context).then((value) {
                      if (value) hostOrJoin(context);
                    });
                  },
                  child: Container(
                      height: 40,
                      width: 150,
                      child: Center(
                          child: Text(
                        host ? 'Host' : 'Join',
                        style: TextStyle(fontSize: 18),
                      ))),
                ),
              ),
            ])));
  }

  Future<bool> validate(BuildContext context) async {
    if (!host) {
      if (textController.text.length < 6) {
        showText(context, 'Code should be 6 digits');
        return false;
      }
      int code = int.parse(textController.text);
      QuerySnapshot snapshot = await Utils.getGameSession(code);
      if (snapshot == null ||
          snapshot.docs == null ||
          snapshot.docs.length == 0) {
        showText(context,
            'Error: Invalid code. Check with your friend and try again');
        return false;
      }
      if (snapshot.docs.length > 1) {
        showText(context, 'Error: Ask host to regenerate code');
        return false;
      }
      Map data = snapshot.docs[0].data();
      if (data['gameState'] == null || data['gameState'] != 0) {
        showText(context,
            'Host is not ready yet. They should start first before you join');
        return false;
      }
      if (data['hostTeam'] != null &&
          data['hostTeam'].toString() != Utils.IPL11 &&
          data['hostTeam'].toString().toLowerCase() ==
              selectedTeam.toLowerCase()) {
        showText(
            context, 'Please select a different team than the host or IPL 11');
        return false;
      }
      if (data['version'] == null || data['version'] < Utils.DATA_VERSION) {
        showText(context, 'Host is lower version. Please ask them to update');
        return false;
      } else if (data['version'] > Utils.DATA_VERSION) {
        showText(context, 'Please update to latest version as host');
        return false;
      }
    }

    return true;
  }

  void showText(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: DefaultTextStyle(
                style: TextStyle(
                    fontSize: 24, color: CricketCardsAppTheme.textColor),
                child: Text(text)));
      },
    );
  }

  Future<int> checkHostId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int code = prefs.getInt('hostcode');
    String id = prefs.getString('hostid');
    if (code == null || id == null) {
      List codeAndId = await Utils.increaseAndCreateHost();
      code = codeAndId[0];
      id = codeAndId[1];
      prefs.setInt('hostcode', code);
      prefs.setString('hostid', id);
    } else {
      await Utils.clearGameSession(id, code);
    }
    hostcode = code;
    hostid = id;
    return code;
  }

  hostOrJoin(BuildContext context) async {
    Teams team = selectedTeam == Utils.IPL11
        ? null
        : Team.teamsMap[selectedTeam.toLowerCase()];
    this.host
        ? _hostTwoPlayer(context, team, hostid)
        : _joinTwoPlayer(context, team, int.parse(textController.text));
  }

  List<String> teamList() {
    List<String> teamlist = Team.teamsMap.keys.toList();
    teamlist.insert(0, Utils.IPL11);
    return teamlist;
  }

  _joinTwoPlayer(BuildContext context, Teams team, int code) {
    Utils.joinTwoPlayers(team, code: code)
        .then((model) => _moveToGamePlay(context, model, false, model.hostid));
  }

  _hostTwoPlayer(BuildContext context, Teams team, String id) {
    Utils.hostTwoPlayers(team, id)
        .then((model) => _moveToGamePlay(context, model, true, id));
  }

  _moveToGamePlay(
      BuildContext context, TrumpModel model, bool host, String id) {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context1) =>
                _listenAndGamePlay(context1, model, host, id)));
  }

  _listenAndGamePlay(
      BuildContext context, TrumpModel model, bool host, String id) {
    return ChangeNotifierProvider(
        create: (_) => model,
        builder: (newcontext, child) {
          Utils.listenTwoPlayers(newcontext, host, id: id);
          return GamePlay();
        });
  }
}
