import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:mobx/mobx.dart';
import '../players/player.dart';

@jsonSerializable
@Json(allowCircularReferences: 1)
@observable
class Team extends _Team {}

@jsonSerializable
abstract class _Team {
  @observable
  String name;
  @observable
  ObservableList<Player> players = ObservableList<Player>();
}
