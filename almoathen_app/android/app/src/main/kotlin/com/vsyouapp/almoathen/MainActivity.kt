package com.vsyouapp.almoathen

import android.content.Context
import android.content.Intent
import android.media.AudioManager
import android.os.Bundle
import android.provider.MediaStore
import android.widget.Toast
import com.vsyouapp.almoathen.Receiver.AlathanPlayerReceiver
import com.vsyouapp.almoathen.rest.RestServerFactory
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit

class MainActivity : FlutterActivity() {
    private val CHANNEL = "app.native/updater"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
            when {
                call.method == "updatePrayerTimesAfterNewPlaceData" -> {
                    RestServerFactory.getDataFromServer(this, true)
                    result.success(true)
                }
                call.method == "updateTodayPrayerTimes" -> {
                    Executors.newSingleThreadScheduledExecutor().schedule({
                        JsonFilesServices.getTodayDatesFromJsonFile(this, true)
                    }, 1500, TimeUnit.MILLISECONDS)
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                    Toast.makeText(this, "prayerTimes not updated", Toast.LENGTH_LONG).show()
                }
            }
        }

        AlarmM.updatePrayerTimesAt1HourDaily(this, 0, 1, 0)

       /* AlarmM.setPrayerTimesToPlayAlathan(ctxt = this, id = 21,
                hour = 6,
                minute = 49,
                nameOfPrayer = "",
                index = 0)*/

        this.startService(Intent(this, AlathanPlayerReceiver::class.java))
    }
}