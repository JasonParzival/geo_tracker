import 'package:geolocator/geolocator.dart';

class LocationService {
  final LocationSettings _settings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5,
  );

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(locationSettings: _settings);
  }

  Future<bool> requestPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final newPermission = await Geolocator.requestPermission();
      return newPermission == LocationPermission.whileInUse || 
             newPermission == LocationPermission.always;
    }
    return permission == LocationPermission.whileInUse || 
           permission == LocationPermission.always;
  }
}