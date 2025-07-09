// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FeedbackModelAdapter extends TypeAdapter<FeedbackModel> {
  @override
  final int typeId = 2;

  @override
  FeedbackModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FeedbackModel(
      rating: fields[0] as double,
      feedbackText: fields[1] as String,
      submissionDate: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FeedbackModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.rating)
      ..writeByte(1)
      ..write(obj.feedbackText)
      ..writeByte(2)
      ..write(obj.submissionDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedbackModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
