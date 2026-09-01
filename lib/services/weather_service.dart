import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<double> getTemperature() async {

    final url = Uri.parse(
      'http://192.168.77.91:5000/weather?lat=24.75&lon=92.79',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return (data['current']['temperature_2m'] as num).toDouble();

    } else {

      throw Exception('Failed to load weather');
    }
  }
}