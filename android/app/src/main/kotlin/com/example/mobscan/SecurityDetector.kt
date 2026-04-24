package com.example.mobscan

import java.io.File
import java.net.Socket

object SecurityDetector {
    fun isFridaRunning(): Boolean {
        return try {
            val process = Runtime.getRuntime().exec("ps")
            val output = process.inputStream.bufferedReader().readText()

            output.contains("frida") ||
                    output.contains("frida-server") ||
                    output.contains("gadget")
        } catch (e: Exception) {
            false
        }
    }

    fun isFridaPortOpen(): Boolean {
        return try {
            Socket("127.0.0.1", 27042).close()
            true
        } catch (e: Exception) {
            false
        }
    }
    fun checkLoadedLibraries(): Boolean {
        return try {
            val maps = File("/proc/self/maps").readText()

            maps.contains("frida") ||
                    maps.contains("gadget") ||
                    maps.contains("gum-js-loop")
        } catch (e: Exception) {
            false
        }
    }
    fun isFridaDetected(): Boolean {
        return isFridaRunning() ||
                isFridaPortOpen() ||
                checkLoadedLibraries()
    }
}