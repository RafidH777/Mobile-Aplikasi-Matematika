import 'package:flutter/material.dart';

class DeretScreen extends StatefulWidget {
  const DeretScreen({Key? key}) : super(key: key);

  @override
  State<DeretScreen> createState() => _DeretScreenState();
}

class _DeretScreenState extends State<DeretScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _inputController = TextEditingController();

  List<num> _angkaTerbaca = [];
  num _jumlahTotal = 0;
  bool _sudahDihitung = false;

  void _hitungJumlahTotal() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Pisahkan input berdasarkan koma ATAU spasi, lalu buang elemen kosong
    final List<String> potongan = _inputController.text
        .trim()
        .split(RegExp(r'[,\s]+'))
        .where((s) => s.isNotEmpty)
        .toList();

    final List<num> angkaValid = [];
    num total = 0;

    for (final s in potongan) {
      final nilai = num.tryParse(s);
      if (nilai != null) {
        angkaValid.add(nilai);
        total += nilai;
      }
    }

    setState(() {
      _angkaTerbaca = angkaValid;
      _jumlahTotal = total;
      _sudahDihitung = true;
    });
  }

  void _resetForm() {
    setState(() {
      _inputController.clear();
      _angkaTerbaca = [];
      _jumlahTotal = 0;
      _sudahDihitung = false;
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jumlah Total')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Jumlah Total Angka',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Masukkan beberapa angka, pisahkan dengan koma atau spasi.\n'
                  'Contoh: 3, 5, 10, 2  atau  3 5 10 2',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _inputController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Deret Angka',
                    hintText: 'contoh: 3, 5, 10, 2',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Masukkan minimal satu angka';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _hitungJumlahTotal,
                        child: const Text('Hitung'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _resetForm,
                        child: const Text('Reset'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                if (_sudahDihitung) ...[
                  const Divider(),
                  const Text(
                    'Angka yang terbaca:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _angkaTerbaca.isEmpty
                      ? const Text(
                          'Tidak ada angka valid yang ditemukan.',
                          style: TextStyle(color: Colors.red),
                        )
                      : Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _angkaTerbaca
                              .map((nilai) => Chip(label: Text('$nilai')))
                              .toList(),
                        ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Jumlah Total: $_jumlahTotal',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
