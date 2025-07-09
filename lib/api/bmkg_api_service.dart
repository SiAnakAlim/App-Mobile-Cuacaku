import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fixtugasakhir/models/weather_model.dart';

class BMKGApiService {
  static const String _baseUrl = 'https://api.bmkg.go.id/publik/prakiraan-cuaca';

  Future<List<WeatherData>> fetchWeatherData(String areaId) async {
    final url = Uri.parse('$_baseUrl?adm4=$areaId');
    print('Mengambil data cuaca dari: $url');

    try {
      final response = await http.get(url, headers: {
        'User-Agent': 'Mozilla/5.0 (BMKGFlutterApp)',
      });

      print('Status response: ${response.statusCode}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        /// ✅ Ambil list cuaca yang benar (list dalam list)
        final List<dynamic> cuacaList = jsonData['data'][0]['cuaca'][0];

        final weatherList = cuacaList
            .map((item) => WeatherData.fromJson(item))
            .toList();

        return weatherList;
      } else {
        throw Exception('Gagal memuat data. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error mengambil data cuaca: $e');
      throw Exception(
        'Gagal mengambil data cuaca. Pastikan koneksi internet aktif dan coba lagi.',
      );
    }
  }
}
