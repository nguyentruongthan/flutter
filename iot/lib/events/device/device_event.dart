class DeviceEvent {}

class RecvValueEvent extends DeviceEvent {
  RecvValueEvent(this.message);
  final String message;
}

class SendValueEvent extends DeviceEvent {
  SendValueEvent(this.deviceID, this.value);
  final String deviceID;
  final String value;
}
