// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodLogAdapter extends TypeAdapter<FoodLog> {
  @override
  final int typeId = 0;

  @override
  FoodLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodLog(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      foodName: fields[2] as String,
      quantity: fields[3] as String,
      hadReaction: fields[4] as bool,
      reactionNotes: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FoodLog obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.foodName)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.hadReaction)
      ..writeByte(5)
      ..write(obj.reactionNotes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
