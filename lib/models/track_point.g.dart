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
      latitude: fields[0] as double,
      longitude: fields[1] as double,
      timestamp: fields[2] as DateTime,
      speed: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TrackPoint obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.latitude)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
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
