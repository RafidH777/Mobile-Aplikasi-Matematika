import 'package:flutter/material.dart';

class KalkulatorScreen extends StatefulWidget {
  const KalkulatorScreen({Key? key}) : super(key: key);

  @override
  State<KalkulatorScreen> createState() => _KalkulatorScreenState();
}

class _KalkulatorScreenState extends State<KalkulatorScreen> {
  final TextEditingController _angka1Controller = TextEditingController();
  final TextEditingController _angka2Controller = TextEditingController();

  String _operator = '+';
  String _hasil = '';

  @override
  void dispose() {
    _angka1Controller.dispose();
    _angka2Controller.dispose();
    super.dispose();
  }

  void _hitung() {
    final teks1 = _angka1Controller.text.trim();
    final teks2 = _angka2Controller.text.trim();

    
    if (teks1.isEmpty || teks2.isEmpty) {
      setState(() => _hasil = 'Input tidak boleh kosong');
      return;
    }

    
    final angka1 = double.tryParse(teks1.replaceAll(',', '.'));
    final angka2 = double.tryParse(teks2.replaceAll(',', '.'));

    if (angka1 == null || angka2 == null) {
      setState(() => _hasil = 'Bilangan tak valid');
      return;
    }

    
    if (angka1.isNaN || angka2.isNaN || angka1.isInfinite || angka2.isInfinite) {
      setState(() => _hasil = 'Bilangan tak valid');
      return;
    }

    try {
      double hasilOperasi;

      switch (_operator) {
        case '+':
          hasilOperasi = angka1 + angka2;
          break;
        case '-':
          hasilOperasi = angka1 - angka2;
          break;
        case '×':
          hasilOperasi = angka1 * angka2;
          break;
        case '÷':
          
          if (angka2 == 0) {
            setState(() => _hasil = 'Tidak bisa membagi dengan nol');
            return;
          }
          hasilOperasi = angka1 / angka2;
          break;
        default:
          setState(() => _hasil = 'Operator tidak dikenali');
          return;
      }

      
      if (hasilOperasi.isInfinite || hasilOperasi.isNaN) {
        setState(() => _hasil = 'Hasil terlalu besar / tidak valid');
        return;
      }

      setState(() => _hasil = _formatHasil(hasilOperasi));
    } catch (e) {
      
      setState(() => _hasil = 'Terjadi kesalahan saat menghitung');
    }
  }

  
  
  String _formatHasil(double value) {
    final bool isBulat = value == value.roundToDouble();

    if (isBulat) {
      final BigInt bulat = BigInt.from(value);
      return _beriPemisahRibuan(bulat.toString());
    } else {
      
      String teks = value.toStringAsFixed(6);
      teks = teks.replaceAll(RegExp(r'0+$'), '');
      teks = teks.replaceAll(RegExp(r'\.$'), '');
      final parts = teks.split('.');
      final bagianDepan = _beriPemisahRibuan(parts[0]);
      return parts.length > 1 ? '$bagianDepan,${parts[1]}' : bagianDepan;
    }
  }

  String _beriPemisahRibuan(String angka) {
    final bool negatif = angka.startsWith('-');
    if (negatif) angka = angka.substring(1);

    final buffer = StringBuffer();
    for (int i = 0; i < angka.length; i++) {
      if (i > 0 && (angka.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(angka[i]);
    }
    return negatif ? '-${buffer.toString()}' : buffer.toString();
  }

  Widget _tombolOperator(String simbol) {
    final bool aktif = _operator == simbol;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(simbol, style: const TextStyle(fontSize: 16)),
        selected: aktif,
        onSelected: (_) => setState(() => _operator = simbol),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kalkulator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _angka1Controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Angka pertama',
                hintText: 'contoh: 1',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _tombolOperator('+'),
                _tombolOperator('-'),
                _tombolOperator('×'),
                _tombolOperator('÷'),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _angka2Controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Angka kedua',
                hintText: 'contoh: 2',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _hitung,
              child: const Text('Hitung'),
            ),
            const SizedBox(height: 20),
            Text(
              _hasil,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
