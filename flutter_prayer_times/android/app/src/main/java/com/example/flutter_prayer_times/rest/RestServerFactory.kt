package com.example.flutter_prayer_times.rest

import android.annotation.SuppressLint
import android.content.Context
import android.widget.Toast
import com.example.flutter_prayer_times.AppSettings.AppSettings

import org.json.simple.JSONArray

import java.io.FileWriter
import java.io.IOException

import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.jackson.JacksonConverterFactory
import java.io.File

class RestServerFactory internal constructor(ctxt: Context) {

    var ctxt: Context? = null

    init {
        this.ctxt = ctxt
    }

    companion object {
        fun createRestService(ctxt: Context): RestServicePrayerTimes {

            val appSettings = AppSettings(ctxt)
            println(appSettings.lat)
            println(appSettings.lng)
            println(appSettings.place)

            val BASE_URL = "https://stage.prayer-times.vsyou.app/?lat=${appSettings.lat}&lng=${appSettings.lng}&today=true&language=arabic"

            val retrofit = Retrofit.Builder()
                    .baseUrl(BASE_URL)
                    .addConverterFactory(JacksonConverterFactory.create())
                    .build()

            return retrofit.create(RestServicePrayerTimes::class.java)
        }

        fun getDataFromServer(ctxt: Context) {
            val restServicePrayerTimes = createRestService(ctxt)

            val call = restServicePrayerTimes.all

            call.enqueue(object : Callback<List<Map<String, List<String>>>> {

                override fun onResponse(
                        call: Call<List<Map<String, List<String>>>>,
                        response: Response<List<Map<String, List<String>>>>
                ) {
                    if (!response.isSuccessful) {
                        return
                    }

                    val resBody = response.body()

                    println("List of API" + resBody!!)

                    val listOfPrayers = JSONArray()
                    for (i in 0 until resBody.toTypedArray().size) {
                        listOfPrayers.add(resBody.toTypedArray()[i])
                    }

                    try {
                        val filePath = "/data/user/0/com.example.flutter_prayer_times/app_flutter/serverDataFile.json"
                        FileWriter(filePath).use { file ->
                            file.write(listOfPrayers.toJSONString())
                            println("Successfully Copied JSON Object to File...")
                            Toast.makeText(ctxt, "Prayer Times are updated", Toast.LENGTH_LONG).show()
                            println("JSON Object: $listOfPrayers")
                        }

                        /*
                        // Alathan Player setter
                        // Format yyyy-MM-dd HH:mm:ssz
                        val string = "2019-08-03 05:40:00Z"
                        val date = LocalDateTime.parse(string, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ssz"))
                        println(date.hour)
                        println(date.minute)
                        AlarmM.setPrayerTimesToPlayAlathan(this, 0, date.hour, date.minute)
                        */

                    } catch (e: IOException) {
                        Toast.makeText(ctxt, "Prayer Times cann't updated", Toast.LENGTH_LONG).show()
                        e.printStackTrace()
                    }

                    return
                }

                override fun onFailure(
                        call: Call<List<Map<String, List<String>>>>,
                        t: Throwable) {
                    println("TestTest")
                    println(t)
                }
            })
        }
    }

}
