import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/api_data_provider.dart';
import 'package:weather_app/screens/homeScreen/home_screen.dart';
import 'package:weather_app/screens/mainScreen/main_screen.dart';
import 'package:weather_app/widgets/weather_info_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ApiDataProvider provider = Provider.of<ApiDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WeatherHomeScreen();
                })),
            child: const Icon(Icons.arrow_back)),
        title: const Text("Search"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 5),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Consumer<ApiDataProvider>(builder: (context, state, child) {
                    return TextFormField(
                      controller: state.textEditingController,
                      decoration: InputDecoration(
                          hintText: "Search City Name Here....",
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                  color: Colors.blue, width: 2.00))),
                    );
                  }),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .03,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        if (provider.textEditingController.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please Enter a city")));
                          return;
                        }
                        FocusScope.of(context).unfocus();
                        await provider.fetchWeather(provider
                            .textEditingController.text
                            .trim()
                            .toLowerCase());
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            Colors.blue, // Set background color to blue
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 60.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        "Search",
                        style: TextStyle(
                          color: Colors.white, // Text color to white
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .03,
                  ),
                  Consumer<ApiDataProvider>(builder: (context, state, child) {
                    return state.isLoading
                        ? Center(
                            child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * .2,
                              ),
                              const CircularProgressIndicator(),
                            ],
                          )) // Show loading indicator
                        : state.errorMessage != null
                            ? Text(state.errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red))
                            : state.weatherData != null
                                ? WeatherInfoCard(
                                    cityName: state.weatherData!.name,
                                    weatherIconUrl:
                                        "http://openweathermap.org/img/wn/${state.weatherData!.weather[0].icon}@2x.png",
                                    description: state
                                        .weatherData!.weather[0].description,
                                    temperature: state.weatherData!.main.temp,
                                    feelsLike:
                                        state.weatherData!.main.feelsLike,
                                    tempMin: state.weatherData!.main.tempMin,
                                    tempMax: state.weatherData!.main.tempMax,
                                    humidity: state.weatherData!.main.humidity,
                                    pressure: state.weatherData!.main.pressure,
                                    windSpeed: state.weatherData!.wind.speed,
                                    visibility: state.weatherData!.visibility,
                                  )
                                : const Text(
                                    "Enter a city name to get weather data");
                  })
                ],
              ),
            )),
      ),
    );
  }
}
