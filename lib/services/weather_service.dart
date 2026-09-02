import 'dart:convert';

import 'package:http/http.dart' as http;

const _defaultWeatherApiBaseUrl = 'http://192.168.77.91:5000';

class DailyForecastDay {
  const DailyForecastDay({
    required this.date,
    required this.minTemperature,
    required this.maxTemperature,
    required this.weatherCode,
  });

  final DateTime date;
  final double minTemperature;
  final double maxTemperature;
  final int weatherCode;

  double get minimumTemperature => minTemperature;
  double get maximumTemperature => maxTemperature;

  String get dateLabel =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';

  String get dayLabel {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }
}

class WeatherData {
  const WeatherData({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.maxTemp,
    required this.minTemp,
    required this.aqi,
  });

  final double temperature;
  final double feelsLike;
  final double humidity;
  final double windSpeed;
  final double windDirection;
  final double maxTemp;
  final double minTemp;
  final double? aqi;
}

class WeatherService {
  WeatherService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ??
            const String.fromEnvironment(
              'WEATHER_API_BASE_URL',
              defaultValue: _defaultWeatherApiBaseUrl,
            );

  final http.Client _client;
  final String _baseUrl;

  Future<double> getTemperature() async {
    final weather = await getWeather();
    return weather.temperature;
  }

  Future<WeatherData> getWeather() async {
    final data = await _fetchWeather();
    final current = data['current'] as Map<String, dynamic>;
    final daily = data['daily'] as Map<String, dynamic>;
    final airQuality = data['air_quality'] as Map<String, dynamic>?;
    final airQualityCurrent = airQuality?['current'] as Map<String, dynamic>?;
    final maxTemperatures = daily['temperature_2m_max'] as List<dynamic>?;
    final minTemperatures = daily['temperature_2m_min'] as List<dynamic>?;

    if (maxTemperatures == null ||
        minTemperatures == null ||
        maxTemperatures.isEmpty ||
        minTemperatures.isEmpty) {
      throw const FormatException('Weather response is missing temperature data');
    }

    return WeatherData(
      temperature: (current['temperature_2m'] as num).toDouble(),
      feelsLike: (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      windDirection: (current['wind_direction_10m'] as num).toDouble(),
      maxTemp: (maxTemperatures[0] as num).toDouble(),
      minTemp: (minTemperatures[0] as num).toDouble(),
      aqi: (airQualityCurrent?['us_aqi'] as num?)?.toDouble(),
    );
  }

  Future<List<DailyForecastDay>> getDailyForecast() async {
    final data = await _fetchWeather();
    final daily = data['daily'] as Map<String, dynamic>;
    final dates = (daily['time'] as List<dynamic>?)?.cast<String>();
    final minTemperatures = daily['temperature_2m_min'] as List<dynamic>?;
    final maxTemperatures = daily['temperature_2m_max'] as List<dynamic>?;
    final weatherCodes = daily['weather_code'] as List<dynamic>?;

    if (dates == null ||
        minTemperatures == null ||
        maxTemperatures == null ||
        weatherCodes == null ||
        dates.length != minTemperatures.length ||
        dates.length != maxTemperatures.length ||
        dates.length != weatherCodes.length) {
      throw const FormatException('Invalid daily forecast data');
    }

    return List<DailyForecastDay>.generate(
      dates.length,
      (index) => DailyForecastDay(
        date: DateTime.parse(dates[index]),
        minTemperature: (minTemperatures[index] as num).toDouble(),
        maxTemperature: (maxTemperatures[index] as num).toDouble(),
        weatherCode: (weatherCodes[index] as num).toInt(),
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchWeather() async {
    final url = Uri.parse('$_baseUrl/weather').replace(
      queryParameters: const {'lat': '24.75', 'lon': '92.79'},
    );
    final response = await _client
        .get(url)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw http.ClientException(
        'Weather API returned HTTP ${response.statusCode}',
        url,
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic> ||
        decoded['current'] is! Map<String, dynamic> ||
        decoded['daily'] is! Map<String, dynamic>) {
      throw const FormatException('Weather API returned an invalid response');
    }
    return decoded;
  }
}
