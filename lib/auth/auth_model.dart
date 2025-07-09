// lib/auth/auth_model.dart
import 'package:hive/hive.dart';
import 'package:fixtugasakhir/models/premium_transaction.dart';

part 'auth_model.g.dart';

@HiveType(typeId: 0) // Harus unik di seluruh Hive adapters
class User extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String encryptedPassword;

  @HiveField(3)
  bool isLoggedIn;

  @HiveField(4)
  bool isPremium;

  @HiveField(5)
  DateTime? premiumExpiryDate;

  @HiveField(6)
  List<PremiumTransaction> premiumHistory;

  @HiveField(7)
  String? profileImagePath;

  User({
    required this.name,
    required this.email,
    required this.encryptedPassword,
    this.isLoggedIn = false,
    this.isPremium = false,
    this.premiumExpiryDate,
    List<PremiumTransaction>? premiumHistory,
    this.profileImagePath,
  }) : this.premiumHistory = premiumHistory ?? [];
}
