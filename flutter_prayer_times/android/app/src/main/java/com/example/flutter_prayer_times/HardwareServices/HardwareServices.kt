package com.example.flutter_prayer_times.HardwareServices

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator

class HardwareServices {
    companion object{
        fun vibrateAlathan(ctxt: Context) {
            val vibrator = ctxt.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                vibrator.vibrate(VibrationEffect.createOneShot(200, VibrationEffect.DEFAULT_AMPLITUDE))
            else
                vibrator.vibrate(200)
        }
    }
}