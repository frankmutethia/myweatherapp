import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../util/utils.dart' as util;

class Weather extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  String _cityEntered; //private string used to ensure change in input of city

  Future _goToNextScreen(BuildContext context) async {
    // goToNextScreen is what will be called on clicking the menu icon
    Map results = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return ChangeCity();
    }));
    if (results != null && results.containsKey('enter')) {
      _cityEntered = results['enter'];
      // print("From First Screen"+ results['enter'].toString());//will display the city input
    }
  }

  void showStuff() async {
    Map data = await getWeather(util.appId, util.defaultcity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Weather by Ragnar'),
        centerTitle: true,
        backgroundColor: Colors.orange,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(
                  Icons.menu), //will display the menu icon on the appbar
              onPressed: () {
                _goToNextScreen(context);
              } // currently passes to the next screenwith all its content// () => debugPrint("Hey") //method debugPrint is defined
              ),
        ],
      ),
      body: new Stack(
        // in a stack most things are relative to other objects
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'assets/images/beach.jpg',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: Text(
              '${_cityEntered == null ? util.defaultcity : _cityEntered}',
              style: cityStyle(),
            ),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset('assets/images/light_rain.png'),
          ),
          updateTempWidget(_cityEntered)

          // new Container(//future build class will be used on the container that is to be changed
          //margin: const EdgeInsets.fromLTRB(30.0, 310.0, 0.0, 0.0),
          //alignment: Alignment.center,
          // child: updateTempWidget(_cityEntered),// we should pass a String here
          // ),
        ],
      ),
    );
  }

// when using future remember to return a future type
  Future<Map> getWeather(String appId, String city) async {
    //(step4)it then goes to the server to fetch json data
    String apiUrl =
        'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}&units=metric';
//this is the api address which will allow us to fetch data
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    //(step1)update widget is initially called, passing the city initially called in the string(currently Beira)
    return new FutureBuilder(
        // allows receiving of any data of future type//(step2)FutureBuilder is then run
        future: getWeather(
            util.appId,
            city == null
                ? util.defaultcity
                : city), // finally used to change the city as per the feedback    //(step3) future passes the getWeather to retrieve data
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          //(step5)the snapshot makes sure there is the availability of data
// where all the json data will be gotten, and setting up of widgets etc.
          if (snapshot.hasData) {
            //send map data to snapshot
            Map content = snapshot.data;
            return new Container(
                margin: const EdgeInsets.fromLTRB(30, 250, 0.0, 0.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new ListTile(
                      title: new Text(
                        content['main']['temp'].toString() + "C",
                        style: new TextStyle(
                          //styling of the fetched content
                          fontStyle: FontStyle.normal,
                          fontSize: 45.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: ListTile(
                        title: Text(
                          "Humidity:${content['main']['humidity'].toString()}\n"
                          "Min:${content['main']['temp_min'].toString()} C\n"
                          "Max:${content['main']['temp_max'].toString()} C\n",
                          style: extraData(),
                        ),
                      ),
                    )
                  ],
                ));
          } else {
            return new Container();
          }
        });
  }
}

class ChangeCity extends StatelessWidget {
  var _cityFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChangeCity'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/images/white_snow.png',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              //width: 490.0 ,
              // height: 800.0,
              fit: BoxFit.fill,
            ),
          ),
          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter City',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              ListTile(
                title: FlatButton(
                    onPressed: () {
                      Navigator.pop(
                          context, {'enter': _cityFieldController.text});
                    },
                    textColor: Colors.white70,
                    color: Colors.red,
                    child: Text('Get Weather')),
              ),
            ],
          )
        ],
      ),
    );
  }
}

TextStyle cityStyle() {
  return new TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

TextStyle tempStyle() {
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 49.9,
  );
}

TextStyle extraData() {
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    //fontWeight: FontWeight.w500,
    fontSize: 17.0,
  );
}
