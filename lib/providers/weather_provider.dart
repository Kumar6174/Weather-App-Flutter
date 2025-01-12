import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather.dart';
import '../utils/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherProvider with ChangeNotifier {
  Weather? _currentWeather;
  String _lastCity = 'Mountain View'; // Default city
  bool _isCelsius = true; // Default unit
  bool _isLoading = false; // Loading indicator

  final ApiService _apiService = ApiService();

  // Getters
  Weather? get currentWeather => _currentWeather;
  String get lastCity => _lastCity;
  bool get isCelsius => _isCelsius;
  bool get isLoading => _isLoading;

  WeatherProvider() {
    _loadInitialWeather();
  }

  // Load initial preferences and weather
  Future<void> _loadInitialWeather() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isCelsius = prefs.getBool('isCelsius') ?? true;

      if (prefs.containsKey('lastCity')) {
        _lastCity = prefs.getString('lastCity')!;
        await fetchWeather(_lastCity);
      } else {
        await fetchLocationWeather();
      }
    } catch (e) {
      debugPrint('Error loading initial weather: $e');
    }
  }

  // Fetch weather for a specific city
  Future<void> fetchWeather(String city) async {
    try {
      _setLoading(true);
      _currentWeather = await _apiService.fetchWeather(city, _isCelsius);
      _lastCity = city;
      notifyListeners();
      savePreferences();
    } catch (e) {
      debugPrint('Error fetching weather for $city: $e');
      throw Exception('Failed to fetch weather for $city.');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch weather for current location
  Future<void> fetchLocationWeather() async {
    try {
      _setLoading(true);
      Position position = await _determinePosition();
      final lat = position.latitude;
      final lon = position.longitude;

      _currentWeather = await _apiService.fetchWeatherByCoordinates(lat, lon, _isCelsius);
      _lastCity = _currentWeather!.cityName;
      notifyListeners();
      savePreferences();
    } catch (e) {
      debugPrint('Error fetching location weather: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Determine user position
  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Toggle unit (Celsius/Fahrenheit)
  void toggleUnit() {
    _isCelsius = !_isCelsius;
    notifyListeners();
    savePreferences();
  }

  // Save preferences to local storage
  Future<void> savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lastCity', _lastCity);
    prefs.setBool('isCelsius', _isCelsius);
  }

  // Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
