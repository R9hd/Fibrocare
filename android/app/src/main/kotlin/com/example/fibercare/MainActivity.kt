package com.example.fibercare

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.yourcompany.alarm/permissions"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "openExactAlarmSettings") {
                try {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM)
                        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        startActivity(intent)
                        result.success(null)
                    } else {
                        result.error("unsupported_version", "Exact alarms not required before Android 12", null)
                    }
                } catch (e: Exception) {
                    result.error("error", "Failed to open settings: ${e.message}", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
