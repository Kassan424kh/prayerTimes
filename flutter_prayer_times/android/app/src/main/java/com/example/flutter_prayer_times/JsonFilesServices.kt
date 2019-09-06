package com.example.flutter_prayer_times

import android.content.Context
import android.os.Build
import android.support.annotation.RequiresApi
import com.example.flutter_prayer_times.AlathanServices.AlathanAlarmsSetter
import com.example.flutter_prayer_times.rest.RestServerFactory
import com.google.gson.Gson
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import org.json.simple.JSONArray
import java.io.BufferedReader
import java.io.File
import java.io.FileWriter
import java.io.IOException
import java.time.LocalDate
import java.time.format.DateTimeFormatter

class JsonFilesServices {
    companion object {
        val filePath = "/data/user/0/com.example.flutter_prayer_times/app_flutter/"

        fun writeToJsonFile(fileName: String, jsonObject: Any?, checkQuery: Boolean = true, checkMessage: String = ""): Boolean {
            try {
                if (!File(filePath + fileName).exists() || (File(filePath + fileName).exists() && !checkQuery)) {
                    FileWriter(filePath + fileName).use { file ->
                        val gson = Gson()
                        val prayersOpject = gson.toJson(jsonObject)
                        file.write(prayersOpject)
                        println("Successfully Copied JSON Object to $fileName File...")
                    }
                    return true
                } else {
                    println("File $fileName is created, or $checkMessage")
                    return true
                }
            } catch (e: IOException) {
                e.printStackTrace()
                println(e)
                return false
            }
        }

        fun getDataFromJsonFile(ctxt: Context): JsonObject? {
            var obj: JsonObject? = null
            try {
                val jsonFilePath = "/data/user/0/com.example.flutter_prayer_times/app_flutter/prayerTimesJsonDateInMonth.json"
                val jsonFile = File(jsonFilePath)
                if (jsonFile.exists()) {
                    val bufferedReader: BufferedReader = jsonFile.bufferedReader()
                    // Read the text from bufferReader and store in String variable
                    val yourJson = bufferedReader.use { it.readText() }
                    val parser = JsonParser()
                    val element = parser.parse(yourJson)
                    obj = element!!.getAsJsonObject()
                } else {
                    RestServerFactory.getDataFromServer(ctxt)
                    print("prayerTimesJsonDateInMonth.json file isn't exists")
                }
            } catch (e: Exception) {
                print("Error[**332**]" + e)
            }
            return obj
        }

        @RequiresApi(Build.VERSION_CODES.O)
        fun getTodayDatesFromJsonFile(ctxt: Context): JsonArray? {
            val objs: JsonObject? = getDataFromJsonFile(ctxt)
            var todayDateDateArray: JsonArray? = null
            if (objs != null) {
                val formatters = DateTimeFormatter.ofPattern("yyyy-MM-dd")
                val todayDate = LocalDate.now().format(formatters)
                if (todayDate in objs.keySet()) {
                    todayDateDateArray = objs[todayDate] as JsonArray

                    val listOfPrayers = JSONArray()
                    for (i in 0 until todayDateDateArray.size())
                        listOfPrayers.add(todayDateDateArray[i])

                    val fileName = "serverDataFile.json"

                    var checkIfPrayerDateIsAvailable = true
                    if (File(filePath + fileName).exists()) {
                        val bufferedReader: BufferedReader = File(filePath + fileName).bufferedReader()
                        // Read the text from bufferReader and store in String variable
                        val yourJson = bufferedReader.use { it.readText() }
                        val parser = JsonParser()
                        val element = parser.parse(yourJson)
                        val obj = element.asJsonArray
                        val formatters = DateTimeFormatter.ofPattern("yyyy-MM-dd")
                        val todayDate = LocalDate.now().format(formatters)
                        val innerObject = obj.get(0).asJsonObject
                        var dateOfStartPrayerTimesDatetime = ""
                        for (key: String in innerObject.keySet()) {
                            dateOfStartPrayerTimesDatetime = innerObject.get(key).asJsonArray.get(0).toString().subSequence(1, 11).toString()
                            break
                        }
                        checkIfPrayerDateIsAvailable = todayDate.equals(dateOfStartPrayerTimesDatetime)
                    }

                    writeToJsonFile(fileName, todayDateDateArray, checkIfPrayerDateIsAvailable, "$fileName is up to date")

                    val alathanAlarmsSetter = AlathanAlarmsSetter()
                    alathanAlarmsSetter.setAlathanAlarms(array = todayDateDateArray, ctxt = ctxt)

                } else
                    RestServerFactory.getDataFromServer(ctxt)
            } else
                RestServerFactory.getDataFromServer(ctxt)
            return todayDateDateArray
        }
    }
}