import 'package:flutter/services.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import 'package:mobscan/models/app_model.dart';
import 'package:mobscan/services/risk_calculator_service.dart';
// import your AppModel and RiskCalculatorService here

class AppScannerService {
  final RiskCalculatorService _riskEngine = RiskCalculatorService();

  // 1. Define the channel exactly as it is in your Kotlin file
  static const platform = MethodChannel('mobscan.scanner/permissions');

  Future<List<AppModel>> scanDevice() async {
    List<AppModel> scannedResults = [];

    try {
      // 2. Fetch the basic app data quickly using the package
      List<AppInfo> apps = await InstalledApps.getInstalledApps(withIcon: true);

      for (AppInfo app in apps) {
        // 3. Call your native Kotlin code for each app!
        List<String> perms = [];
        try {
          final List<dynamic> result = await platform.invokeMethod(
            'getAppPermissions',
            {'packageName': app.packageName},
          );
          perms = result.cast<String>();
        } on PlatformException catch (_) {
          // Silent failure for permission fetching on specific apps
        }

        // 4. Feed the Native data into your Risk Engine
        String categoryName = app.category.name;
        final riskResult = _riskEngine.calculateRisk(categoryName, perms);

        scannedResults.add(
          AppModel(
            name: app.name,
            package: app.packageName,
            category: categoryName,
            requestedPermissions: perms, // Now populated with actual data
            riskLevel: riskResult['score'],
            riskReason: riskResult['reason'],
            icon: app.icon,
          ),
        );
      }

      // Sort highest risk to the top
      scannedResults.sort((a, b) => b.riskLevel!.compareTo(a.riskLevel!));
      return scannedResults;
    } catch (_) {
      return [];
    }
  }
}
