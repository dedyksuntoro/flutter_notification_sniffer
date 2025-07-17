// lib/flutter_notification_sniffer.dart
import 'dart:async';
import 'package:flutter/services.dart';

class FlutterNotificationSniffer {
  static const MethodChannel _channel =
      MethodChannel('flutter_notification_sniffer');

  static const EventChannel _eventChannel =
      EventChannel('flutter_notification_sniffer/notifications');

  static Stream<Map<String, dynamic>> get notificationStream =>
      _eventChannel.receiveBroadcastStream().map((event) {
        if (event is Map) {
          return Map<String, dynamic>.from(event);
        }
        return <String, dynamic>{};
      });

  static Future<bool> requestPermission() async {
    try {
      final bool granted =
          await _channel.invokeMethod('requestPermission') ?? false;
      return granted;
    } catch (e) {
      print('Error requesting permission: $e');
      return false;
    }
  }

  static Future<bool> initialize() async {
    try {
      final bool initialized =
          await _channel.invokeMethod('initialize') ?? false;
      return initialized;
    } catch (e) {
      print('Error initializing: $e');
      return false;
    }
  }

  static Future<bool> isPermissionGranted() async {
    try {
      final bool granted =
          await _channel.invokeMethod('isPermissionGranted') ?? false;
      return granted;
    } catch (e) {
      print('Error checking permission: $e');
      return false;
    }
  }
}
