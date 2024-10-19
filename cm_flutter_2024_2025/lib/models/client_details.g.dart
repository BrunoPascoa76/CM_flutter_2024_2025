// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClientDetailsAdapter extends TypeAdapter<ClientDetails> {
  @override
  final int typeId = 3;

  @override
  ClientDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientDetails(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClientDetails obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.clientName)
      ..writeByte(2)
      ..write(obj.phoneNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClientDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
