import 'package:flutter/material.dart';

import '../services/weather_service.dart';

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
  late WeatherService _weatherService;
  late Future<WeatherData> _weather;
  late Future<List<HourlyForecastHour>> _hourly;
  late Future<List<DailyForecastDay>> _daily;
  late Future<SunMoonData> _sunMoon;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  void _loadWeather() {
    _weatherService = WeatherService(
      latitude: _location.latitude,
      longitude: _location.longitude,
    );
    _weather = _weatherService.getWeather();
    _hourly = _weatherService.getHourlyForecast();
    _daily = _weatherService.getDailyForecast();
    _sunMoon = _weatherService.getSunMoon();
  }

  Future<void> _refresh() async {
    setState(_loadWeather);
    await Future.wait([_weather, _hourly, _daily, _sunMoon]);
  }

  Future<void> _selectLocation() async {
    final location = await showSearch<WeatherLocation>(
      context: context,
      delegate: _LocationSearchDelegate(WeatherService()),
    );
    if (location != null && mounted) {
      setState(() {
        _location = location;
        _loadWeather();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9F5FB),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _refresh,
          color: const Color(0xFF0877C9),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _Header(location: _location, onSearch: _selectLocation)),
              SliverToBoxAdapter(
                child: _WeatherCard(location: _location, weather: _weather),
              ),
              SliverToBoxAdapter(child: _AlertStrip()),
              SliverToBoxAdapter(child: _OutdoorCard()),
              SliverToBoxAdapter(child: _NeedsSection()),
              SliverToBoxAdapter(
                child: _ForecastRow(hourly: _hourly, daily: _daily),
              ),
              SliverToBoxAdapter(child: _DetailsRow(sunMoon: _sunMoon)),
              SliverToBoxAdapter(child: _PlaceholderRow()),
              SliverToBoxAdapter(child: _InsightCard()),
              const SliverToBoxAdapter(child: SizedBox(height: 98)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const _BottomNavigation(),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.location, required this.onSearch});

  final WeatherLocation location;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date = '${_weekday(now.weekday)}, ${now.day.toString().padLeft(2, '0')} '
        '${_month(now.month)} ${now.year}';
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0877C9), Color(0xFF45A9E7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.menu_rounded, color: Colors.white, size: 30),
              const SizedBox(width: 16),
              const Icon(Icons.location_on_rounded, color: Colors.white, size: 24),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(location.name.split(',').first,
                        style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold)),
                    Text(location.name.contains(',') ? location.name.split(',').skip(1).join(',').trim() : ' ',
                        style: const TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ),
              IconButton(onPressed: onSearch, icon: const Icon(Icons.search_rounded, color: Colors.white, size: 27)),
              const CircleAvatar(
                radius: 17,
                backgroundColor: Color(0x99FFFFFF),
                child: Text('SJ', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(date, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  const _WeatherCard({required this.location, required this.weather});

  final WeatherLocation location;
  final Future<WeatherData> weather;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherData>(
      future: weather,
      builder: (context, snapshot) {
        final data = snapshot.data;
        final loading = snapshot.connectionState == ConnectionState.waiting;
        final temp = data == null ? '--' : data.temperature.toStringAsFixed(0);
        final feels = data == null ? '--' : data.feelsLike.toStringAsFixed(0);
        final description = data == null ? 'Loading weather...' : _weatherDescription(data.weatherCode);
        return Container(
          margin: const EdgeInsets.fromLTRB(14, 8, 14, 8),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(colors: [Color(0xFF4BADE7), Color(0xFF0871B7)]),
            boxShadow: [BoxShadow(color: Colors.blueGrey.withValues(alpha: .2), blurRadius: 12, offset: const Offset(0, 5))],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(_weatherIcon(data?.weatherCode), color: Colors.white, size: 43),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(description, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(temp == '--' ? '--°C' : '$temp°C',
                            style: const TextStyle(color: Colors.white, fontSize: 48, height: 1, fontWeight: FontWeight.bold)),
                        Text('Feels like ${feels == '--' ? '--' : '$feels°C'}',
                            style: const TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                  Container(
                    width: 118,
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .78), borderRadius: BorderRadius.circular(14)),
                    child: Text(
                      loading ? 'Loading weather data...' : 'Current conditions for ${location.name.split(',').first}.',
                      style: const TextStyle(color: Color(0xFF174669), fontSize: 10, height: 1.25, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white30, height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Metric(icon: Icons.water_drop_rounded, label: 'Humidity', value: data == null ? '--' : '${data.humidity.toStringAsFixed(0)}%'),
                  _Metric(icon: Icons.air_rounded, label: 'Wind', value: data == null ? '--' : '${data.windSpeed.toStringAsFixed(0)} km/h'),
                  _Metric(icon: Icons.device_thermostat_rounded, label: 'Max / Min', value: data == null ? '--' : '${data.maxTemp.toStringAsFixed(0)}° / ${data.minTemp.toStringAsFixed(0)}°'),
                  _Metric(icon: Icons.eco_rounded, label: 'AQI', value: data?.aqi?.toStringAsFixed(0) ?? '--'),
                  const _Metric(icon: Icons.wb_sunny_rounded, label: 'UV Index', value: '--'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFBDEBFF), size: 21),
            Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 9)),
            Text(value, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ),
      );
}

class _AlertStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _SoftCard(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 7),
        color: const Color(0xFFFFE9E8),
        child: Row(children: [
          const Icon(Icons.notifications_rounded, color: Color(0xFFE52B48), size: 27),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Weather Alerts', style: TextStyle(color: Color(0xFF8F2630), fontWeight: FontWeight.bold)),
            Text('No active alerts for your location.', style: TextStyle(color: Color(0xFF4E4E57), fontSize: 11)),
          ])),
          CircleAvatar(radius: 12, backgroundColor: Color(0xFF58D19B), child: Icon(Icons.check, size: 16, color: Colors.white)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF9F5260)),
        ]),
      );
}

