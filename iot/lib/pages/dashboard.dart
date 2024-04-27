// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import 'package:iot/controller/mqtt_controler.dart';
import 'package:iot/events/device/device_state.dart';

class DashBoard extends StatefulWidget {
  DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  _DashBoardState() {
    // UI lắng nghe state thay đổi để update UI
    bloc.stateRecvValueController.stream.listen((RecvValueState state) {
      //listen state when MQTTClientHelper push state to bloc
      String deviceID = state.deviceID;
      String value = state.value;

      if (deviceID == "0") {
        //light sensor
        setState(() {
          lightSensor = Sensor(
              //update new value for light sensor
              name: "Ánh sáng",
              unit: " LUX",
              icon: Icons.wb_sunny_outlined,
              iconColor: Colors.yellow.shade300,
              value: value);
        });
      } else if (deviceID == "2") {
        //humi air sensor
        setState(() {
          humiAirSensor = Sensor(
              //update new value for humi air sensor
              name: "Độ ẩm",
              unit: "%",
              icon: Icons.opacity_outlined,
              iconColor: Colors.blue.shade300,
              value: value);
        });
      } else if (deviceID == "3") {
        //temp sensor
        setState(() {
          tempSensor = Sensor(
              //update new value for temp sensor
              name: "Nhiệt độ",
              unit: "°C",
              icon: Icons.thermostat,
              iconColor: Colors.red.shade400,
              value: value);
        });
      } else if (deviceID == "4") {
        //nutnhan1
        setState(() => 
          nutNhan1 = NutNhan(
              //update new value for nutnhan1
              title: "Nút nhấn 1",
              isChecked: value == "1" ? true : false,
              deviceID: '4',
              )
        );
      }else if (deviceID == "5") {
        //nutnhan2
        setState(() => 
          nutNhan2 = NutNhan(
              //update new value for nutnhan1
              title: "Nút nhấn 2",
              isChecked: value == "1" ? true : false,
              deviceID: '5',
              )
        );
      }
    });
  }


  Sensor lightSensor = Sensor(
      name: "Ánh sáng",
      unit: " LUX",
      icon: Icons.wb_sunny_outlined,
      iconColor: Colors.yellow.shade300,
      value: "Empty");

  Sensor humiAirSensor = Sensor(
      name: "Độ ẩm",
      unit: "%",
      icon: Icons.opacity_outlined,
      iconColor: Colors.blue.shade300,
      value: "Empty");

  Sensor tempSensor = Sensor(
      name: "Nhiệt độ",
      unit: "°C",
      icon: Icons.thermostat,
      iconColor: Colors.red.shade400,
      value: "Empty");
  NutNhan nutNhan1 = NutNhan(
      title: "Nút nhấn 1", isChecked: false, deviceID: '4');
  NutNhan nutNhan2 = NutNhan(
      title: "Nút nhấn 2", isChecked: false, deviceID: '5');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Dash Board",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          lightSensor,
          SizedBox(
            height: 20,
          ),
          humiAirSensor,
          SizedBox(
            height: 20,
          ),
          tempSensor,
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              nutNhan1,
              nutNhan2,
            ],
          )
        ],
      ),
    );
  }
}

class Sensor extends StatefulWidget {
  String name;
  String unit;
  IconData icon;
  Color iconColor;
  String value;
  Sensor({
    required this.name,
    required this.unit,
    required this.icon,
    required this.iconColor,
    required this.value,
  });

  @override
  State<Sensor> createState() => _SensorState();
}

class _SensorState extends State<Sensor> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.red.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      margin: EdgeInsets.only(left: 20, right: 20),
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Icon(
              widget.icon,
              size: 50,
              color: widget.iconColor,
            ),
          ),
          Expanded(
              flex: 9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                  Text('${widget.value}${widget.unit}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w600))
                ],
              ))
        ],
      ),
    );
  }
}

class NutNhan extends StatefulWidget {
  bool isChecked;
  String title;
  String deviceID;
  NutNhan(
      {required this.isChecked,
      required this.title,
      required this.deviceID,
      super.key});
  @override
  State<NutNhan> createState() => _NutNhanState();
}

class _NutNhanState extends State<NutNhan> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w400)),
        SizedBox(
          height: 10,
        ),
        Transform.scale(
          scale: 1.75,
          child: (Switch(
            value: widget.isChecked,
            onChanged: (bool value) {
              setState(() {
                mqttClientHelper.publish("ai", "${widget.deviceID}:${value ? '1' : '0'}");
                widget.isChecked = value;
              });
            },
          )),
        )
      ],
    );
  }
}
