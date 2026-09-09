import 'package:flutter/material.dart';

class KelompokScreen extends StatelessWidget {
  const KelompokScreen({Key? key}) : super(key: key);

  static const Color _primaryColor = Color(0xFF1A1A1A);

  // TODO: ganti dengan nama & NIM anggota kelompok yang sebenarnya
  static const List<Map<String, String>> _anggota = [
    {'nama': 'Nama Anggota 1', 'nim': 'NIM 1'},
    {'nama': 'Nama Anggota 2', 'nim': 'NIM 2'},
    {'nama': 'Nama Anggota 3', 'nim': 'NIM 3'},
    {'nama': 'Nama Anggota 4', 'nim': 'NIM 4'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Data Kelompok',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  itemCount: _anggota.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final anggota = _anggota[index];
                    final nama = anggota['nama']!;
                    final nim = anggota['nim']!;
                    final inisial = nama.isNotEmpty ? nama[0].toUpperCase() : '?';

                    return _AnggotaCard(
                      inisial: inisial,
                      nama: nama,
                      nim: nim,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnggotaCard extends StatelessWidget {
  final String inisial;
  final String nama;
  final String nim;

  const _AnggotaCard({
    required this.inisial,
    required this.nama,
    required this.nim,
  });

  static const Color _primaryColor = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _primaryColor, width: 1.2),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: _primaryColor,
            child: Text(
              inisial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            nama,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            nim,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}