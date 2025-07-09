// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      name: fields[0] as String,
      email: fields[1] as String,
      encryptedPassword: fields[2] as String,
      isLoggedIn: fields[3] as bool,
      isPremium: fields[4] as bool,
      premiumExpiryDate: fields[5] as DateTime?,
      premiumHistory: (fields[6] as List?)?.cast<PremiumTransaction>(),
      profileImagePath: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.encryptedPassword)
      ..writeByte(3)
      ..write(obj.isLoggedIn)
      ..writeByte(4)
      ..write(obj.isPremium)
      ..writeByte(5)
      ..write(obj.premiumExpiryDate)
      ..writeByte(6)
      ..write(obj.premiumHistory)
      ..writeByte(7)
      ..write(obj.profileImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
