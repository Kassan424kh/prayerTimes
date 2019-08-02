package com.example.flutter_prayer_times

import android.content.Context
import java.io.IOException

class TasksToDo {

    private var ctx: Context

    constructor(ctx: Context) {
        this.ctx = ctx
    }

    internal fun listOfContentFilesAndOrdersInAssetOrder(path: String): Boolean {
        val list: Array<String>?
        try {
            list = this.ctx.getAssets().list(path)
            if (list.isNotEmpty()) {
                // This is a folder
                for (file in list) {
                    if (listOfContentFilesAndOrdersInAssetOrder("$path/$file")) {
                        if (file == "raw/alathan.mp3"){
                            println(file)
                        }
                    } else {
                        println("File is not founded")
                        return false
                    }
                }
            }
        } catch (e: IOException) {
            return false
        }
        return true
    }
}
