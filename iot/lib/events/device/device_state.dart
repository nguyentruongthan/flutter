class DeviceState {}

class RecvValueState extends DeviceState {
  RecvValueState(this.deviceID, this.value);
  final String deviceID;
  final String value;
}

class SendValueState extends DeviceState {
  SendValueState(this.message);
  final String message;
}
