class EncryptionUtil {
  // Key (jumlah rel) untuk Rail Fence Cipher.
  static const int _railFenceKey = 3;

  // Fungsi enkripsi Rail Fence Cipher
  static String encryptRailFence(String plaintext, {int? key}) {
    int rails = key ?? _railFenceKey;
    if (rails <= 1) return plaintext; // Tidak ada enkripsi jika 1 rel atau kurang

    List<List<String>> fence = List.generate(rails, (_) => []);
    int rail = 0;
    bool down = true; // Arah pergerakan: true = turun, false = naik

    for (int i = 0; i < plaintext.length; i++) {
      fence[rail].add(plaintext[i]);
      if (down) {
        rail++; // Turun ke rel berikutnya
      } else {
        rail--; // Naik ke rel sebelumnya
      }

      // Balik arah jika mencapai batas atas atau batas bawah rel
      if (rail == rails - 1) {
        down = false;
      } else if (rail == 0) {
        down = true;
      }
    }

    // Gabungkan karakter dari setiap rel secara berurutan untuk membentuk ciphertext
    String ciphertext = '';
    for (int i = 0; i < rails; i++) {
      ciphertext += fence[i].join();
    }
    return ciphertext;
  }

  // Fungsi dekripsi Rail Fence Cipher
  static String decryptRailFence(String ciphertext, {int? key}) {
    int rails = key ?? _railFenceKey;
    if (rails <= 1) return ciphertext;

    // Buat "pagar" kosong dengan ukuran yang sama dengan ciphertext
    List<List<String>> fence = List.generate(rails, (_) => List.filled(ciphertext.length, ''));

    // Hitung berapa banyak karakter yang akan ada di setiap rel
    List<int> railLengths = List.filled(rails, 0);
    int rail = 0;
    bool down = true;
    for (int i = 0; i < ciphertext.length; i++) {
      railLengths[rail]++;
      if (down) {
        rail++;
      } else {
        rail--;
      }
      if (rail == rails - 1) {
        down = false;
      } else if (rail == 0) {
        down = true;
      }
    }


    int charIndex = 0;
    for (int i = 0; i < rails; i++) {
      for (int j = 0; j < railLengths[i]; j++) {
        if (charIndex < ciphertext.length) {
          fence[i][j] = ciphertext[charIndex++];
        }
      }
    }

    // Baca karakter dari "pagar" dengan pola zig-zag untuk mendapatkan plaintext
    String plaintext = '';
    rail = 0;
    down = true;
    List<int> currentRailIndex = List.filled(rails, 0); // Melacak indeks saat ini di setiap rel

    for (int i = 0; i < ciphertext.length; i++) {
      plaintext += fence[rail][currentRailIndex[rail]];
      currentRailIndex[rail]++; // Pindah ke karakter berikutnya di rel ini

      if (down) {
        rail++;
      } else {
        rail--;
      }
      if (rail == rails - 1) {
        down = false;
      } else if (rail == 0) {
        down = true;
      }
    }
    return plaintext;
  }
}