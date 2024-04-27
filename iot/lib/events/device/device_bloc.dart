import 'dart:async';

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
  DeviceBloc() {
    // lắng nghe khi eventController push event mới
    eventController.stream.listen((DeviceEvent event) {
      if (event is RecvValueEvent) {
        String message = event.message;
        //message = <deviceID>:<value>
        List splitMessage = message.split(":");
        if (splitMessage.length != 2) return;
        String deviceID = splitMessage[0];
        String value = splitMessage[1];
        state = RecvValueState(deviceID, value);
        stateRecvValueController.sink.add(RecvValueState(deviceID, value));
      }
    });
  }

  // khi không cần thiết thì close tất cả controller
  void dispose() {
    stateRecvValueController.close();
    eventController.close();
  }
}
