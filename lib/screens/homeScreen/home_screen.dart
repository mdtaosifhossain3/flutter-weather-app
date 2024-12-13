// Home Screen Content (Weather Details Screen)
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_app/providers/lat_lon_provider.dart';
import 'package:weather_app/screens/otpView/otp_send_view.dart';
import 'package:weather_app/widgets/weather_card.dart';

import '../../colors/colors.dart';
import '../../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  @override
  void initState() {
    checkLocationService(); // Added check for location services
    checkAndRequestPermission(); // Added comprehensive permission handling
    super.initState();
  }

  double? currentLat;
  double? currentLon;

  Future<void> checkLocationService() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      if (kDebugMode) {
        print("Location services are disabled");
      }
      // Prompt user to enable location services
      await Geolocator.openLocationSettings();
    }
  }

  Future<void> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Request permission if denied or denied forever
      permission = await Geolocator.requestPermission();
    }

    // Handle Android 11+ background location separately
    if (Platform.isAndroid && permission == LocationPermission.whileInUse) {
      if (kDebugMode) {
        print("Requesting background location permission");
      }
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // Permission granted, proceed with getting the location
      getCurrentLocation();
    } else {
      if (kDebugMode) {
        print("Permission still denied");
      }
      // Open app settings to allow the user to enable permissions
      await Geolocator.openAppSettings();
    }
  }

  Future<void> getCurrentLocation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (kDebugMode) {
        print("Location Denied");
      }
      // Retry requesting permission
      await Geolocator.requestPermission();
      setState(() {});
      return;
    } else {
      try {
        // Request high accuracy location settings
        LocationSettings locationSettings = const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        );
        Position currentPosition = await Geolocator.getCurrentPosition(
            locationSettings: locationSettings);

        setState(() {
          currentLat = currentPosition.latitude;
          currentLon = currentPosition.longitude;
          sharedPreferences.setDouble("LAT", currentLat!);
          sharedPreferences.setDouble("LON", currentLon!);
        });
      } catch (e) {
        if (kDebugMode) {
          print("Error fetching location: $e");
        }
      }
    }
  }

  // Function to send a message to the SMS app
  Future<void> sendStopMessage() async {
    const phoneNumber = '21213';
    const message = 'STOP atms';

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': message}, // pre-fill message
    );

    // Check if the URL can be launched (i.e., if SMS is available)
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri); // Opens SMS app with pre-filled message
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch SMS')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("The Lat: $currentLat");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            Colors.transparent, // Transparent for seamless transition
        elevation: 0, // Remove shadow
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                  onPressed: () async {
                    await showPopover(
                        context: context,
                        bodyBuilder: (context) => Column(
                              children: [
                                TextButton(
                                    onPressed: () async {
                                      await sendStopMessage();
                                      await Future.delayed(
                                          const Duration(seconds: 6));
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) {
                                        return OtpSendView();
                                      }));
                                    },
                                    child: const Text(
                                      "Unsubscribe",
                                      style: TextStyle(color: Colors.red),
                                    ))
                              ],
                            ),
                        width: 120,
                        height: 50,
                        backgroundColor: MyColors.blackColor,
                        direction: PopoverDirection.bottom);
                  },
                  icon: const Icon(
                    Icons.logout_outlined,
                    color: Colors.white,
                  ));
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff47BFDF), Color(0xff4A91FF)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: FutureBuilder(
              future: _apiService.getWeather(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                      child:
                          Text("No data available")); // Handle null data case
                }
                final weather = snapshot.data;

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            " ${weather!.name}",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat("MMMM d, y").format(DateTime.now()),
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white70),
                          ),
                          Text(
                            DateFormat("h:mm a").format(DateTime.now()),
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white70),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .27,
                            decoration: const BoxDecoration(),
                            child: Image.network(
                              "http://openweathermap.org/img/wn/${weather.weather[0].icon}@4x.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(weather.weather[0].description.toString(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                          Text(
                            "${weather.main.temp}°C",
                            style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 8,
                        color: Colors.white.withOpacity(0.85),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 24.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  WeatherDetailCard(
                                    label: 'Feels Like',
                                    value: "${weather.main.feelsLike}°C",
                                  ),
                                  WeatherDetailCard(
                                    label: 'Min Temp',
                                    value: "${weather.main.tempMin}°C",
                                  ),
                                  WeatherDetailCard(
                                    label: 'Max Temp',
                                    value: "${weather.main.tempMax}°C",
                                  ),
                                ],
                              ),
                              Divider(color: Colors.blue.shade200),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  WeatherDetailCard(
                                    label: 'Wind',
                                    value: "${weather.wind.speed}km/h",
                                  ),
                                  WeatherDetailCard(
                                    label: 'Humidity',
                                    value: "${weather.main.humidity}%",
                                  ),
                                  WeatherDetailCard(
                                    label: 'Pressure',
                                    value: "${weather.main.pressure}hPa",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}
