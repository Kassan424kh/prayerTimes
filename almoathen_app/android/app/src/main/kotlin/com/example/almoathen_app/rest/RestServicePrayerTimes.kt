package com.example.almoathen_app.rest

import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.jackson.JacksonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query

interface RestServicePrayerTimes {
    @GET("/")
    fun all(@Query("lat") lat: String,
            @Query("lng") lng: String,
            @Query("language") language: String): Call<Map<String, List<Map<String, List<String>>>>>

    /**
     * Companion object to create the GithubApiService
     */
    companion object Factory {
        fun create() : RestServicePrayerTimes {
            val BASE_URL = "https://prayer-times.vsyou.app/"
            val retrofit = Retrofit.Builder()
                    .baseUrl(BASE_URL)
                    .addConverterFactory(JacksonConverterFactory.create())
                    .build()

            return retrofit.create(RestServicePrayerTimes::class.java)
        }
    }
}
