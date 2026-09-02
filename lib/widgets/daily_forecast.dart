import 'package:flutter/material.dart';

import '../services/weather_service.dart';

class DailyForecast extends StatelessWidget {
  const DailyForecast({super.key});

  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }

  String _formatDay(DateTime date) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;
    return isToday ? 'Today' : _weekdays[date.weekday - 1];
  }

  IconData _iconForWeatherCode(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code <= 3) return Icons.cloud;
    if (code <= 67 || (code >= 80 && code <= 82)) {
      return Icons.umbrella;
    }
    if (code <= 77) return Icons.ac_unit;
    if (code >= 95) return Icons.thunderstorm;
    return Icons.cloud;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DailyForecastDay>>(
      future: WeatherService().getDailyForecast(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Unable to load forecast',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        final days = snapshot.data!.take(7);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: const Color(0xFF4679A5),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: days.map((day) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatDate(day.date),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDay(day.date),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 25),
                    Icon(
                      _iconForWeatherCode(day.weatherCode),
                      color: Colors.white,
                      size: 38,
                    ),
                    const SizedBox(width: 25),
                    Text(
                      '${day.minTemperature.toStringAsFixed(1)}°',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Container(
                        height: 15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFC107), Color(0xFFFF0000)],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      '${day.maxTemperature.toStringAsFixed(1)}°',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 30,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
