import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const Color _primaryColor = Color(0xFF1A1A1A);

  static const List<_MenuItem> _menuItems = [
    _MenuItem('Data Kelompok', Icons.groups_outlined, '/kelompok'),
    _MenuItem('Kalkulator', Icons.calculate_outlined, '/kalkulator'),
    _MenuItem('Ganjil / Genap', Icons.filter_2_outlined, '/ganjil-genap'),
    _MenuItem('Jumlah Total', Icons.functions, '/deret'),
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
                'Pilih Menu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  itemCount: _menuItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final item = _menuItems[index];
                    return _MenuCard(
                      title: item.title,
                      icon: item.icon,
                      onTap: () => Navigator.pushNamed(context, item.route),
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

class _MenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  static const Color _primaryColor = Color(0xFF1A1A1A);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: _primaryColor, width: 1.2),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: _primaryColor),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _primaryColor,
                ),
              ),
            ],
          ),
        ),
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