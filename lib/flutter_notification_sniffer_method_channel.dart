import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_notification_sniffer_platform_interface.dart';

/// An implementation of [FlutterNotificationSnifferPlatform] that uses method channels.
class MethodChannelFlutterNotificationSniffer extends FlutterNotificationSnifferPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_notification_sniffer');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
