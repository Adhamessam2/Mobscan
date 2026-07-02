import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

import '../controllers/apps_controller/cubit/settings_cubit.dart';
import '../services/security_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {

    if (task == autoScanTaskName) {
      final service = SecurityService();
      await service.fullAutoScan();

    }

    return Future.value(true);
  });
}