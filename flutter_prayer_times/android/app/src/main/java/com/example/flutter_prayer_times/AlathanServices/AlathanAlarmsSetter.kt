package com.example.flutter_prayer_times.AlathanServices

import android.content.Context
import android.os.Build
import android.support.annotation.RequiresApi
import android.widget.Toast
import com.example.flutter_prayer_times.AlarmM
import com.google.gson.JsonArray
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

class AlathanAlarmsSetter {
    @RequiresApi(Build.VERSION_CODES.O)
    fun setAlathanAlarms(array: JsonArray, ctxt: Context) {
        // Alathan Player setter
        // Format yyyy-MM-dd HH:mm:ssz

        var dateTimeInString: String? = null
        for (i in 0..(array.size() - 1)) {
            if (i == 1)
                continue

            val prayerTimeJsonObject = array.get(i).asJsonObject
            var nameOfPrayer = ""

            // get start dateTime Of Prayer
            for (keyInObject: String in prayerTimeJsonObject.keySet()) {
                dateTimeInString = (prayerTimeJsonObject[keyInObject] as JsonArray).get(0).toString().replace("\"", "")
                nameOfPrayer = keyInObject
            }

            if (dateTimeInString != null) {
                val dateTimeNow: LocalDateTime = LocalDateTime.now()
                val prayerTimeStartDateFormatted = LocalDateTime.parse(dateTimeInString,
                        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ssz"))
                if (prayerTimeStartDateFormatted.isAfter(dateTimeNow)) {
                    AlarmM.setPrayerTimesToPlayAlathan(ctxt, i + 1,
                            prayerTimeStartDateFormatted.hour,
                            prayerTimeStartDateFormatted.minute,
                            nameOfPrayer,
                            prayerTimeStartDateFormatted)
                }
            }
        }
    }
}
