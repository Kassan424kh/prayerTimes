package com.example.flutter_prayer_times.Receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.example.flutter_prayer_times.JsonFilesServices

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        JsonFilesServices.getTodayDatesFromJsonFile(context)
    }
}