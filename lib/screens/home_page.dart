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

    // 🆕 NEW
  Future<void> refreshWeather() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07569A),

      body: SafeArea(
  // 🆕 NEW
  child: RefreshIndicator(
    onRefresh: refreshWeather,

    child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), 
          child: Column(
            children: const [

              TopHeader(),

              SizedBox(height: 20),

              CurrentWeather(),

              SizedBox(height: 20),

              HourlyForecast(),

              SizedBox(height: 20),

              ActionButtons(),

              SizedBox(height: 20),

              AlertCard(),

              SizedBox(height: 15),

              InteractiveMapButton(),

              SizedBox(height: 25),

              DailyForecast(),

              SizedBox(height: 25),

              SunMoonSection(),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    )
    );
  }
}