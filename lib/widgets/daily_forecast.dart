import 'package:flutter/material.dart';

class DailyForecast extends StatelessWidget {
  const DailyForecast({super.key});

  @override
  Widget build(BuildContext context) {

    final days = [
      ["01/09", "Today", "26.0°", "33.0°", Icons.thunderstorm],
      ["02/09", "Wednesday", "26.0°", "33.0°", Icons.thunderstorm],
      ["03/09", "Thursday", "25.0°", "32.0°", Icons.thunderstorm],
      ["04/09", "Friday", "25.0°", "32.0°", Icons.cloud],
      ["05/09", "Saturday", "25.0°", "31.0°", Icons.cloud],
      ["06/09", "Sunday", "25.0°", "31.0°", Icons.cloud],
      ["07/09", "Monday", "25.0°", "31.0°", Icons.cloud],
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),

      padding: const EdgeInsets.all(25),

      decoration: BoxDecoration(
        color: const Color(0xFF4679A5),
        borderRadius: BorderRadius.circular(30),
      ),

      child: Column(
        children: days.map((day) {

          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),

            child: Row(
              children: [

                SizedBox(
                  width: 75,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(
                        day[0].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        day[1].toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 25),

                Icon(
                  day[4] as IconData,
                  color: Colors.white,
                  size: 38,
                ),

                const SizedBox(width: 25),

                Text(
                  day[2].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Container(
                    height: 15,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),

                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFFC107),
                          Color(0xFFFF0000),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                Text(
                  day[3].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(width: 10),

                const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          );

        }).toList(),
      ),
    );
  }
}