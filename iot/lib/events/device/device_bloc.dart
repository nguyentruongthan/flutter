import 'dart:async';
import 'dart:convert';

import 'package:iot/events/device/device_event.dart';
import 'package:iot/events/device/device_state.dart';

class DeviceBloc {
  //init state
  var state = DeviceState();

  // tạo 2 controller
  // 1 cái quản lý event, đảm nhận nhiệm vụ nhận event từ UI
  final eventController = StreamController<DeviceEvent>();

  // this state return deviceID and value which is received from mqtt server
  final stateRecvValueController = StreamController<RecvValueState>();

  // event ack
  final eventAckController = StreamController<String>.broadcast();

  // event setloading
  final eventSetLoadingController = StreamController<bool>();

  DeviceBloc() {
    // lắng nghe khi eventController push event mới
    eventController.stream.listen((DeviceEvent event) {
      if (event is RecvValueEvent) {
        String message = event.message;
        List splitMessage = message.split(':');
        final header = splitMessage[0];
        if (header == '2') {
          //header recv sensor value
          //<header = 2>:<deviceID>:<value>
          String deviceID = splitMessage[1];
          String value = splitMessage[2];
          // send state to UI
          state = RecvValueState(deviceID, value);
          stateRecvValueController.sink.add(RecvValueState(deviceID, value));
        } 
        else if (header == '6') {
          //recv ACK
          //<header = 6>:<ack>
          eventAckController.sink.add(splitMessage[1]);
        }
        // print('end handle');
      }
    });
  }

  // khi không cần thiết thì close tất cả controller
  void dispose() {
    stateRecvValueController.close();
    eventController.close();
  }
}
