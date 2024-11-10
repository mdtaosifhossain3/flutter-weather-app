import 'package:flutter/material.dart';

class WeatherInfoCard extends StatelessWidget {
  final String cityName;
  final String weatherIconUrl;
  final String description;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int visibility;

  const WeatherInfoCard({
    super.key,
    required this.cityName,
    required this.weatherIconUrl,
    required this.description,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.visibility,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8, // Shadow effect
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // City Name
            Text(
              cityName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),

            // Weather Icon and Description
            Column(
              children: [
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Current Temperature and Feels Like
            Text(
              "${temperature.toStringAsFixed(1)}°C",
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            Text(
              "Feels like ${feelsLike.toStringAsFixed(1)}°C",
              style: const TextStyle(fontSize: 18, color: Colors.blueGrey),
            ),
            const SizedBox(height: 16),

            // Other Weather Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetail(
                    "Min Temp", "${tempMin.toStringAsFixed(1)}°C"),
                _buildWeatherDetail(
                    "Max Temp", "${tempMax.toStringAsFixed(1)}°C"),
                _buildWeatherDetail("Humidity", "$humidity%"),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetail("Pressure", "$pressure hPa"),
                _buildWeatherDetail(
                    "Wind", "${windSpeed.toStringAsFixed(1)} km/h"),
                _buildWeatherDetail("Visibility", "${visibility / 1000} km"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}
