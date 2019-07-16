package com.example.flutter_prayer_times.rest

import retrofit2.Call
import retrofit2.http.GET

interface RestServicePrayerTimes {
    @get:GET("/")
    val all: Call<List<Map<String, List<String>>>>
}
