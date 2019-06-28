package com.example.flutter_prayer_times;

import android.content.Context;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public class MainActivity extends FlutterActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        GeneratedPluginRegistrant.registerWith(this);

        Date date = new Date();   // given date
        Calendar calendar = GregorianCalendar.getInstance();
        calendar.setTime(date);
        calendar.get(Calendar.MINUTE);
        System.out.println(calendar.get(Calendar.MINUTE) + 1);
        AlarmM.playPrayerAlathan(this, 0, 1, 0);

        /*File folder = new File("/data/user/0/com.example.flutter_prayer_times/app_flutter");
        File[] listOfFiles = folder.listFiles();

        for (int i = 0; i < listOfFiles.length; i++) {
            if (listOfFiles[i].isFile()) {
                System.out.println("File " + listOfFiles[i].getName());
            } else if (listOfFiles[i].isDirectory()) {
                System.out.println("Directory " + listOfFiles[i].getName());
            }
        }*/
    }


}


