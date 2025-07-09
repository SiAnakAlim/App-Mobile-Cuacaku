// lib/screens/premium_purchase_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:fixtugasakhir/auth/auth_model.dart'; // Import model User
import 'package:fixtugasakhir/models/premium_transaction.dart'; // Import PremiumTransaction
import 'package:fixtugasakhir/utils/app_constants.dart'; // Import AppConstants

class PremiumPurchaseScreen extends StatefulWidget {
  final String currentUserEmail;

  const PremiumPurchaseScreen({Key? key, required this.currentUserEmail}) : super(key: key);

  @override
  State<PremiumPurchaseScreen> createState() => _PremiumPurchaseScreenState();
}

class _PremiumPurchaseScreenState extends State<PremiumPurchaseScreen> {
  String? _selectedPackage;
  double? _selectedPackagePriceIDR;
  String _selectedCurrency = 'IDR'; // Default currency
  double _convertedPrice = 0.0;

  // Define premium packages and their prices in IDR
  final Map<String, double> _premiumPackages = {
    '1 Hari': 10000.0,  // Rp 10.000 untuk 1 Hari
    '1 Bulan': 50000.0, // Rp 50.000 untuk 1 Bulan
    '3 Bulan': 120000.0, // Rp 120.000 untuk 3 Bulan
  };

  @override
  void initState() {
    super.initState();
    // Inisialisasi dengan paket pertama secara default jika ada
    if (_premiumPackages.isNotEmpty) {
      _selectedPackage = _premiumPackages.keys.first;
      _selectedPackagePriceIDR = _premiumPackages[_selectedPackage];
      _convertPrice(); // Hitung harga awal
    }
  }

  void _convertPrice() {
    if (_selectedPackagePriceIDR != null && AppConstants.exchangeRatesToIDR.containsKey(_selectedCurrency)) {
      setState(() {
        _convertedPrice = _selectedPackagePriceIDR! / AppConstants.exchangeRatesToIDR[_selectedCurrency]!;
      });
    } else {
      setState(() {
        _convertedPrice = 0.0;
      });
    }
  }

  Future<void> _purchasePremium() async {
    if (_selectedPackage == null || _selectedPackagePriceIDR == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih paket premium terlebih dahulu.')),
      );
      return;
    }

    final userBox = Hive.box<User>('users');
    final currentUser = userBox.values.firstWhere((user) => user.email == widget.currentUserEmail);

    // Hitung tanggal kedaluwarsa baru
    DateTime newExpiryDate;
    final now = DateTime.now();

    // Jika user sudah premium dan tanggal expirednya masih di masa depan, lanjutkan dari sana.
    // Jika tidak, mulai dari sekarang.
    DateTime baseDate = currentUser.isPremium && currentUser.premiumExpiryDate != null && currentUser.premiumExpiryDate!.isAfter(now)
        ? currentUser.premiumExpiryDate!
        : now;

    if (_selectedPackage == '1 Hari') {
      newExpiryDate = baseDate.add(const Duration(days: 1));
    } else if (_selectedPackage == '1 Bulan') {
      newExpiryDate = DateTime(baseDate.year, baseDate.month + 1, baseDate.day, baseDate.hour, baseDate.minute, baseDate.second);
    } else if (_selectedPackage == '3 Bulan') {
      newExpiryDate = DateTime(baseDate.year, baseDate.month + 3, baseDate.day, baseDate.hour, baseDate.minute, baseDate.second);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paket premium tidak valid.')),
      );
      return;
    }

    // Buat objek transaksi
    final transaction = PremiumTransaction(
      email: currentUser.email,
      packageName: _selectedPackage!,
      originalAmount: _selectedPackagePriceIDR!,
      currency: _selectedCurrency,
      convertedAmount: _convertedPrice,
      purchaseDate: now,
      expiryDate: newExpiryDate,
    );

    // Update status premium user
    currentUser.isPremium = true;
    currentUser.premiumExpiryDate = newExpiryDate;
    currentUser.premiumHistory.add(transaction); // Tambahkan transaksi ke riwayat
    await currentUser.save(); // Simpan perubahan pada user

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pembelian Premium ${_selectedPackage!} berhasil!')),
    );

    Navigator.pop(context, true); // Kembali ke ProfileScreen dan beri sinyal berhasil
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Beli Premium', style: GoogleFonts.cormorantGaramond()),
        backgroundColor: Colors.amber[700],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Paket Premium:',
              style: GoogleFonts.openSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.amber[900],
              ),
            ),
            const SizedBox(height: 15),
            ..._premiumPackages.entries.map((entry) {
              final packageName = entry.key;
              final priceIDR = entry.value;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: _selectedPackage == packageName ? 8 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: _selectedPackage == packageName ? Colors.amber.shade700 : Colors.grey.shade300,
                    width: _selectedPackage == packageName ? 3 : 1,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedPackage = packageName;
                      _selectedPackagePriceIDR = priceIDR;
                      _convertPrice(); // Konversi ulang saat paket berubah
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              packageName,
                              style: GoogleFonts.openSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[800],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Harga: Rp ${NumberFormat('#,##0').format(priceIDR)}',
                              style: GoogleFonts.openSans(
                                fontSize: 15,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        Radio<String>(
                          value: packageName,
                          groupValue: _selectedPackage,
                          onChanged: (value) {
                            setState(() {
                              _selectedPackage = value;
                              _selectedPackagePriceIDR = _premiumPackages[value];
                              _convertPrice(); // Konversi ulang saat paket berubah
                            });
                          },
                          activeColor: Colors.amber[700],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 30),
            Text(
              'Pilih Mata Uang Pembayaran:',
              style: GoogleFonts.openSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.amber[900],
              ),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.amber.shade700, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              ),
              items: AppConstants.exchangeRatesToIDR.keys.map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency, style: GoogleFonts.openSans()),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCurrency = newValue;
                    _convertPrice(); // Konversi saat mata uang berubah
                  });
                }
              },
            ),
            const SizedBox(height: 30),
            if (_selectedPackagePriceIDR != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Pembayaran:',
                        style: GoogleFonts.openSans(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[900],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Paket Terpilih: ${_selectedPackage ?? 'Belum dipilih'}',
                        style: GoogleFonts.openSans(fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Harga (${_selectedCurrency}): ${NumberFormat('#,##0.00', 'en_US').format(_convertedPrice)}',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _selectedPackage != null ? _purchasePremium : null,
                          icon: const Icon(Icons.shopping_cart),
                          label: Text('Beli Sekarang', style: GoogleFonts.openSans(fontSize: 18)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
      ),
    );
  }
}