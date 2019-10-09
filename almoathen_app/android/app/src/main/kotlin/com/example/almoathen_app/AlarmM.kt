package com.example.almoathen_app

import android.app.Activity
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import com.example.almoathen_app.Receiver.AlarmReceiver
import com.example.almoathen_app.Receiver.AlathanPlayerReceiver
import java.time.LocalDateTime
import java.util.*

object AlarmM : Activity() {
    fun cancelAlarmManagerIfUpdateIsDone(am: AlarmManager, ai: PendingIntent) {
        am.cancel(ai)
    }

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
    }

    fun setPrayerTimesToPlayAlathan(ctxt: Context, id: Int, hour: Int, minute: Int,
                                    nameOfPrayer: String = "",
                                    prayerTimeStartDateFormatted: Any? = null,
                                    index: Int = -1) {
        val alarmMgr: AlarmManager?
        val alarmIntent: PendingIntent?

        alarmMgr = ctxt.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(ctxt, AlathanPlayerReceiver::class.java)
        intent.putExtra("index", index)
        alarmIntent = PendingIntent.getBroadcast(ctxt, id, intent, 0)

        val calendar = Calendar.getInstance()
        calendar.timeInMillis = System.currentTimeMillis()
        calendar.set(Calendar.HOUR_OF_DAY, hour)
        calendar.set(Calendar.MINUTE, minute)
        calendar.set(Calendar.SECOND, 0)

        if (Build.VERSION.SDK_INT >= 23)
            alarmMgr.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, calendar.timeInMillis, alarmIntent)
        else if (Build.VERSION.SDK_INT >= 19)
            alarmMgr.setExact(AlarmManager.RTC_WAKEUP, calendar.timeInMillis, alarmIntent)
        else
            alarmMgr.set(AlarmManager.RTC_WAKEUP, calendar.timeInMillis, alarmIntent)

        if (nameOfPrayer != "" && prayerTimeStartDateFormatted != null) {
            val hour: Int = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                (prayerTimeStartDateFormatted as LocalDateTime).hour
            } else {
                (prayerTimeStartDateFormatted as Date).hours
            }

            val minute: Int = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                (prayerTimeStartDateFormatted as LocalDateTime).minute
            } else {
                (prayerTimeStartDateFormatted as Date).minutes
            }
            println("✓ ${nameOfPrayer} was set at ${hour}:${minute} today")
        }
    }
}
