// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeliveryAdapter extends TypeAdapter<Delivery> {
  @override
  final int typeId = 5;

  @override
  Delivery read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Delivery(
      fields[0] as int,
      fields[1] as ClientDetails,
      fields[2] as Address,
      fields[3] as Address,
      fields[8] as String,
      fields[9] as DateTime,
    )
      ..status = fields[5] as String
      ..predictedDeliveryTime = fields[6] as DateTime?
      ..actualDeliveryTime = fields[7] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Delivery obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.clientDetails)
      ..writeByte(2)
      ..write(obj.pickupAddress)
      ..writeByte(3)
      ..write(obj.deliveryAddress)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.predictedDeliveryTime)
      ..writeByte(7)
      ..write(obj.actualDeliveryTime)
      ..writeByte(8)
      ..write(obj.pinHash)
      ..writeByte(9)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
