import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../services/api_service.dart';

class ApiDataProvider extends ChangeNotifier {
  TextEditingController textEditingController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;
  WeatherModel? weatherData;
  List<WeatherModel> divisionDataList = [];

  List<String> bangladeshDivisions = [
    "Dhaka",
    "Chittagong",
    "Khulna",
    "Rajshahi",
    "Sylhet",
    "Barisal",
    "Rangpur",
    "Mymensingh"
  ];

  void addCityName({city}) {
    textEditingController.text = city;
    notifyListeners();
  }

  Future<void> fetchWeather(String cityName) async {
    isLoading = true; // Start loading
    errorMessage = null; // Reset any previous error

    try {
      final weather = await ApiService().getWeatherByCity(cityName: cityName);
      weatherData = weather;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      isLoading = false; // Stop loading
      notifyListeners();
    }
  }

  Future fetchDivisionWeather(String cityName) async {
    errorMessage = null;
    notifyListeners();
    try {
      final weather = await ApiService().getWeatherByCity(cityName: cityName);
      return weather;
    } catch (e) {
      errorMessage = e.toString().replaceAll("Exception: ", "");
      notifyListeners();
      return errorMessage;
    }
  }

  allData() async {
    for (var city = 0; city < bangladeshDivisions.length; city++) {
      isLoading = true;
      var d = await fetchDivisionWeather(
          bangladeshDivisions[city].trim().toLowerCase());
      divisionDataList.add(d);
    }

    isLoading = false;
    notifyListeners();
  }
}
