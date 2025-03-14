// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSettingsAdapter extends TypeAdapter<UserSettingsModel> {
  @override
  final int typeId = 1;

  @override
  UserSettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSettingsModel(
      isFullScreenTap: fields[0] as bool,
      tapAreaX: fields[1] as double,
      tapAreaY: fields[2] as double,
      tapWidth: fields[3] as double,
      tapHeight: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, UserSettingsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.isFullScreenTap)
      ..writeByte(1)
      ..write(obj.tapAreaX)
      ..writeByte(2)
      ..write(obj.tapAreaY)
      ..writeByte(3)
      ..write(obj.tapWidth)
      ..writeByte(4)
      ..write(obj.tapHeight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
