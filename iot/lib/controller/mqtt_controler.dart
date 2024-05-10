// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:iot/events/device/device_bloc.dart';
import 'package:iot/events/device/device_event.dart';

class MQTTClientHelper {
  final client = MqttServerClient('io.adafruit.com', '1883');

  final String username = "nguyentruongthan";
  String password = "aio_qNbo71v!!!!k0Iuv!!!!OGutmbxMWMfphX8E";
  final List<String> subTopics = ["ai"];
  MQTTClientHelper() {
    print("start mqtt class");
    client.logging(on: false);
    client.keepAlivePeriod = 60;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;

    password = password.replaceAll('!', '');
    final connMess = MqttConnectMessage()
        .withClientIdentifier('dart_client')
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce)
        .authenticateAs(username, password);
    client.connectionMessage = connMess;
  }

  Future<void> connect() async {
    print("Connecting");
    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      print('Client exception: $e');
      client.disconnect();
    } on SocketException catch (e) {
      print('Socket exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Client connected');
    } else {
      print(
          'Client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      exit(-1);
    }

    print('connect success');
    //on message
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      onMessage(c[0].topic, pt);
    });
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus!.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('OnDisconnected callback is solicited, this is correct');
    }
    // exit(-1);
  }

  /// The successful connect callback
  void onConnected() {
    print('OnConnected client callback - Client connection was sucessful');

    for (var subTopic in subTopics) {
      print('Subscribing to the $subTopic topic');
      client.subscribe("$username/feeds/$subTopic", MqttQos.atMostOnce);
    }
  }

  /// Pong callback
  void pong() {
    print('Ping response client callback invoked');
  }

  void onMessage(String topic, String message) {
    print('Received message: topic is $topic, payload is $message');
    bloc.eventController.sink.add(RecvValueEvent(message));
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(
        'nguyentruongthan/feeds/$topic', MqttQos.exactlyOnce, builder.payload!);
  }
}

final bloc = DeviceBloc();
MQTTClientHelper mqttClientHelper = MQTTClientHelper();

/*
MQTTClientHelper mqttClientHelper = MQTTClientHelper();
final bloc = SensorBloc();
Future<void> main() async {
  await mqttClientHelper.connect();

  

  // UI lắng nghe state thay đổi để update UI
  bloc.stateController.stream.listen((SensorState state) {
    print('Nhiệt độ hiện tại: ${state.value}');
  });
}
*/
