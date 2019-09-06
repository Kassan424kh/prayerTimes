package com.example.flutter_prayer_times

import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.support.annotation.RequiresApi
import com.example.flutter_prayer_times.Receiver.AlathanPlayerReceiver
import com.example.flutter_prayer_times.rest.RestServerFactory

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter


class MainActivity : FlutterActivity() {
    var context: Context = this
    private val CHANNEL = "com.prayer-times.flutter/prayer-times-updater"

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        // Set scheduler with AlarmManager
        AlarmM.updatePrayerTimesAt1HourDaily(this, 0, 1, 0)

        RestServerFactory.getDataFromServer(this)

        /*// Task To Do
        tToDo.listOfContentFilesAndOrdersInAssetOrder("flutter_assets")

        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "updatePrayerTimesAfterLocation") {
                RestServerFactory.getDataFromServer(this)
                result.success(true)
            } else{
                result.notImplemented()
                Toast.makeText(this, "prayerTimes do's not updated", Toast.LENGTH_LONG).show()
            }
        }*/

        this.startService(Intent(this, AlathanPlayerReceiver::class.java))
    }
}