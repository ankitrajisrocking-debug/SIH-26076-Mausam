import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  const AlertCard({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),

      padding: const EdgeInsets.all(25),

      decoration: BoxDecoration(
        color: const Color(0xFFFFC107),
        borderRadius: BorderRadius.circular(35),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Row(
            children: [

              Icon(
                Icons.location_on_outlined,
                size: 30,
              ),

              SizedBox(width: 10),

              Text(
                "CACHAR",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Icon(
                Icons.warning_amber_outlined,
                size: 27,
              ),

              SizedBox(width: 15),

              Expanded(
                child: Text(
                  "- Light rain: < 5 mm/hr\n\n"
                  "- Light Thunderstorms with maximum surface "
                  "wind speed less than 40 kmph (In gusts)",
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          Row(
            children: [

              Expanded(
                child: _InfoBox(
                  title: "Date of Issue",
                  value: "2026-09-01 1600\nHours",
                  icon: Icons.calendar_month,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: _InfoBox(
                  title: "Valid up to",
                  value: "2026-09-01 1900\nHours",
                  icon: Icons.event_available,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(
              vertical: 18,
            ),

            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(30),
            ),

            child: const Center(
              child: Text(
                "ALERT (BE PREPARED)",
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {

  final String title;
  final String value;
  final IconData icon;

  const _InfoBox({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Icon(
                icon,
                size: 20,
              ),

              const SizedBox(width: 7),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class InteractiveMapButton extends StatelessWidget {
  const InteractiveMapButton({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),

      width: double.infinity,
      height: 70,

      decoration: BoxDecoration(
        color: Colors.white38,
        borderRadius: BorderRadius.circular(35),
      ),

      child: const Center(
        child: Text(
          "Interactive Map  ›",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}