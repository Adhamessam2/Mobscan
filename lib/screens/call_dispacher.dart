import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

import '../controllers/apps_controller/cubit/settings_cubit.dart';
import '../firebase_options.dart';
import '../services/notification_service.dart';
import '../services/security_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await NotificationService.init();
    } catch (e) {
      // In case they are already initialized or fail
    }

    if (task == autoScanTaskName) {
      final service = SecurityService();
      await service.fullAutoScan();
    }

    return Future.value(true);
  });
}
