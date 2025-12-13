import 'package:flutter/material.dart';

class Domain1Page extends StatelessWidget {
  const Domain1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Domain 1'),
      ),
      body: const Center(
        child: Text(
          'Contenido de Domain 1',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}