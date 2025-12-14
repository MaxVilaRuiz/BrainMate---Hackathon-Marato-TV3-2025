import 'package:flutter/material.dart';
import '../services/daily_questionnaire_storage.dart';
import 'daily_questionnaire_page.dart';
import '../widgets/speechrobust.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool hasCompletedToday = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    final completed =
        await DailyQuestionnaireStorage.hasCompletedToday();

    setState(() {
      hasCompletedToday = completed;
      isLoading = false;
    });
  }

  void _goToQuestionnaire() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DailyQuestionnairePage(),
      ),
    );
    _loadStatus(); // refresca al volver
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Bienvenido Max',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            if (!hasCompletedToday)
              ElevatedButton(
                onPressed: _goToQuestionnaire,
                child: const Text(
                  'Completa el cuestionario de hoy',
                ),
              ),

            const SizedBox(height: 24),

            const Expanded(
              child: STTWidget(),
            ),
          ],
        ),
      ),
    );
  }
}