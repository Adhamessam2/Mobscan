import 'package:flutter/services.dart';

class VirusTotalService {
  static const MethodChannel _channel =
  MethodChannel('app.scanner/virustotal');
  Future<List<dynamic>> getInstalledAppsNames() async {
    final result = await _channel.invokeMethod('getInstalledApps');
    return result;
  }
}