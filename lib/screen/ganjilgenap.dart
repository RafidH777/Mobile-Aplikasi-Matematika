import 'package:flutter/material.dart';

class GanjilGenapScreen extends StatefulWidget {
  const GanjilGenapScreen({Key? key}) : super(key: key);

  @override
  State<GanjilGenapScreen> createState() => _GanjilGenapScreenState();
}

class _GanjilGenapScreenState extends State<GanjilGenapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ganjil / Genap')),
      body: const Center(
        child: Text('TODO: form cek ganjil/genap'),
      ),
    );
  }
}