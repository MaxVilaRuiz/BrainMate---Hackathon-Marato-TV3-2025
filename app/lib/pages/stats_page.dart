import 'package:flutter/material.dart';
import '../services/daily_questionnaire_storage.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  static const int requiredDays = 7;

  // Videos + Recommendations
  static const Map<String, List<String>> videosByDiagnosis = {
    'Atenció': [
      'https://www.youtube.com/watch?v=B_M8eFq2GCA',
      'https://www.youtube.com/watch?v=_5HCl5CDA94',
      'https://www.youtube.com/watch?v=fXDHm8PP6qo',
      'https://www.youtube.com/watch?v=OlyIT2zIimw',
      'https://www.youtube.com/watch?v=zXqljYzFb3w',
    ],
    'Memòria': [
      'https://www.youtube.com/watch?v=RExO6edCQYk',
      'https://www.youtube.com/watch?v=FJIy-R3Gze4',
      'https://www.youtube.com/watch?v=iGTnb1YeRNw',
    ],
    'Velocitat de processament': [
      'https://www.youtube.com/watch?v=RExO6edCQYk',
      'https://www.youtube.com/watch?v=FJIy-R3Gze4',
    ],
    'Fluència verbal': [
      'https://www.youtube.com/watch?v=B_M8eFq2GCA',
      'https://www.youtube.com/watch?v=_5HCl5CDA94',
      'https://www.youtube.com/watch?v=fXDHm8PP6qo',
      'https://www.youtube.com/watch?v=OlyIT2zIimw',
      'https://www.youtube.com/watch?v=zXqljYzFb3w',
    ],
    'Cap': [],
  };

  static const Map<String, String> recommendationByDiagnosis = {
    'Atenció': '''
  Avui és un bon dia per fer algo d'esport, potser anar a caminar una estona o alguna altra activitat que et vingui de gust.
  Aquesta setmana és ideal per fer alguna manualitat, posa molta atenció en allò que fas, potser un dibuix, un puzle, cosir alguna cosa, etc.
  Si tens una estona, llegeix un text curt (una notícia, un paràgraf d’un llibre) i intenta comprendre’l detenidament. Pots subratllar mentalment les idees importants per mantenir-te concentrat.
  ''',

    'Memòria': '''
  Avui és un bon dia per fer algo d'esport, potser anar a caminar una estona o alguna altra activitat que et vingui de gust.
  Aquesta setmana és ideal per tornar a fer aquella recepta que has deixat de fer i et sortia tan bé.
  Prova d'aprendre algunes paraules d'un nou idioma, potser un idioma que ja en sàpigues una mica o un completament nou!
  ''',

    'Velocitat de processament': '''
  Avui és un bon dia per fer algo d'esport, potser anar a caminar una estona o alguna altra activitat que et vingui de gust.
  Avui és el dia de les decisions ràpides: no pots tardar més de 15 segons en escollir la roba que et posaràs.
  Dia d'anar al supermercat! Prova a trobar el més ràpid possible on són les galetes Maria al teu supermercat de confiança.
  ''',

    'Fluència verbal': '''
  Avui és un bon dia per fer algo d'esport, potser anar a caminar una estona o alguna altra activitat que et vingui de gust.
  Avui durant 5 minuts has d'anar dient els objectes que veus al teu voltant.
  Pensa durant uns minuts quantes fruites i verdures hi ha de color vermell.
  ''',

    'Cap': '''
  Enhorabona! Les teves respostes indiquen que actualment no presentes problemes cognitius.
  És important, però, mantenir un estil de vida saludable per ajudar a prevenir-ho. T'animem a:
  - Fer esport
  - Cuidar l'alimentació
  - Aprendre coses noves
  - Sociabilitzar
  - Practicar mindfulness
  ''',
  };

  // The diagnoses to display
  static const List<String> trackedDiagnoses = [
    'Atenció',
    'Memòria',
    'Velocitat de processament',
    'Fluència verbal',
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DailyQuestionnaireStorage.getLast7DaysEntries(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final entries = snapshot.data ?? [];
        if (entries.length < requiredDays) {
          final missing = requiredDays - entries.length;
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Encara no hi ha prou dades.\nFalten $missing dies per omplir formularis.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }

        // Count diagnoses in the last 7 days
        final counts = <String, int>{};
        for (final e in entries) {
          final diag = (e['diagnosis'] as String?) ?? 'Cap';
          counts[diag] = (counts[diag] ?? 0) + 1;
        }

        // If all are "Cap" => block "No problems"
        final allNoProblem = entries.every((e) => (e['diagnosis'] as String?) == 'Cap');

        // Diagnoses detected, ordered by frequency
        final detected = trackedDiagnoses
            .where((d) => (counts[d] ?? 0) > 0)
            .toList()
          ..sort((a, b) {
            final cb = counts[b] ?? 0;
            final ca = counts[a] ?? 0;
            if (cb != ca) return cb.compareTo(ca);
            // Respect the order if is a draw
            return trackedDiagnoses.indexOf(a).compareTo(trackedDiagnoses.indexOf(b));
          });

        // Blocks to show
        final blocks = <Widget>[];

        // TODO
        // Cognitive problems block
        blocks.add(_InfoBlock(
          title: 'Problemes cognitius (no actiu)',
          subtitle: 'Aquest bloc no s’està utilitzant de moment.',
          recommendation:
              'Quan s’integri la part objectiva, aquí es mostraran resultats i recomanacions específiques.',
          urls: const [],
        ));

        // Block without problems 
        if (allNoProblem || detected.isEmpty) {
          blocks.add(_InfoBlock(
            title: 'No s’han detectat problemes',
            subtitle: 'Els últims 7 dies no indiquen dificultats subjectives destacades.',
            recommendation: recommendationByDiagnosis['Cap']!,
            urls: videosByDiagnosis['Cap']!,
          ));
        }

        // Diagnostic blocks detected in order
        for (final diag in detected) {
          blocks.add(_InfoBlock(
            title: diag,
            subtitle: 'Detectat ${counts[diag]} de $requiredDays dies.',
            recommendation: recommendationByDiagnosis[diag] ?? 'Mantén un pla d’entrenament breu i constant.',
            urls: videosByDiagnosis[diag] ?? const [],
          ));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Mesura subjectiva',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "Resultats de la setmana del XXX", 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...blocks.map((w) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: w,
                )),
          ],
        );
      },
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final String subtitle;
  final String recommendation;
  final List<String> urls;

  const _InfoBlock({
    required this.title,
    required this.subtitle,
    required this.recommendation,
    required this.urls,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(subtitle,
                style:
                    const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 12),

            // Recommendations
            const Text(
              'Recomanacions:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              recommendation,
              style: const TextStyle(fontSize: 14),
            ),

            // Videos
            if (urls.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Vídeos recomanats:',
                style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              ...urls.map(
                (u) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    u,
                    style: const TextStyle(
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}