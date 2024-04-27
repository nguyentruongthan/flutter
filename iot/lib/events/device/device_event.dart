class DeviceEvent {}

class RecvValueEvent extends DeviceEvent {
  RecvValueEvent(this.message);
  final String message;
}

