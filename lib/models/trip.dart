import 'package:hive/hive.dart';

part 'trip.g.dart';

@HiveType(typeId: 0)
class Trip {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final DateTime startTime;
  
  @HiveField(2)
  final DateTime endTime;
  
  @HiveField(3)
  final int duration;
  
  @HiveField(4)
  final double distance;
  
  @HiveField(5)
  final String transportType;
  
  @HiveField(6)
  final String tripPurpose;
  
  @HiveField(7)
  final bool isUploaded;

  Trip({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.distance,
    required this.transportType,
    required this.tripPurpose,
    this.isUploaded = false,
  });
}