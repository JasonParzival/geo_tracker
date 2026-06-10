import 'package:flutter/material.dart';

class AttributesScreen extends StatelessWidget {
  const AttributesScreen({super.key});

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
            const Text('Здесь будет выбор вида транспорта и цели поездки'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Отправить'),
            ),
          ],
        ),
      ),
    );
  }
}