// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'premium_transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PremiumTransactionAdapter extends TypeAdapter<PremiumTransaction> {
  @override
  final int typeId = 2;

  @override
  PremiumTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PremiumTransaction(
      email: fields[0] as String,
      packageName: fields[1] as String,
      originalAmount: fields[2] as double,
      currency: fields[3] as String,
      convertedAmount: fields[4] as double,
      purchaseDate: fields[5] as DateTime,
      expiryDate: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PremiumTransaction obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.email)
      ..writeByte(1)
      ..write(obj.packageName)
      ..writeByte(2)
      ..write(obj.originalAmount)
      ..writeByte(3)
      ..write(obj.currency)
      ..writeByte(4)
      ..write(obj.convertedAmount)
      ..writeByte(5)
      ..write(obj.purchaseDate)
      ..writeByte(6)
      ..write(obj.expiryDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PremiumTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
