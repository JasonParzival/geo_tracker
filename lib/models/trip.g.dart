// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripAdapter extends TypeAdapter<Trip> {
  @override
  final int typeId = 0;

  @override
  Trip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trip(
      id: fields[0] as String,
      startTime: fields[1] as DateTime,
      endTime: fields[2] as DateTime,
      duration: fields[3] as int,
      distance: fields[4] as double,
      transportType: fields[5] as String,
      tripPurpose: fields[6] as String,
      isUploaded: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Trip obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.duration)
      ..writeByte(4)
      ..write(obj.distance)
      ..writeByte(5)
      ..write(obj.transportType)
      ..writeByte(6)
      ..write(obj.tripPurpose)
      ..writeByte(7)
      ..write(obj.isUploaded);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
