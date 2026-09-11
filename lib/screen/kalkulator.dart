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

  
  static const int _presisiBagi = 20;

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

    final desimal1 = _parseDesimal(teks1.replaceAll(',', '.'));
    final desimal2 = _parseDesimal(teks2.replaceAll(',', '.'));

    if (desimal1 == null || desimal2 == null) {
      setState(() => _hasil = 'Bilangan tak valid');
      return;
    }

    try {
      switch (_operator) {
        case '+':
          _tampilkanHasil(_tambah(desimal1, desimal2));
          break;
        case '-':
          _tampilkanHasil(_kurang(desimal1, desimal2));
          break;
        case '×':
          _tampilkanHasil(_kali(desimal1, desimal2));
          break;
        case '÷':
          if (desimal2.nilai == BigInt.zero) {
            setState(() => _hasil = 'Tidak bisa membagi dengan nol');
            return;
          }
          _tampilkanHasil(_bagi(desimal1, desimal2));
          break;
        default:
          setState(() => _hasil = 'Operator tidak dikenali');
      }
    } catch (e) {
      setState(() => _hasil = 'Terjadi kesalahan saat menghitung');
    }
  }

  void _tampilkanHasil(_Desimal hasil) {
    setState(() => _hasil = _formatDesimal(hasil));
  }

  

  _Desimal? _parseDesimal(String teks) {
    final bool negatif = teks.startsWith('-');
    final String s = negatif ? teks.substring(1) : teks;

    if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(s)) return null;

    final parts = s.split('.');
    final bagianBulat = parts[0];
    final bagianDesimal = parts.length > 1 ? parts[1] : '';
    final gabungan = bagianBulat + bagianDesimal;

    BigInt nilai = BigInt.parse(gabungan);
    if (negatif) nilai = -nilai;

    return _Desimal(nilai: nilai, skala: bagianDesimal.length);
  }

  BigInt _pangkat10(int n) => BigInt.from(10).pow(n);

 
  ({BigInt v1, BigInt v2, int skala}) _samakanSkala(_Desimal a, _Desimal b) {
    final skalaMaks = a.skala > b.skala ? a.skala : b.skala;
    final v1 = a.nilai * _pangkat10(skalaMaks - a.skala);
    final v2 = b.nilai * _pangkat10(skalaMaks - b.skala);
    return (v1: v1, v2: v2, skala: skalaMaks);
  }

  _Desimal _tambah(_Desimal a, _Desimal b) {
    final s = _samakanSkala(a, b);
    return _Desimal(nilai: s.v1 + s.v2, skala: s.skala);
  }

  _Desimal _kurang(_Desimal a, _Desimal b) {
    final s = _samakanSkala(a, b);
    return _Desimal(nilai: s.v1 - s.v2, skala: s.skala);
  }

  _Desimal _kali(_Desimal a, _Desimal b) {
    return _Desimal(nilai: a.nilai * b.nilai, skala: a.skala + b.skala);
  }

  
  _Desimal _bagi(_Desimal a, _Desimal b) {
   
    final pembilang = a.nilai * _pangkat10(b.skala + _presisiBagi);
    final penyebut = b.nilai * _pangkat10(a.skala);
    final hasilBagi = pembilang ~/ penyebut; 
    return _Desimal(nilai: hasilBagi, skala: _presisiBagi);
  }

  String _formatDesimal(_Desimal d) {
    final bool negatif = d.nilai.isNegative;
    BigInt absNilai = negatif ? -d.nilai : d.nilai;
    String teks = absNilai.toString().padLeft(d.skala + 1, '0');

    String bagianBulat;
    String bagianDesimal;

    if (d.skala == 0) {
      bagianBulat = teks;
      bagianDesimal = '';
    } else {
      bagianBulat = teks.substring(0, teks.length - d.skala);
      bagianDesimal = teks.substring(teks.length - d.skala);
      bagianDesimal = bagianDesimal.replaceAll(RegExp(r'0+$'), ''); // buang nol ekor
    }

    final bagianBulatFormatted = _beriPemisahRibuan(bagianBulat);
    final hasilAkhir = bagianDesimal.isNotEmpty
        ? '$bagianBulatFormatted,$bagianDesimal'
        : bagianBulatFormatted;

    return negatif ? '-$hasilAkhir' : hasilAkhir;
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


class _Desimal {
  final BigInt nilai;
  final int skala;
  const _Desimal({required this.nilai, required this.skala});
}