class _OutdoorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _SoftCard(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 7),
        color: const Color(0xFFDFF9EC),
        child: Row(children: [
          const Icon(Icons.directions_run_rounded, color: Color(0xFF159B69), size: 37),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Best Time for Outdoor Activities', style: TextStyle(color: Color(0xFF194A3A), fontWeight: FontWeight.bold, fontSize: 12)),
            Text('--:-- - --:--', style: TextStyle(color: Color(0xFF153A30), fontWeight: FontWeight.bold, fontSize: 14)),
            Text('Activity recommendation will appear when connected.', style: TextStyle(color: Color(0xFF457163), fontSize: 10)),
          ])),
          _OutlineButton(label: 'View Details'),
        ]),
      );
}

class _NeedsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const needs = [
      (Icons.directions_run_rounded, 'Fitness', Color(0xFF1475D1)),
      (Icons.favorite_rounded, 'Health', Color(0xFFD62547)),
      (Icons.directions_car_rounded, 'Commute', Color(0xFF1766B8)),
      (Icons.groups_rounded, 'Family', Color(0xFF149879)),
      (Icons.flight_rounded, 'Travel', Color(0xFF226BC3)),
      (Icons.local_florist_rounded, 'Agriculture', Color(0xFF23985B)),
      (Icons.beach_access_rounded, 'Beach', Color(0xFFE99B25)),
      (Icons.event_rounded, 'Events', Color(0xFFE02C8C)),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 1, 14, 7),
      child: Column(children: [
        const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Explore by Your Needs', style: TextStyle(color: Color(0xFF123B60), fontWeight: FontWeight.bold, fontSize: 13)),
          Text('See All', style: TextStyle(color: Color(0xFF0877C9), fontWeight: FontWeight.bold, fontSize: 11)),
        ]),
        const SizedBox(height: 5),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: needs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 5, mainAxisSpacing: 5, childAspectRatio: 1.35),
          itemBuilder: (_, index) => _SoftCard(
            color: const Color(0xFFF4F7FD),
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(needs[index].$1, color: needs[index].$3, size: 25),
              const SizedBox(height: 2),
              Text(needs[index].$2, style: const TextStyle(color: Color(0xFF274465), fontSize: 10, fontWeight: FontWeight.w600)),
            ]),
          ),
        ),
      ]),
    );
  }
}

