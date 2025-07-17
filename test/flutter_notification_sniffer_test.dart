// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_notification_sniffer/flutter_notification_sniffer.dart';
// import 'package:flutter_notification_sniffer/flutter_notification_sniffer_platform_interface.dart';
// import 'package:flutter_notification_sniffer/flutter_notification_sniffer_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockFlutterNotificationSnifferPlatform
//     with MockPlatformInterfaceMixin
//     implements FlutterNotificationSnifferPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final FlutterNotificationSnifferPlatform initialPlatform = FlutterNotificationSnifferPlatform.instance;

//   test('$MethodChannelFlutterNotificationSniffer is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelFlutterNotificationSniffer>());
//   });

//   test('getPlatformVersion', () async {
//     FlutterNotificationSniffer flutterNotificationSnifferPlugin = FlutterNotificationSniffer();
//     MockFlutterNotificationSnifferPlatform fakePlatform = MockFlutterNotificationSnifferPlatform();
//     FlutterNotificationSnifferPlatform.instance = fakePlatform;

//     expect(await flutterNotificationSnifferPlugin.getPlatformVersion(), '42');
//   });
// }
