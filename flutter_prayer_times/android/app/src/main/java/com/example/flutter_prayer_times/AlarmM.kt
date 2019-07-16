package com.example.flutter_prayer_times

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.widget.Toast

import com.example.flutter_prayer_times.AlathanPlayer.AlathanPlayer
import java.util.*

object AlarmM {
    fun updatePrayerTimesAt1HourDaily(ctxt: Context, id: Int, hour: Int, minute: Int) {
        val alarmMgr: android.app.AlarmManager
        val alarmIntent: PendingIntent

        alarmMgr = ctxt.getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
        val intent = Intent(ctxt, AlarmReceiver::class.java)
        alarmIntent = PendingIntent.getBroadcast(ctxt, id, intent, 0)

        val calendar = Calendar.getInstance()
        calendar.timeInMillis = System.currentTimeMillis()
        calendar.set(Calendar.HOUR_OF_DAY, hour)
        calendar.set(Calendar.MINUTE, minute)
        calendar.set(Calendar.SECOND, 0)

        alarmMgr.setRepeating(android.app.AlarmManager.RTC_WAKEUP, calendar.timeInMillis, AlarmManager.INTERVAL_DAY, alarmIntent)
        
        Toast.makeText(ctxt, "PrayerTimes updater Seted", Toast.LENGTH_SHORT).show()
    }

    fun setPrayerTimesToPlayAlathan(ctxt: Context, id: Int, hour: Int, minute: Int) {
        val alarmMgr: android.app.AlarmManager
        val alarmIntent: PendingIntent

        alarmMgr = ctxt.getSystemService(Context.ALARM_SERVICE) as android.app.AlarmManager
        val intent = Intent(ctxt, AlathanPlayer::class.java)
        alarmIntent = PendingIntent.getBroadcast(ctxt, id, intent, 0)

        val calendar = Calendar.getInstance()
        calendar.timeInMillis = System.currentTimeMillis()
        calendar.set(Calendar.HOUR_OF_DAY, hour)
        calendar.set(Calendar.MINUTE, minute)
        calendar.set(Calendar.SECOND, 0)

        alarmMgr.setRepeating(android.app.AlarmManager.RTC_WAKEUP, calendar.timeInMillis, AlarmManager.INTERVAL_DAY, alarmIntent)

        Toast.makeText(ctxt, "Prayer Alathan Set", Toast.LENGTH_SHORT).show()
    }
}
