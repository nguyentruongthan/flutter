import 'package:flutter/material.dart';
import 'package:iot/controller/mqtt_controler.dart';
import 'package:iot/pages/dashboard.dart';


void main() {
  
  mqttClientHelper.connect();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  DashBoard dashBoard = DashBoard();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: dashBoard,
    );
  }
}
