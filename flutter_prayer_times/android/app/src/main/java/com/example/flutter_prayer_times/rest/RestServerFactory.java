package com.example.flutter_prayer_times.rest;

import android.content.Context;
import android.widget.Toast;

import org.json.simple.JSONArray;

import java.io.FileWriter;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.jackson.JacksonConverterFactory;

public class RestServerFactory {

    Context ctxt = null;

    RestServerFactory(Context ctxt){
        this.ctxt = ctxt;
    }

    private static final String BASE_URL = "https://prayer-times.vsyou.app";


    public static RestServicePrayerTimes createRestService() {
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(BASE_URL)
                .addConverterFactory(JacksonConverterFactory.create())
                .build();

        return retrofit.create(RestServicePrayerTimes.class);
    }

    public static void getDataFromServer(Context ctxt) {
        RestServicePrayerTimes restServicePrayerTimes = createRestService();

        Call<List<Map<String, List<String>>>> call = restServicePrayerTimes.getAll();

        call.enqueue(new Callback<List<Map<String, List<String>>>>() {

            @Override
            public void onResponse(
                    Call<List<Map<String, List<String>>>> call,
                    Response<List<Map<String, List<String>>>> response
            ) {
                if (!response.isSuccessful()) {
                    return;
                }

                List<Map<String, List<String>>> resBody = response.body();

                System.out.println("List of API" + resBody);

                JSONArray listOfPrayers = new JSONArray();
                for (int i = 0; i < resBody.toArray().length; i++) {
                    listOfPrayers.add(resBody.toArray()[i]);
                }

                try (FileWriter file = new FileWriter("/data/user/0/com.example.flutter_prayer_times/app_flutter/serverDataFile.json")) {
                    file.write(listOfPrayers.toJSONString());
                    System.out.println("Successfully Copied JSON Object to File...");
                    Toast.makeText(ctxt, "Prayer Times are updated", Toast.LENGTH_SHORT).show();
                    System.out.println("JSON Object: " + listOfPrayers);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                return;
            }

            @Override
            public void onFailure(
                    Call<List<Map<String, List<String>>>> call,
                    Throwable t) {
                System.out.println("TestTest");
                System.out.println(t);
            }
        });
    }

}
