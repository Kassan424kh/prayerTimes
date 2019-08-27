package com.example.flutter_prayer_times.AppSettings

import com.google.gson.Gson
import java.io.BufferedReader
import java.io.File

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

class AppSettings {

    var appSettingsFormat: AppSettingsFormat? = null

    private var gson = Gson()

    val appSettingsJsonfile: File = File("/data/user/0/com.example.flutter_prayer_times/app_flutter/appSettings.json")
    val bufferedReader: BufferedReader = appSettingsJsonfile.bufferedReader()
    val stringFromJsonFile = bufferedReader.use { it.readText() }
    var appSettingsData = gson.fromJson(stringFromJsonFile, AppSettingsFormat::class.java)

    fun isAppSettingsFileExists(): Boolean {
        return appSettingsJsonfile.exists()
    }

    private val geoLocationData : Place? =  appSettingsData.place
    val lat : String? =  geoLocationData?.lat
    val lng : String? =  geoLocationData?.lng
    val place : String? =  geoLocationData?.place

    fun getDataFromAppSettingsFile(): AppSettingsFormat {
        return appSettingsData
    }
}
