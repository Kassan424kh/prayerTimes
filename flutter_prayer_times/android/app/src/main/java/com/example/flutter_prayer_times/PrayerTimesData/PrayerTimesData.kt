package com.example.flutter_prayer_times.PrayerTimesData

import com.google.gson.Gson
import java.io.BufferedReader
import java.io.File

class PrayersFormat {
    val days: PrayerDateTimesFormat? = null
}

class PrayerDateTimesFormat {
    val dateTime: Map<String, List<String>>? = null
}

class PrayersData {
    private var gson = Gson()

    val prayersFormatJsonfile: File = File("/data/user/0/com.example.flutter_prayer_times/app_flutter/appSettings.json")
    val bufferedReader: BufferedReader = prayersFormatJsonfile.bufferedReader()
    val stringFromJsonFile = bufferedReader.use { it.readText() }
    var prayersDataData = gson.fromJson(stringFromJsonFile, PrayersFormat::class.java)

    fun getDataFromPrayersJsonFile(): PrayersFormat {
        return prayersDataData
    }
}
