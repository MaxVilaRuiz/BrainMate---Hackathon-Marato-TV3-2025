import 'package:flutter/material.dart';
import 'package:speech_to_text_ultra/speech_to_text_ultra.dart';

class STTUWidget extends StatefulWidget {
    final Function(bool)? onListeningChanged;
    final Function(List<String>)? onWordsUpdated;

    const STTUWidget({super.key, this.onListeningChanged, this.onWordsUpdated});

    @override
    State<STTUWidget> createState() => STTUState();
}

class STTUState extends State<STTUWidget> {
    bool mIsListening = false;
    String mResponse = '';
    String mLiveResponse = '';
    List<String> mWords = [];

    @override
    Widget build(BuildContext context) {
        return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text(
                mIsListening ? '$mResponse $mLiveResponse' : mResponse,
                textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SpeechToTextUltra(
                ultraCallback:
                    (String liveText, String finalText, bool isListening) {
                    setState(() {
                        mLiveResponse = liveText;
                        mResponse = finalText;
                        mIsListening = isListening;
                        widget.onListeningChanged?.call(mIsListening);
                        mWords = mLiveResponse.split(' ');
                        widget.onWordsUpdated?.call(mWords);
                    });
                },
            ),
            ],
        ),
        );
    }
}