class _ForecastRow extends StatelessWidget {
  const _ForecastRow({required this.hourly, required this.daily});
  final Future<List<HourlyForecastHour>> hourly;
  final Future<List<DailyForecastDay>> daily;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 7),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _ForecastCard(title: 'Hourly Forecast', hourly: hourly)),
          const SizedBox(width: 7),
          Expanded(child: _ForecastCard(title: '7-Day Forecast', daily: daily)),
        ]),
      );
}

class _ForecastCard extends StatelessWidget {
  const _ForecastCard({required this.title, this.hourly, this.daily});
  final String title;
  final Future<List<HourlyForecastHour>>? hourly;
  final Future<List<DailyForecastDay>>? daily;

  @override
  Widget build(BuildContext context) => _SoftCard(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(8, 9, 8, 8),
        child: FutureBuilder<dynamic>(
          future: hourly ?? daily,
          builder: (context, snapshot) {
            final items = (snapshot.data as List?)?.take(5).toList() ?? const [];
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(title, style: const TextStyle(color: Color(0xFF153D62), fontWeight: FontWeight.bold, fontSize: 13)),
                const Text('See All', style: TextStyle(color: Color(0xFF0877C9), fontWeight: FontWeight.bold, fontSize: 10)),
              ]),
              const SizedBox(height: 8),
              if (items.isEmpty)
                const SizedBox(height: 66, child: Center(child: Text('--', style: TextStyle(color: Color(0xFF7D9AB0), fontSize: 18))))
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: items.map((item) {
                    final isHour = item is HourlyForecastHour;
                    final value = isHour ? item.temperature.toStringAsFixed(0) : item.maximumTemperature.toStringAsFixed(0);
                    final label = isHour ? _timeLabel(item.time) : item.dayLabel;
                    return Column(children: [
                      Text(label, style: const TextStyle(color: Color(0xFF5B7082), fontSize: 9)),
                      Icon(_weatherIcon(isHour ? item.weatherCode : item.weatherCode), color: const Color(0xFF55A8D7), size: 20),
                      Text('$value°', style: const TextStyle(color: Color(0xFF24415F), fontSize: 11, fontWeight: FontWeight.bold)),
                    ]);
                  }).toList(),
                ),
            ]);
          },
        ),
      );
}

class _DetailsRow extends StatelessWidget {
  const _DetailsRow({required this.sunMoon});
  final Future<SunMoonData> sunMoon;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 7),
        child: Row(children: [
          Expanded(child: _SunMoonCard(sunMoon: sunMoon)),
          const SizedBox(width: 7),
          const Expanded(child: _UnavailableCard(title: 'Air Quality & Health', icon: Icons.eco_rounded, message: 'AQI data will appear here.')),
        ]),
      );
}

class _SunMoonCard extends StatelessWidget {
  const _SunMoonCard({required this.sunMoon});
  final Future<SunMoonData> sunMoon;

  @override
  Widget build(BuildContext context) => _SoftCard(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<SunMoonData>(
          future: sunMoon,
          builder: (_, snapshot) {
            final data = snapshot.data;
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [Icon(Icons.wb_sunny_rounded, color: Color(0xFFF29C23), size: 23), SizedBox(width: 7), Text('Sun & Moon', style: TextStyle(color: Color(0xFF24415F), fontWeight: FontWeight.bold, fontSize: 12)), Spacer(), Icon(Icons.chevron_right, color: Color(0xFF66849A), size: 18)]),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _TimeColumn(label: 'Sunrise', value: data == null ? '--:--' : _timeLabel(data.sunrise), icon: Icons.wb_sunny_rounded),
                _TimeColumn(label: 'Sunset', value: data == null ? '--:--' : _timeLabel(data.sunset), icon: Icons.wb_twilight_rounded),
              ]),
            ]);
          },
        ),
      );
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Column(children: [
        Icon(icon, color: const Color(0xFFF3A526), size: 23),
        Text(label, style: const TextStyle(color: Color(0xFF73879A), fontSize: 9)),
        Text(value, style: const TextStyle(color: Color(0xFF24415F), fontWeight: FontWeight.bold, fontSize: 12)),
      ]);
}

