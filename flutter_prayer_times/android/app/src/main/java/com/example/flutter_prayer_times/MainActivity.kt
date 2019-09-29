package com.example.flutter_prayer_times

import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import com.example.flutter_prayer_times.Receiver.AlathanPlayerReceiver
import com.example.flutter_prayer_times.rest.RestServerFactory
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit


class MainActivity : FlutterActivity() {
    private val CHANNEL_UPDATER = "com.prayer-times.flutter/prayer-times-updater"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        AlarmM.updatePrayerTimesAt1HourDaily(this, 0, 1, 0)

        MethodChannel(flutterView, CHANNEL_UPDATER).setMethodCallHandler { call, result ->
            when {
                call.method == "updatePrayerTimesAfterNewPlaceData" -> {
                    RestServerFactory.getDataFromServer(this, true)
                    result.success(true)
                }
                call.method == "updateTodayPrayerTimes" -> {
                    Executors.newSingleThreadScheduledExecutor().schedule({
                        JsonFilesServices.getTodayDatesFromJsonFile(this, true)
                    }, 1500, TimeUnit.MILLISECONDS)
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                    Toast.makeText(this, "prayerTimes not updated", Toast.LENGTH_LONG).show()
                }
            }
        }

        /*
            AlarmM.setPrayerTimesToPlayAlathan(ctxt = this, id = 21,
                hour = 12,
                minute = 48,
                nameOfPrayer = "",
                index = 0)
        */

        this.startService(Intent(this, AlathanPlayerReceiver::class.java))
    }
}