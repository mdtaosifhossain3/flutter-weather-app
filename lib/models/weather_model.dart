class WeatherModel {
  WeatherModel({
    required this.weather,
    required this.main,
    required this.visibility,
    required this.wind,
    required this.name,
  });

  late final List<Weather> weather;
  late final Main main;
  late final visibility;
  late final Wind wind;
  late final String name;

  WeatherModel.fromJson(Map<String, dynamic> json) {
    weather =
        List.from(json['weather']).map((e) => Weather.fromJson(e)).toList();

    main = Main.fromJson(json['main']);
    visibility = json['visibility'];
    wind = Wind.fromJson(json['wind']);

    name = json['name'];
  }
}

class Weather {
  Weather({
    required this.main,
    required this.description,
    required this.icon,
  });

  late final String main;
  late final String description;
  late final String icon;

  Weather.fromJson(Map<String, dynamic> json) {
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
  }
}

class Main {
  Main({
    required this.temp,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.humidity,
  });
  late final temp;
  late final feelsLike;
  late final tempMin;
  late final tempMax;
  late final pressure;
  late final humidity;

  Main.fromJson(Map<String, dynamic> json) {
    temp = json['temp'];
    feelsLike = json['feels_like'];
    tempMin = json['temp_min'];
    tempMax = json['temp_max'];
    pressure = json['pressure'];
    humidity = json['humidity'];
  }
}

class Wind {
  Wind({
    required this.speed,
  });
  late final speed;

  Wind.fromJson(Map<String, dynamic> json) {
    speed = json['speed'];
  }
}
