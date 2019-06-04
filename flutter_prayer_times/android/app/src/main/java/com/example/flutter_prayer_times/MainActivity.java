package com.example.flutter_prayer_times;

import android.os.Bundle;
import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.provider.DocumentsContract;
import android.widget.Toast;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Calendar;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class MainActivity extends FlutterActivity {
  private PendingIntent pendingIntent;
  private AlarmManager manager;

  public void playPrayerAlathan (int id, int hour, int minute) {
    Intent alarmIntent = new Intent(this, AlarmReceiver.class);
    pendingIntent = PendingIntent.getBroadcast(this, id, alarmIntent, 0);

    manager = (AlarmManager)getSystemService(Context.ALARM_SERVICE);

    Calendar calendar = Calendar.getInstance();
    calendar.setTimeInMillis(System.currentTimeMillis());
    calendar.set(Calendar.HOUR_OF_DAY, hour);
    calendar.set(Calendar.MINUTE, minute);
    calendar.set(Calendar.SECOND, 0);

    manager.setInexactRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), AlarmManager.INTERVAL_DAY, pendingIntent);
    Toast.makeText(this, "Alarm Set", Toast.LENGTH_SHORT).show();
  }

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    /*playPrayerAlathan(0, 13, 19);


    File folder = new File("/data/user/0/com.example.flutter_prayer_times/app_flutter");
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
