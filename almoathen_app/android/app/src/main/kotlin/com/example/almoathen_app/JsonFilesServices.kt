package com.example.almoathen_app

import android.annotation.SuppressLint
import android.content.Context
import android.content.ContextWrapper
import android.os.Build
import com.example.almoathen_app.AlathanServices.AlathanAlarmsSetter
import com.example.almoathen_app.rest.RestServerFactory
import com.google.gson.Gson
import com.google.gson.JsonArray
import com.google.gson.JsonObject
import com.google.gson.JsonParser
import org.json.simple.JSONArray
import java.io.BufferedReader
import java.io.File
import java.io.FileWriter
import java.io.IOException
import java.text.SimpleDateFormat
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.util.*

class JsonFilesServices {
    companion object {

        private fun getApplicationDataPath (ctxt: Context) :String {
            val contextWrapper = ContextWrapper(ctxt)
            return contextWrapper.getDir("flutter", 0).path
        }

        fun writeToJsonFile(ctxt: Context, fileName: String, jsonObject: Any?, checkQuery: Boolean = true, checkMessage: String = "", force: Boolean = false): Boolean {
            try {
                return if (!File(getApplicationDataPath(ctxt) + fileName).exists() || (File(getApplicationDataPath(ctxt) + fileName).exists() && !checkQuery) || force) {
                    FileWriter(getApplicationDataPath(ctxt) + fileName).use { file ->
                        val gson = Gson()
                        val prayersObject = gson.toJson(jsonObject)
                        file.write(prayersObject)
                        println("Successfully Copied JSON Object to $fileName File...")
                    }
                    true
                } else {
                    println("File $fileName is created, or $checkMessage")
                    true
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
                val contextWrapper = ContextWrapper(ctxt)
                val filePath = contextWrapper.getDir("flutter", 0).path
                val jsonFilePath = "$filePath/prayerTimesJsonDateInMonth.json"
                val jsonFile = File(jsonFilePath)
                if (jsonFile.exists()) {
                    val bufferedReader: BufferedReader = jsonFile.bufferedReader()
                    // Read the text from bufferReader and store in String variable
                    val yourJson = bufferedReader.use { it.readText() }
                    val parser = JsonParser()
                    val element = parser.parse(yourJson)
                    obj = element!!.asJsonObject
                } else {
                    RestServerFactory.getDataFromServer(ctxt)
                    println("prayerTimesJsonDateInMonth.json file isn't exists")
                }
            } catch (e: Exception) {
                println("Error[**332**] $e")
            }
            return obj
        }

        @SuppressLint("SimpleDateFormat")
        fun getTodayDatesFromJsonFile(ctxt: Context, force: Boolean = false): JsonArray? {
            fun dateNow () :String {
                return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val formatters = DateTimeFormatter.ofPattern("yyyy-MM-dd")
                    LocalDate.now().format(formatters)
                } else{
                    val formatters = SimpleDateFormat("yyyy-MM-dd")
                    formatters.format(Date())
                }
            }

            val objs: JsonObject? = getDataFromJsonFile(ctxt)
            var todayDateDateArray: JsonArray? = null
            if (objs != null) {
                if (dateNow() in objs.keySet()) {
                    todayDateDateArray = objs[dateNow()] as JsonArray

                    val listOfPrayers = JSONArray()
                    for (i in 0 until todayDateDateArray.size())
                        listOfPrayers.add(todayDateDateArray[i])

                    val fileName = "/serverDataFile.json"

                    var checkIfPrayerDateIsAvailable = true
                    if (File(getApplicationDataPath(ctxt) + fileName).exists()) {
                        val bufferedReader: BufferedReader = File(getApplicationDataPath(ctxt) + fileName).bufferedReader()
                        // Read the text from bufferReader and store in String variable
                        val yourJson = bufferedReader.use { it.readText() }
                        val parser = JsonParser()
                        val element = parser.parse(yourJson)
                        val obj = element.asJsonArray
                        val innerObject = obj.get(0).asJsonObject
                        var dateOfStartPrayerTimesDatetime = ""
                        for (key: String in innerObject.keySet()) {
                            dateOfStartPrayerTimesDatetime = innerObject.get(key).asJsonArray.get(0).toString().subSequence(1, 11).toString()
                            break
                        }
                        checkIfPrayerDateIsAvailable = dateNow() == dateOfStartPrayerTimesDatetime
                    }

                    writeToJsonFile(
                            ctxt = ctxt,
                            fileName = fileName,
                            jsonObject = todayDateDateArray,
                            checkQuery = checkIfPrayerDateIsAvailable,
                            checkMessage = "$fileName is up to date",
                            force = force)

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