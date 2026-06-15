import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geo_tracker/models/trip.dart';
import 'package:geo_tracker/models/track_point.dart';
import 'package:geo_tracker/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализируем Hive
  await Hive.initFlutter();
  
  // Регистрируем адаптеры
  Hive.registerAdapter(TripAdapter());
  Hive.registerAdapter(TrackPointAdapter());
  
  // Открываем коробку для поездок
  await Hive.openBox<Trip>('trips');
  await Hive.openBox<TrackPoint>('trackPoints');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}