import 'package:app/services/risk_calculator_service.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';

import '../models/app_model.dart';

class AppScannerService {
  final RiskCalculatorService _riskEngine = RiskCalculatorService();

  // Method Channel
  static const platform = MethodChannel('app.scanner/permissions');

  Future<List<AppModel>> scanDevice() async {
    List<AppModel> scannedResults = [];

    try {
      print("========== App Scanner ==========");
      print("Fetching installed apps...");

      final List<AppInfo> apps =
      await InstalledApps.getInstalledApps(withIcon: true);

      print("Installed apps found: ${apps.length}");

      for (AppInfo app in apps) {
        List<String> perms = [];

        try {
          final List<dynamic> result = await platform.invokeMethod(
            'getAppPermissions',
            {'packageName': app.packageName},
          );

          perms = result.cast<String>();
        } on PlatformException catch (e) {
          print(
              "Permission error for ${app.packageName}: ${e.message}");
        }

        final String categoryName = app.category.name;

        final riskResult =
        _riskEngine.calculateRisk(categoryName, perms);

        scannedResults.add(
          AppModel(
            name: app.name,
            package: app.packageName,
            category: categoryName,
            requestedPermissions: perms,
            riskLevel: riskResult['score'],
            riskReason: riskResult['reason'],
            icon: app.icon,
          ),
        );
      }

      scannedResults.sort(
            (a, b) => b.riskLevel!.compareTo(a.riskLevel!),
      );

      print("Final scanned apps: ${scannedResults.length}");
      print("========== Finished ==========");

      return scannedResults;
    } catch (e, stackTrace) {
      print("========== Scanner Error ==========");
      print(e);
      print(stackTrace);
      print("===================================");

      return [];
    }
  }
}