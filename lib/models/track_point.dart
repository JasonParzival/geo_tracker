import 'package:hive/hive.dart';

part 'track_point.g.dart';

@HiveType(typeId: 1)
class TrackPoint {
  @HiveField(0)
  final String tripId;

  @HiveField(1)
  final double latitude;
  
  @HiveField(2)
  final double longitude;
  
  @HiveField(3)
  final DateTime timestamp;
  
  @HiveField(4)
  final double speed;

  TrackPoint({
    required this.tripId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.speed,
  });
}