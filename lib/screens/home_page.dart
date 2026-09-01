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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07569A),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [

              // Top blue header
              TopHeader(),

              SizedBox(height: 20),

              // Current temperature + humidity + wind
              CurrentWeather(),

              SizedBox(height: 20),

              // 3-hour weather
              HourlyForecast(),

              SizedBox(height: 20),

              // Agromet + Crowd Source
              ActionButtons(),

              SizedBox(height: 20),

              // Weather warning
              AlertCard(),

              SizedBox(height: 15),

              // Interactive map button
              InteractiveMapButton(),

              SizedBox(height: 25),

              // 7-day forecast
              DailyForecast(),

              SizedBox(height: 25),

              // Sun and moon
              SunMoonSection(),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}