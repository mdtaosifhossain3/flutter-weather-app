import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/api_data_provider.dart';
import 'widgets/weather_card_divisions.dart';

class AllDivisionsScreen extends StatefulWidget {
  const AllDivisionsScreen({super.key});

  @override
  State<AllDivisionsScreen> createState() => _AllDivisionsScreenState();
}

class _AllDivisionsScreenState extends State<AllDivisionsScreen> {
  bool _dataFetched = false; // Flag to prevent repeated calls

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_dataFetched) {
      _dataFetched = true;
      // Schedule the call to `allData()` after the current build is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ApiDataProvider>(context, listen: false).allData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Divisions"),
        centerTitle: true,
      ),
      body: Consumer<ApiDataProvider>(
        builder: (context, state, child) {
          return state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : state.errorMessage != null
                  ? Center(child: Text(state.errorMessage!))
                  : ListView.builder(
                      itemCount: state.divisionDataList.length,
                      itemBuilder: (context, index) {
                        final weather = state.divisionDataList[index];

                        return WeatherCard(
                          divisionName: state.bangladeshDivisions[index],
                          weatherImageUrl:
                              "https://openweathermap.org/img/wn/${weather.weather[0].icon}@2x.png",
                          temperature: weather.main.temp,
                          humidity: weather.main.humidity,
                        );
                      });
        },
      ),
    );
  }
}
