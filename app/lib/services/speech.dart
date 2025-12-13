import 'package:flutter/material.dart';
import 'package:speech_to_text_ultra/speech_to_text_ultra.dart';

class STTUWidget extends StatefulWidget
{
    const STTUWidget({super.key});

    @override
    State<STTUWidget> createState() => STTUState();
}

class STTUState extends State<STTUWidget>
{
    bool mIsListening = false;
    String mResponse = '';
    String mLiveResponse = '';

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.red,
                centerTitle: true,
                title: const Text('Speech -> Text', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                ),
                body: Center(
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                mIsListening
                                    ? Text('$mResponse $mLiveResponse')
                                    : Text(mResponse),
                                const SizedBox(height: 20),
                                SpeechToTextUltra(
                                    ultraCallback: 
                                        (String liveText, String finalText, bool isListening) {
                                            setState(() {
                                                mResponse = liveText;
                                                mResponse = finalText;
                                                mIsListening = isListening;
                                            });
                                        },
                                    ),
                                    const SizedBox(
                                        height: 10,
                                    ),
                            ],
                        ),
                    ),
                ),
            );
    }
}