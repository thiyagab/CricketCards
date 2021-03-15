// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$Game on _Game, Store {
  Computed<Team> _$botTeamComputed;

  @override
  Team get botTeam => (_$botTeamComputed ??=
          Computed<Team>(() => super.botTeam, name: '_Game.botTeam'))
      .value;
  Computed<Player> _$chosenBotPlayerComputed;

  @override
  Player get chosenBotPlayer => (_$chosenBotPlayerComputed ??= Computed<Player>(
          () => super.chosenBotPlayer,
          name: '_Game.chosenBotPlayer'))
      .value;

  final _$teamsAtom = Atom(name: '_Game.teams');

  @override
  ObservableList<Team> get teams {
    _$teamsAtom.reportRead();
    return super.teams;
  }

  @override
  set teams(ObservableList<Team> value) {
    _$teamsAtom.reportWrite(value, super.teams, () {
      super.teams = value;
    });
  }

  final _$userPlayersAtom = Atom(name: '_Game.userPlayers');

  @override
  ObservableList<Player> get userPlayers {
    _$userPlayersAtom.reportRead();
    return super.userPlayers;
  }

  @override
  set userPlayers(ObservableList<Player> value) {
    _$userPlayersAtom.reportWrite(value, super.userPlayers, () {
      super.userPlayers = value;
    });
  }

  final _$botPlayersAtom = Atom(name: '_Game.botPlayers');

  @override
  ObservableList<Player> get botPlayers {
    _$botPlayersAtom.reportRead();
    return super.botPlayers;
  }

  @override
  set botPlayers(ObservableList<Player> value) {
    _$botPlayersAtom.reportWrite(value, super.botPlayers, () {
      super.botPlayers = value;
    });
  }

  final _$userTeamAtom = Atom(name: '_Game.userTeam');

  @override
  Team get userTeam {
    _$userTeamAtom.reportRead();
    return super.userTeam;
  }

  @override
  set userTeam(Team value) {
    _$userTeamAtom.reportWrite(value, super.userTeam, () {
      super.userTeam = value;
    });
  }

  final _$chosenUserPlayerAtom = Atom(name: '_Game.chosenUserPlayer');

  @override
  Player get chosenUserPlayer {
    _$chosenUserPlayerAtom.reportRead();
    return super.chosenUserPlayer;
  }

  @override
  set chosenUserPlayer(Player value) {
    _$chosenUserPlayerAtom.reportWrite(value, super.chosenUserPlayer, () {
      super.chosenUserPlayer = value;
    });
  }

  final _$_GameActionController = ActionController(name: '_Game');

  @override
  dynamic setUserTeam(Team team) {
    final _$actionInfo =
        _$_GameActionController.startAction(name: '_Game.setUserTeam');
    try {
      return super.setUserTeam(team);
    } finally {
      _$_GameActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUserPlayer(Player player) {
    final _$actionInfo =
        _$_GameActionController.startAction(name: '_Game.setUserPlayer');
    try {
      return super.setUserPlayer(player);
    } finally {
      _$_GameActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setUserPlayers(List<Player> players) {
    final _$actionInfo =
        _$_GameActionController.startAction(name: '_Game.setUserPlayers');
    try {
      return super.setUserPlayers(players);
    } finally {
      _$_GameActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setBotPlayers(List<Player> botList) {
    final _$actionInfo =
        _$_GameActionController.startAction(name: '_Game.setBotPlayers');
    try {
      return super.setBotPlayers(botList);
    } finally {
      _$_GameActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
teams: ${teams},
userPlayers: ${userPlayers},
botPlayers: ${botPlayers},
userTeam: ${userTeam},
chosenUserPlayer: ${chosenUserPlayer},
botTeam: ${botTeam},
chosenBotPlayer: ${chosenBotPlayer}
    ''';
  }
}
