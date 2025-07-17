// example/lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_notification_sniffer/flutter_notification_sniffer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializePlugin();
    _listenToNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _initializePlugin();
    }
  }

  Future<void> _initializePlugin() async {
    bool granted = await FlutterNotificationSniffer.isPermissionGranted();
    if (!granted) {
      granted = await FlutterNotificationSniffer.requestPermission();
      if (!granted) {
        debugPrint('Permission not granted for notification listener');
        return;
      }
    }
    bool initialized = await FlutterNotificationSniffer.initialize();
    debugPrint('Notification listener initialized: $initialized');
  }

  void _listenToNotifications() {
    FlutterNotificationSniffer.notificationStream.listen(
      (notification) {
        debugPrint('Notification Received:');
        debugPrint('Title: ${notification['title'] ?? 'No Title'}');
        debugPrint('Message: ${notification['message'] ?? 'No Message'}');
        debugPrint(
          'Timestamp: ${DateTime.fromMillisecondsSinceEpoch((notification['timestamp'] as num).toInt())}',
        );
        debugPrint(
          'Package (Android) / Identifier (iOS): ${notification['packageName'] ?? notification['identifier'] ?? 'Unknown'}',
        );
        debugPrint('---');

        setState(() {
          notifications.add(notification);
        });
      },
      onError: (error) {
        debugPrint('Error receiving notification: $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Sniffer')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            title: Text(notification['title'] ?? 'No Title'),
            subtitle: Text(notification['message'] ?? 'No Message'),
            trailing: Text(
              DateTime.fromMillisecondsSinceEpoch(
                (notification['timestamp'] as num).toInt(),
              ).toString(),
            ),
          );
        },
      ),
    );
  }
}
