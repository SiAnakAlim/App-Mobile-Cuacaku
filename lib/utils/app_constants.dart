class AppConstants {
  // Wilayah lengkap + kode desa (unikan value!)
  static const Map<String, String> slemanDistricts = {
    'Balecatur (Gamping)': '34.04.01.2001',
    'Sidokarto (Godean)': '34.04.02.2001',
    'Sumberrahayu (Moyudan)': '34.04.03.2001',
    'Sendangrejo (Minggir)': '34.04.04.2001',
    'Margodadi (Seyegan)': '34.04.05.2001',
    'Tlogoadi (Mlati)': '34.04.06.2001',
    'Condongcatur (Depok)': '34.04.07.2001',
    'Kalitirto (Berbah)': '34.04.08.2001',
    'Bokoharjo (Prambanan)': '34.04.09.2001',
    'Tirtomartani (Kalasan)': '34.04.10.2001',
    'Wedomartani (Ngemplak)': '34.04.11.2001',
    'Sariharjo (Ngaglik)': '34.04.12.2001',
    'Caturharjo (Sleman)': '34.04.13.2001',
    'Tirtoadi (Tempel)': '34.04.14.2001',
    'Donokerto (Turi)': '34.04.15.2001',
    'Purwobinangun (Pakem)': '34.04.16.2001',
    'Glagaharjo (Cangkringan)': '34.04.17.2001',
  };


  static const String defaultDistrictCode = '34.04.01.2001';

  // Kurs mata uang
  static const Map<String, double> exchangeRatesToIDR = {
    'IDR': 1.0,
    'SAR': 4200.0,
    'EUR': 17500.0,
    'MYR': 3500.0,
  };

  // Zona waktu
  static const List<Map<String, String>> timezones = [
    {'name': 'WIB', 'offset': '+07:00'},
    {'name': 'WITA', 'offset': '+08:00'},
    {'name': 'WIT', 'offset': '+09:00'},
    {'name': 'London', 'offset': '+00:00'},
    {'name': 'Riyadh', 'offset': '+03:00'},
  ];
}