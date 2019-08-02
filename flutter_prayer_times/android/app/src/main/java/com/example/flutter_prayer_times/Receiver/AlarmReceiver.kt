package com.example.flutter_prayer_times.Receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast

import com.example.flutter_prayer_times.rest.RestServerFactory

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(ctxt: Context, intent: Intent) {
        RestServerFactory.getDataFromServer(ctxt)
    }
}