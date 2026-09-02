import 'dart:convert';

import 'package:http/http.dart' as http;

const _defaultWeatherApiBaseUrl = 'http://192.168.137.1:5000';

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

class HourlyForecastHour {
  const HourlyForecastHour({
    required this.time,
    required this.temperature,
    required this.humidity,
    required this.weatherCode,
  });

  final DateTime time;
  final double temperature;
  final double humidity;
  final int weatherCode;
}

class SunMoonData {
  const SunMoonData({
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
  });

  final DateTime sunrise;
  final DateTime sunset;
  final DateTime moonrise;
  final DateTime moonset;
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
    required this.weatherCode,
    required this.precipitation,
  });

  final double temperature;
  final double feelsLike;
  final double humidity;
  final double windSpeed;
  final double windDirection;
  final double maxTemp;
  final double minTemp;
  final double? aqi;
  final int weatherCode;
  final double precipitation;
}

class WeatherLocation {
  const WeatherLocation({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final double latitude;
  final double longitude;
}

class WeatherService {
  WeatherService({
    http.Client? client,
    String? baseUrl,
    this.latitude = 24.75,
    this.longitude = 92.79,
  }) : _client = client ?? http.Client(),
       _baseUrl =
           baseUrl ??
           const String.fromEnvironment(
             'WEATHER_API_BASE_URL',
             defaultValue: _defaultWeatherApiBaseUrl,
           );

  final http.Client _client;
  final String _baseUrl;
  final double latitude;
  final double longitude;

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
      throw const FormatException(
        'Weather response is missing temperature data',
      );
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
      weatherCode: (current['weather_code'] as num).toInt(),
      precipitation: (current['precipitation'] as num?)?.toDouble() ?? 0,
    );
  }

  Future<List<WeatherLocation>> searchLocations(String query) async {
    final url = Uri.https('geocoding-api.open-meteo.com', '/v1/search', {
      'name': query,
      'count': '8',
      'language': 'en',
      'format': 'json',
    });
    final response = await _client
        .get(url)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw http.ClientException(
        'Geocoding API returned HTTP ${response.statusCode}',
        url,
      );
    }
    final decoded = jsonDecode(response.body);
    final results = decoded is Map<String, dynamic>
        ? decoded['results'] as List<dynamic>?
        : null;
    if (results == null) return const [];
    return results.whereType<Map<String, dynamic>>().map((result) {
      final name = result['name'] as String?;
      final resultLatitude = result['latitude'] as num?;
      final resultLongitude = result['longitude'] as num?;
      if (name == null || resultLatitude == null || resultLongitude == null) {
        throw const FormatException('Invalid location search result');
      }
      final admin = result['admin1'] as String?;
      return WeatherLocation(
        name: admin == null ? name : '$name, $admin',
        latitude: resultLatitude.toDouble(),
        longitude: resultLongitude.toDouble(),
      );
    }).toList();
  }

  Future<List<HourlyForecastHour>> getHourlyForecast() async {
    final data = await _fetchWeather();
    final hourly = data['hourly'] as Map<String, dynamic>?;
    final times = (hourly?['time'] as List<dynamic>?)?.cast<String>();
    final temperatures = hourly?['temperature_2m'] as List<dynamic>?;
    final humidities = hourly?['relative_humidity_2m'] as List<dynamic>?;
    final weatherCodes = hourly?['weather_code'] as List<dynamic>?;

    if (times == null ||
        temperatures == null ||
        humidities == null ||
        weatherCodes == null ||
        times.length != temperatures.length ||
        times.length != humidities.length ||
        times.length != weatherCodes.length) {
      throw const FormatException('Invalid hourly forecast data');
    }

    final now = DateTime.now();
    final upcoming = <HourlyForecastHour>[];
    for (var index = 0; index < times.length && upcoming.length < 8; index++) {
      final time = DateTime.parse(times[index]);
      if (time.isBefore(now)) continue;
      upcoming.add(
        HourlyForecastHour(
          time: time,
          temperature: (temperatures[index] as num).toDouble(),
          humidity: (humidities[index] as num).toDouble(),
          weatherCode: (weatherCodes[index] as num).toInt(),
        ),
      );
    }
    return upcoming;
  }

  Future<SunMoonData> getSunMoon() async {
    final data = await _fetchWeather();
    final daily = data['daily'] as Map<String, dynamic>;
    DateTime firstDate(String key) {
      final values = daily[key] as List<dynamic>?;
      if (values == null || values.isEmpty || values.first == null) {
        throw FormatException('Weather response is missing $key');
      }
      return DateTime.parse(values.first as String);
    }

    return SunMoonData(
      sunrise: firstDate('sunrise'),
      sunset: firstDate('sunset'),
      moonrise: firstDate('moonrise'),
      moonset: firstDate('moonset'),
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
      queryParameters: {
        'lat': latitude.toString(),
        'lon': longitude.toString(),
      },
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
        decoded['daily'] is! Map<String, dynamic> ||
        decoded['hourly'] is! Map<String, dynamic>) {
      throw const FormatException('Weather API returned an invalid response');
    }
    return decoded;
  }
}
