// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return Player()
    ..id = json['id'] as int
    ..shortName = json['shortName'] as String
    ..role = json['role'] as String
    ..totalMatches = json['totalMatches'] as String
    ..totalNotOuts = json['totalNotOuts'] as String
    ..totalRuns = json['totalRuns'] as String
    ..highestScore = json['highestScore'] as String
    ..battingAverage = json['battingAverage'] as String
    ..totalBallsFaced = json['totalBallsFaced'] as String
    ..battingStrikeRate = json['battingStrikeRate'] as String
    ..totalFours = json['totalFours'] as String
    ..totalSixes = json['totalSixes'] as String
    ..totalFifties = json['totalFifties'] as String
    ..totalBallsBowled = json['totalBallsBowled'] as String
    ..totalRunsConceded = json['totalRunsConceded'] as String
    ..totalWickets = json['totalWickets'] as String
    ..bowlingAverage = json['bowlingAverage'] as String
    ..bowlingEconomy = json['bowlingEconomy'] as String
    ..bowlingStrikeRate = json['bowlingStrikeRate'] as String
    ..score = json['score'] as int
    ..team = _$enumDecodeNullable(_$TeamsEnumMap, json['team']);
}

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'id': instance.id,
      'shortName': instance.shortName,
      'role': instance.role,
      'totalMatches': instance.totalMatches,
      'totalNotOuts': instance.totalNotOuts,
      'totalRuns': instance.totalRuns,
      'highestScore': instance.highestScore,
      'battingAverage': instance.battingAverage,
      'totalBallsFaced': instance.totalBallsFaced,
      'battingStrikeRate': instance.battingStrikeRate,
      'totalFours': instance.totalFours,
      'totalSixes': instance.totalSixes,
      'totalFifties': instance.totalFifties,
      'totalBallsBowled': instance.totalBallsBowled,
      'totalRunsConceded': instance.totalRunsConceded,
      'totalWickets': instance.totalWickets,
      'bowlingAverage': instance.bowlingAverage,
      'bowlingEconomy': instance.bowlingEconomy,
      'bowlingStrikeRate': instance.bowlingStrikeRate,
      'score': instance.score,
      'team': _$TeamsEnumMap[instance.team],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$TeamsEnumMap = {
  Teams.CHENNAI: 'CHENNAI',
  Teams.MUMBAI: 'MUMBAI',
  Teams.BENGALURU: 'BENGALURU',
  Teams.PUNJAB: 'PUNJAB',
  Teams.HYDERABAD: 'HYDERABAD',
  Teams.KOLKATA: 'KOLKATA',
  Teams.DELHI: 'DELHI',
  Teams.RAJASTHAN: 'RAJASTHAN',
};
