import 'package:flutter/material.dart';
import 'dart:math';
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

    List<String> compareWords = [];
    int correctWords = 0;

    bool showInstructions = true;
    bool showResults = false;

    final TextEditingController controller = TextEditingController();
    final HuggingFaceService _classification = HuggingFaceService();

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

    void _nextStep()
    {
        compareWords.clear();
        compareWords = controller.text.split(' ');
        _classification.getEmbeddingVector(controller.text);
        for(var i in compareWords)
        {
            if(correctCategory(i, category))
            {
                correctWords++;
            }
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
            compareWords = [];
        });
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
                'You will have to say words as many words that belong to that category as you can.\n\n',
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
            title: const Text("Fluencia verbal"),
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
                child: //STTUWidget(
                    //onWordsUpdated: _onSpeechWordsUpdated
                //),),
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
}