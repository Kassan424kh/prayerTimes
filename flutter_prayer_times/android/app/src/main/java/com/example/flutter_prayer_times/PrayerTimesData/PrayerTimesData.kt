package com.example.flutter_prayer_times.PrayerTimesData

import android.annotation.SuppressLint
import android.content.Context
import android.content.ContextWrapper
import com.example.flutter_prayer_times.MainActivity
import com.google.gson.Gson
import java.io.BufferedReader
import java.io.File

class PrayersFormat {
    val days: PrayerDateTimesFormat? = null
}

class PrayerDateTimesFormat {
    val dateTime: Map<String, List<String>>? = null
}

class PrayersData(ctxt:Context) {
    private var gson = Gson()
    val contextWrapper = ContextWrapper(ctxt)
    val filePath = contextWrapper.getDir("flutter", 0).path
    val prayersFormatJsonfile: File = File(filePath + "/appSettings.json")
    val bufferedReader: BufferedReader = prayersFormatJsonfile.bufferedReader()
    val stringFromJsonFile = bufferedReader.use { it.readText() }
    var prayersDataData = gson.fromJson(stringFromJsonFile, PrayersFormat::class.java)

    fun getDataFromPrayersJsonFile(): PrayersFormat {
        return prayersDataData
    }
}
