# flutter_notification_sniffer

A Flutter plugin to capture push notifications on Android and iOS devices. This plugin allows developers to listen to incoming notifications and retrieve details such as title, message, and timestamp in real-time.

## Features
- Capture push notifications on Android using `NotificationListenerService`.
- Capture notifications on iOS using `UNUserNotificationCenter`.
- Stream notification data (title, message, timestamp, etc.) to your Flutter app.
- Simple API to request permissions and initialize the notification listener.
- Cross-platform support for Android and iOS.

## Getting Started

### Prerequisites
- Flutter SDK: `>=2.18.0 <3.0.0`
- Android: Minimum API level 21
- iOS: Minimum deployment target 11.0

### Installation
Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_notification_sniffer: ^0.0.1
```

Run `flutter pub get` to install the plugin.

### Platform Setup

#### Android
1. Add the notification listener permission to your app's `AndroidManifest.xml`:
   ```xml
   <uses-permission android:name="android.permission.BIND_NOTIFICATION_LISTENER_SERVICE" />
   ```
2. Ensure your app targets at least API level 31 (Android 12) for `android:exported` compatibility. Update `android/app/build.gradle`:
   ```gradle
   android {
       compileSdkVersion 33
       defaultConfig {
           minSdkVersion 21
           targetSdkVersion 33
       }
   }
   ```

#### iOS
Add the notification permission description to your app's `Info.plist`:
```xml
<key>NSUserNotificationUsageDescription</key>
<string>We need access to notifications to provide functionality.</string>
```

### Usage
1. **Request Permission**: Prompt the user to grant notification access.
2. **Initialize the Plugin**: Start the notification listener.
3. **Listen to Notifications**: Use the stream to capture notification data.

Here’s an example of how to use the plugin:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_notification_sniffer/flutter_notification_sniffer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const NotificationSnifferScreen(),
    );
  }
}

class NotificationSnifferScreen extends StatefulWidget {
  const NotificationSnifferScreen({super.key});

  @override
  State<NotificationSnifferScreen> createState() => _NotificationSnifferScreenState();
}

class _NotificationSnifferScreenState extends State<NotificationSnifferScreen> {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _initializePlugin();
    _listenToNotifications();
  }

  Future<void> _initializePlugin() async {
    bool granted = await FlutterNotificationSniffer.isPermissionGranted();
    if (!granted) {
      granted = await FlutterNotificationSniffer.requestPermission();
      if (!granted) {
        print('Permission not granted');
        return;
      }
    }
    bool initialized = await FlutterNotificationSniffer.initialize();
    print('Notification listener initialized: $initialized');
  }

  void _listenToNotifications() {
    FlutterNotificationSniffer.notificationStream.listen((notification) {
      setState(() {
        notifications.add(notification);
      });
      print('Notification: $notification');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Sniffer'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            title: Text(notification['title'] ?? 'No Title'),
            subtitle: Text(notification['message'] ?? 'No Message'),
            trailing: Text(
              DateTime.fromMillisecondsSinceEpoch(
                      (notification['timestamp'] as num).toInt())
                  .toString(),
            ),
          );
        },
      ),
    );
  }
}
```

### Notification Data
The plugin streams a `Map<String, dynamic>` with the following keys:
- `title`: The notification title (String).
- `message`: The notification body (String).
- `timestamp`: The notification timestamp in milliseconds (num).
- `packageName` (Android): The package name of the app sending the notification (String).
- `identifier` (iOS): The notification identifier (String).

### Notes
- **Android**: Users must manually enable the app in `Settings > Notifications > Notification access`.
- **iOS**: Notifications are only captured when the app is in the foreground. For background capture, consider implementing a Notification Service Extension.
- Ensure you handle permission denial gracefully in your app.

### Example Project
Check the `example` directory for a complete working example of the plugin.

### Contributing
Contributions are welcome! Please submit issues or pull requests to the [GitHub repository](https://github.com/yourusername/flutter_notification_sniffer).

### License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.