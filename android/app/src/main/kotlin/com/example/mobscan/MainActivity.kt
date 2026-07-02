package com.example.mobscan

import android.content.pm.PackageManager
import java.io.File
import java.security.MessageDigest
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val PERMISSION_CHANNEL = "mobscan.scanner/permissions"
    private val SECURITY_CHANNEL = "mobscan/security"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // VirusTotal Channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "mobscan.scanner/virustotal"
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "getInstalledApps" -> {

                    try {

                        val packageManager = packageManager
                        val installedApps = packageManager.getInstalledApplications(
                            PackageManager.GET_META_DATA
                        )

                        val appsList = mutableListOf<Map<String, String>>()

                        for (app in installedApps.take(10)) {

                            try {

                                val appName =
                                    packageManager.getApplicationLabel(app).toString()

                                val packageName = app.packageName

                                val hash =
                                    calculateSHA256(app.sourceDir)

                                appsList.add(
                                    mapOf(
                                        "appName" to appName,
                                        "packageName" to packageName,
                                        "hash" to hash
                                    )
                                )

                            } catch (e: Exception) {
                                e.printStackTrace()
                            }
                        }

                        result.success(appsList)

                    } catch (e: Exception) {

                        result.error(
                            "ERROR",
                            e.message,
                            null
                        )
                    }
                }

                else -> result.notImplemented()
            }
        }

        // Permissions Channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PERMISSION_CHANNEL
        ).setMethodCallHandler { call, result ->

            PermissionHandler().handle(
                call,
                result,
                packageManager
            )
        }

        // Security Channel
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            SECURITY_CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                "checkFrida" -> {
                    result.success(SecurityDetector.isFridaDetected())
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun calculateSHA256(filePath: String): String {

        val digest = MessageDigest.getInstance("SHA-256")
        val file = File(filePath)

        file.inputStream().use { inputStream ->

            val buffer = ByteArray(8192)
            var bytesRead: Int

            while (
                inputStream.read(buffer).also {
                    bytesRead = it
                } != -1
            ) {
                digest.update(
                    buffer,
                    0,
                    bytesRead
                )
            }
        }

        return digest.digest().joinToString("") {
            "%02x".format(it)
        }
    }
}