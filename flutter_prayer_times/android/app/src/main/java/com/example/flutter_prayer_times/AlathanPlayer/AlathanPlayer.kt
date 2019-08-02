package com.example.flutter_prayer_times.AlathanPlayer

import android.app.Service
import android.media.MediaPlayer
import android.widget.Toast
import com.example.flutter_prayer_times.R
import android.content.ContentValues.TAG
import android.content.Intent
import android.os.IBinder
import android.util.Log
import com.example.flutter_prayer_times.MainActivity

class AlathanPlayer : Service(){
    private var mediaPlayer:MediaPlayer? = null
    private var mainActivity: MainActivity = MainActivity()

    override fun onBind(arg0: Intent): IBinder? {
        Log.i(TAG, "onBind()")
        return null
    }

    override fun onCreate() {
        super.onCreate()
        this.mediaPlayer = MediaPlayer()
    }

    override fun onStartCommand ( intent: Intent, flags: Int, startId: Int): Int{
        this.mediaPlayer = MediaPlayer.create(mainActivity.context, R.raw.alathan)
        this.mediaPlayer?.setOnPreparedListener{
            println("Ready to go!")
        }
        this.mediaPlayer?.start()
        Toast.makeText(mainActivity.context,  "Alathan is running", Toast.LENGTH_SHORT).show()
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        this.mediaPlayer?.stop()
    }
}
