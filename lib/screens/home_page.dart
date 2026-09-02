import 'package:flutter/material.dart';

import '../widgets/top_header.dart';
import '../widgets/current_weather.dart';
import '../widgets/hourly_forecast.dart';
import '../widgets/action_buttons.dart';
import '../widgets/alert_card.dart';
import '../widgets/daily_forecast.dart';
import '../widgets/sun_moon_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> refreshWeather() async {
    await Future.delayed(const Duration(milliseconds: 900));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A5C9C),
              Color(0xFF061C2D),
            ],
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
              child: const Column(
                children: [
                  TopHeader(),
                  SizedBox(height: 20),
                  CurrentWeather(),
                  SizedBox(height: 20),
                  HourlyForecast(),
                  SizedBox(height: 20),
                  ActionButtons(),
                  SizedBox(height: 20),
                  AlertCard(),
                  SizedBox(height: 16),
                  InteractiveMapButton(),
                  SizedBox(height: 24),
                  DailyForecast(),
                  SizedBox(height: 24),
                  SunMoonSection(),
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