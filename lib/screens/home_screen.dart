import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          Row(
            children: [
              const Text('°C'),
              Switch(
                value: weatherProvider.isCelsius,
                onChanged: (value) {
                  weatherProvider.toggleUnit();
                  weatherProvider.fetchWeather(weatherProvider.lastCity);
                },
              ),
              const Text('°F'),
            ],
          ),
        ],
      ),
      body: weatherProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isPortrait
            ? _buildPortraitLayout(context, weatherProvider)
            : _buildLandscapeLayout(context, weatherProvider),
      ),
    );
  }

  /// Portrait Layout
  Widget _buildPortraitLayout(
      BuildContext context, WeatherProvider weatherProvider) {
    return Column(
      children: [
        _buildSearchBar(context, weatherProvider),
        if (weatherProvider.currentWeather != null)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildWeatherDetails(context, weatherProvider),
                const SizedBox(height: 20),
                const Text(
                  '3-Day Forecast:',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: _buildForecastList(weatherProvider),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Landscape Layout
  Widget _buildLandscapeLayout(
      BuildContext context, WeatherProvider weatherProvider) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildSearchBar(context, weatherProvider),
              if (weatherProvider.currentWeather != null)
                Expanded(
                  child: _buildWeatherDetails(context, weatherProvider),
                ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: weatherProvider.currentWeather != null
              ? _buildForecastList(weatherProvider)
              : const SizedBox(),
        ),
      ],
    );
  }

  /// Search Bar
  Widget _buildSearchBar(BuildContext context, WeatherProvider weatherProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onSubmitted: (city) => weatherProvider.fetchWeather(city),
        decoration: InputDecoration(
          labelText: 'Search City',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }

  /// Weather Details (City, Temperature, Description, Humidity)
  Widget _buildWeatherDetails(
      BuildContext context, WeatherProvider weatherProvider) {
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${weatherProvider.currentWeather!.cityName}',
          style: TextStyle(
            fontSize: 32 * textScale,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.thermostat_outlined, color: Colors.white, size: 32),
            const SizedBox(width: 10),
            Text(
              '${weatherProvider.currentWeather!.temperature}°${weatherProvider.isCelsius ? 'C' : 'F'}',
              style: TextStyle(fontSize: 28 * textScale, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wb_sunny_outlined, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            Text(
              weatherProvider.currentWeather!.description.toUpperCase(),
              style: TextStyle(fontSize: 18 * textScale, color: Colors.white70),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.water_drop_outlined, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            Text(
              'Humidity: ${weatherProvider.currentWeather!.humidity}%',
              style: TextStyle(fontSize: 18 * textScale, color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }

  /// Forecast List (3-Day Forecast)
  Widget _buildForecastList(WeatherProvider weatherProvider) {
    return ListView.builder(
      itemCount: weatherProvider.currentWeather!.forecast.length,
      itemBuilder: (context, index) {
        final forecast = weatherProvider.currentWeather!.forecast[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.white.withOpacity(0.8),
          child: ListTile(
            title: Text(
              forecast.day,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${forecast.temperature}°${weatherProvider.isCelsius ? 'C' : 'F'} - ${forecast.description}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }
}
