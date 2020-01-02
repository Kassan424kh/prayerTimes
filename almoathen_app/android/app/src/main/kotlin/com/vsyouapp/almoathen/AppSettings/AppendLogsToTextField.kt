package com.vsyouapp.almoathen.AppSettings

import android.os.Build
import android.os.Environment
import androidx.annotation.RequiresApi
import java.io.BufferedWriter
import java.io.File
import java.io.FileWriter
import java.io.IOException

object AppendLogsToTextField {
    @RequiresApi(Build.VERSION_CODES.O)
    fun appendLog(text: String?) {
        println(Environment.getExternalStoragePublicDirectory("Download").path+"/almoathen.log")
        val logFile = File(Environment.getExternalStoragePublicDirectory("Download/almoathen").path + "/almoathen_logs.txt")
        if (!logFile.exists()) {
            try {
                logFile.createNewFile()
            } catch (e: IOException) {
                e.printStackTrace()
            }
        }
        try {
            val buf = BufferedWriter(FileWriter(logFile, true))
            buf.append(text)
            buf.newLine()
            buf.close()
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }
}