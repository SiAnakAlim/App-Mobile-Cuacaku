import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fixtugasakhir/widgets/custom_text_field.dart';
import 'package:fixtugasakhir/widgets/custom_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive
import 'package:fixtugasakhir/models/feedback_model.dart'; // Import model Feedback
import 'package:intl/intl.dart'; // Import intl untuk format tanggal

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _rating = 0;
  bool _isSubmitting = false;
  Box<FeedbackModel>? _feedbackBox; // Deklarasi Box Hive
  FeedbackModel? _lastFeedback; // Untuk menyimpan feedback terakhir yang ditampilkan

  @override
  void initState() {
    super.initState();
    _openFeedbackBox();
  }

  // Metode untuk membuka Hive Box dan memuat feedback terakhir
  Future<void> _openFeedbackBox() async {
    // Pastikan box sudah dibuka di main.dart
    _feedbackBox = Hive.box<FeedbackModel>('feedbacks');
    _loadLastFeedback(); // Muat feedback terakhir setelah box terbuka
  }

  // Metode untuk memuat feedback terakhir dari Hive
  void _loadLastFeedback() {
    if (_feedbackBox != null && _feedbackBox!.isNotEmpty) {
      // Ambil feedback terakhir yang ditambahkan (biasanya di akhir box)
      _lastFeedback = _feedbackBox!.values.last;
    } else {
      _lastFeedback = null;
    }
    setState(() {}); // Perbarui UI setelah memuat feedback
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate() && _rating > 0) {
      setState(() => _isSubmitting = true);

      // Buat objek FeedbackModel
      final newFeedback = FeedbackModel(
        rating: _rating,
        feedbackText: _feedbackController.text,
        submissionDate: DateTime.now(),
      );

      // Simpan ke Hive
      if (_feedbackBox != null) {
        await _feedbackBox!.add(newFeedback);
        _loadLastFeedback(); // Muat ulang feedback terakhir untuk ditampilkan setelah submit
      }

      // Simulate API call delay (optional, bisa dihapus jika tidak ada API)
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Terima kasih atas masukan Anda untuk mata kuliah ini!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.green,
        ),
      );

      _feedbackController.clear();
      setState(() {
        _rating = 0;
        _isSubmitting = false;
      });
      FocusScope.of(context).unfocus(); // Sembunyikan keyboard
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    // Tidak perlu menutup box di sini karena box dibuka di main.dart dan akan tetap terbuka
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amber = Colors.amber;
    final gradientColors = [
      amber[700]!,
      amber[900]!,
    ];

    return Scaffold(
      backgroundColor: amber[50],
      appBar: AppBar(
        title: Text(
          'Saran & Kesan TPM',
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: amber[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/images/feedback.png',
                  height: 150,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.feedback,
                    size: 100,
                    color: amber[800],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Bagikan Pengalaman Belajar Anda',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: amber[900],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Kami sangat menghargai setiap masukan untuk meningkatkan materi dan penyampaian matkul ini',
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 30),

              // Rating Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Beri Rating Matkul:',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: RatingBar.builder(
                      initialRating: _rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() => _rating = rating);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      _rating == 0
                          ? 'Pilih rating Anda'
                          : 'Anda memberi $_rating bintang',
                      style: GoogleFonts.openSans(
                        color: _rating == 0 ? Colors.grey : amber[800],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Feedback Form
              CustomTextField(
                controller: _feedbackController,
                labelText: 'Saran & Kesan Anda',
                hintText: 'Tulis pengalaman Anda selama matkul...',
                icon: Icons.edit_note,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi saran dan kesan Anda';
                  }
                  if (value.length < 10) {
                    return 'Masukan minimal 10 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Submit Button
              CustomButton(
                text: 'Kirim Masukan',
                onPressed: _rating == 0 ? null : _submitFeedback,
                icon: Icons.send,
                isLoading: _isSubmitting,
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              const SizedBox(height: 20),


              if (_lastFeedback != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(height: 40, thickness: 1, color: amber[200]),
                    Text(
                      'Masukan Terakhir Anda:',
                      style: GoogleFonts.openSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: amber[900],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: amber[100],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 24),
                                const SizedBox(width: 8),
                                Text(
                                  'Rating: ${_lastFeedback!.rating} / 5',
                                  style: GoogleFonts.openSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: amber[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Kesan & Saran:',
                              style: GoogleFonts.openSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _lastFeedback!.feedbackText,
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                'Disubmit pada: ${DateFormat('dd MMMM yyyy, HH:mm').format(_lastFeedback!.submissionDate)}',
                                style: GoogleFonts.openSans(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              // Additional Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: amber[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: amber[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: amber[800]),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Masukan Anda akan membantu kami meningkatkan kualitas pembelajaran',
                        style: GoogleFonts.openSans(
                          color: amber[900],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}