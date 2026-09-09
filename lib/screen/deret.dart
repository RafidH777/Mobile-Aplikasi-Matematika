import 'package:flutter/material.dart';

class DeretScreen extends StatefulWidget {
  const DeretScreen({Key? key}) : super(key: key);

  @override
  State<DeretScreen> createState() => _DeretScreenState();
}

class _DeretScreenState extends State<DeretScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jumlah Total')),
      body: const Center(
        child: Text('TODO: form jumlah total angka dalam field input'),
      ),
    );
  }
}