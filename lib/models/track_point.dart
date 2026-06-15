import 'package:hive/hive.dart';

part 'track_point.g.dart';

@HiveType(typeId: 1)
class TrackPoint {
  @HiveField(0)
  final double latitude;
  
  @HiveField(1)
  final double longitude;
  
  @HiveField(2)
  final DateTime timestamp;
  
  @HiveField(3)
  final double speed;

  TrackPoint({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.speed,
  });
}