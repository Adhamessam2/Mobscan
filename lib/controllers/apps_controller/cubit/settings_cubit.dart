import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart';

part 'settings_state.dart';

const String autoScanTaskName = 'mobscan_auto_scan';
const String autoScanTaskId = 'mobscan_auto_scan_id';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    emit(state.copyWith(
      autoScan: prefs.getBool('autoScan') ?? false,
      notifications: prefs.getBool('notifications') ?? false,
    ));
  }

  Future<void> toggleAutoScan(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autoScan', value);

    if (value) {
      // Register periodic background scan every 6 hours
      await Workmanager().registerPeriodicTask(
        autoScanTaskId,
        autoScanTaskName,
        frequency: const Duration(hours: 6),
        existingWorkPolicy: ExistingWorkPolicy.replace,
        constraints: Constraints(
          networkType: NetworkType.not_required,
        ),
      );
    } else {
      // Cancel background scan
      await Workmanager().cancelByUniqueName(autoScanTaskId);
    }

    emit(state.copyWith(autoScan: value));
  }

  Future<void> toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value) {
      final status = await Permission.notification.request();
      if (!status.isGranted) {
        // Permission denied, don't turn on
        return;
      }
    }

    await prefs.setBool('notifications', value);
    emit(state.copyWith(notifications: value));
  }
}