// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) {
  return Player(
    id: json['id'] as int,
    shortName: json['shortName'] as String,
    totalMatches: json['totalMatches'] as String,
    battingAverage: json['battingAverage'] as String,
    totalFifties: json['totalFifties'] as String,
    num100s: json['num100s'] as String,
    team: _$enumDecodeNullable(_$TeamsEnumMap, json['team']),
    totalRuns: json['totalRuns'] as String,
  )
    ..battingStrikeRate = json['battingStrikeRate'] as String
    ..score = json['score'] as int;
}

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'id': instance.id,
      'shortName': instance.shortName,
      'totalMatches': instance.totalMatches,
      'battingAverage': instance.battingAverage,
      'totalFifties': instance.totalFifties,
      'num100s': instance.num100s,
      'totalRuns': instance.totalRuns,
      'battingStrikeRate': instance.battingStrikeRate,
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
