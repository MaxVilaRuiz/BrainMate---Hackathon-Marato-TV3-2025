// ignore_for_file: use_function_type_syntax_for_parameters
import 'dart:math';
import 'package:flutter/material.dart';
import '../services/daily_questionnaire_storage.dart';
import 'daily_questionnaire_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class SpeechBubble extends StatefulWidget {
  final List<String> texts; // Llista de textos que volem mostrar

  const SpeechBubble({super.key, required this.texts});

  @override
  State<SpeechBubble> createState() => _SpeechBubbleState();
}

class _SpeechBubbleState extends State<SpeechBubble> {
  int currentIndex = 0;

  void _nextText() {
    setState(() {
      if (currentIndex < widget.texts.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0; // opcional: torna a començar
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.texts[currentIndex],
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ),
          IconButton(
            onPressed: _nextText,
            icon: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}

class TextOption {
  final String text;
  bool used;

  @override
  
  TextOption(this.text, {this.used = false});
}

class _HomePageState extends State<HomePage> {
  bool hasCompletedToday = false;
  bool isLoading = true;
  bool challenge1 = false;
  bool challenge2 = false;
  bool challenge3 = false;
  final List<TextOption> challenges = [TextOption("Menjar una poma"), 
  TextOption("Fer 5 flexions i 10 abdominals"),
  TextOption("Baixar i pujar per les escales i no amb l'ascensor"),
  TextOption("Sortir a caminar"),
  TextOption("Fer una sessió d'estiraments"),
  TextOption("Dutxar-se amb aigua freda"),
  TextOption("Fer algun tipus d'excercici durant 30 min o més"),
  ];
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  String randomTxt (){

    int r;
    while(true){
      r = random.nextInt(challenges.length);
      if(!challenges[r].used){
        return challenges[r].text;
      }
    }
    

  }

  Future<void> resetTxts() async {
    final completed =
        await DailyQuestionnaireStorage.hasCompletedToday();

    setState(() {
      hasCompletedToday = completed;
      isLoading = false;
    });
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
              'Benvingut/da',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 24),

            Tooltip(
              message: hasCompletedToday
                  ? "Ja has completat el qüestionari d'avui"
                  : '',
              child: ElevatedButton(
                onPressed: hasCompletedToday ? null : _goToQuestionnaire,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      hasCompletedToday ? Colors.grey[700] : null,
                  foregroundColor:
                      hasCompletedToday ? Colors.white70 : null,
                ),
                child: const Text(
                  "Completa el qüestionari d'avui!",
                ),
                
              ),

            ),
            
            const SizedBox(height: 24),
            
            const Expanded(
              child: Spacer(), 
            ),

            // Column(
            //   children: [
            //     Expanded(
            //       child: ElevatedButton(
            //         onPressed: challenge1
            //             ? null
            //             : () {
            //                 setState(() {
            //                   challenge1 = true;
            //                 });
            //               },
            //         style: ElevatedButton.styleFrom(
            //           side: BorderSide(
            //           color: challenge1
            //               ? const Color.fromARGB(255, 116, 147, 248)
            //                 : const Color.fromARGB(255, 33, 243, 121),
            //           width: 4,
            //         ),
            //           backgroundColor: challenge1 ? const Color.fromARGB(255, 56, 56, 56) : const Color.fromARGB(255, 194, 221, 243),
            //         ),
            //         child: const Text('Botó 1'),
            //       ),
            //     ),
            //     Expanded(
            //       child: ElevatedButton(
            //         onPressed: challenge2
            //             ? null
            //             : () {
            //                 setState(() {
            //                   challenge2 = true;
            //                 });
            //               },
            //         style: ElevatedButton.styleFrom(
            //           side: BorderSide(
            //           color: challenge2
            //               ? const Color.fromARGB(255, 116, 147, 248)
            //                 : const Color.fromARGB(255, 33, 243, 121),
            //           width: 4,
            //         ),
            //           backgroundColor: challenge2 ? const Color.fromARGB(255, 56, 56, 56) : const Color.fromARGB(255, 194, 221, 243),
            //         ),
            //         child: const Text('Botó 1'),
            //       ),
            //     ),
            //     Expanded(
            //       child: ElevatedButton(
            //         onPressed: challenge3
            //             ? null
            //             : () {
            //                 setState(() {
            //                   challenge3 = true;
            //                 });
            //               },
            //         style: ElevatedButton.styleFrom(
            //           side: BorderSide(
            //           color: challenge3
            //               ? const Color.fromARGB(255, 116, 147, 248)
            //                 : const Color.fromARGB(255, 33, 243, 121),
            //           width: 4,
            //         ),
            //           backgroundColor: challenge3 ? const Color.fromARGB(255, 56, 56, 56) : const Color.fromARGB(255, 194, 221, 243),
            //         ),
            //         child: const Text('Botó 1'),
            //       ),
            //     ),
            //   ],
            // ),

            const Text(
                  "Consells de vida:",
                ),
            SpeechBubble(texts: ["Fer esport és bó tant per el cos com per la ment, no ho oblidis!", 
              "Recorda menjar 5 peces de fruita al dia com a mínim",
              "Sortir amb els amics a vegades pot ser el millor per desestresar-se",
              "Intenta mantenir una dieta variada, per estar sà s'ha de menjar sà!",
              "No tota la força vé dels músculs, a vegades el cervell és el més fort de tots!",
              "És important descansar, intenta dormir més de 7h diàries",
              "Per asegurar el millor dels descansos, abans de dormir evita les llums blaves",
              "No deixis que 5 minuts dolents espatllin un bon dia"
              "Hidratar-se és important, recorda beure com a mínim 2 litres d'aigua al dia"
            ]), 

          ],
        ),
      ),
    );
  }
}