class DeviceState {}

class RecvValueState extends DeviceState {
  RecvValueState(this.deviceID, this.value);
  final String deviceID;
  final String value;
}
