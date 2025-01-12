import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class ApiService {
  final String apiKey = 'cc174ca35c4f787d1fa801982aa6df7b';

  Future<Weather> fetchWeather(String city, bool isCelsius) async {
    final units = isCelsius ? 'metric' : 'imperial';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=$units&appid=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      try {
        return Weather(
          cityName: data['name'],
          temperature: (data['main']['temp'] as num).toDouble(), // Cast to double
          description: data['weather'][0]['description'],
          humidity: (data['main']['humidity'] as num).toDouble(), // Cast to double
          forecast: await fetchForecast(city, isCelsius), // Fetch 3-day forecast
        );
      } catch (e) {
        debugPrint('Error in parsing weather data: $e');
        throw Exception('Error parsing weather data.');
      }
    } else {
      throw Exception('Failed to fetch weather data. Status code: ${response.statusCode}');
    }
  }



  Future<Weather> fetchWeatherByCoordinates(
      double lat, double lon, bool isCelsius) async {
    final units = isCelsius ? 'metric' : 'imperial';
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=$units&appid=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather(
        cityName: data['name'],
        temperature: data['main']['temp'].toDouble(),
        description: data['weather'][0]['description'],
        humidity: data['main']['humidity'].toDouble(),
        forecast: await fetchForecastByCoordinates(lat, lon, isCelsius),
      );
    } else {
      throw Exception('Failed to fetch weather data.');
    }
  }

  Future<List<Forecast>> fetchForecast(String city, bool isCelsius) async {
    final units = isCelsius ? 'metric' : 'imperial';
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=$units&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Forecast> forecasts = [];
      final forecastList = data['list'] as List;

      for (var i = 0; i < forecastList.length; i++) {
        final forecastData = forecastList[i];
        final time = DateTime.parse(forecastData['dt_txt']);

        // Select forecasts at 12:00 PM
        if (time.hour == 12) {
          forecasts.add(Forecast(
            day: time.toLocal().toString().split(' ')[0], // Extract date
            temperature: (forecastData['main']['temp'] as num).toDouble(), // Cast to double
            description: forecastData['weather'][0]['description'],
          ));
        }

        if (forecasts.length == 3) break; // Limit to 3 days
      }

      return forecasts;
    } else {
      throw Exception('Failed to fetch forecast data.');
    }
  }


  Future<List<Forecast>> fetchForecastByCoordinates(
      double lat, double lon, bool isCelsius) async {
    final units = isCelsius ? 'metric' : 'imperial';
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=$units&appid=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return _mapForecastData(data);
    } else {
      throw Exception('Failed to fetch forecast data.');
    }
  }

  List<Forecast> _mapForecastData(Map<String, dynamic> data) {
    return List.generate(
      3,
          (index) {
        final forecastData = data['list'][index];
        return Forecast(
          day: forecastData['dt_txt'],
          temperature: forecastData['main']['temp'].toDouble(),
          description: forecastData['weather'][0]['description'],
        );
      },
    );
  }
}
