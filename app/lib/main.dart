import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/main_scaffold.dart';

const String firstRunKey = 'has_initialized_app';
const String dailyEntriesKey = 'daily_entries';
const String completedDaysKey = 'completed_days';
const String dateKey = 'date';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Delete after testing
  // Predefined data
  final predefinedCompletedDays = [
    "2025-12-13",
    "2025-12-12",
    "2025-12-11",
    "2025-12-10",
    "2025-12-09",
    "2025-12-08",
  ];

  final predefinedQuestionnaires = [
    '{"date":"2025-12-13","diagnosis":"Atenció"}',
    '{"date":"2025-12-12","diagnosis":"Fluència verbal"}',
    '{"date":"2025-12-11","diagnosis":"Velocitat de processament"}',
    '{"date":"2025-12-10","diagnosis":"Memòria"}',
    '{"date":"2025-12-09","diagnosis":"Velocitat de processament"}',
    '{"date":"2025-12-08","diagnosis":"Fluència verbal"}',
  ];

  final prefs = await SharedPreferences.getInstance();

  final isFirstRun = !prefs.containsKey(firstRunKey);

  if (isFirstRun) {
    // Clean the shared Preferences
    await prefs.remove(dailyEntriesKey);
    await prefs.remove(completedDaysKey);
    await prefs.remove(dateKey);

    // Initial storage
    await prefs.setStringList(dailyEntriesKey, predefinedQuestionnaires);
    await prefs.setStringList(completedDaysKey, predefinedCompletedDays);

    // Mark initialize date
    await prefs.setBool(firstRunKey, true);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anticancer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MainScaffold(),
    );
  }
}