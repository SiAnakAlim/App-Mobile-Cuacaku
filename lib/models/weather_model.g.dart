// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherDataAdapter extends TypeAdapter<WeatherData> {
  @override
  final int typeId = 1;

  @override
  WeatherData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherData(
      datetime: fields[0] as String,
      localDatetime: fields[1] as String,
      temperature: fields[2] as double,
      humidity: fields[3] as double,
      weatherDescriptionEn: fields[4] as String,
      windSpeed: fields[5] as double,
      windDirection: fields[6] as String,
      cloudCoverage: fields[7] as double,
      visibility: fields[8] as String,
      imageUrl: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherData obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.datetime)
      ..writeByte(1)
      ..write(obj.localDatetime)
      ..writeByte(2)
      ..write(obj.temperature)
      ..writeByte(3)
      ..write(obj.humidity)
      ..writeByte(4)
      ..write(obj.weatherDescriptionEn)
      ..writeByte(5)
      ..write(obj.windSpeed)
      ..writeByte(6)
      ..write(obj.windDirection)
      ..writeByte(7)
      ..write(obj.cloudCoverage)
      ..writeByte(8)
      ..write(obj.visibility)
      ..writeByte(9)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherData _$WeatherDataFromJson(Map<String, dynamic> json) => WeatherData(
      datetime: json['datetime'] as String,
      localDatetime: json['local_datetime'] as String,
      temperature: _parseDouble(json['t']),
      humidity: _parseDouble(json['hu']),
      weatherDescriptionEn: json['weather_desc_en'] as String,
      windSpeed: _parseDouble(json['ws']),
      windDirection: json['wd'] as String,
      cloudCoverage: _parseDouble(json['tcc']),
      visibility: json['vs_text'] as String,
      imageUrl: json['image'] as String,
    );

Map<String, dynamic> _$WeatherDataToJson(WeatherData instance) =>
    <String, dynamic>{
      'datetime': instance.datetime,
      'local_datetime': instance.localDatetime,
      't': instance.temperature,
      'hu': instance.humidity,
      'weather_desc_en': instance.weatherDescriptionEn,
      'ws': instance.windSpeed,
      'wd': instance.windDirection,
      'tcc': instance.cloudCoverage,
      'vs_text': instance.visibility,
      'image': instance.imageUrl,
    };
