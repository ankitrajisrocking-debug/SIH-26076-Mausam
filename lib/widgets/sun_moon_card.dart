import 'package:flutter/material.dart';

class SunMoonSection extends StatelessWidget {
  const SunMoonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _SkyCard(
              title: 'Sun',
              startTime: '05:00',
              endTime: '17:38',
              icon: Icons.wb_sunny_rounded,
              accent: const Color(0xFFFFD166),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _SkyCard(
              title: 'Moon',
              startTime: '20:03',
              endTime: '08:39',
              icon: Icons.nightlight_round_rounded,
              accent: const Color(0xFFB9C8FF),
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
  final Color accent;

  const _SkyCard({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
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
          Icon(
            icon,
            color: accent,
            size: 52,
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'IST',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'IST',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
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