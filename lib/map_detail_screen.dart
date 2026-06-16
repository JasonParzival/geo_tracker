import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geo_tracker/models/trip.dart';
import 'package:geo_tracker/models/track_point.dart';

class MapDetailScreen extends StatefulWidget {
  final Trip trip;
  const MapDetailScreen({super.key, required this.trip});

  @override
  State<MapDetailScreen> createState() => _MapDetailScreenState();
}

class _MapDetailScreenState extends State<MapDetailScreen> {
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadTrack();
  }

  Future<void> _loadTrack() async {
    final box = await Hive.openBox<TrackPoint>('trackPoints');
    final points = box.values.where((p) => p.tripId == widget.trip.id).toList();
    
    if (points.isEmpty) {
      // Если точек нет, показываем сообщение
      return;
    }
    
    final latLngs = points.map((p) => LatLng(p.latitude, p.longitude)).toList();
    
    setState(() {
      // Маркеры старта и финиша
      _markers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: latLngs.first,
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('end'),
          position: latLngs.last,
        ),
      );
      // Полилиния трека
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('track'),
          points: latLngs,
          color: Colors.blue,
          width: 5,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Поездка ${widget.trip.startTime.toString().substring(0, 16)}'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _markers.isEmpty 
              ? const LatLng(52.2854, 104.2894) 
              : _markers.first.position,
          zoom: 14,
        ),
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }
}