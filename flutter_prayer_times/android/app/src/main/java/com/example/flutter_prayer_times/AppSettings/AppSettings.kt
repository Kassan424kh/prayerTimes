package com.example.flutter_prayer_times.AppSettings

import android.content.Context
import com.example.flutter_prayer_times.R
import com.google.gson.Gson
import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader

class AppSettingsFormat {
    var place: Place? = null
    var acceptPlayingAthans: List<Boolean>? = null
    var languages: Languages? = null
}

class Place {
    var lat: String? = null
    var lng: String? = null
    var place: String? = null
}

class Languages {
    var arabic: Boolean? = null
    var english: Boolean? = null
    var persian: Boolean? = null
    var turkish: Boolean? = null
}

class AppSettings constructor(ctx: Context) {

    var appSettingsFormat: AppSettingsFormat? = null

    var stringFromJsonFile: String? = null
    private var gson = Gson()

    init {
        try {
            val appSettingsJsonfile = File("/data/user/0/com.example.flutter_prayer_times/app_flutter/appSettings.json")
            val bufferedReader: BufferedReader? = if (!appSettingsJsonfile.exists()){
                println("get place data from default appSettings Json File")
                BufferedReader(InputStreamReader(ctx.getResources().openRawResource(R.raw.default_app_settings)))
            } else{
                println("get place data from appSettings Json File")
                appSettingsJsonfile.bufferedReader()
            }
            stringFromJsonFile = bufferedReader.use { it?.readText() }
        } catch (e: Exception) {
            print(e)
        }
    }

    var appSettingsData = gson.fromJson(stringFromJsonFile, AppSettingsFormat::class.java)

    private val geoLocationData: Place? = appSettingsData.place
    val lat: String? = geoLocationData?.lat
    val lng: String? = geoLocationData?.lng
    val place: String? = geoLocationData?.place

    fun getDataFromAppSettingsFile(): AppSettingsFormat {
        return appSettingsData
    }
}
