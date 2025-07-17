// ios/Classes/FlutterNotificationSnifferPlugin.swift
import Flutter
import UserNotifications

@objc class FlutterNotificationSnifferPlugin: NSObject, FlutterPlugin, UNUserNotificationCenterDelegate {
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "flutter_notification_sniffer",
            binaryMessenger: registrar.messenger()
        )
        let eventChannel = FlutterEventChannel(
            name: "flutter_notification_sniffer/notifications",
            binaryMessenger: registrar.messenger()
        )
        let instance = FlutterNotificationSnifferPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        eventChannel.setStreamHandler(instance)
    }

    private var eventSink: FlutterEventSink?

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "requestPermission":
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized {
                    DispatchQueue.main.async {
                        result(true)
                    }
                } else {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                        if let error = error {
                            print("Error requesting permission: \(error)")
                            result(false)
                            return
                        }
                        if granted {
                            DispatchQueue.main.async {
                                UNUserNotificationCenter.current().delegate = self
                            }
                        }
                        result(granted)
                    }
                }
            }
        case "initialize":
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                if settings.authorizationStatus == .authorized {
                    DispatchQueue.main.async {
                        UNUserNotificationCenter.current().delegate = self
                    }
                    result(true)
                } else {
                    result(false)
                }
            }
        case "isPermissionGranted":
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                result(settings.authorizationStatus == .authorized)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

extension FlutterNotificationSnifferPlugin: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notification = response.notification
        let content = notification.request.content
        let notificationData: [String: Any] = [
            "title": content.title,
            "message": content.body,
            "timestamp": notification.date.timeIntervalSince1970 * 1000,
            "identifier": response.notification.request.identifier
        ]
        eventSink?(notificationData)
        completionHandler()
    }
}