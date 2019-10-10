package com.vsyouapp.almoathen.Receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.Toast
import com.vsyouapp.almoathen.AlathanServices.AlathanPlayer

class AlathanPlayerReceiver : BroadcastReceiver() {
    override fun onReceive(ctxt: Context, intent: Intent) {
        val index :Int = intent.getIntExtra("index", -1)
        Toast.makeText(ctxt, "Alathan is running", Toast.LENGTH_SHORT).show()

        val alathanPlayerClass = AlathanPlayer()
        val myService = Intent(ctxt, AlathanPlayer::class.java)
        myService.putExtra("index", index)
        myService.setAction(alathanPlayerClass.ACTION_START_FOREGROUND_SERVICE)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
            ctxt.startForegroundService(myService)
        else
            ctxt.startService(myService)

    }
}