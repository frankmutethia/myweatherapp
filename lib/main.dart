import 'package:flutter/material.dart';
import './ui/weather.dart';


void main() {
  runApp(
    new MaterialApp(
      debugShowCheckedModeBanner: false,
    title:'Weather',
    home: new Weather(),
  ),
  ); 
}
