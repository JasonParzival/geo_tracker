import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geo_tracker/models/trip.dart';

class AttributesScreen extends StatefulWidget {
  final String tripId;
  const AttributesScreen({super.key, required this.tripId});

  @override
  State<AttributesScreen> createState() => _AttributesScreenState();
}

class _AttributesScreenState extends State<AttributesScreen> {
  String? _selectedTransport;
  String? _selectedPurpose;
  String? _errorMessage;
  bool _isEditMode = false;

  final List<String> _transportTypes = [
    'Легковой автомобиль',
    'Общественный транспорт',
    'Пешком',
    'Велосипед',
    'Самокат'
  ];

  final List<String> _tripPurposes = [
    'Работа',
    'Учёба',
    'Личные дела',
    'Досуг'
  ];

  @override
  void initState() {
    super.initState();
    _loadTripIfExists();
  }

  Future<void> _loadTripIfExists() async {
    final box = await Hive.openBox<Trip>('trips');
    final existingTrip = box.get(widget.tripId);
    if (existingTrip != null) {
      setState(() {
        _selectedTransport = existingTrip.transportType;
        _selectedPurpose = existingTrip.tripPurpose;
        _isEditMode = true;
      });
    }
  }

  void _submit() async {
    if (_selectedTransport == null || _selectedPurpose == null) {
      setState(() {
        _errorMessage = 'Необходимо заполнить все поля';
      });
      return;
    }

    final box = await Hive.openBox<Trip>('trips');
    final trip = Trip(
      id: widget.tripId,
      startTime: _isEditMode
          ? (box.get(widget.tripId)?.startTime ?? DateTime.now())
          : DateTime.now().subtract(const Duration(seconds: 10)),
      endTime: _isEditMode
          ? (box.get(widget.tripId)?.endTime ?? DateTime.now())
          : DateTime.now(),
      duration: _isEditMode
          ? (box.get(widget.tripId)?.duration ?? 10)
          : 10,
      distance: _isEditMode
          ? (box.get(widget.tripId)?.distance ?? 0.0)
          : 0.0,
      transportType: _selectedTransport!,
      tripPurpose: _selectedPurpose!,
      isUploaded: _isEditMode
          ? (box.get(widget.tripId)?.isUploaded ?? false)
          : false,
    );

    await box.put(widget.tripId, trip);
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Атрибуты поездки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedTransport,
              items: _transportTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTransport = value;
                  _errorMessage = null;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Вид транспорта',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedPurpose,
              items: _tripPurposes.map((purpose) {
                return DropdownMenuItem(
                  value: purpose,
                  child: Text(purpose),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPurpose = value;
                  _errorMessage = null;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Цель поездки',
                border: OutlineInputBorder(),
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: Text(_isEditMode ? 'Сохранить изменения' : 'Отправить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}