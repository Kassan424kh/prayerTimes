package com.example.flutter_prayer_times;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

import java.util.Calendar;

public class AlarmM {
    public static void playPrayerAlathan(Context ctxt, int id, int hour, int minute) {
        android.app.AlarmManager alarmMgr;
        PendingIntent alarmIntent;

        alarmMgr = (android.app.AlarmManager)ctxt.getSystemService(Context.ALARM_SERVICE);
        Intent intent = new Intent(ctxt, AlarmReceiver.class);
        alarmIntent = PendingIntent.getBroadcast(ctxt, id, intent, 0);

        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(System.currentTimeMillis());
        calendar.set(Calendar.HOUR_OF_DAY, hour);
        calendar.set(Calendar.MINUTE, minute);
        calendar.set(Calendar.SECOND, 0);

        alarmMgr.setRepeating(android.app.AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), AlarmManager.INTERVAL_DAY, alarmIntent);

        System.out.println("test asdfasdfasdf asdfasdf  sdafasdf");
        Toast.makeText(ctxt, "Alarm Set", Toast.LENGTH_SHORT).show();
    }
}
