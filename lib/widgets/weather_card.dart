import 'package:flutter/material.dart';
import '../models/weather.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({Key? key, required this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${weather.cityName}', style: Theme.of(context).textTheme.headlineSmall),
        Text('Temperature: ${weather.temperature}°'),
        Text('Description: ${weather.description}'),
        Text('Humidity: ${weather.humidity}%'),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: weather.forecast.length,
            itemBuilder: (context, index) {
              final forecast = weather.forecast[index];
              return ListTile(
                title: Text(forecast.day),
                subtitle: Text('${forecast.temperature}° - ${forecast.description}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
