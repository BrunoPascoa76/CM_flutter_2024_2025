// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_route.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryRouteAdapter extends TypeAdapter<DeliveryRoute> {
  @override
  final int typeId = 6;

  @override
  DeliveryRoute read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeliveryRoute(
      fields[0] as int,
      (fields[5] as List).cast<Delivery>(),
    )
      ..driver = fields[1] as Driver?
      ..startTime = fields[2] as DateTime?
      ..endTime = fields[3] as DateTime?
      ..totalDistance = fields[4] as int?
      ..current_delivery = fields[6] as int;
  }

  @override
  void write(BinaryWriter writer, DeliveryRoute obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.driver)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.totalDistance)
      ..writeByte(5)
      ..write(obj.deliveries)
      ..writeByte(6)
      ..write(obj.current_delivery);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryRouteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
