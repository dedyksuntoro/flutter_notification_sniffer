import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_notification_sniffer_method_channel.dart';

abstract class FlutterNotificationSnifferPlatform extends PlatformInterface {
  /// Constructs a FlutterNotificationSnifferPlatform.
  FlutterNotificationSnifferPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterNotificationSnifferPlatform _instance = MethodChannelFlutterNotificationSniffer();

  /// The default instance of [FlutterNotificationSnifferPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterNotificationSniffer].
  static FlutterNotificationSnifferPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterNotificationSnifferPlatform] when
  /// they register themselves.
  static set instance(FlutterNotificationSnifferPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
