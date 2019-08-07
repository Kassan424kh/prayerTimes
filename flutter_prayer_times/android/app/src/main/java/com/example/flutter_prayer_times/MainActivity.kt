package com.example.flutter_prayer_times

import android.content.Intent
import android.os.Build
import android.os.Bundle
import com.example.flutter_prayer_times.AlathanPlayer.AlathanPlayer
import com.example.flutter_prayer_times.Receiver.AlathanPlayerReceiver

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)
        val tToDo = TasksToDo(this)

        // Set scheduler with AlarmManager
        AlarmM.updatePrayerTimesAt1HourDaily(this,  0, 1, 0)


        /*// Alathan Player setter
        val date = Date()
        val calendar:Calendar = GregorianCalendar.getInstance()
        calendar.setTime(date)
        calendar.get(Calendar.MINUTE)
        val newMinutesPlusOne: Int = calendar.get(Calendar.MINUTE) + 1
        print("\n Now minute + 1: " + newMinutesPlusOne + "\n")
        AlarmM.setPrayerTimesToPlayAlathan(this, 0, 10, newMinutesPlusOne)*/

        // Task To Do
        tToDo.listOfContentFilesAndOrdersInAssetOrder("flutter_assets")

        this.startService( Intent(this, AlathanPlayerReceiver::class.java))
    }
}


