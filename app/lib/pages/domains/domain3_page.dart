import 'dart:math';
import 'package:app/widgets/speechrobust.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/speechrobust.dart';

class Domain3Page extends StatefulWidget {
  const Domain3Page({super.key});

  @override
  State<Domain3Page> createState() => _Domain3PageState();
}

class _Domain3PageState extends State<Domain3Page> {
  // Test config
  static const int totalPhases = 5;
  static const int repetitionsPerPhase = 2;

  bool loading = true; // to check the SharedPreferences
  int? storedCompletedPhases;

  int currentPhase = 0;
  int currentRepetition = 0;

  bool showInstructions = true;
  bool showInput = false;
  bool testFinished = false;

  List<int> currentNumbers = [];
  List<int> phaseFailures = [];

  final TextEditingController controller = TextEditingController();
  final Random random = Random();

    @override
    void initState() {
        super.initState();
        phaseFailures = List.filled(totalPhases, 0);
        _checkStoredResult();
    }


  // Logic
    Future<void> _checkStoredResult() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('domain3');

    if (stored != null) {
        final data = jsonDecode(stored);
        storedCompletedPhases = data['completedPhases'] as int;

        setState(() {
        testFinished = true;
        showInstructions = false;
        loading = false;
        });
    } else {
        setState(() {
        loading = false;
        });
    }
    }

    Future<void> _saveResult() async {
    final prefs = await SharedPreferences.getInstance();
 
    final completedPhases = testFinished && currentPhase < totalPhases
        ? currentPhase
        : totalPhases;

    final data = jsonEncode({
        'completedPhases': completedPhases,
        'totalPhases': totalPhases,
    });

    await prefs.setString('domain3', data);
    }

  void _onSpeechWordsUpdated(List<String> words) {
    // Join the words and skip the gaps
    final text = words.join('').replaceAll(' ', '');

    setState(() {
      controller.text = text;
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    });
  }

  void _startTest() {
    _generateNumbers();
    setState(() {
      showInstructions = false;
    });
  }

  void _generateNumbers() {
    int digits = currentPhase + 4; // 4 to 9
    currentNumbers =
        List.generate(digits, (_) => random.nextInt(9) + 1);
  }

  void _startRepetition() {
    setState(() {
      showInput = true;
    });
  }

  void _nextStep() {
    // Sequence in reverse order
    final expected =
        currentNumbers.reversed.join('');

    final input =
        controller.text.replaceAll(' ', '');

    if (input != expected) {
      phaseFailures[currentPhase]++;
    }

    controller.clear();
    showInput = false;

    // If fails twice in the same fase, it terminates
    if (phaseFailures[currentPhase] == repetitionsPerPhase) {
      setState(() {
        testFinished = true;
      });
      _saveResult();
      return;
    }

    // Pass to the next fase
    if (currentRepetition < repetitionsPerPhase - 1) {
      currentRepetition++;
      _generateNumbers();
    } else {
      currentPhase++;
      currentRepetition = 0;

      if (currentPhase == totalPhases) {
        testFinished = true;
        _saveResult();
        setState(() {});
        return;
      }

      _generateNumbers();
    }

    setState(() {});
  }


  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test de memòria de treball'),
      ),
      body: loading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
          padding: const EdgeInsets.all(16.0),
          child: showInstructions
              ? _buildInstructions()
              : testFinished
                  ? _buildResults()
                  : showInput
                      ? _buildInputPhase()
                      : _buildShowNumbersPhase(),
        ),
    );
  }


  // Screens
  Widget _buildInstructions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Instruccions',
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        const Text(
          'You will see sequences of numbers.\n\n'
          'Your task is to repeat the numbers\n'
          'IN REVERSE ORDER.\n\n'
          'Each phase has two attempts.\n'
          'If you fail both attempts in the same phase,\n'
          'the test will end.\n\n'
          'Try to be as accurate as possible.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _startTest,
          child: const Text('Començar'),
        ),
      ],
    );
  }

  Widget _buildShowNumbersPhase() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Fase ${currentPhase + 1} '
          '(Ronda ${currentRepetition + 1}/$repetitionsPerPhase)',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: currentNumbers
              .map(
                (n) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    n.toString(),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _startRepetition,
          child: const Text('Introduir'),
        ),
      ],
    );
  }

  Widget _buildInputPhase() {
    return Column(
      children: [
        Text(
          'Fase ${currentPhase + 1} '
          '(Ronda ${currentRepetition + 1}/$repetitionsPerPhase)',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Introdueix la seqüència en ordre invers',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        STTWidget(
          onWordsUpdated: _onSpeechWordsUpdated,
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: _nextStep,
          child: const Text('Següent'),
        ),
      ],
    );
  }

  Widget _buildResults() {
    final completedPhases = storedCompletedPhases ??
        (testFinished && currentPhase < totalPhases
            ? currentPhase
            : totalPhases);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Resultats',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Text(
            'Fases completades correctament: $completedPhases / $totalPhases',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Acabar'),
          ),
        ],
      ),
    );
  }
}