// android/src/main/kotlin/com/dedyksuntoro/flutter_notification_sniffer/NotificationSnifferPlugin.kt
package com.dedyksuntoro.flutter_notification_sniffer

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class NotificationSnifferPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    private lateinit var context: Context
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        methodChannel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "flutter_notification_sniffer"
        )
        methodChannel.setMethodCallHandler(this)
        eventChannel = EventChannel(
            flutterPluginBinding.binaryMessenger,
            "flutter_notification_sniffer/notifications"
        )
        eventChannel.setStreamHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "requestPermission" -> {
                if (isNotificationServiceEnabled()) {
                    result.success(true)
                } else {
                    val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    context.startActivity(intent)
                    result.success(false)
                }
            }
            "initialize" -> {
                val isServiceEnabled = isNotificationServiceEnabled()
                if (isServiceEnabled) {
                    NotificationListener.instance?.setEventSink(eventSink)
                    result.success(true)
                } else {
                    result.success(false)
                }
            }
            "isPermissionGranted" -> {
                result.success(isNotificationServiceEnabled())
            }
            else -> result.notImplemented()
        }
    }

    private fun isNotificationServiceEnabled(): Boolean {
        val pkgName = context.packageName
        val flat = Settings.Secure.getString(context.contentResolver, "enabled_notification_listeners")
        if (!flat.isNullOrEmpty()) {
            return flat.contains("$pkgName/${NotificationListener::class.java.name}")
        }
        return false
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        NotificationListener.instance?.setEventSink(events)
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
        NotificationListener.instance?.setEventSink(null)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }
}