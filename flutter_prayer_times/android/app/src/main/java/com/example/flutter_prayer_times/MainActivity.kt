package com.example.flutter_prayer_times

import android.content.Context
import android.content.Intent
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        val tToDo = TasksToDo(this)

        // Set scheduler with AlarmManager
        //AlarmM.updatePrayerTimesAt1HourDaily(this,  0, 1, 0)

        AlarmM.setPrayerTimesToPlayAlathan(this, 5, 16, 8)

        // Task To Do
        tToDo.listOfContentFilesAndOrdersInAssetOrder("flutter_assets")

        this.startService( Intent(this, AlathanPlayerReceiver::class.java))
    }


    var context: Context = this
}

private fun FlutterActivity.onCreate() {
    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
}


