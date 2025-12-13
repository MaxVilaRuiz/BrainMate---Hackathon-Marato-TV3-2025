import 'package:flutter/material.dart';

class Domain3Page extends StatelessWidget {
  const Domain3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Domain 3'),
      ),
      body: const Center(
        child: Text(
          'Contenido de Domain 3',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}