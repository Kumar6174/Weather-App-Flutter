class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final double humidity;
  final List<Forecast> forecast;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.forecast,
  });
}

class Forecast {
  final String day;
  final double temperature;
  final String description;

  Forecast({
    required this.day,
    required this.temperature,
    required this.description,
  });
}
