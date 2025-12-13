// import 'package:flutter/material.dart';
// import 'dart:math';



// class Dom4Page extends StatefulWidget {
//   const Dom4Page({super.key});

//   @override
//   State<Dom4Page> createState() => Page4();
// }


// class ButtonNum {

//     final int value;
//     bool active = true;

//     @override
//     ButtonNum(this.value);

//     void check (){

//         if(this.value == buttonAct - 1){
                
//             this.active = false;
//         }

//     }

//     @override
//     Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//         child: active
//             ? ElevatedButton(
//                 onPressed: () {
//                     setState(() {
//                     active = false; // desapareix el botó
//                     });
//                 },
//                 child: const Text('$value'),
//             )
//         ),
//     );
//     }
// }



// class Page4 extends State<Dom4Page>{
//     bool showStartButton = true;
//     List<List<int> > matrix = List.generate(
//     4,
//     (_) => List.filled(5, 0), 
//     );

//     int buttonAct = 0;

//     final Random random = Random();

//     @override

//     void clearMatrix (){
//         for(int i = 0; i<4; i++){
//             for(int j = 0; j<5; j++){
//                 matrix[i] [j] = 0;
//             }
//         }
//     }
    

//     void positionNumbers (){
//         for(int i = 1; i<11; i++){
//             int r = random.nextInt(20);
//             if(matrix[r/4] [r%5] == 0){
//                 matrix[r/4] [r%5] = i;
//             }
//             else{
//                 i--;
//             }
//         }
//     }

//     @override
//     Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title: const Text('Dom4')),
//         body: Center(
//         child: showStartButton
//             ? ElevatedButton(
//                 onPressed: () {
//                     setState(() {
//                     showStartButton = false; // desapareix el botó
//                     clearMatrix();
//                     positionNumbers(); // inicialitza la matriu
//                     });
//                 },
//                 child: const Text('Començar Prova'),
//                 )
//         ),
//     );
//     }


// }



import 'package:flutter/material.dart';
import 'dart:math';

class Domain4Page extends StatefulWidget {
  const Domain4Page({super.key});

  @override
  State<Domain4Page> createState() => Page4();
}

// Classe simple per guardar el número i si és actiu
class ButtonNum {
  final int value;
  bool active;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dom4')),
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
                  crossAxisCount: 5,
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
                      onPressed: btn.active
                          ? () {
                              setState(() {
                                btn.active = false;
                                buttonAct++;
                              });
                            }
                          : null,
                      child: Text('${btn.value}'),
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
