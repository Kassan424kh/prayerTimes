package com.example.flutter_prayer_times.HardwareServices

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator

class HardwareServices {
    companion object{
        var mVibratePattern = longArrayOf(0, 500, 300, 500, 700, 500,
                600, 800, 400, 300, 500, 100, 500, 300)
        fun vibrateAlathan(ctxt: Context) {
            val vibrator = ctxt.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                vibrator.vibrate(VibrationEffect.createWaveform(mVibratePattern, -1))
            else
                vibrator.vibrate(3000)
        }
    }
}