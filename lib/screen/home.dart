import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Daftar menu ditulis sebagai data supaya gampang ditambah/diubah
  static const List<_MenuItem> _menuItems = [
    _MenuItem('Data Kelompok', Icons.group, '/kelompok'),
    _MenuItem('Kalkulator', Icons.calculate, '/kalkulator'),
    _MenuItem('Ganjil / Genap', Icons.filter_2, '/ganjil-genap'),
    _MenuItem('Jumlah Total (Deret)', Icons.functions, '/deret'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
        automaticallyImplyLeading: false, // tidak ada tombol back ke login
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _menuItems.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return Card(
            child: ListTile(
              leading: Icon(item.icon, color: Colors.blue),
              title: Text(item.title),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pushNamed(context, item.route);
              },
            ),
          );
        },
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final String route;

  const _MenuItem(this.title, this.icon, this.route);
}