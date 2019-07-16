package com.example.flutter_prayer_times.AlathanPlayer

import android.media.MediaPlayer
import java.io.IOException


class AlathanPlayer @Throws(IOException::class)
internal constructor() {
    init {
        val PATH_TO_FILE = "/sdcard/music.mp3"
        val mediaPlayer = MediaPlayer()
        mediaPlayer.setDataSource(PATH_TO_FILE)
        mediaPlayer.prepare()
        mediaPlayer.start()
    }
}
