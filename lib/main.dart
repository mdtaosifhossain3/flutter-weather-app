import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/api_data_provider.dart';
import 'package:weather_app/providers/lat_lon_provider.dart';
import 'package:weather_app/screens/otpView/otp_verify_view.dart';
import 'package:weather_app/screens/splashScreen/splash_screen.dart';

void main() async {

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ApiDataProvider()),
    ChangeNotifierProvider(create: (_) => LatLonProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}
