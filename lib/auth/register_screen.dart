// lib/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixtugasakhir/auth/auth_service.dart';
import 'package:fixtugasakhir/widgets/custom_text_field.dart';
import 'package:fixtugasakhir/widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback onLoginPressed;

  const RegisterScreen({Key? key, required this.onLoginPressed}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();

  // State untuk mengontrol visibilitas password
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final RegExp _emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  final RegExp _passwordRegex = RegExp(
      r'''^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,20}$'''
  );


  void _register() async {

    print('Password input: ${_passwordController.text}');
    print('Length: ${_passwordController.text.length}');
    print('Password matches regex: ${_passwordRegex.hasMatch(_passwordController.text)}');


    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password dan konfirmasi password tidak cocok!')),
        );
        return;
      }

      String? errorMessage = await _authService.registerUser(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
        );
        widget.onLoginPressed();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                  Icons.cloud_queue,
                  size: 120,
                  color: Colors.amber[800],
                ),
                SizedBox(height: 20),
                Text(
                  'Daftar ke CuacaKu',
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[900],
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Dapatkan akses prakiraan cuaca premium Anda!',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                CustomTextField(
                  controller: _nameController,
                  labelText: 'Nama Lengkap',
                  icon: Icons.badge,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
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
                    if (value.length < 8 || value.length > 20) {
                      return 'Password harus 8-20 karakter.';
                    }
                    if (!_passwordRegex.hasMatch(value)) {
                      return 'Password harus mengandung:\n'
                          '- Huruf kecil (a-z)\n'
                          '- Huruf besar (A-Z)\n'
                          '- Angka (0-9)\n'
                          '- Karakter spesial (seperti !@#\$%^&*()_+-=[]{};\':"\\|,.<>/?).';
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
                SizedBox(height: 20),
                CustomTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Konfirmasi Password',
                  icon: Icons.lock_reset,
                  obscureText: _obscureConfirmPassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi password tidak boleh kosong';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.amber[800],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                SizedBox(height: 30),
                CustomButton(
                  text: 'Daftar Sekarang',
                  onPressed: _register,
                  icon: Icons.app_registration,
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: widget.onLoginPressed,
                  child: Text(
                    'Sudah punya akun? Login di sini',
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