import 'package:flutter/material.dart';

import '../services/weather_service.dart';
import '../widgets/top_header.dart';
import '../widgets/current_weather.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/action_buttons.dart';
import '../widgets/alert_card.dart';
import '../widgets/daily_forecast.dart';
import '../widgets/sun_moon_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherLocation _location = const WeatherLocation(
    name: 'NIT Silchar',
    latitude: 24.75,
    longitude: 92.79,
  );

  Future<void> _selectLocation() async {
    final location = await showSearch<WeatherLocation>(
      context: context,
      delegate: _LocationSearchDelegate(WeatherService()),
    );
    if (location != null && mounted) {
      setState(() => _location = location);
    }
  }

  Future<void> refreshWeather() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A5C9C), Color(0xFF061C2D)],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: refreshWeather,
            color: Colors.white,
            backgroundColor: const Color(0xFF0B6DB6),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 28),
              child: Column(
                children: [
                  TopHeader(
                    locationName: _location.name,
                    onSearch: _selectLocation,
                  ),
                  SizedBox(height: 20),
                  CurrentWeather(
                    weatherService: WeatherService(
                      latitude: _location.latitude,
                      longitude: _location.longitude,
                    ),
                  ),
                  SizedBox(height: 20),
                  HourlyForecast(
                    weatherService: WeatherService(
                      latitude: _location.latitude,
                      longitude: _location.longitude,
                    ),
                  ),
                  SizedBox(height: 20),
                  ActionButtons(),
                  SizedBox(height: 20),
                  AlertCard(
                    locationName: _location.name,
                    weatherService: WeatherService(
                      latitude: _location.latitude,
                      longitude: _location.longitude,
                    ),
                  ),
                  SizedBox(height: 16),
                  InteractiveMapButton(),
                  SizedBox(height: 24),
                  DailyForecast(
                    weatherService: WeatherService(
                      latitude: _location.latitude,
                      longitude: _location.longitude,
                    ),
                  ),
                  SizedBox(height: 24),
                  SunMoonSection(
                    weatherService: WeatherService(
                      latitude: _location.latitude,
                      longitude: _location.longitude,
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LocationSearchDelegate extends SearchDelegate<WeatherLocation> {
  _LocationSearchDelegate(this._service);

  final WeatherService _service;

  @override
  List<Widget>? buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () => Navigator.of(context).pop(),
    icon: const Icon(Icons.arrow_back),
  );

  @override
  Widget buildResults(BuildContext context) => _results();

  @override
  Widget buildSuggestions(BuildContext context) => _results();

  Widget _results() {
    if (query.trim().length < 2) {
      return const Center(child: Text('Enter a city or location'));
    }
    return FutureBuilder<List<WeatherLocation>>(
      future: _service.searchLocations(query.trim()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Unable to search locations'));
        }
        final locations = snapshot.data ?? const [];
        if (locations.isEmpty) {
          return const Center(child: Text('No locations found'));
        }
        return ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, index) => ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(locations[index].name),
            onTap: () => close(context, locations[index]),
          ),
        );
      },
    );
  }
}
