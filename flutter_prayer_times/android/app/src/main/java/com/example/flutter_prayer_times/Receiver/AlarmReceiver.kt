package com.example.flutter_prayer_times.Receiver

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.support.annotation.RequiresApi
import com.example.flutter_prayer_times.AlarmM

import com.example.flutter_prayer_times.rest.RestServerFactory
import java.time.LocalDateTime
import java.time.LocalTime
import java.time.format.DateTimeFormatter
import java.util.*

class AlarmReceiver : BroadcastReceiver() {
    @RequiresApi(Build.VERSION_CODES.O)
    override fun onReceive(ctxt: Context, intent: Intent) {
        RestServerFactory.getDataFromServer(ctxt)

        val timeNow: LocalTime = LocalTime.now()
        val startTimeFormatted = LocalTime.parse("00:30",
                DateTimeFormatter.ofPattern("HH:mm"))
        val endTimeFormatted = LocalTime.parse("01:30",
                DateTimeFormatter.ofPattern("HH:mm"))
        if (timeNow.isAfter(startTimeFormatted) && timeNow.isBefore(endTimeFormatted)) {
            val alarmManager = AlarmM

            val alarmMgr = ctxt.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val alarmIntent = PendingIntent.getBroadcast(ctxt, 0, intent, 0)
            Timer().schedule(object : TimerTask() {
                override fun run() {
                    alarmManager.cancelAlarmManagerIfUpdateIsDone(alarmMgr, alarmIntent)
                }
            }, 10000)
        }
    }
}