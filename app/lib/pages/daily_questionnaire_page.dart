import 'package:flutter/material.dart';
import '../services/daily_questionnaire_storage.dart';

class DailyQuestionnairePage extends StatefulWidget {
  const DailyQuestionnairePage({super.key});

  @override
  State<DailyQuestionnairePage> createState() =>
      _DailyQuestionnairePageState();
}

class _DailyQuestionnairePageState
    extends State<DailyQuestionnairePage> {
  String? selectedOption;

  final List<String> options = [
    'He anat a un lloc de l’habitació i, quan hi he arribat, no he recordat què hi anava a fer.',
    'He trigat més del normal a fer una activitat que abans feia més ràpid.',
    'Volia dir una paraula i no m’ha sortit, o n’he dit una altra sense voler.',
    'Quan estava parlant amb algú, he perdut el fil de la conversa.',
    'M’han preguntat per una cosa que m’havien dit fa poc i no me n’he recordat.',
    'He tingut problemes per recordar informació que ja sabia prèviament.',
    'He tingut problemes per prendre una decisió que abans no m’hauria costat.',
    'He tingut dificultats per planificar el meu dia.',
    'He sentit sensació de nebulosa mental.',
    'He sentit que penso més lenta avui.',
    'Ninguna de les anteriors.',
  ];

  final Map<String, String> responseDiagnosisMap = {
    'He anat a un lloc de l’habitació i, quan hi he arribat, no he recordat què hi anava a fer.':
        'Atenció',
    'He trigat més del normal a fer una activitat que abans feia més ràpid.':
        'Velocitat de processament',
    'Volia dir una paraula i no m’ha sortit, o n’he dit una altra sense voler.':
        'Fluència verbal',
    'Quan estava parlant amb algú, he perdut el fil de la conversa.':
        'Atenció',
    'M’han preguntat per una cosa que m’havien dit fa poc i no me n’he recordat.':
        'Memòria',
    'He tingut problemes per recordar informació que ja sabia prèviament.':
        'Memòria',
    'He tingut problemes per prendre una decisió que abans no m’hauria costat.':
        'Fluència verbal',
    'He tingut dificultats per planificar el meu dia.':
        'Fluència verbal',
    'He sentit sensació de nebulosa mental.':
        'Fluència verbal',
    'He sentit que penso més lenta avui.':
        'Velocitat de processament',
    'Ninguna de les anteriors.': 'Cap',
  };

    Future<void> _submit() async {
    if (selectedOption == null) return;

    final diagnosis =
        responseDiagnosisMap[selectedOption!] ?? 'Cap';

    await DailyQuestionnaireStorage.saveDailyEntry(
        diagnosis: diagnosis,
    );

    if (mounted) {
        Navigator.pop(context);
    }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qüestionari Diari - Mesura subjectiva'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Què és el que t'acaba de passar?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(

              value: selectedOption,

              isExpanded: true,
              initialValue: selectedOption,

              items: options
                  .map(
                    (o) => DropdownMenuItem<String>(
                      value: o,
                      child: Text(o),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Selecciona una opció',
              ),
            ),
            const Spacer(),
            Align( 
              child: FractionallySizedBox(
                widthFactor: 0.6,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Enviar'),
                ),
              ),

              
            ),
            
          ],
        ),
      ),
    );
  }
}