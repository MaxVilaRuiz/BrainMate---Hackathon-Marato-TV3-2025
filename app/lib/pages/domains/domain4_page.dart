import 'package:flutter/material.dart';

class Domain4Page extends StatelessWidget {
  const Domain4Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Domain 4'),
      ),
      body: const Center(
        child: Text(
          'Contenido de Domain 4',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}