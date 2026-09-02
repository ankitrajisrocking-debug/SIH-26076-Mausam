import 'package:flutter/material.dart';

import '../services/weather_service.dart';

class CurrentWeather extends StatefulWidget {
  const CurrentWeather({super.key});

  @override
  State<CurrentWeather> createState() => _CurrentWeatherState();
}

class _CurrentWeatherState extends State<CurrentWeather> {
  final WeatherService weatherService = WeatherService();

  double? temperature;
  double? windSpeed;
  double? feelsLikeTemperature;
  double? maxTemperature;
  double? minTemperature;
  double? humidity;
  double? aqi;
  int? weatherCode;

  DateTime? updatedAt;

  @override
  void initState() {
    super.initState();
    loadTemperature();
  }

  Future<void> loadTemperature() async {
    try {
      final weather = await weatherService.getWeather();

      setState(() {
        temperature = weather.temperature;
        windSpeed = weather.windSpeed;
        feelsLikeTemperature = weather.feelsLike;
        maxTemperature = weather.maxTemp;
        minTemperature = weather.minTemp;
        humidity = weather.humidity;
        aqi = weather.aqi;
        weatherCode = weather.weatherCode;
        updatedAt = DateTime.now();
      });
    } catch (e) {
      debugPrint('Error loading temperature: $e');
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
    final currentTemp = temperature == null
        ? '--'
        : temperature!.toStringAsFixed(1);
    final feelsLike = feelsLikeTemperature?.toStringAsFixed(1) ?? '--';
    final maxTemp = maxTemperature?.toStringAsFixed(1) ?? '--';
    final minTemp = minTemperature?.toStringAsFixed(1) ?? '--';
    final humidityValue = humidity?.toStringAsFixed(0) ?? '--';
    final aqiValue = aqi?.toStringAsFixed(0) ?? '--';

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
                final compact = constraints.maxWidth < 390;
                final windSize = compact ? 112.0 : 150.0;
                final summary = Column(
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
                        Flexible(
                          child: Text(
                            "$currentTemp°",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 62,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
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
                    Text(
                      _weatherDescription(weatherCode),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
                final wind = Container(
                  width: windSize,
                  height: windSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white30, width: 3),
                    color: Colors.white.withOpacity(0.08),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.air_rounded,
                          color: Color(0xFFBCE7FF),
                          size: 34,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          windSpeed?.toStringAsFixed(1) ?? '--',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'km/h',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );

                return compact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          summary,
                          const SizedBox(height: 18),
                          Center(child: wind),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: summary),
                          const SizedBox(width: 12),
                          wind,
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
                  value: '$humidityValue%',
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
                    child: Text(
                      'AQI $aqiValue',
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
                      child: Text(
                        _aqiDescription(aqi),
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

  String _weatherDescription(int? code) {
    if (code == null) return 'Loading weather conditions';
    if (code == 0) return 'Clear skies';
    if (code <= 3) return 'Cloudy skies';
    if (code >= 95) return 'Thunderstorms';
    if (code >= 51) return 'Rain showers';
    return 'Overcast skies';
  }

  String _aqiDescription(double? value) {
    if (value == null) return 'Unavailable';
    if (value <= 50) return 'Good';
    if (value <= 100) return 'Satisfactory';
    if (value <= 150) return 'Unhealthy for sensitive groups';
    if (value <= 200) return 'Unhealthy';
    if (value <= 300) return 'Very unhealthy';
    return 'Hazardous';
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
