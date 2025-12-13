import 'package:flutter/material.dart';

class Domain2Page extends StatelessWidget {
  const Domain2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Domain 2'),
      ),
      body: const Center(
        child: Text(
          'Contenido de Domain 2',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}