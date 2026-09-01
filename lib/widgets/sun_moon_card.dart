import 'package:flutter/material.dart';

class SunMoonSection extends StatelessWidget {
  const SunMoonSection({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),

      child: Row(
        children: [

          Expanded(
            child: _SkyCard(
              title: "☼ Sun",
              startTime: "05:00",
              endTime: "17:38",
              icon: Icons.wb_sunny_outlined,
            ),
          ),

          const SizedBox(width: 25),

          Expanded(
            child: _SkyCard(
              title: "◐ Moon",
              startTime: "20:03",
              endTime: "08:39",
              icon: Icons.nightlight_outlined,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkyCard extends StatelessWidget {

  final String title;
  final String startTime;
  final String endTime;
  final IconData icon;

  const _SkyCard({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 280,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFF4679A5),
        borderRadius: BorderRadius.circular(30),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Icon(
                icon,
                color: Colors.white70,
                size: 25,
              ),

              const SizedBox(width: 7),

              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
              ),
            ],
          ),

          const Spacer(),

          Center(
            child: Icon(
              icon,
              color: Colors.white,
              size: 70,
            ),
          ),

          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Column(
                children: [

                  Text(
                    startTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  const Text(
                    "IST",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              Column(
                children: [

                  Text(
                    endTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  const Text(
                    "IST",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}