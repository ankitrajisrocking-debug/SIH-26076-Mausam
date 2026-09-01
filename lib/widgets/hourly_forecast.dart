import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  const HourlyForecast({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> hours = [
      {
        "time": "14:30",
        "weather": "Overcast Sky",
        "temp": "29.7°C",
        "humidity": "73%",
        "icon": Icons.cloud,
      },
      {
        "time": "17:30",
        "weather": "Rain",
        "temp": "25.7°C",
        "humidity": "90%",
        "icon": Icons.thunderstorm,
      },
      {
        "time": "20:30",
        "weather": "Overcast Sky",
        "temp": "25.2°C",
        "humidity": "93%",
        "icon": Icons.cloud,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFF4679A5),
        borderRadius: BorderRadius.circular(30),
      ),

      child: Column(
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: hours.map((hour) {

              return Column(
                children: [

                  const Text(
                    "01 September",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    hour["time"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Icon(
                    hour["icon"],
                    color: Colors.white,
                    size: 40,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    hour["weather"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    hour["temp"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      const Icon(
                        Icons.water_drop_outlined,
                        color: Colors.white,
                        size: 22,
                      ),

                      Text(
                        hour["humidity"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              );

            }).toList(),
          ),

          const SizedBox(height: 15),

          Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(
              vertical: 15,
            ),

            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(30),
            ),

            child: const Center(
              child: Text(
                "3-Hourly  ›",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}