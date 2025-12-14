import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class STTWidget extends StatefulWidget
{
    final Function(List<String>)? onWordsUpdated;

    const STTWidget({
        super.key,
        this.onWordsUpdated,
    });

    @override
    State<STTWidget> createState() => STTState();
}

class STTState extends State<STTWidget>
{
    final SpeechToText _stt = SpeechToText();
    bool isEnabled = false;
    String lastWords = '';
    List<String> words = [];

    static const Map<String, String> _numberMap = {
        // Spanish
        'uno': '1',
        'dos': '2',
        'tres': '3',
        'cuatro': '4',
        'cinco': '5',
        'seis': '6',
        'siete': '7',
        'ocho': '8',
        'nueve': '9',

        // Catalan
        'un': '1',
        'quatre': '4',
        'cinc': '5',
        'sis': '6',
        'set': '7',
        'vuit': '8',
        'nou': '9',

        // English
        'one': '1',
        'two': '2',
        'three': '3',
        'four': '4',
        'five': '5',
        'six': '6',
        'seven': '7',
        'eight': '8',
        'nine': '9',
    };

    @override
    void initState()
    {
        super.initState();
        _initSpeech();
    }

    void _initSpeech() async {
        if(!mounted) return;
        isEnabled = await _stt.initialize();
        setState(() {});
    }

    void _startListening() async {
        if(!mounted) return;
        await _stt.listen(onResult: _onSpeechResult);
        setState(() {});
    }

    void _stopListening() async {
        if(!mounted) return;
        await _stt.stop();
        setState(() {});
    }

    void _onSpeechResult(SpeechRecognitionResult result)
    {
        if(!mounted) return;
        setState(() {
            lastWords = result.recognizedWords;
            words = result.recognizedWords.split(' ');
            words = words.map((w) {
                return _numberMap.containsKey(w) ? _numberMap[w].toString() : w;
            }).toList();
            widget.onWordsUpdated?.call(words);
        });
    }
    
    @override
    Widget build(BuildContext context) {
        return Center(
            child: _stt.isListening ?
            IconButton(onPressed: _stopListening, 
                icon: Icon(Icons.pause),
                color: Colors.black,
                iconSize: 24) :
            IconButton(onPressed: _startListening, 
                icon: Icon(Icons.mic),
                color: Colors.black,
                iconSize: 24
            ,)
        );
    }

    @override
    void dispose() {
        _stopListening();
        super.dispose();
    }
}