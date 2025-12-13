import 'package:flutter/material.dart';
import 'dart:math';

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
  bool showStartButton = true;
  List<List<int>> matrix = List.generate(4, (_) => List.filled(5, 0));
  List<ButtonNum> buttons = [];
  final Random random = Random();

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
      body: showStartButton
          ? Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showStartButton = false;
                    clearMatrix();
                    positionNumbers();
                  });
                },
                child: const Text('Començar Prova'),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: 20,
                itemBuilder: (context, index) {
                  int row = index ~/ 5;
                  int col = index % 5;
                  int value = matrix[row][col];
                  if (value != 0) {
                    ButtonNum btn =
                        buttons.firstWhere((b) => b.value == value);
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: btn.active ? Colors.white : Colors.grey[700],
                        foregroundColor: Colors.black,
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
                                  buttonAct++;
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

                      child: Text(
                        '${btn.value}',
                        style: const TextStyle(
                          fontSize: 71,
                        ),
                      ),
                    );
                  } else {
                    return Container(color: Colors.grey[200]);
                  }
                },
              ),
            ),
    );
  }
}
