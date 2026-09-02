import 'dart:convert';
import 'package:http/http.dart' as http;

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
    final url = Uri.parse(
      'http://10.0.2.2:5000/weather?lat=24.75&lon=92.79',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

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
    } else {
      throw Exception('Failed to load weather');
    }
  }
}