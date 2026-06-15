import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripMap extends StatefulWidget {
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final CameraPosition initialCameraPosition;

  const TripMap({
    super.key,
    this.markers = const {},
    this.polylines = const {},
    required this.initialCameraPosition,
  });

  @override
  State<TripMap> createState() => _TripMapState();
}

class _TripMapState extends State<TripMap> {
  late GoogleMapController _controller;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: widget.initialCameraPosition,
      markers: widget.markers,
      polylines: widget.polylines,
      onMapCreated: (controller) {
        _controller = controller;
      },
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
    );
  }
}