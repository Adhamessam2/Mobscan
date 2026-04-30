package com.example.mobscan

import android.content.pm.PackageManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "mobscan.scanner/permissions"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAppPermissions") {
                val packageName = call.argument<String>("packageName")
                if (packageName != null) {
                    try {
                        // Ask Android specifically for the permissions of this single app
                        val packageInfo = context.packageManager.getPackageInfo(
                            packageName, 
                            PackageManager.GET_PERMISSIONS
                        )
                        // Extract the array and send it back to Flutter
                        val permissions = packageInfo.requestedPermissions?.toList() ?: emptyList<String>()
                        result.success(permissions)
                    } catch (e: PackageManager.NameNotFoundException) {
                        result.success(emptyList<String>())
                    }
                } else {
                    result.error("ERROR", "Package name was null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
