// Home Screen Content (Weather Details Screen)
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/lat_lon_provider.dart';
import 'package:weather_app/widgets/weather_card.dart';

import '../../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  bool _dataFetched = false; // Flag to prevent repeated calls

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dataFetched) {
      _dataFetched = true;
      // Schedule the call to `allData()` after the current build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<LatLonProvider>(context, listen: false)
            .getCurrentLocation();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
