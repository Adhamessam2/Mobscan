import 'package:url_launcher/url_launcher.dart';

class GoogleSecurityService {
  static Future<void> openSecurityCheckup() async {
    final Uri url =
    Uri.parse('https://myaccount.google.com/security-checkup');

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch Google Security Checkup');
    }
  }

  static Future<void> openDeviceActivity() async {
    final Uri url =
    Uri.parse('https://myaccount.google.com/device-activity');

    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch Device Activity');
    }
  }
}