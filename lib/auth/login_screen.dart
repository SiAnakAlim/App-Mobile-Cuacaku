// lib/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixtugasakhir/auth/auth_service.dart';
import 'package:fixtugasakhir/widgets/custom_text_field.dart';
import 'package:fixtugasakhir/widgets/custom_button.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:fixtugasakhir/widgets/success_dialog.dart'; // Import dialog sukses

class LoginScreen extends StatefulWidget {
  final VoidCallback onRegisterPressed;
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    Key? key,
    required this.onRegisterPressed,
    required this.onLoginSuccess,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();


  bool _obscurePassword = true;

  // Regex untuk validasi format email
  final RegExp _emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String? errorMessage = await _authService.loginUser(
        _emailController.text,
        _passwordController.text,
      );

      if (errorMessage == null) {
        // Login berhasil, tampilkan notifikasi sukses kustom
        showDialog(
          context: context,
          barrierDismissible: false, // User harus menekan OK
          builder: (BuildContext context) {
            return SuccessDialog(
              title: 'Login Berhasil!',
              message: 'Selamat datang kembali di CuacaKu!',
              onDismissed: widget.onLoginSuccess, // Panggil callback setelah dialog ditutup
            );
          },
        );
      } else {
        // Login gagal, tampilkan SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  MdiIcons.weatherSunny,
                  size: 120,
                  color: Colors.amber[800],
                ),
                SizedBox(height: 20),
                Text(
                  'Selamat Datang di CuacaKu',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[900],
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Silakan login untuk mengakses fitur premium.',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!_emailRegex.hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  icon: Icons.lock,
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.amber[800],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                SizedBox(height: 30),
                CustomButton(
                  text: 'Login',
                  onPressed: _login,
                  icon: Icons.login,
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: widget.onRegisterPressed,
                  child: Text(
                    'Belum punya akun? Daftar di sini',
                    style: GoogleFonts.openSans(
                      color: Colors.amber[800],
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}