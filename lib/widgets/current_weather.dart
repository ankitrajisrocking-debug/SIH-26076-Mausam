import 'package:flutter/material.dart';

import '../services/weather_service.dart';

class CurrentWeather extends StatefulWidget {
  const CurrentWeather({super.key});

  @override
  State<CurrentWeather> createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  final WeatherService weatherService = WeatherService();

WeatherData? weatherData; // 🟢 CHANGED
DateTime? updatedAt;

  @override
  void initState() {
    super.initState();
    loadWeather(); // 🟢 CHANGED
  }

  Future<void> loadWeather() async {
    try {
      final data = await weatherService.getWeather();

      setState(() {
        weatherData = data;
        updatedAt = DateTime.now();
      });
    } catch (e) {
      debugPrint('Error loading weather: $e');
    }
  }

  String _formatTime(DateTime? value) {
    if (value == null) return '--:--';
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final currentTemp = weatherData == null
        ? '--'
        : weatherData!.temperature.toStringAsFixed(1);

    final feelsLike = weatherData == null
        ? '--'
        : weatherData!.feelsLike.toStringAsFixed(1);

    final maxTemp = weatherData == null
        ? '--'
        : weatherData!.maxTemp.toStringAsFixed(1);

    final minTemp = weatherData == null
        ? '--'
        : weatherData!.minTemp.toStringAsFixed(1);

    final humidity = weatherData == null
        ? '--'
        : weatherData!.humidity.toStringAsFixed(0);

    final windSpeed = weatherData == null
        ? '--'
        : weatherData!.windSpeed.toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A8CD7), Color(0xFF0B4F8C)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 390;
                final weatherSummary = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      const Text(
                        'Now',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$currentTemp°",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 62,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8, left: 4),
                            child: Text(
                              'C',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Updated at ${_formatTime(updatedAt)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Cloudy skies with occasional rain',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                );
                final windIndicator = Container(
                  width: isCompact ? 128 : 150,
                  height: isCompact ? 128 : 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white30, width: 3),
                    color: Colors.white.withOpacity(0.08),
                  ),
                  child:  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.air_rounded, color: Color(0xFFBCE7FF), size: 34),
                        SizedBox(height: 8),
                        Text(
                          windSpeed,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('km/h', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                );

                if (isCompact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      weatherSummary,
                      const SizedBox(height: 18),
                      Center(child: windIndicator),
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: weatherSummary),
                    const SizedBox(width: 12),
                    windIndicator,
                  ],
                );
              },
            ),
            const SizedBox(height: 22),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _WeatherInfoChip(
                  label: 'Feels like',
                  value: '${feelsLike}°C',
                  color: const Color(0xFF86D9FF),
                ),
                _WeatherInfoChip(
                  label: 'Max',
                  value: '${maxTemp}°C',
                  color: const Color(0xFFFFD166),
                ),
                _WeatherInfoChip(
                  label: 'Min',
                  value: '${minTemp}°C',
                  color: const Color(0xFF9DE0C4),
                ),
                _WeatherInfoChip(
                  label: 'Humidity',
                  value: '$humidity%',
                  color: const Color(0xFF8AD5FF),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F7EE),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'AQI 53',
                      style: TextStyle(
                        color: Color(0xFF0F2E12),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF7ACB88),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Satisfactory',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF0D2C12),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'National AQI-Source-CPCB',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeatherInfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _WeatherInfoChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
