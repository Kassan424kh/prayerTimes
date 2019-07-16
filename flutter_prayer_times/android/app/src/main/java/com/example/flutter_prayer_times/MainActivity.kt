package com.example.flutter_prayer_times

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        val tToDo = TasksToDo(this)

        // Set scheduler with AlarmManager
        AlarmM.updatePrayerTimesAt1HourDaily(this, 0, 1, 0)

        tToDo.listOfContentFilesAndOrdersInAssetOrder("flutter_assets")
    }
}


