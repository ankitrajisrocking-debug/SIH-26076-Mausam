import 'package:flutter/material.dart';

import '../services/weather_service.dart';

class SunMoonSection extends StatelessWidget {
  const SunMoonSection({super.key, required this.weatherService});

  final WeatherService weatherService;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FutureBuilder<SunMoonData>(
        future: weatherService.getSunMoon(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 220,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          }
          if (snapshot.hasError) {
            return const SizedBox(
              height: 220,
              child: Center(
                child: Text(
                  'Unable to load sun and moon times.',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            );
          }

          final data = snapshot.data!;
          return LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 380;
              final cardHeight = (constraints.maxWidth * 0.58).clamp(
                180.0,
                220.0,
              );
              final cards = [
                _SkyCard(
                  title: 'Sun',
                  startTime: data.sunrise,
                  endTime: data.sunset,
                  icon: Icons.wb_sunny_rounded,
                  accent: const Color(0xFFFFD166),
                  height: cardHeight,
                ),
                _SkyCard(
                  title: 'Moon',
                  startTime: data.moonrise,
                  endTime: data.moonset,
                  icon: Icons.nightlight_round_rounded,
                  accent: const Color(0xFFB9C8FF),
                  height: cardHeight,
                ),
              ];
              return compact
                  ? Column(
                      children: [
                        cards[0],
                        const SizedBox(height: 16),
                        cards[1],
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: cards[0]),
                        const SizedBox(width: 16),
                        Expanded(child: cards[1]),
                      ],
                    );
            },
          );
        },
      ),
    );
  }
}

class _SkyCard extends StatelessWidget {
  const _SkyCard({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.icon,
    required this.accent,
    required this.height,
  });

  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final IconData icon;
  final Color accent;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: accent, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(icon, color: accent, size: 52),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TimeValue(value: startTime),
              _TimeValue(value: endTime),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeValue extends StatelessWidget {
  const _TimeValue({required this.value});

  final DateTime value;

  @override
  Widget build(BuildContext context) {
    final time =
        '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
    return Column(
      children: [
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Text(
          'IST',
          style: TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
