import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService {
  Future<double> getTemperature() async {

    final url = Uri.parse(
      'http://10.0.2.2:5000/weather?lat=24.75&lon=92.79',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return (data['current']['temperature_2m'] as num).toDouble();

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
