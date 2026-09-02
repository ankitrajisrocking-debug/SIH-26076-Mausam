import 'dart:convert';


import 'package:http/http.dart' as http;

const _defaultWeatherApiBaseUrl = 'http://192.168.77.91:5000';

class WeatherData {
  final double temperature;
  final double feelsLike;
  final double humidity;
  final double windSpeed;
  final double windDirection;
  final double maxTemp;
  final double minTemp;
  final double aqi; // 🟢 ADD

  WeatherData({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.maxTemp,
    required this.minTemp,
    required this.aqi, // 🟢 ADD
  });
}

class WeatherService {
  WeatherService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl =
          baseUrl ??
          const String.fromEnvironment(
            'WEATHER_API_BASE_URL',
            defaultValue: _defaultWeatherApiBaseUrl,
          );

  final http.Client _client;
  final String _baseUrl;

  Future<WeatherData> getWeather() async {
    final url = Uri.parse('$_baseUrl/weather')
        .replace(queryParameters: const {'lat': '24.75', 'lon': '92.79'});
  Future<double> getTemperature() async {

    final url = Uri.parse(
      'http://10.0.2.2:5000/weather?lat=24.75&lon=92.79',
    );

    final response = await _client
        .get(url)
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic> ||
          decoded['current'] is! Map<String, dynamic> ||
          decoded['daily'] is! Map<String, dynamic> ||
          decoded['air_quality'] is! Map<String, dynamic>) {
        throw const FormatException('Weather API returned an invalid response');
      }
      final data = decoded;

      return (data['current']['temperature_2m'] as num).toDouble();

    } else {
      throw http.ClientException(
        'Weather API returned HTTP ${response.statusCode}',
        url,
      );
    }
  }

  Future<List<DailyForecastDay>> getDailyForecast() async {
    final url = Uri.parse(
      'http://192.168.77.91:5000/weather?lat=24.75&lon=92.79',
    );
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load daily forecast');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final daily = data['daily'] as Map<String, dynamic>?;
    if (daily == null) {
      throw Exception('Daily forecast data is missing');
    }

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
      throw Exception('Invalid daily forecast data');
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
}
