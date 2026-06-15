// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_point.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TrackPointAdapter extends TypeAdapter<TrackPoint> {
  @override
  final int typeId = 1;

  @override
  TrackPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TrackPoint(
      tripId: fields[0] as String,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
      timestamp: fields[3] as DateTime,
      speed: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TrackPoint obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.tripId)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.speed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrackPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
