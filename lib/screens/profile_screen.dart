import 'dart:io';
import 'package:flutter/material.dart'; // DIKOREKSI: material.111 menjadi material.dart
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fixtugasakhir/auth/auth_model.dart';
import 'package:fixtugasakhir/auth/auth_service.dart';
import 'package:fixtugasakhir/models/premium_transaction.dart';
import 'package:fixtugasakhir/screens/premium_purchase_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserEmail;

  const ProfileScreen({Key? key, required this.currentUserEmail}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

  }

  Future<void> _pickProfileImage(User user) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);
      final sizeInBytes = await file.length();
      if (sizeInBytes > 2 * 1024 * 1024) { // 2MB limit
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ukuran gambar maksimal 2MB')),
        );
        return;
      }

      final appDir = await getApplicationDocumentsDirectory();
      final newPath = '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
      final newFile = await file.copy(newPath);

      user.profileImagePath = newFile.path;
      await user.save();
    }
  }

  Duration? _getRemainingPremiumDuration(User user) {
    if (user.isPremium && user.premiumExpiryDate != null) {
      final now = DateTime.now();
      if (user.premiumExpiryDate!.isAfter(now)) {
        return user.premiumExpiryDate!.difference(now);
      }
    }
    return null;
  }

  String _formatDuration(Duration d) {
    final days = d.inDays;
    final hours = d.inHours % 24;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    return "${days} hari, ${hours} jam, ${minutes} menit, ${seconds} detik";
  }

  Future<void> _cancelPremium(User user) async {
    user.isPremium = false;
    user.premiumExpiryDate = null;
    await user.save();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Premium telah dibatalkan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<User>>(
      valueListenable: Hive.box<User>('users').listenable(),
      builder: (context, box, _) {
        final currentUser = box.values.firstWhere(
              (user) => user.email == widget.currentUserEmail,
          orElse: () => User(
            name: 'Guest',
            email: 'guest@example.com',
            encryptedPassword: '',
          ),
        );

        final remaining = _getRemainingPremiumDuration(currentUser);
        final hasProfileImage = currentUser.profileImagePath != null &&
            File(currentUser.profileImagePath!).existsSync();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _pickProfileImage(currentUser),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: hasProfileImage
                      ? FileImage(File(currentUser.profileImagePath!))
                      : null,
                  backgroundColor: Colors.amber[200],
                  child: hasProfileImage
                      ? null
                      : Icon(Icons.person, size: 80, color: Colors.amber[800]),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => _pickProfileImage(currentUser),
                child: Text('Ganti Foto Profil (max 2MB)',
                    style: GoogleFonts.openSans(color: Colors.amber[800])),
              ),
              const SizedBox(height: 10),
              Text(
                currentUser.name,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[900],
                ),
              ),
              Text(
                currentUser.email,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 30),
              _buildStatusCard(currentUser, remaining),
              const SizedBox(height: 30),
              _buildTransactionHistory(currentUser.premiumHistory),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusCard(User currentUser, Duration? remaining) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status Akun:', style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber[800])),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  currentUser.isPremium ? Icons.check_circle : Icons.info,
                  color: currentUser.isPremium ? Colors.green : Colors.blueGrey,
                ),
                const SizedBox(width: 10),
                Text(
                  currentUser.isPremium ? 'Premium User' : 'Basic User',
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: currentUser.isPremium ? Colors.green[700] : Colors.blueGrey[700],
                  ),
                ),
              ],
            ),

            if (currentUser.isPremium && remaining != null && remaining > Duration.zero) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.timer_outlined, color: Colors.amber[800]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sisa Waktu Premium:', style: GoogleFonts.openSans(fontWeight: FontWeight.bold)),
                        Text(_formatDuration(remaining), style: GoogleFonts.openSans()),
                      ],
                    ),
                  ),
                ],
              ),
            ] else if (currentUser.isPremium && (remaining == null || !(remaining > Duration.zero))) ...[
              // Jika premium tapi sudah expired
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 10),
                  Text(
                    'Premium Anda telah berakhir.',
                    style: GoogleFonts.openSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.red[700],
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PremiumPurchaseScreen(currentUserEmail: currentUser.email), // Teruskan email
                        ),
                      );

                    },
                    icon: const Icon(Icons.workspace_premium),
                    label: Text('Kelola Premium', style: GoogleFonts.openSans(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                if (currentUser.isPremium) // Hanya tampilkan tombol batal jika memang premium
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _cancelPremium(currentUser),
                      icon: const Icon(Icons.cancel),
                      label: Text('Batalkan', style: GoogleFonts.openSans(fontSize: 16)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red[800],
                        side: BorderSide(color: Colors.red.shade800),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHistory(List<PremiumTransaction> transactions) {
    if (transactions.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Riwayat Transaksi Premium', style: GoogleFonts.openSans(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber[900])),
        const SizedBox(height: 10),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: transactions.reversed.length,
          itemBuilder: (context, index) {
            final trans = transactions.reversed.toList()[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                leading: Icon(Icons.receipt_long, color: Colors.amber[800]),
                title: Text('${trans.packageName} (${trans.currency} ${trans.convertedAmount.toStringAsFixed(2)})',
                    style: GoogleFonts.openSans(fontWeight: FontWeight.w600)),
                subtitle: Text(

                  'Dibeli: ${DateFormat('dd MMM yyyy, HH:mm').format(trans.purchaseDate)}\n'
                      'Kadaluarsa: ${DateFormat('dd MMM yyyy, HH:mm').format(trans.expiryDate)}',
                  style: GoogleFonts.openSans(fontSize: 13),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}