class _PlaceholderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 7),
        child: Row(children: const [
          Expanded(child: _UnavailableCard(title: 'Interactive Map', icon: Icons.map_rounded, message: 'Map data will appear here.')),
          SizedBox(width: 7),
          Expanded(child: _UnavailableCard(title: 'Community Reports', icon: Icons.groups_rounded, message: 'No connected reports yet.')),
        ]),
      );
}

class _UnavailableCard extends StatelessWidget {
  const _UnavailableCard({required this.title, required this.icon, required this.message});
  final String title;
  final IconData icon;
  final String message;
  @override
  Widget build(BuildContext context) => _SoftCard(
        color: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Row(children: [
          Icon(icon, color: const Color(0xFF0B83C8), size: 25),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Color(0xFF24415F), fontWeight: FontWeight.bold, fontSize: 11)),
            Text(message, style: const TextStyle(color: Color(0xFF71889A), fontSize: 9)),
          ])),
          const Icon(Icons.chevron_right, color: Color(0xFF66849A), size: 18),
        ]),
      );
}

class _InsightCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _SoftCard(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        child: Row(children: const [
          Icon(Icons.lightbulb_rounded, color: Color(0xFF0877C9), size: 27),
          SizedBox(width: 10),
          Text("Today's Insight", style: TextStyle(color: Color(0xFF24415F), fontWeight: FontWeight.bold, fontSize: 12)),
          SizedBox(width: 12),
          Expanded(child: Text('No insight connected yet.', style: TextStyle(color: Color(0xFF71889A), fontSize: 10))),
          Icon(Icons.chevron_right, color: Color(0xFF66849A), size: 18),
        ]),
      );
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({required this.child, required this.color, this.margin, this.padding = const EdgeInsets.all(10)});
  final Widget child;
  final Color color;
  final EdgeInsets? margin;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.blueGrey.withValues(alpha: .08), blurRadius: 5, offset: const Offset(0, 2))]),
        child: child,
      );
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: .55), borderRadius: BorderRadius.circular(18)),
        child: Text(label, style: const TextStyle(color: Color(0xFF237A5B), fontWeight: FontWeight.bold, fontSize: 10)),
      );
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation();
  @override
  Widget build(BuildContext context) => NavigationBar(
        backgroundColor: const Color(0xFF082D47),
        indicatorColor: const Color(0xFF0877C9),
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.notifications_none_rounded), label: 'Alerts'),
          NavigationDestination(icon: Icon(Icons.bookmark_border_rounded), label: 'Saved'),
          NavigationDestination(icon: Icon(Icons.apps_rounded), label: 'More'),
        ],
      );
}

class _LocationSearchDelegate extends SearchDelegate<WeatherLocation> {
  _LocationSearchDelegate(this._service);
  final WeatherService _service;
  @override
  List<Widget>? buildActions(BuildContext context) => [if (query.isNotEmpty) IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.arrow_back));
  @override
  Widget buildResults(BuildContext context) => _results();
  @override
  Widget buildSuggestions(BuildContext context) => _results();
  Widget _results() {
    if (query.trim().length < 2) return const Center(child: Text('Enter a city or location'));
    return FutureBuilder<List<WeatherLocation>>(
      future: _service.searchLocations(query.trim()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return const Center(child: Text('Unable to search locations'));
        final locations = snapshot.data ?? const [];
        if (locations.isEmpty) return const Center(child: Text('No locations found'));
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

IconData _weatherIcon(int? code) {
  if (code == null) return Icons.cloud_queue_rounded;
  if (code <= 1) return Icons.wb_sunny_rounded;
  if (code <= 3) return Icons.cloud_rounded;
  if (code >= 95) return Icons.thunderstorm_rounded;
  return Icons.water_drop_rounded;
}

String _weatherDescription(int code) {
  if (code == 0) return 'Clear';
  if (code <= 3) return 'Partly Cloudy';
  if (code >= 95) return 'Thunderstorm';
  if (code >= 51) return 'Rain';
  return 'Overcast';
}

String _timeLabel(DateTime value) => '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
String _month(int month) => const ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'][month - 1];
String _weekday(int day) => const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'][day - 1];
