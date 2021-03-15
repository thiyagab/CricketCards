import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:mobx/mobx.dart';
import '../players/player.dart';
import '../team/team.dart';

part 'game.g.dart';

@jsonSerializable
class Game extends _Game with _$Game {}

@jsonSerializable
abstract class _Game with Store {
  @observable
  ObservableList<Team> teams = ObservableList<Team>();

  @observable
  ObservableList<Player> userPlayers = ObservableList<Player>();

  @observable
  ObservableList<Player> botPlayers = ObservableList<Player>();

  @observable
  Team userTeam;

  @observable
  Player chosenUserPlayer;

  @computed
  Team get botTeam {
    final clonedList = [...teams];
    return (clonedList..shuffle()).first;
  }

  @computed
  Player get chosenBotPlayer {
    Player player = (chosenUserPlayer != null && botPlayers.isNotEmpty)
        ? ([...botPlayers]..shuffle()).first
        : null;
    return player;
  }

  @action
  setUserTeam(Team team) {
    this.userTeam = team;
  }

  @action
  setUserPlayer(Player player) {
    this.chosenUserPlayer = player;
    final clonedPlayers = [...this.userPlayers];
    final clonedBotPlayers = [...this.botPlayers];
    clonedPlayers.remove(player);
    setUserPlayers(clonedPlayers);
    clonedBotPlayers.remove(chosenBotPlayer);
    setBotPlayers(clonedBotPlayers);
  }

  @action
  setUserPlayers(List<Player> players) {
    this.userPlayers = ObservableList.of([...players]);
  }

  @action
  setBotPlayers(List<Player> botList) {
    final clonedList = [...botList];
    clonedList.shuffle();
    this.botPlayers = ObservableList.of([...clonedList]);
  }
}
