import 'package:flutter/material.dart';

class KelompokScreen extends StatelessWidget {
  const KelompokScreen({Key? key}) : super(key: key);

  // TODO: ganti dengan nama anggota kelompok yang sebenarnya
  static const List<Map<String, String>> _anggota = [
    {'nama': 'Nama Anggota 1', 'nim': 'NIM 1'},
    {'nama': 'Nama Anggota 2', 'nim': 'NIM 2'},
    {'nama': 'Nama Anggota 3', 'nim': 'NIM 3'},
    {'nama': 'Nama Anggota 4', 'nim': 'NIM 4'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Kelompok')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _anggota.length,
        itemBuilder: (context, index) {
          final anggota = _anggota[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(anggota['nama']!),
              subtitle: Text(anggota['nim']!),
            ),
          );
        },
      ),
    );
  }
}