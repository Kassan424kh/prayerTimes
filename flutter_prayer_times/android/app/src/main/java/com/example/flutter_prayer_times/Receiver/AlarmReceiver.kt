package com.example.flutter_prayer_times.Receiver

import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import com.example.flutter_prayer_times.AlarmM

import com.example.flutter_prayer_times.rest.RestServerFactory
import java.text.SimpleDateFormat
import java.time.LocalTime
import java.time.format.DateTimeFormatter
import java.util.*

class AlarmReceiver : BroadcastReceiver() {
    @SuppressLint("SimpleDateFormat")
    override fun onReceive(ctxt: Context, intent: Intent) {
        RestServerFactory.getDataFromServer(ctxt)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
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

        }else{
            val timeNow = Date()
            val pattern = "HH:mm"
            val startTime= "00:30"
            val endTime= "01:30"

            val formatter = SimpleDateFormat(pattern)
            val startTimeFormatted = formatter.parse(startTime)
            val endTimeFormatted = formatter.parse(endTime)
            if (timeNow.after(startTimeFormatted) && timeNow.before(endTimeFormatted)) {
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
}