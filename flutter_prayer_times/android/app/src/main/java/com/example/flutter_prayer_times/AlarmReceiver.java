package com.example.flutter_prayer_times;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

import com.example.flutter_prayer_times.rest.RestServerFactory;

public class AlarmReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context arg0, Intent intent) {
        // For our recurring task, we'll just display a message
        //Toast.makeText(arg0, "Prayer Times are updated", Toast.LENGTH_SHORT).show();
        RestServerFactory.getDataFromServer(arg0);
    }
}