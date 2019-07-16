package com.example.flutter_prayer_times.rest

import android.content.Context
import android.widget.Toast

import org.json.simple.JSONArray

import java.io.FileWriter
import java.io.IOException

import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.jackson.JacksonConverterFactory

class RestServerFactory internal constructor(ctxt: Context) {

    internal var ctxt: Context? = null

    init {
        this.ctxt = ctxt
    }

    companion object {

        private val BASE_URL = "https://prayer-times.vsyou.app"


        fun createRestService(): RestServicePrayerTimes {
            val retrofit = Retrofit.Builder()
                    .baseUrl(BASE_URL)
                    .addConverterFactory(JacksonConverterFactory.create())
                    .build()

            return retrofit.create(RestServicePrayerTimes::class.java)
        }

        fun getDataFromServer(ctxt: Context) {
            val restServicePrayerTimes = createRestService()

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
                        FileWriter("/data/user/0/com.example.flutter_prayer_times/app_flutter/serverDataFile.json").use { file ->
                            file.write(listOfPrayers.toJSONString())
                            println("Successfully Copied JSON Object to File...")
                            Toast.makeText(ctxt, "Prayer Times are updated", Toast.LENGTH_SHORT).show()
                            println("JSON Object: $listOfPrayers")
                        }
                    } catch (e: IOException) {
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
