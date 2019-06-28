package com.example.flutter_prayer_times.rest;

import java.util.List;
import java.util.Map;

import retrofit2.Call;
import retrofit2.http.GET;

public interface RestServicePrayerTimes {
    @GET("/")
    Call<List<Map<String, List<String>>>> getAll();
}
