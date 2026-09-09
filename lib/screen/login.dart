import 'dart:async';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ---- KONFIGURASI (gampang diganti) ----
  static const String _validUsername = 'admin';
  static const String _validPassword = '12345';
  static const int _maxAttempts = 5;
  static const int _lockoutDuration = 30; // dalam detik
  static const Color _primaryColor = Color(0xFF1A1A1A);

  // ---- CONTROLLER ----
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ---- STATE ----
  bool _obscurePassword = true;
  bool _hasError = false;
  String? _errorMessage;

  int _failedAttempts = 0;
  bool _isLocked = false;
  int _secondsRemaining = 0;
  Timer? _timer;

  // ---- LOGIKA (tidak berubah dari sebelumnya) ----
  void _cekLogin() {
    if (_isLocked) return;

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Username dan password wajib diisi';
      });
      return;
    }

    if (username == _validUsername && password == _validPassword) {
      _failedAttempts = 0;
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _failedAttempts++;
      setState(() {
        _hasError = true;
        _errorMessage = 'Username atau password salah';
      });

      if (_failedAttempts >= _maxAttempts) {
        _startLockout();
      }
    }
  }

  void _startLockout() {
    setState(() {
      _isLocked = true;
      _secondsRemaining = _lockoutDuration;
      _errorMessage = 'Terlalu banyak percobaan gagal';
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsRemaining--;
      });

      if (_secondsRemaining <= 0) {
        timer.cancel();
        setState(() {
          _isLocked = false;
          _failedAttempts = 0;
          _hasError = false;
          _errorMessage = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  // ---- TAMPILAN ----
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Judul aplikasi
                  const Text(
                    'Aplikasi Matematika',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Card berisi form login
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Masuk ke Akun',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: _primaryColor,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Username
                          TextField(
                            controller: _usernameController,
                            onChanged: (_) {
                              if (_hasError) {
                                setState(() {
                                  _hasError = false;
                                  _errorMessage = null;
                                });
                              }
                            },
                            decoration: _buildInputDecoration(
                              label: 'Username',
                              icon: Icons.person_outline,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Password
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            onChanged: (_) {
                              if (_hasError) {
                                setState(() {
                                  _hasError = false;
                                  _errorMessage = null;
                                });
                              }
                            },
                            decoration: _buildInputDecoration(
                              label: 'Password',
                              icon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: _primaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),

                          // Pesan error
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),

                          // Tombol Masuk
                          ElevatedButton(
                            onPressed: _isLocked ? null : _cekLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryColor,
                              disabledBackgroundColor: Colors.grey,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              _isLocked
                                  ? 'Tunggu $_secondsRemaining detik'
                                  : 'Masuk',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: _primaryColor),
      suffixIcon: suffixIcon,
      border: const OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: _hasError ? Colors.red : Colors.grey,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: _hasError ? Colors.red : _primaryColor,
          width: 2,
        ),
      ),
    );
  }
}