import 'package:flutter/material.dart';

import '../services/weather_service.dart';

class AlertCard extends StatefulWidget {
  const AlertCard({
    super.key,
    required this.locationName,
    required this.weatherService,
  });

  final String locationName;
  final WeatherService weatherService;

  @override
  State<AlertCard> createState() => _AlertCardState();
}

class _AlertCardState extends State<AlertCard> {
  WeatherData? _weather;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  @override
  void didUpdateWidget(covariant AlertCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weatherService.latitude != widget.weatherService.latitude ||
        oldWidget.weatherService.longitude != widget.weatherService.longitude) {
      _loadWeather();
    }
  }

  Future<void> _loadWeather() async {
    try {
      final weather = await widget.weatherService.getWeather();
      if (mounted) setState(() => _weather = weather);
    } catch (error) {
      debugPrint('Error loading alert weather data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final issuedAt = DateTime.now();
    final validUntil = issuedAt.add(const Duration(hours: 3));
    final rain =
        _weather != null &&
        (_weather!.weatherCode >= 51 || _weather!.precipitation > 0);
    final alertText = rain
        ? '- Precipitation: ${_weather?.precipitation.toStringAsFixed(1) ?? '--'} mm'
        : '- No precipitation detected at the current location';
    final status = rain ? 'ALERT (BE PREPARED)' : 'NO ACTIVE ALERT';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFD06B), Color(0xFFFFA726)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = (constraints.maxWidth * 0.06).clamp(
            14.0,
            22.0,
          );
          final titleSize = (constraints.maxWidth * 0.07).clamp(18.0, 26.0);
          final bodySize = (constraints.maxWidth * 0.042).clamp(13.0, 16.0);
          return Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 28,
                      color: Color(0xFF0A2C44),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.locationName.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A2C44),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 24,
                      color: Color(0xFF0A2C44),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        alertText,
                        style: TextStyle(
                          fontSize: bodySize,
                          height: 1.4,
                          color: Color(0xFF0A2C44),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _InfoBox(
                        title: 'Date of issue',
                        value: _formatDateTime(issuedAt),
                        icon: Icons.calendar_today_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _InfoBox(
                        title: 'Valid up to',
                        value: _formatDateTime(validUntil),
                        icon: Icons.event_available_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Center(
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: (constraints.maxWidth * 0.047).clamp(
                          15.0,
                          18.0,
                        ),
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A2C44),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDateTime(DateTime value) =>
      '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}\n'
      '${value.hour.toString().padLeft(2, '0')}${value.minute.toString().padLeft(2, '0')} hours';
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF0A2C44)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF0A2C44),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0A2C44),
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, color: Colors.white, size: 24),
            SizedBox(width: 10),
            Text(
              'Interactive Map',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
