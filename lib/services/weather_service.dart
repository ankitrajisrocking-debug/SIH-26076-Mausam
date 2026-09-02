import 'dart:convert';

import 'package:http/http.dart' as http;

<<<<<<< HEAD
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
}

class WeatherService {
  Future<double> getTemperature() async {
=======
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
  Future<WeatherData> getWeather() async {
>>>>>>> e0f479ca78572a3c6ffa68cf445970a56026cc5c
    final url = Uri.parse(
      'http://10.0.2.2:5000/weather?lat=24.75&lon=92.79',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
<<<<<<< HEAD
      return (data['current']['temperature_2m'] as num).toDouble();
=======

      return WeatherData(
        temperature:
            (data['current']['temperature_2m'] as num).toDouble(),

        feelsLike:
            (data['current']['apparent_temperature'] as num).toDouble(),

        humidity:
            (data['current']['relative_humidity_2m'] as num).toDouble(),

        windSpeed:
            (data['current']['wind_speed_10m'] as num).toDouble(),

        windDirection:
            (data['current']['wind_direction_10m'] as num).toDouble(),

        maxTemp:
            (data['daily']['temperature_2m_max'][0] as num).toDouble(),

        minTemp:
            (data['daily']['temperature_2m_min'][0] as num).toDouble(),

         aqi:
            (data['air_quality']['current']['us_aqi'] as num).toDouble(),   
      );
>>>>>>> e0f479ca78572a3c6ffa68cf445970a56026cc5c
    } else {
      throw Exception('Failed to load weather');
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
