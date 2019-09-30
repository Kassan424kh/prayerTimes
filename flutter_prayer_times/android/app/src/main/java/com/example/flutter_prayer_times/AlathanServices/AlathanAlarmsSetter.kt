package com.example.flutter_prayer_times.AlathanServices

import android.annotation.SuppressLint
import android.app.AlarmManager
import android.app.PendingIntent.*
import android.content.Context
import android.os.Build
import com.example.flutter_prayer_times.AlarmM
import com.google.gson.JsonArray
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import android.content.Intent
import com.example.flutter_prayer_times.AppSettings.AppSettings
import com.example.flutter_prayer_times.Receiver.AlathanPlayerReceiver
import java.text.SimpleDateFormat
import java.util.*


class AlathanAlarmsSetter {

    fun checkIfAlarmIsAlradySet(ctxt: Context, id: Int, nameOfPrayer: String): Boolean {
        var check = false
        val intent = Intent(ctxt, AlathanPlayerReceiver::class.java)
        val alarmUp = getBroadcast(ctxt, id, intent, 0) != null

        if (alarmUp) {
            println("$nameOfPrayer was set")
            check = true
        } else
            println("$nameOfPrayer wasn't set")

        return check
    }

    fun deleteAlarm(ctxt: Context, id: Int, nameOfPrayer: String) {
        val alarmManager: AlarmManager = ctxt.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val check = checkIfAlarmIsAlradySet(ctxt, id, nameOfPrayer)
        val intent = Intent(ctxt, AlathanPlayerReceiver::class.java)

        if (check) {
            alarmManager.cancel(getService(ctxt, id, intent, 0))
            println("$nameOfPrayer is canceled")
        }
    }

    @SuppressLint("SimpleDateFormat")
    fun setAlathanAlarms(array: JsonArray, ctxt: Context) {
        // Alathan Player setter
        // Format yyyy-MM-dd HH:mm:ssz
        val appSettings = AppSettings(ctxt)

        var dateTimeInString: String? = null
        for (index in 0..(array.size() - 1)) {
            if (index == 1)
                continue

            val prayerTimeJsonObject = array.get(index).asJsonObject
            var nameOfPrayer = ""

            // get start dateTime Of Prayer
            for (keyInObject: String in prayerTimeJsonObject.keySet()) {
                dateTimeInString = (prayerTimeJsonObject[keyInObject] as JsonArray).get(0).toString().replace("\"", "")
                nameOfPrayer = keyInObject
            }

            if (dateTimeInString != null) {

                val isAlarmSoundActive = appSettings.getDataFromAppSettingsFile().acceptPlayingAthans?.get(index)?.get(0)
                val isAlarmVibrateActive = appSettings.getDataFromAppSettingsFile().acceptPlayingAthans?.get(index)?.get(1)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val dateTimeNow: LocalDateTime = LocalDateTime.now()
                    val prayerTimeStartDateFormatted = LocalDateTime.parse(dateTimeInString,
                            DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ssz"))

                    if (prayerTimeStartDateFormatted.isAfter(dateTimeNow) && (isAlarmSoundActive!! || isAlarmVibrateActive!!)) {
                        AlarmM.setPrayerTimesToPlayAlathan(ctxt = ctxt, id = index + 1,
                                hour = prayerTimeStartDateFormatted.hour,
                                minute = prayerTimeStartDateFormatted.minute,
                                nameOfPrayer = nameOfPrayer,
                                prayerTimeStartDateFormatted = prayerTimeStartDateFormatted,
                                index = index)
                    } else if (prayerTimeStartDateFormatted.isAfter(dateTimeNow) && !isAlarmSoundActive!! && !isAlarmVibrateActive!!) {
                        deleteAlarm(ctxt, index + 1, nameOfPrayer)
                    }
                } else {
                    val dateTimeNow = Date()
                    val formatter = SimpleDateFormat("yyyy-MM-dd HH:mm:ss'Z'")
                    val prayerTimeStartDateFormattedString = formatter.parse(dateTimeInString)

                    if (prayerTimeStartDateFormattedString.after(dateTimeNow) && (isAlarmSoundActive!! || isAlarmVibrateActive!!)) {
                        AlarmM.setPrayerTimesToPlayAlathan(ctxt = ctxt, id = index + 1,
                                hour = prayerTimeStartDateFormattedString.hours,
                                minute = prayerTimeStartDateFormattedString.minutes,
                                nameOfPrayer = nameOfPrayer,
                                prayerTimeStartDateFormatted = prayerTimeStartDateFormattedString,
                                index = index)
                    } else if (prayerTimeStartDateFormattedString.after(dateTimeNow) && !isAlarmSoundActive!! && !isAlarmVibrateActive!!) {
                        deleteAlarm(ctxt, index + 1, nameOfPrayer)
                    }
                }

            }
        }
    }
}
