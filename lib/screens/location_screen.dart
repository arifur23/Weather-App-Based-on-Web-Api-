import 'package:clima_weather_app/screens/city_screen.dart';
import 'package:clima_weather_app/services/weather.dart';
import 'package:clima_weather_app/utilities/constants.dart';
import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
   LocationScreen({Key? key, @required this.weatherData}) : super(key: key);
   var weatherData;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  WeatherModel weather = WeatherModel();

  late int temperature;
  late String weatherIcon;
  late String cityName;
  late String weatherMessage;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    updateUi(widget.weatherData);

  }

  void updateUi(dynamic weatherData){

     setState(() {
       if(weatherData == null){
         temperature = 0;
         weatherIcon = "Error";
         weatherMessage = "Unable to get weather data";
         cityName = '';
         return;
       }
       double temp = weatherData['main']['temp'];
       temperature = temp.toInt();
       var condition = weatherData['weather'][0]['id'];
       cityName = weatherData['name'];

       weatherIcon = weather.getWeatherIcon(condition);

       weatherMessage = weather.getMessage(temperature);
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUi(weatherData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const CityScreen();
                        }
                      ));
                      if(typedName != null){
                        var weatherData = await weather.getCityWeather(typedName);
                        updateUi(weatherData);
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children:  <Widget>[
                    Text(
                      '$temperature °',
                      style: kTempTextStyle,
                    ),
                     Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
               Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weatherMessage in $cityName",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// double temperature = decodedData['main']['temp'];
// print(temperature);
// int condition = decodedData['weather'][0]['id'];
// String cityName = decodedData['name'];
// print(condition);
// print(cityName);