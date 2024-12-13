import "dart:convert";
import "dart:io";
import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import "package:weather_app/models/weather_model.dart";

class ApiService {
  Future<WeatherModel?> getWeather() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    double? lat = sharedPreferences.getDouble("LAT");
    double? lon = sharedPreferences.getDouble("LON");

    print("Lat: $lat");
    try {
      var res = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=${lat ?? 23.8041}&lon=${lon ?? 90.4152}&appid=8c71ecf671ff0b5ca0ae59f155cc8f27&units=metric"));

      if (res.statusCode == 200) {
        var jsonData = jsonDecode(res.body);

        var weatherData = WeatherModel.fromJson(jsonData);

        if (kDebugMode) {
          print("Weather Data: $weatherData");
        }
        return weatherData;
      }
      throw Exception("error");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception("Something Went Wrong");
    }
  }

  Future<WeatherModel?> getWeatherByCity({required String cityName}) async {
    try {
      var res = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=b1cb26993ffeacb28752e8a095593c75&units=metric"));

      if (res.statusCode == 200) {
        var jsonData = jsonDecode(res.body);
        return WeatherModel.fromJson(jsonData);
      } else if (res.statusCode == 404) {
        throw Exception("City not found. Please enter a valid city name.");
      } else {

        throw Exception("Failed to fetch weather data.");
      }
    } on SocketDirection{
      throw Exception("Network Issue");
    }  catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
      throw Exception("Something went wrong. ${e.toString()}");
    }
  }
}
