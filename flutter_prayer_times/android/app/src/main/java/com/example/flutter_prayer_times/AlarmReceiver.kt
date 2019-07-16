package com.example.flutter_prayer_times

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast

import com.example.flutter_prayer_times.rest.RestServerFactory

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(arg0: Context, intent: Intent) {
        RestServerFactory.getDataFromServer(arg0)
    }
}