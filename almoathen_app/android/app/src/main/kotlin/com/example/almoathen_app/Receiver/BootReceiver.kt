package com.example.almoathen_app.Receiver

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.example.almoathen_app.AlarmM
import com.example.almoathen_app.JsonFilesServices

class BootReceiver : BroadcastReceiver() {
    @SuppressLint("UnsafeProtectedBroadcastReceiver")
    override fun onReceive(context: Context, intent: Intent) {
        JsonFilesServices.getTodayDatesFromJsonFile(context)
        AlarmM.updatePrayerTimesAt1HourDaily(context, 0, 1, 0)
    }
}