// lib/models/premium_transaction.dart
import 'package:hive/hive.dart';
part 'premium_transaction.g.dart';

@HiveType(typeId: 2)
class PremiumTransaction extends HiveObject {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String packageName; // "1 Hari", "1 Bulan"

  @HiveField(2)
  final double originalAmount; // in IDR

  @HiveField(3)
  final String currency; // "IDR", "MYR"

  @HiveField(4)
  final double convertedAmount;

  @HiveField(5)
  final DateTime purchaseDate;

  @HiveField(6)
  final DateTime expiryDate;

  PremiumTransaction({
    required this.email,
    required this.packageName,
    required this.originalAmount,
    required this.currency,
    required this.convertedAmount,
    required this.purchaseDate,
    required this.expiryDate,
  });
}