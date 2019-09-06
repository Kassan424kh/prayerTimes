package com.example.flutter_prayer_times.rest

import android.content.Context
import android.os.Build
import android.support.annotation.RequiresApi
import com.example.flutter_prayer_times.AppSettings.AppSettings
import com.example.flutter_prayer_times.JsonFilesServices
import com.google.gson.JsonParser
import retrofit2.Call
import retrofit2.Callback
import java.io.BufferedReader
import java.io.File
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import retrofit2.Response as Response1


class RestServerFactory internal constructor() {
    companion object {
        val restServicePrayerTimes = RestServicePrayerTimes.create()
        fun getDataFromServer(ctxt: Context, force: Boolean = false) {
            val appSettings = AppSettings(ctxt)
            val call = restServicePrayerTimes.all(
                    lat = appSettings.lat.toString(),
                    lng = appSettings.lng.toString(),
                    language = "arabic")

            call.enqueue(object : Callback<Map<String, List<Map<String, List<String>>>>> {
                @RequiresApi(Build.VERSION_CODES.O)
                override fun onResponse(
                        call: Call<Map<String, List<Map<String, List<String>>>>>,
                        response: Response1<Map<String, List<Map<String, List<String>>>>>
                ) {
                    if (!response.isSuccessful)
                        return

                    val resBody = response.body()
                    val fileName = "prayerTimesJsonDateInMonth.json"
                    val filePath = "/data/user/0/com.example.flutter_prayer_times/app_flutter/"

                    var checkIfPrayerDateIsAvailable = true
                    if (File(filePath + fileName).exists()) {
                        val bufferedReader: BufferedReader = File(filePath + fileName).bufferedReader()
                        // Read the text from bufferReader and store in String variable
                        val yourJson = bufferedReader.use { it.readText() }
                        val parser = JsonParser()
                        val element = parser.parse(yourJson)
                        val obj = element!!.getAsJsonObject()
                        val formatters = DateTimeFormatter.ofPattern("yyyy-MM-dd")
                        val todayDate = LocalDate.now().format(formatters)
                        checkIfPrayerDateIsAvailable = todayDate in obj.keySet()
                    }

                    val isWrited = JsonFilesServices.writeToJsonFile(
                            fileName = fileName,
                            jsonObject = resBody,
                            checkQuery = checkIfPrayerDateIsAvailable,
                            checkMessage = "data in $fileName are up to date",
                            force = force)

                    if (isWrited)
                        JsonFilesServices.getTodayDatesFromJsonFile(ctxt)
                    return
                }

                override fun onFailure(
                        call: Call<Map<String, List<Map<String, List<String>>>>>,
                        t: Throwable) {
                    println(t)
                }
            })
        }
    }
}
