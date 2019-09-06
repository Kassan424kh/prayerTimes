package com.example.flutter_prayer_times.Receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.Toast
import com.example.flutter_prayer_times.AlathanServices.AlathanPlayer

class AlathanPlayerReceiver : BroadcastReceiver() {
    override fun onReceive(ctxt: Context, intent: Intent) {
        Toast.makeText(ctxt, "Alathan is running", Toast.LENGTH_SHORT).show()

        val alathanPlayerClass = AlathanPlayer()
        val alathanPlayer = AlathanPlayer::class.java
        val myService = Intent(ctxt, alathanPlayer)
        myService.setAction(alathanPlayerClass.ACTION_START_FOREGROUND_SERVICE)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ctxt.startForegroundService(myService)
        } else {
            ctxt.startService(myService)
        }

    }
}