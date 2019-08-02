package com.example.flutter_prayer_times

import android.app.Activity
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.widget.Toast

import com.example.flutter_prayer_times.AlathanPlayer.AlathanPlayer
import java.util.*

object AlarmM : Activity() {
    fun updatePrayerTimesAt1HourDaily(ctxt: Context, id: Int, hour: Int, minute: Int) {
        val alarmMgr: AlarmManager?
        val alarmIntent: PendingIntent?

        alarmMgr = ctxt.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(ctxt, AlarmReceiver::class.java)
        alarmIntent = PendingIntent.getBroadcast(ctxt, id, intent, 0)

        val calendar = Calendar.getInstance()
        calendar.timeInMillis = System.currentTimeMillis()
        calendar.set(Calendar.HOUR_OF_DAY, hour)
        calendar.set(Calendar.MINUTE, minute)
        calendar.set(Calendar.SECOND, 0)

        alarmMgr.setRepeating(AlarmManager.RTC_WAKEUP, calendar.timeInMillis, AlarmManager.INTERVAL_DAY, alarmIntent)
        
        Toast.makeText(ctxt, "PrayerTimes updater set", Toast.LENGTH_SHORT).show()
    }

    fun setPrayerTimesToPlayAlathan(ctxt: Context, id: Int, hour: Int, minute: Int) {
        val alarmMgr: AlarmManager?
        val alarmIntent: PendingIntent?

        alarmMgr = ctxt.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(ctxt, AlathanPlayerReceiver::class.java)
        alarmIntent = PendingIntent.getActivity(ctxt, id, intent, 0)

        val calendar = Calendar.getInstance()
        calendar.timeInMillis = System.currentTimeMillis()
        calendar.set(Calendar.HOUR_OF_DAY, hour)
        calendar.set(Calendar.MINUTE, minute)
        calendar.set(Calendar.SECOND, 0)

        alarmMgr.set(AlarmManager.RTC_WAKEUP, calendar.timeInMillis, alarmIntent)

        Toast.makeText(ctxt, "Prayer Alathan Set", Toast.LENGTH_SHORT).show()
    }
}
