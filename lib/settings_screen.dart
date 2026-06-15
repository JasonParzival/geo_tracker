import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isConsentGiven = true;

  @override
  void initState() {
    super.initState();
    _loadConsent();
  }

  Future<void> _loadConsent() async {
    final box = await Hive.openBox<bool>('settings');
    final consent = box.get('consent', defaultValue: true) ?? true;  
    setState(() {
      _isConsentGiven = consent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль и Настройки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Согласие на обработку персональных данных',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Вы можете в любой момент отозвать согласие на обработку ваших персональных данных. После отзыва сбор новых поездок прекратится, но уже переданные данные останутся обезличенными.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Согласие на обработку ПД'),
                Switch(
                  value: _isConsentGiven,
                  onChanged: (value) async {
                    final box = await Hive.openBox<bool>('settings');
                    await box.put('consent', value);
                    setState(() {
                      _isConsentGiven = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Вернуться на главный экран'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}