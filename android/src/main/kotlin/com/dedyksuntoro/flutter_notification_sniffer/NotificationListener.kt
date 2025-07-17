// android/src/main/kotlin/com/dedyksuntoro/flutter_notification_sniffer/NotificationListener.kt
package com.dedyksuntoro.flutter_notification_sniffer

import android.app.Notification
import android.content.Intent
import android.os.Bundle
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import io.flutter.plugin.common.EventChannel

class NotificationListener : NotificationListenerService() {
    companion object {
        var instance: NotificationListener? = null
    }

    private var eventSink: EventChannel.EventSink? = null

    override fun onCreate() {
        super.onCreate()
        instance = this
    }

    fun setEventSink(sink: EventChannel.EventSink?) {
        eventSink = sink
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        sbn?.notification?.let { notification ->
            val extras = notification.extras
            val notificationData = mutableMapOf<String, Any?>()
            notificationData["packageName"] = sbn.packageName
            notificationData["title"] = extras.getString(Notification.EXTRA_TITLE)
            notificationData["message"] = extras.getString(Notification.EXTRA_TEXT)
            notificationData["timestamp"] = sbn.postTime

            eventSink?.success(notificationData)
        }
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification?) {
        // Handle notification removal if needed
    }

    override fun onDestroy() {
        super.onDestroy()
        instance = null
    }
}