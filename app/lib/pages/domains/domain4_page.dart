import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class Domain4Page extends StatefulWidget {
  const Domain4Page({super.key});

  @override
  State<Domain4Page> createState() => Page4();
}

class ButtonNum {
  final int value;
  bool active;
  bool redBorder = false;
  bool greenBorder = false;

  ButtonNum(this.value, {this.active = true});
}

class Page4 extends State<Domain4Page> {
  Timer? timer;
  int milliseconds = 0;
  bool running = false;
  bool showStartButton = true;
  List<List<int>> matrix = List.generate(4, (_) => List.filled(5, 0));
  List<ButtonNum> buttons = [];
  final Random random = Random();
  bool showEndButton = false;
  int buttonAct = 0;

  void clearMatrix() {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 5; j++) {
        matrix[i][j] = 0;
      }
    }
    buttons.clear();
  }

  void positionNumbers() {
    Set<int> usedIndices = {};
    for (int i = 1; i <= 10; i++) {
      int r;
      do {
        r = random.nextInt(20);
      } while (usedIndices.contains(r));
      usedIndices.add(r);
      matrix[r ~/ 5][r % 5] = i;
      buttons.add(ButtonNum(i));
    }
  }

  void startTimer() {
    if (running) return;

    running = true;
    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        milliseconds += 200;
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
    running = false;
  }

  int resultButton (ButtonNum btn) {

     if(btn.value == buttonAct + 1){
        if(btn.value == 10){
          return 2;
        }
        return 1;
     }
     return -1;


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test de velocitat')),
      body: showStartButton? buildStartScreen(): showEndButton? buildEndScreen(): buildGrid(),
    );
  }

  Widget buildStartScreen(){
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            showStartButton = false;
            showEndButton = false;
            buttonAct = 0;
            milliseconds = 0;
            clearMatrix();
            positionNumbers();
            startTimer();
          });
        },
        child: const Text('Començar Prova'),
      ),
    );
  }

  Widget buildEndScreen() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Has acabat!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Temps: ${milliseconds / 1000}s',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                showStartButton = true;
                showEndButton = false;
              });
            },
            child: const Text('Tornar a començar'),
          ),
        ],
      ),
    );
  }

  Widget buildGrid() {
    Size size = MediaQuery.of(context).size;
    final double screenWidth = size.width;
    final double screenHeight = size.height * 0.7;
    final double aspectRatio = screenWidth / screenHeight;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: aspectRatio,
        ),
        itemCount: 20,
        itemBuilder: (context, index) {
          int row = index ~/ 5;
            int col = index % 5;
            int value = matrix[row][col];
            if (value != 0) {
              ButtonNum btn =
                  buttons.firstWhere((b) => b.value == value);
              return SizedBox.expand(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btn.active ? Colors.white : Colors.grey[700],
                    side: BorderSide(
                      color: btn.redBorder
                          ? Colors.red
                          : btn.greenBorder
                              ? Colors.green
                              : Colors.blue,
                      width: 4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: btn.active
                    ? () {
                        setState(() {
                          if(resultButton(btn) == 1){
                            btn.active = false;
                            btn.greenBorder = true;
                            buttonAct++;
                          }
                          else if(resultButton(btn) == 2){
                            btn.active = false;
                            btn.greenBorder = true;
                            stopTimer();
                            showEndButton = true;
                          }
                          else{
                            btn.redBorder = true;
                          }
                          
                        });
                        if(btn.redBorder){
                          Future.delayed(const Duration(milliseconds: 500), () {
                            setState(() {
                              btn.redBorder = false;
                            });
                          });
                        }
                        
                      }
                    : null,
                  child: FittedBox(
                    fit: BoxFit.scaleDown, // evita que el text sobresurti
                    child: Text(
                      '${btn.value}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50, // augmenta el tamany base
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Container(color: Colors.grey[200]);
            }
        },
      ),
    );
  }



}