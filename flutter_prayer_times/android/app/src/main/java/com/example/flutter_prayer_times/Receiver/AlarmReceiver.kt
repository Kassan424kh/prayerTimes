package com.example.flutter_prayer_times.Receiver

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.widget.Toast
import com.example.flutter_prayer_times.AlarmM

import com.example.flutter_prayer_times.rest.RestServerFactory
import java.util.*

class AlarmReceiver : BroadcastReceiver() {
    override fun onReceive(ctxt: Context, intent: Intent) {
        RestServerFactory.getDataFromServer(ctxt)
        val alarmManager : AlarmM= AlarmM

        val alarmMgr = ctxt.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val alarmIntent = PendingIntent.getBroadcast(ctxt, 0, intent, 0)
        Timer().schedule(object : TimerTask() {
            override fun run() {
                alarmManager.cancelAlarmManagerIfUpdateIsDone(alarmMgr, alarmIntent)
            }
        }, 6000)

    }
}