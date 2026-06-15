import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geo_tracker/models/trip.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История поездок'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Trip>('trips').listenable(),
        builder: (context, Box<Trip> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('Нет сохранённых поездок'),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final trip = box.getAt(index);
              if (trip == null) return const SizedBox.shrink();
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.directions_car),
                  title: Text('${trip.startTime.toString().substring(0, 16)}'),
                  subtitle: Text('${trip.transportType} • ${trip.tripPurpose}'),
                  trailing: Text(
                    trip.isUploaded ? '✅' : '⏳',
                    style: const TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    // Здесь будет открытие деталей поездки
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}