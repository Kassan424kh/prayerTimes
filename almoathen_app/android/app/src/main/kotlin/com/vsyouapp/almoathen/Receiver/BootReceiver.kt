package com.vsyouapp.almoathen.Receiver

import android.annotation.SuppressLint
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.vsyouapp.almoathen.AlarmM
import com.vsyouapp.almoathen.JsonFilesServices

class BootReceiver : BroadcastReceiver() {
    @SuppressLint("UnsafeProtectedBroadcastReceiver")
    override fun onReceive(context: Context, intent: Intent) {
        JsonFilesServices.getTodayDatesFromJsonFile(context)
        AlarmM.updatePrayerTimesAt1HourDaily(context, 15, 1, 0)
    }
}