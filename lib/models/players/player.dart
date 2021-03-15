import 'package:dart_json_mapper/dart_json_mapper.dart';
import 'package:mobx/mobx.dart';

@jsonSerializable
@Json(allowCircularReferences: 1)
@observable
class Player extends _Player {}

@jsonSerializable
abstract class _Player {
  int id;
  String name;
  String image;
  int nummatches;
  double bataverage;
  int num50s;
  int num100s;
  @observable
  int score = -1;
}
