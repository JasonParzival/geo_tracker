import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geo_tracker/attributes_screen.dart';
import 'package:geo_tracker/history_screen.dart';
import 'package:geo_tracker/settings_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geo_tracker/widgets/trip_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geo_tracker/services/location_service.dart';
import 'package:geo_tracker/models/track_point.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isRecording = false;
  int _seconds = 0;
  Timer? _timer;
  String? _currentTripId;

  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  int _pointCount = 0;

  final LocationService _locationService = LocationService();
  final List<LatLng> _trackPoints = [];
  Timer? _trackTimer;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final hasPermission = await _locationService.requestPermission();
    if (!hasPermission) {
      // Показать сообщение об ошибке
      return;
    }
  }

  void _startTracking() {
    final tripId = _currentTripId;
    if (tripId == null) return;
    
    _trackTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final position = await Geolocator.getCurrentPosition();
      final point = TrackPoint(
        tripId: tripId,
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
        speed: position.speed,
      );
      
      // Сохраняем в Hive
      final box = await Hive.openBox<TrackPoint>('trackPoints');
      await box.add(point);
      
      setState(() {
        _trackPoints.add(LatLng(position.latitude, position.longitude));
        _updateMap();
      });
    });
  }

  void _updateMap() {
    if (_trackPoints.isEmpty) return;
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('start'),
        position: _trackPoints.first,
      ),
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('current'),
        position: _trackPoints.last,
      ),
    );
    _polylines.clear();
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('track'),
        points: _trackPoints,
        color: Colors.blue,
        width: 5,
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo Tracker'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: TripMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(55.7558, 37.6176),
                zoom: 14,
              ),
              markers: _markers,
              polylines: _polylines,
            ),
          ),
          // Статус
          Center(
            child: Text(
              _isRecording ? 'Статус: Запись идёт...' : 'Статус: Готов',
              style: TextStyle(
                fontSize: 18,
                color: _isRecording ? Colors.green : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Таймер
          Center(
            child: Text(
              '${_seconds ~/ 60}:${(_seconds % 60).toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
          // Главная панель управления (Старт + Пауза)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Кнопка Пауза (рядом со Старт)
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: _buildToolButton('Пауза', Icons.pause),
              ),
              // Кнопка Старт / Стоп
              SizedBox(
                width: 100,
                height: 100,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (!_isRecording) {
                        // Запуск записи
                        _isRecording = true;
                        _currentTripId = DateTime.now().millisecondsSinceEpoch.toString();
                        _startTimer();
                        _startTracking();
                      } else {
                        // Остановка записи
                        _isRecording = false;
                        _stopTimer();
                        final tripId = _currentTripId!;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttributesScreen(tripId: tripId),
                          ),
                        );
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: _isRecording ? Colors.red : Colors.green,
                  ),
                  child: Text(
                    _isRecording ? 'Стоп' : 'Старт',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Остальные кнопки (Атрибуты, История, Настройки)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildToolButton('Атрибуты', Icons.label),
              _buildToolButton('История', Icons.history),
              _buildToolButton('Настройки', Icons.settings),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(String label, IconData icon) {
    // Создаём карту действий для каждой кнопки
    VoidCallback? onPressed;
    switch (label) {
      case 'Атрибуты':
        onPressed = () {
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );*/
        };
        break;
      case 'История':
        onPressed = () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HistoryScreen()),
          );
        };
        break;
      case 'Настройки':
        onPressed = () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        };
        break;
      default:
        onPressed = () {};
    }

    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 32),
        ),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}