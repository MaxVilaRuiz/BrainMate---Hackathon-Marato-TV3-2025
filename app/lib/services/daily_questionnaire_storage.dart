import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DailyQuestionnaireStorage {
  static const String _completedDaysKey = 'completed_days';
  static const String _effectiveDateKey = 'date';
  static const String _entriesKey = 'daily_entries';

  /// Fecha efectiva (simulada o real)
  static Future<String> effectiveToday() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDate = prefs.getString(_effectiveDateKey);

    if (storedDate != null) return storedDate;

    final now = DateTime.now();
    final today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    await prefs.setString(_effectiveDateKey, today);
    return today;
  }

  /// Guarda el cuestionario del día con diagnóstico
  static Future<void> saveDailyEntry({
    required String diagnosis,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final today = await effectiveToday();

    // 1. Guardar día como completado
    final completedDays = prefs.getStringList(_completedDaysKey) ?? [];
    if (!completedDays.contains(today)) {
      completedDays.add(today);
      await prefs.setStringList(_completedDaysKey, completedDays);
    }

    // 2. Guardar entrada estructurada
    final rawEntries = ["{\"date\":\"2025-12-13\",\"diagnosis\":\"Velocitat de processament\"}","{\"date\":\"2025-12-14\",\"diagnosis\":\"Fluència verbal\"}","{\"date\":\"2025-12-15\",\"diagnosis\":\"Velocitat de processament\"}","{\"date\":\"2025-12-16\",\"diagnosis\":\"Cap\"}","{\"date\":\"2025-12-17\",\"diagnosis\":\"Velocitat de processament\"}","{\"date\":\"2025-12-18\",\"diagnosis\":\"Fluència verbal\"}","{\"date\":\"2025-12-19\",\"diagnosis\":\"Velocitat de processament\"}"];
    //prefs.getStringList(_entriesKey) ?? [];

    final entry = {
      'date': today,
      'diagnosis': diagnosis,
    };

    //rawEntries.add(jsonEncode(entry));
    await prefs.setStringList(_entriesKey, rawEntries);
  }

  static Future<bool> hasCompletedToday() async {
    final prefs = await SharedPreferences.getInstance();
    final today = await effectiveToday();
    final completedDays =
        prefs.getStringList(_completedDaysKey) ?? [];

    return completedDays.contains(today);
  }

  /// (Preparado para el futuro)
  static Future<List<Map<String, dynamic>>> getLastEntries(
      int days) async {
    final prefs = await SharedPreferences.getInstance();
    final rawEntries = ["{\"date\":\"2025-12-13\",\"diagnosis\":\"Velocitat de processament\"}","{\"date\":\"2025-12-14\",\"diagnosis\":\"Fluència verbal\"}","{\"date\":\"2025-12-15\",\"diagnosis\":\"Velocitat de processament\"}","{\"date\":\"2025-12-16\",\"diagnosis\":\"Cap\"}","{\"date\":\"2025-12-17\",\"diagnosis\":\"Velocitat de processament\"}","{\"date\":\"2025-12-18\",\"diagnosis\":\"Fluència verbal\"}","{\"date\":\"2025-12-19\",\"diagnosis\":\"Velocitat de processament\"}"];
    // prefs.getStringList(_entriesKey) ?? [];

    return rawEntries
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }

  /// DEBUG
  static Future<void> setSimulatedDate(String yyyyMmDd) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_effectiveDateKey, yyyyMmDd);
  }

  static Future<void> clearSimulatedDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_effectiveDateKey);
  }

    /// Devuelve las últimas N entradas únicas por día (YYYY-MM-DD),
  /// ordenadas de más reciente a más antigua.
  static Future<List<Map<String, dynamic>>> getLastNUniqueDayEntries(int n) async {
    final prefs = await SharedPreferences.getInstance();
    final rawEntries = ["{\"date\":\"2025-12-13\",\"diagnosis\":\"Velocitat de processament\"}","{\"date\":\"2025-12-14\",\"diagnosis\":\"Fluència verbal\"}","{\"date\":\"2025-12-15\",\"diagnosis\":\"Velocitat de processament\"}","{\"date\":\"2025-12-16\",\"diagnosis\":\"Cap\"}","{\"date\":\"2025-12-17\",\"diagnosis\":\"Velocitat de processament\"}","{\"date\":\"2025-12-18\",\"diagnosis\":\"Fluència verbal\"}","{\"date\":\"2025-12-19\",\"diagnosis\":\"Velocitat de processament\"}"];
    //prefs.getStringList(_entriesKey) ?? [];

    final entries = rawEntries
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .where((e) => e['date'] != null)
        .toList();

    // Ordenar por fecha desc (formato YYYY-MM-DD => orden lexicográfico válido)
    entries.sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));

    // Quedarnos con 1 entrada por día (la más reciente de ese día)
    final seenDates = <String>{};
    final uniqueByDay = <Map<String, dynamic>>[];

    for (final e in entries) {
      final date = e['date'] as String;
      if (!seenDates.contains(date)) {
        seenDates.add(date);
        uniqueByDay.add(e);
      }
      if (uniqueByDay.length == n) break;
    }

    return uniqueByDay;
  }

  /// Conveniencia: últimos 7 días con formulario
  static Future<List<Map<String, dynamic>>> getLast7DaysEntries() async {
    return getLastNUniqueDayEntries(7);
  }
}