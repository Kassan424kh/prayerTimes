package com.example.flutter_prayer_times.Receiver

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.example.flutter_prayer_times.AlarmM
import com.example.flutter_prayer_times.JsonFilesServices

class BootReceiver : BroadcastReceiver() {
    @SuppressLint("UnsafeProtectedBroadcastReceiver")
    override fun onReceive(context: Context, intent: Intent) {
        JsonFilesServices.getTodayDatesFromJsonFile(context)
        AlarmM.updatePrayerTimesAt1HourDaily(context, 0, 1, 0)
    }
}