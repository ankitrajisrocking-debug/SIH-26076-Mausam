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
  DateTime? updatedAt;

  @override
  void initState() {
    super.initState();
    loadTemperature();
  }

  Future<void> loadTemperature() async {

    try {

      final temp = await weatherService.getTemperature();

      setState(() {
        temperature = temp;

        updatedAt = DateTime.now();
      });

    } catch (e) {

      print("Error loading temperature: $e");

    }
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: const Color(0xFF07569A),
          borderRadius: BorderRadius.circular(25),
        ),

        child: Column(
          children: [

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      // 🔥 LIVE TEMPERATURE
                      Text(
                        temperature == null
                            ? "--°C"
                            : "${temperature!.toStringAsFixed(1)}°C",

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 58,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Updated At   --:--",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        "Feels Like   --°C",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        "Maximum  --°C",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 15),

                      const Text(
                        "Minimum  --°C",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Row(
                        children: [

                          Icon(
                            Icons.water_drop,
                            color: Colors.white,
                            size: 25,
                          ),

                          SizedBox(width: 5),

                          Text(
                            "--%",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // WIND
                Column(
                  children: [

                    const SizedBox(height: 25),

                    Container(
                      width: 170,
                      height: 170,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white70,
                          width: 4,
                        ),
                      ),

                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [

                            Icon(
                              Icons.navigation,
                              color: Colors.redAccent,
                              size: 35,
                            ),

                            SizedBox(height: 5),

                            Text(
                              "4.4",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              "Km/h",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // AQI
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),

                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),

                  child: const Text(
                    "AQI 53",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),

                  decoration: const BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),

                  child: const Text(
                    "Satisfactory",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 5),

            const Text(
              "National AQI-Source-CPCB",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}