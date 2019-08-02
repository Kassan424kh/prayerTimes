package com.example.flutter_prayer_times

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.MediaPlayer
import android.widget.Toast

class AlathanPlayerReceiver : BroadcastReceiver() {
    override fun onReceive(ctxt: Context, intent: Intent) {
        print("Hallo World")
        Toast.makeText(ctxt, "Alathan is running", Toast.LENGTH_SHORT).show()
    }
}