package com.example.tasknotate // Replace with your actual package name

import android.app.KeyguardManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL_NAME = "com.example.tasknotate/alarm"
    private var methodChannel: MethodChannel? = null
    private var initialIntentData: Map<String, Any?>? = null

    private fun applyLockScreenFlags() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
            // Optional: Dismiss keyguard. Test this behavior carefully.
            // val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as KeyguardManager
            // if (keyguardManager.isKeyguardLocked) {
            //     keyguardManager.requestDismissKeyguard(this, null)
            // }
        } else {
            window.addFlags(
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or
                        WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                        WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED //or
                       // WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD
            )
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        // Apply window flags BEFORE super.onCreate() if the intent is an alarm trigger
        if (intent?.action == "com.example.tasknotate.ALARM_TRIGGER") {
            Log.d("MainActivity", "onCreate: ALARM_TRIGGER intent found. Applying lock screen flags.")
            applyLockScreenFlags()
        }
        super.onCreate(savedInstanceState)
        Log.d("MainActivity", "onCreate complete. Intent: ${intent?.action}")
        handleIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.d("MainActivity", "configureFlutterEngine called.")

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialIntent" -> {
                    Log.d("MainActivity", "MethodChannel: getInitialIntent called by Flutter. Data: $initialIntentData")
                    result.success(initialIntentData)
                    // Clear it after sending if it's a one-time thing for initial launch,
                    // to prevent re-processing if Flutter restarts without activity restart.
                    // initialIntentData = null
                }
                "stopAlarm" -> {
                    val alarmId = call.argument<Int>("alarmId")
                    Log.d("MainActivity", "MethodChannel: stopAlarm called by Flutter for ID $alarmId.")
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
        // No need to re-process initialIntentData here if Flutter's getInitialIntent handles it.
    }

    override fun onNewIntent(intent: Intent) {
        Log.d("MainActivity", "onNewIntent called. New Intent: ${intent.action}")
        // Apply window flags if a new alarm intent comes while activity is running
        if (intent.action == "com.example.tasknotate.ALARM_TRIGGER") {
            Log.d("MainActivity", "onNewIntent: ALARM_TRIGGER intent. Applying lock screen flags.")
            applyLockScreenFlags()
        }
        super.onNewIntent(intent)
        setIntent(intent) // Update the activity's intent
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        if (intent?.action == "com.example.tasknotate.ALARM_TRIGGER") {
            val alarmId = intent.getIntExtra("alarmId", -1)
            val title = intent.getStringExtra("title")
            Log.d("MainActivity", "handleIntent: ALARM_TRIGGER received. ID: $alarmId, Title: $title")

            if (alarmId != -1 && title != null) {
                initialIntentData = mapOf(
                    "action" to "com.example.tasknotate.ALARM_TRIGGER",
                    "alarmId" to alarmId,
                    "title" to title
                )
                // If Flutter engine is ready and app is resumed, could invoke directly.
                // However, relying on getInitialIntent for launch and AlarmService stream for runtime
                // is generally more robust.
                if (flutterEngine != null && methodChannel != null && lifecycle.currentState.isAtLeast(androidx.lifecycle.Lifecycle.State.RESUMED)) {
                     Log.d("MainActivity", "handleIntent: App resumed. Invoking showAlarmScreen on Flutter for ALARM_TRIGGER.")
                     // This direct invocation might be redundant if AlarmService also picks it up,
                     // or if main.dart handles initial intent. Be cautious of double navigations.
                     // For alarms received while app is running, AlarmService stream is often preferred.
                     // invokeShowAlarmScreen(alarmId, title)
                } else {
                     Log.d("MainActivity", "handleIntent: ALARM_TRIGGER. Data stored for getInitialIntent.")
                }
            } else {
                Log.w("MainActivity", "handleIntent: ALARM_TRIGGER missing alarmId or title.")
                initialIntentData = mapOf("action" to "com.example.tasknotate.ALARM_TRIGGER", "error" to "Missing data")
            }
        } else if (intent != null) {
            // For non-alarm intents, store some basic info if needed.
            initialIntentData = mapOf("action" to intent.action, "data" to intent.dataString)
            Log.d("MainActivity", "handleIntent: Normal intent. Action: ${intent.action}")
        } else {
            initialIntentData = null // Clear if intent is null
        }
    }

    // Method to call the 'showAlarmScreen' method on the Flutter side (if needed for direct invocation)
    // private fun invokeShowAlarmScreen(alarmId: Int, title: String) {
    //    methodChannel?.invokeMethod("showAlarmScreen", mapOf("alarmId" to alarmId, "title" to title))
    // }

    override fun onDestroy() {
        Log.d("MainActivity", "onDestroy called.")
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        super.onDestroy()
    }
}