import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geo_tracker/models/trip.dart';
import 'package:geo_tracker/map_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История поездок'),
      ),
      body: ValueListenableBuilder<Box<Trip>>(
        valueListenable: Hive.box<Trip>('trips').listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('Нет сохранённых поездок'),
            );
          }

          return ListView.builder(
            itemCount: box.keys.length,
            itemBuilder: (context, index) {
              final key = box.keys.elementAt(index);
              final trip = box.get(key);
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapDetailScreen(trip: trip),
                      ),
                    );
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