// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantHiveModelAdapter extends TypeAdapter<RestaurantHiveModel> {
  @override
  final int typeId = 1;

  @override
  RestaurantHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantHiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      pictureId: fields[2] as String,
      city: fields[3] as String,
      rating: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.pictureId)
      ..writeByte(3)
      ..write(obj.city)
      ..writeByte(4)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
