import 'dart:math';
import 'package:flutter/material.dart';
import '../../widgets/speech.dart';

class Domain2Page extends StatefulWidget {
  const Domain2Page({super.key});

  @override
  State<Domain2Page> createState() => _Domain2PageState();
}

class _Domain2PageState extends State<Domain2Page> {
  static const int totalPhases = 6;

  int currentPhase = 0;
  bool showInput = false;

  List<List<int>> phaseNumbers = [];
  List<bool> phaseResults = [];

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateAllPhases();
  }

  void _generateAllPhases() {
    final random = Random();
    for (int i = 0; i < totalPhases; i++) {
      int count = i + 2;
      phaseNumbers.add(
        List.generate(count, (_) => random.nextInt(9) + 1),
      );
      phaseResults.add(false);
    }
  }

  void _startPhase() {
    setState(() {
      showInput = true;
    });
  }

  void _nextPhase() {
    final expected =
        phaseNumbers[currentPhase].join('');

    final input =
        controller.text.replaceAll(' ', '');

    if (input == expected) {
      phaseResults[currentPhase] = true;
    }

    controller.clear();

    if (currentPhase < totalPhases - 1) {
      setState(() {
        currentPhase++;
        showInput = false;
      });
    } else {
      setState(() {
        showInput = false;
      });
    }
  }

  bool get isFinished => currentPhase == totalPhases - 1 && showInput == false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Domain 2 Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isFinished
            ? _buildResults()
            : showInput
                ? _buildInputPhase()
                : _buildShowNumbersPhase(),
      ),
    );
  }

  // UI STATES
  Widget _buildShowNumbersPhase() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Phase ${currentPhase + 1}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: phaseNumbers[currentPhase]
              .map(
                (n) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    n.toString(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _startPhase,
          child: const Text('Start'),
        ),
      ],
    );
  }

  Widget _buildInputPhase() {
    return Column(
      children: [
        Text(
          'Phase ${currentPhase + 1}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),

        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Enter the numbers',
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 16),

        // Speech to text widget
        STTUWidget(),

        const Spacer(),

        ElevatedButton(
          onPressed: _nextPhase,
          child: Text(
            currentPhase == totalPhases - 1
                ? 'Finish'
                : 'Next',
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    final failed =
        phaseResults.where((e) => e == false).length;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Test Results',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Failed phases: $failed / $totalPhases',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}