import 'package:hive_flutter/hive_flutter.dart';
import 'package:fixtugasakhir/auth/auth_model.dart';
import 'package:fixtugasakhir/utils/encryption_util.dart';

class AuthService {
  late Box<User> _userBox;
  late Box _sessionBox;


  AuthService._internal();


  static final AuthService _instance = AuthService._internal();


  factory AuthService() {
    return _instance;
  }


  // Metode inisialisasi public untuk membuka Hive Boxes.
  Future<void> init() async {
    // Membuka box 'users'.
    if (!Hive.isBoxOpen('users')) {
      _userBox = await Hive.openBox<User>('users');
    } else {
      _userBox = Hive.box<User>('users');
    }

    // Membuka box 'session'
    if (!Hive.isBoxOpen('session')) {
      _sessionBox = await Hive.openBox('session');
    } else {
      _sessionBox = Hive.box('session');
    }

    // Inisialisasi status login default jika belum ada data.
    if (_sessionBox.get('isLoggedIn') == null) {
      await _sessionBox.put('isLoggedIn', false);
      await _sessionBox.put('loggedInUserEmail', null);
    }
  }

  // --- Metode untuk Mengecek dan Mendapatkan Status Login ---
  bool isUserLoggedIn() {
    return _sessionBox.get('isLoggedIn') ?? false;
  }

  String? getLoggedInUserEmail() {
    return _sessionBox.get('loggedInUserEmail');
  }

  // --- Metode Otentikasi ---
  Future<String?> registerUser(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return 'Nama, email, dan password tidak boleh kosong.';
    }

    if (_userBox.containsKey(email)) {
      return 'Email sudah terdaftar.';
    }

    // Enkripsi password menggunakan Rail Fence Cipher.
    String encryptedPassword = EncryptionUtil.encryptRailFence(password);


    User newUser = User(
      name: name,
      email: email,
      encryptedPassword: encryptedPassword,
      isLoggedIn: false,
      isPremium: false,
    );

    await _userBox.put(email, newUser);
    return null;
  }

  Future<String?> loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return 'Email dan password tidak boleh kosong.';
    }

    User? user = _userBox.get(email);

    if (user == null) {
      return 'Email tidak ditemukan.';
    }

    // Mendekripsi password yang tersimpan dan membandingkannya.
    String decryptedPassword = EncryptionUtil.decryptRailFence(user.encryptedPassword);
    if (decryptedPassword != password) {
      return 'Password salah.';
    }


    user.isLoggedIn = true;
    await user.save();

    await _sessionBox.put('isLoggedIn', true);
    await _sessionBox.put('loggedInUserEmail', email);

    return null;
  }

  Future<void> logoutUser() async {
    String? currentEmail = _sessionBox.get('loggedInUserEmail');
    if (currentEmail != null) {
      User? user = _userBox.get(currentEmail);
      if (user != null) {
        user.isLoggedIn = false;
        await user.save();
      }
    }
    // Reset status login di session box.
    await _sessionBox.put('isLoggedIn', false);
    await _sessionBox.put('loggedInUserEmail', null);
  }


  User? getUser(String email) {
    return _userBox.get(email);
  }

  User? getLoggedInUser() {
    String? email = getLoggedInUserEmail();
    if (email == null) return null;
    return getUser(email);
  }

  // FUNGSI UNTUK DEBUGGING: CETAK SEMUA USER
  void printAllUsers() {
    print('--- All Registered Users ---');
    if (_userBox.isEmpty) {
      print('No users registered yet.');
      return;
    }
    _userBox.values.forEach((user) {

      print('Name: ${user.name}, Email: ${user.email}, Password Encrypted: ${user.encryptedPassword}, Is Premium: ${user.isPremium}');
    });
    print('--------------------------');
  }

  // FUNGSI UNTUK DEBUGGING: CETAK STATUS SESI
  void printSessionStatus() {
    print('--- Session Status ---');
    print('Is Logged In: ${_sessionBox.get('isLoggedIn', defaultValue: false)}');
    print('Logged In User Email: ${_sessionBox.get('loggedInUserEmail')}');
    print('--------------------');
  }


  Future<void> clearAllUserData() async {
    await _userBox.clear();
    await _sessionBox.clear();
    await _sessionBox.put('isLoggedIn', false);
    await _sessionBox.put('loggedInUserEmail', null);
    print('All user and session data cleared.');
  }
}