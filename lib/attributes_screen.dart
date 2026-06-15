import 'package:flutter/material.dart';

class AttributesScreen extends StatefulWidget {
  const AttributesScreen({super.key});

  @override
  State<AttributesScreen> createState() => _AttributesScreenState();
}

class _AttributesScreenState extends State<AttributesScreen> {
  String? _selectedTransport;
  String? _selectedPurpose;
  String? _errorMessage;

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

  void _submit() {
    if (_selectedTransport == null || _selectedPurpose == null) {
      setState(() {
        _errorMessage = 'Необходимо заполнить все поля';
      });
      return;
    }

    // Здесь будет логика отправки данных
    print('Отправка: $_selectedTransport, $_selectedPurpose');
    Navigator.pop(context);
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
                child: const Text('Отправить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}