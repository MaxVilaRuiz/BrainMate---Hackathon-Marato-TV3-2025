import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import '../../widgets/speechrobust.dart';
import '../../services/map.dart';
import '../../services/embeddings.dart';

class Domain1Page extends StatefulWidget
{
    const Domain1Page({super.key});

    @override
    State<Domain1Page> createState() => _Domain1PageState();
}

class _Domain1PageState extends State<Domain1Page> {

    Category category = Category.animals;
    String letter = '';
    Timer? timer;
    int milliseconds = 0;
    bool running = false;

    List<String> compareWords = [];
    int correctWords = 0;

    bool showInstructions = true;
    bool showResults = false;

    final TextEditingController controller = TextEditingController();
    final HuggingFaceService _classification = HuggingFaceService();

    String randomLetter()
    {
        final random = Random();
        const letters = 'abcdefghijklmnopqrstuwxyz';
        return letters[random.nextInt(letters.length)];
    }

    bool correctLetter(String word)
    {
        if(word.isEmpty) return false;
        return normalizeFirstLetter(word)[0].toLowerCase() == letter;
    }

    String normalizeFirstLetter(String word) {
        final first = word[0].toLowerCase();
        const map = {
            'á':'a','à':'a','ä':'a','â':'a',
            'é':'e','è':'e','ë':'e','ê':'e',
            'í':'i','ì':'i','ï':'i','î':'i',
            'ó':'o','ò':'o','ö':'o','ô':'o',
            'ú':'u','ù':'u','ü':'u','û':'u',
            'ç':'c',
        };
        return map[first] ?? first;
    }

    @override
    void initState() {
        super.initState();
    }

    void _onSpeechWordsUpdated(List<String> words) {
        // Join the words and skip the gaps
        //compareWords = words;
        final text = words.join(' ');

        setState(() {
            controller.text = text;
            controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
            );
        });
    }

    void _startTimer()
    {
        if(running) return;

        running = true;
        timer = Timer.periodic(const Duration(milliseconds: 200), (timer)
        {
            if(!mounted) return;
            setState(() {
                milliseconds += 200;
                if(milliseconds >= 60000) _stopTimer();
            });
        });
    }

    void _stopTimer()
    {
        _nextStep();
        timer?.cancel();
        running = false;
    }

    void _nextStep()
    {
        compareWords.clear();
        compareWords = controller.text.split(' ');
        
        int ind = 0;
        for(var i in compareWords)
        {
            int choose = ind%2;

            if(correctCategory(i, category) && choose == 0)
            {
                correctWords++;
            }
            else if(correctLetter(i) && choose == 1)
            {
                correctWords++;
            }

            ind++;
        }

        print(correctWords);
        showResults = true;
        setState(() {});
    }

    void _startTest() {
        setState(() {
            showInstructions = false;
            // Pick a random category each time the test starts
            category = Category.values[Random().nextInt(Category.values.length)];
            letter = randomLetter();
            compareWords = [];
        });
        _startTimer();
        correctWords = 0;
    }

    Widget _buildInstructions() {
        return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            const Text(
                "Instruccions",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                const Text(
                'You will see a category.\n'
                'You will have to say as many words that belong to that category as you can.\n'
                'Between each word of the category, you will have to say a word that starts with the specified letter.\n',
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

    @override
    Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
            title: const Text("Fluencia verbal alternant"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: showInstructions ? _buildInstructions() : showResults ? _buildResults() : _buildTest(),
        ),
        );
    }

    Widget _buildTest() {
        return SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Text(categoryNames[category] ?? ''),
                SizedBox(height: 12,),
                Text(letter),
                SizedBox(height: 24),
                TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Introdueix la seqüència',
                        border: OutlineInputBorder(),
                    ),
                ),
                SizedBox(height: 24,),
                // Widget de Speech to Text
                Expanded(
                child:
                    STTWidget(onWordsUpdated: _onSpeechWordsUpdated,)
                ),
                SizedBox(height: 24),
                ElevatedButton(
                    onPressed: _nextStep,
                    child: const Text('Next'),
                ),
            ],
            ),
        ),
        );
    }

    Widget _buildResults()
    {
        return SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Text("Paraules correctes: $correctWords"),
                Text(["Paraules dites: ", compareWords.length.toString()].join()),
            ],
            ),
        ),
        );
    }

    @override
    void dispose() {
        timer?.cancel();
        timer = null;
        super.dispose();
    }
}