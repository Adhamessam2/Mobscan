package com.mobscan1.app

import android.content.pm.PackageManager
import android.os.Build
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PermissionHandler {

    fun handle(call: MethodCall, result: MethodChannel.Result, packageManager: PackageManager) {

        if (call.method != "getAppPermissions") {
            result.notImplemented()
            return
        }

        val packageName = call.argument<String>("packageName")

        if (packageName == null) {
            result.error("INVALID_PACKAGE", "Package name is null", null)
            return
        }

        try {

            val packageInfo =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    packageManager.getPackageInfo(
                        packageName,
                        PackageManager.PackageInfoFlags.of(
                            PackageManager.GET_PERMISSIONS.toLong()
                        )
                    )
                } else {
                    @Suppress("DEPRECATION")
                    packageManager.getPackageInfo(
                        packageName,
                        PackageManager.GET_PERMISSIONS
                    )
                }

            val permissions =
                packageInfo.requestedPermissions?.toList() ?: emptyList()

            result.success(permissions)

        } catch (e: Exception) {
            result.error("ERROR", e.message, null)
        }
    }
}