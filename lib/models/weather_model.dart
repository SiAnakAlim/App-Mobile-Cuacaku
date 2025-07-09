import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  if (value is String) {
    try {
      return double.parse(value);
    } catch (_) {
      return 0.0;
    }
  }
  return 0.0;
}

@HiveType(typeId: 1)
@JsonSerializable()
class WeatherData extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'datetime')
  final String datetime;

  @HiveField(1)
  @JsonKey(name: 'local_datetime')
  final String localDatetime;

  @HiveField(2)
  @JsonKey(name: 't', fromJson: _parseDouble)
  final double temperature;

  @HiveField(3)
  @JsonKey(name: 'hu', fromJson: _parseDouble)
  final double humidity;

  @HiveField(4)
  @JsonKey(name: 'weather_desc_en')
  final String weatherDescriptionEn;

  @HiveField(5)
  @JsonKey(name: 'ws', fromJson: _parseDouble)
  final double windSpeed;

  @HiveField(6)
  @JsonKey(name: 'wd')
  final String windDirection;

  @HiveField(7)
  @JsonKey(name: 'tcc', fromJson: _parseDouble)
  final double cloudCoverage;

  @HiveField(8)
  @JsonKey(name: 'vs_text')
  final String visibility;

  @HiveField(9)
  @JsonKey(name: 'image')
  final String imageUrl;

  WeatherData({
    required this.datetime,
    required this.localDatetime,
    required this.temperature,
    required this.humidity,
    required this.weatherDescriptionEn,
    required this.windSpeed,
    required this.windDirection,
    required this.cloudCoverage,
    required this.visibility,
    required this.imageUrl,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) =>
      _$WeatherDataFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherDataToJson(this);
}
