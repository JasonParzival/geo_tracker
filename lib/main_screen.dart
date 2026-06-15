import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geo_tracker/attributes_screen.dart';
import 'package:geo_tracker/history_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geo_tracker/widgets/trip_map.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _isRecording = false;
  int _seconds = 0;
  Timer? _timer;

  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  int _pointCount = 0;

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
                      if (_isRecording) {
                        _isRecording = false;
                        _stopTimer();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AttributesScreen()),
                        );
                      } else {
                        _isRecording = true;
                        _startTimer();
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
          // Открыть атрибуты
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
          // Открыть настройки
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