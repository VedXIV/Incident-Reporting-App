// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IncidentAdapter extends TypeAdapter<Incident> {
  @override
  final int typeId = 0;

  @override
  Incident read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Incident(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      category: fields[3] as String,
      priority: fields[4] as String,
      location: fields[5] as String,
      status: fields[6] as String,
      timeReported: fields[7] as DateTime,
      assignedResponder: fields[8] as String?,
      isSynced: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Incident obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.timeReported)
      ..writeByte(8)
      ..write(obj.assignedResponder)
      ..writeByte(9)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncidentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
