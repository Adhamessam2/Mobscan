import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/security_controller/service.dart';
import 'notification_service.dart';

class SecurityService {
  static const platform = MethodChannel('mobscan/security');
  Future<void> checkBlacklistedApps() async {
    final snapshot =
    await FirebaseFirestore.instance.collection('blacklist').get();

    final apps = await VirusTotalService().getInstalledAppsNames();

    final prefs = await SharedPreferences.getInstance();
    final notificationsEnabled =
        prefs.getBool('notifications') ?? false;

    Set<String> blacklist = {};

    for (var doc in snapshot.docs) {
      blacklist.add(doc.id);
    }

    for (var app in apps) {
      final packageName = app['packageName'];

      if (blacklist.contains(packageName)) {
        if (notificationsEnabled) {
          await NotificationService.showRiskNotification(
            title: "${app.appName} is dangerous",
            body: "Uninstall it now.",
          );
        }
      }
    }
  }
  Future<bool> checkFrida() async {
    return await platform.invokeMethod('checkFrida');
  }

  Future<bool> isRooted() async {
    return await JailbreakRootDetection.instance.isNotTrust;
  }

  Future<bool> isDeveloperMode() async {
    return await JailbreakRootDetection.instance.isDevMode;
  }

  Future<bool> isDebugMode() async {
    return await JailbreakRootDetection.instance.isDebugged;
  }

  Future<bool> isRealDevice() async {
    return await JailbreakRootDetection.instance.isRealDevice;
  }
  Future<void> fullAutoScan() async {
    final prefs = await SharedPreferences.getInstance();

    final notificationsEnabled =
        prefs.getBool('notifications') ?? false;

    if (await checkFrida()) {
      if (notificationsEnabled) {
        await NotificationService.showRiskNotification(
          title: "Frida Detected",
          body: "Someone may be monitoring your device.",
        );
      }
    }

    // Root
    if (await isRooted()) {
      if (notificationsEnabled) {
        await NotificationService.showRiskNotification(
          title: "Device Security Alert",
          body: "Your device appears to be rooted.",
        );
      }
    }

    // Developer Mode
    if (await isDeveloperMode()) {
      if (notificationsEnabled) {
        await NotificationService.showRiskNotification(
          title: "Developer Mode Enabled",
          body: "This may reduce your device security.",
        );
      }
    }
    if (await isDebugMode()) {
      if (notificationsEnabled) {
        await NotificationService.showRiskNotification(
          title: "Debug Mode Enabled",
          body: "Disable debugging to improve security.",
        );
      }
    }

    await checkBlacklistedApps();
  }
}