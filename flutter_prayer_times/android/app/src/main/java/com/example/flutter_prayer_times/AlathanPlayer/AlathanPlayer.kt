package com.example.flutter_prayer_times.AlathanPlayer

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.media.MediaPlayer
import com.example.flutter_prayer_times.R
import android.content.ContentValues.TAG
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.os.IBinder
import android.util.Log
import android.support.v4.app.NotificationCompat
import android.os.Build.VERSION_CODES.O
import android.os.Build.VERSION.SDK_INT
import android.support.annotation.RequiresApi


class AlathanPlayer : Service(){
    private var mediaPlayer: MediaPlayer? = null
    val ACTION_START_FOREGROUND_SERVICE = "ACTION_START_FOREGROUND_SERVICE"

    override fun onBind(arg0: Intent): IBinder? {
        Log.i(TAG, "onBind()")
        return null
    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        this.mediaPlayer = MediaPlayer.create(this, R.raw.alathan)
        this.mediaPlayer?.start()

        // Notification to keep foregroundService running in android > Android "O" version
        if (SDK_INT >= O) {
            val ANDROID_CHANNEL_ID:String = createNotificationChannel("my_service", "My Background Service")
            val builder = Notification.Builder(this, ANDROID_CHANNEL_ID)
                    .setContentTitle(getString(R.string.app_name))
                    .setContentText("Background service")
                    .setAutoCancel(true)

            val notification = builder.build()
            startForeground(1, notification)

        } else {
            val builder = NotificationCompat.Builder(this)
                    .setContentTitle(getString(R.string.app_name))
                    .setContentText("Background service")
                    .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                    .setAutoCancel(true)
            val notification = builder.build()
            startForeground(1, notification)
        }

        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        this.mediaPlayer?.stop()
    }

    // Create NotificationId "ANDROID_CHANNEL_ID" function
    @RequiresApi(O)
    private fun createNotificationChannel(channelId: String, channelName: String): String{
        val chan = NotificationChannel(channelId,
                channelName, NotificationManager.IMPORTANCE_NONE)
        chan.lightColor = Color.BLUE
        chan.lockscreenVisibility = Notification.VISIBILITY_PRIVATE
        val service = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        service.createNotificationChannel(chan)
        return channelId
    }
}
