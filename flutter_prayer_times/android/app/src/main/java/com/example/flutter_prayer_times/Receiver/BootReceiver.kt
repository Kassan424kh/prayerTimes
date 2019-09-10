package com.example.flutter_prayer_times.Receiver

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.support.annotation.RequiresApi
import com.example.flutter_prayer_times.AlarmM
import com.example.flutter_prayer_times.JsonFilesServices

class BootReceiver : BroadcastReceiver() {
    @SuppressLint("UnsafeProtectedBroadcastReceiver")
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onReceive(context: Context, intent: Intent) {
        JsonFilesServices.getTodayDatesFromJsonFile(context)
        AlarmM.updatePrayerTimesAt1HourDaily(context, 0, 1, 0)

    }
}