package com.example.flutter_prayer_times

import android.content.Context
import java.io.IOException

class TasksToDo {

    private var ctx: Context

    constructor(ctx: Context) {
        this.ctx = ctx
    }

    internal fun listOfContentFilesAndOrdersInAssetOrder(path: String): Boolean {
        val list: Array<String>
        try {
            list = this.ctx.getAssets().list(path)
            if (list.size > 0) {
                // This is a folder
                for (file in list) {
                    if (!listOfContentFilesAndOrdersInAssetOrder("$path/$file")) {
                        println("File is not founded")
                        return false
                    } else {
                        println(file)
                    }
                }
            }
        } catch (e: IOException) {
            return false
        }
        return true
    }
}
