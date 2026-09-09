import 'package:flutter/material.dart';

class GanjilGenapScreen extends StatefulWidget {
  const GanjilGenapScreen({Key? key}) : super(key: key);

  @override
  State<GanjilGenapScreen> createState() => _GanjilGenapScreenState();
}

class _GanjilGenapScreenState extends State<GanjilGenapScreen> {
  final TextEditingController _angkaController = TextEditingController();
  String _hasil = '';
  String? _errorText;

  void _cekGanjilGenap() {
    final String input = _angkaController.text.trim();

    if (input.isEmpty) {
      setState(() {
        _errorText = 'Bilangan tidak boleh kosong';
        _hasil = '';
      });
      return;
    }

    final int? angka = int.tryParse(input);

    if (angka == null) {
      setState(() {
        _errorText = 'Masukkan bilangan bulat yang valid';
        _hasil = '';
      });
      return;
    }

    setState(() {
      _errorText = null;
      if (angka % 2 == 0) {
        _hasil = '$angka adalah bilangan GENAP';
      } else {
        _hasil = '$angka adalah bilangan GANJIL';
      }
    });
  }

  void _reset() {
    setState(() {
      _angkaController.clear();
      _hasil = '';
      _errorText = null;
    });
  }

  @override
  void dispose() {
    _angkaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ganjil / Genap')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Masukkan sebuah bilangan bulat untuk mengecek '
              'apakah bilangan tersebut ganjil atau genap.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _angkaController,
              keyboardType: const TextInputType.numberWithOptions(signed: true),
              decoration: InputDecoration(
                labelText: 'Masukkan bilangan',
                border: const OutlineInputBorder(),
                errorText: _errorText,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _cekGanjilGenap,
                    child: const Text('Cek'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _reset,
                    child: const Text('Reset'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_hasil.isNotEmpty)
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _hasil,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
