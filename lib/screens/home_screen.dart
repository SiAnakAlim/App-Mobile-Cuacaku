import 'dart:async'; // Added for Timer
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fixtugasakhir/models/weather_model.dart';
import 'package:fixtugasakhir/utils/app_constants.dart';
import 'package:fixtugasakhir/api/bmkg_api_service.dart';
import 'package:fixtugasakhir/utils/notification_service.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BMKGApiService _apiService = BMKGApiService();
  final TextEditingController _searchController = TextEditingController();
  List<WeatherData> _weatherData = [];
  List<WeatherData> _filteredWeatherData = [];
  bool _isLoading = true;
  String _error = '';
  String _selectedDistrict = 'Balecatur (Gamping)';
  String _selectedTimezone = 'WIB';
  String _currentTime = '';
  AccelerometerEvent? _accelerometerData;
  bool _showSensorData = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initServices();
    _startClock();
    _fetchWeatherData();
    _initSensors();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer when widget is disposed
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _initServices() async {
    await NotificationService.init();
  }

  void _startClock() {
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime = DateFormat('HH:mm:ss').format(now);
    });
  }

  void _initSensors() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (_showSensorData) {
        setState(() {
          _accelerometerData = event;
        });
      }
    });
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final code = AppConstants.slemanDistricts[_selectedDistrict]!;
      final data = await _apiService.fetchWeatherData(code);

      setState(() {
        _weatherData = data;
        _filteredWeatherData = data;
        _isLoading = false;
      });

      await _sendMorningWeatherNotification(data.first);
    } catch (e) {
      setState(() {
        _error = 'Gagal memuat data cuaca: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMorningWeatherNotification(WeatherData data) async {
    await NotificationService.showNotification(
      id: 1,
      title: 'Cuaca Pagi di $_selectedDistrict',
      body: 'Suhu: ${data.temperature}°C | ${data.weatherDescriptionEn}',
    );
  }

  void _filterWeatherData(String query) {
    setState(() {
      _filteredWeatherData = _weatherData.where((data) {
        final desc = data.weatherDescriptionEn.toLowerCase();
        final temp = data.temperature.toString();
        return desc.contains(query.toLowerCase()) ||
            temp.contains(query);
      }).toList();
    });
  }

  String _convertToSelectedTimezone(String datetimeStr) {
    try {
      final DateTime utcDate = DateTime.parse(datetimeStr).toUtc();
      final offsetStr = AppConstants.timezones
          .firstWhere((t) => t['name'] == _selectedTimezone)['offset']!;
      final duration = Duration(
        hours: int.parse(offsetStr.split(':')[0]),
        minutes: int.parse(offsetStr.split(':')[1]),
      );
      final localTime = utcDate.add(duration);
      return DateFormat('EEE, dd MMM yyyy HH:mm').format(localTime);
    } catch (_) {
      return datetimeStr;
    }
  }

  Widget _buildWeatherCard(WeatherData data) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue.shade100, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {

        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _convertToSelectedTimezone(data.datetime),
                    style: GoogleFonts.openSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildWeatherItem(Icons.thermostat, '${data.temperature}°C', 'Suhu'),
                    _buildWeatherItem(Icons.water_drop, '${data.humidity}%', 'Kelembaban'),
                    _buildWeatherItem(Icons.air, '${data.windSpeed} km/j', 'Angin'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(data.weatherDescriptionEn),
                    backgroundColor: Colors.orange[50],
                    labelStyle: GoogleFonts.openSans(
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_active),
                    color: Colors.blue,
                    onPressed: () {
                      NotificationService.showNotification(
                        id: DateTime.now().millisecondsSinceEpoch % 100000,
                        title: 'Cuaca di $_selectedDistrict',
                        body: '${data.temperature}°C | ${data.weatherDescriptionEn}',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.blue[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.openSans(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterWeatherData,
        decoration: InputDecoration(
          hintText: 'Cari kondisi cuaca...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _filterWeatherData('');
            },
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeAndSensorInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, size: 18),
              const SizedBox(width: 8),
              Text(
                _currentTime,
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              _showSensorData ? Icons.sensors : Icons.sensors_off,
              color: Colors.blue,
            ),
            onPressed: () {
              setState(() {
                _showSensorData = !_showSensorData;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSensorData() {
    if (!_showSensorData || _accelerometerData == null) {
      return const SizedBox();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Sensor Accelerometer',
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSensorValue('X', _accelerometerData!.x.toStringAsFixed(2)),
                _buildSensorValue('Y', _accelerometerData!.y.toStringAsFixed(2)),
                _buildSensorValue('Z', _accelerometerData!.z.toStringAsFixed(2)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorValue(String axis, String value) {
    return Column(
      children: [
        Text(
          axis,
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cuaca Wilayah Sleman',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              if (_weatherData.isNotEmpty) {
                NotificationService.scheduleDailyWeatherNotification(
                  time: const TimeOfDay(hour: 7, minute: 0),
                  location: _selectedDistrict,
                  weather: _weatherData.first,
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            _buildTimeAndSensorInfo(),
            if (_showSensorData && _accelerometerData != null) _buildSensorData(),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedDistrict,
              decoration: InputDecoration(
                labelText: 'Pilih Wilayah',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              dropdownColor: Colors.white,
              items: AppConstants.slemanDistricts.keys.map((district) {
                return DropdownMenuItem(
                  value: district,
                  child: Text(
                    district,
                    style: GoogleFonts.openSans(),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedDistrict = value);
                  _fetchWeatherData();
                }
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedTimezone,
              decoration: InputDecoration(
                labelText: 'Zona Waktu',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              dropdownColor: Colors.white,
              items: AppConstants.timezones.map((tz) {
                return DropdownMenuItem(
                  value: tz['name'],
                  child: Text(
                    '${tz['name']} (UTC${tz['offset']})',
                    style: GoogleFonts.openSans(),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedTimezone = value);
                }
              },
            ),
            const SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.blue[700]))
                : _error.isNotEmpty
                ? Center(
              child: Text(
                _error,
                style: GoogleFonts.openSans(color: Colors.red),
              ),
            )
                : _filteredWeatherData.isEmpty
                ? Center(
              child: Text(
                'Data cuaca tidak ditemukan',
                style: GoogleFonts.openSans(),
              ),
            )
                : Column(
              children: _filteredWeatherData
                  .map((data) => _buildWeatherCard(data))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Sumber data: BMKG | ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
                style: GoogleFonts.openSans(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}