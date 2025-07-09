// lib/widgets/success_dialog.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessDialog extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback onDismissed; // Callback saat dialog ditutup

  const SuccessDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onDismissed,
  }) : super(key: key);

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation; // Animasi skala untuk efek muncul
  late Animation<double> _opacityAnimation; // Animasi opacity untuk efek fade

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700), // Durasi animasi
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut), // Efek elastis
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn), // Efek fade in
    );

    _controller.forward(); // Mulai animasi saat widget diinisialisasi
  }

  @override
  void dispose() {
    _controller.dispose(); // Pastikan controller di-dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.amber[50],
          title: Column(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green[600], size: 60),
              SizedBox(height: 10),
              Text(
                widget.title,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[900],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: Text(
            widget.message,
            style: GoogleFonts.openSans(
              fontSize: 16,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDismissed();
              },
              child: Text(
                'OK',
                style: GoogleFonts.openSans(
                  color: Colors.amber[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}