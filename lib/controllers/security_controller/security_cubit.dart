import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mobscan/controllers/security_controller/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/Scan_result.dart';
import '../../services/notification_service.dart';
import '../../services/security_service.dart';

part 'security_state.dart';

class SecurityCubit extends Cubit<SecurityState> {
  static final List<ScanResult> defaultResults = [
    ScanResult(
      svg: 'assets/icons/hook_blue.svg',
      svgColor: Colors.blue.withOpacity(0.2),
      behaviour: "Secure",
      behavColor: Colors.blue,
      explain: "No one monitor you",
      smallExplain: "Device is safe",
    ),
    ScanResult(
      svg: 'assets/icons/secret_blue.svg',
      svgColor: Colors.blue.withOpacity(0.2),
      behaviour: "Secure",
      behavColor: Colors.blue,
      explain: "Root Detection",
      smallExplain: "Environment is safe",
    ),
    ScanResult(
      svg: 'assets/icons/emulator.svg',
      svgColor: Colors.blue.withOpacity(0.2),
      behaviour: "Secure",
      behavColor: Colors.blue,
      explain: "Physical Device",
      smallExplain: "Not an emulator",
    ),
    ScanResult(
      svg: 'assets/icons/secret_blue.svg',
      svgColor: Colors.blue.withOpacity(0.2),
      behaviour: "Secure",
      behavColor: Colors.blue,
      explain: "Blacklist Scan",
      smallExplain: "No dangerous apps detected",
    ),
  ];

  SecurityCubit() : super(SecuirtyInitial()) {
    results = List.from(defaultResults);
  }
  List<ScanResult> results = [];
  List<ScanResult> result_virus = [];
  int threats = 0;
  int score = 100;
  final SecurityService _service = SecurityService();
  static const platform = MethodChannel('mobscan/security');

  Future<bool> isNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notifications') ?? true;
  }

  Future<void> sendNotificationIfEnabled({
    required String title,
    required String body,
  }) async {
    if (await isNotificationEnabled()) {
      await NotificationService.showRiskNotification(title: title, body: body);
    }
  }

  Future<void> _collectBlacklistedAppsResults() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('blacklist')
        .get();

    final apps = await VirusTotalService().getInstalledAppsNames();

    final blacklistIds = snapshot.docs.map((doc) => doc.id).toList();

    // Offload heavy signature matching to background Isolate to protect main UI thread
    final List<String> matchedPackages = await compute(matchBlacklistedApps, {
      'apps': apps,
      'blacklist': blacklistIds,
    });

    bool dangerousAppFound = matchedPackages.isNotEmpty;

    for (final packageName in matchedPackages) {
      threats++;
      results.add(
        ScanResult(
          svg: 'assets/icons/secret.svg',
          svgColor: Colors.red.withOpacity(0.2),
          behaviour: "High",
          behavColor: Colors.red,
          explain: packageName,
          smallExplain: "Dangerous app detected",
        ),
      );
    }

    if (!dangerousAppFound) {
      results.add(
        ScanResult(
          svg: 'assets/icons/secret_blue.svg',
          svgColor: Colors.blue.withOpacity(0.2),
          behaviour: "Secure",
          behavColor: Colors.blue,
          explain: "Blacklist Scan",
          smallExplain: "No dangerous apps detected",
        ),
      );
    }
  }

  Future<void> checkblacklistedApps() async {
    emit(SecurityLoading());
    try {
      await _collectBlacklistedAppsResults();
    } catch (e) {
      debugPrint("Standalone blacklist check error: $e");
    }
    emit(SecuritySuccess(results, calculateScore(), DateTime.now(), threats));
  }

  Future<void> checkVirusTotal(String sha256Hash, String packageName) async {
    final response = await http.get(
      Uri.parse('https://www.virustotal.com/api/v3/files/$sha256Hash'),
      headers: {
        'x-apikey':
            '7165900d04c37bb0dc21af8f44a2439c40a193d765c1f2433a3d5adde61cf250',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final stats = data['data']['attributes']['last_analysis_stats'];

      final malicious = stats['malicious'] ?? 0;

      final suspicious = stats['suspicious'] ?? 0;

      debugPrint(
        "$packageName => "
        "malicious=$malicious "
        "suspicious=$suspicious",
      );
    }
  }

  Future<void> scanApps() async {
    final apps = await VirusTotalService().getInstalledAppsNames();

    for (final app in apps.take(5)) {
      try {
        await checkVirusTotal(app['hash'], app['packageName']);
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> _collectRootJailbreakResults() async {
    final isNotTrust = await _service.isRooted();
    final isRealDevice = await _service.isRealDevice();
    final isDebug = await _service.isDebugMode();
    final isDevmode = await _service.isDeveloperMode();

    if (isNotTrust) {
      threats++;
      results.add(
        ScanResult(
          svg: 'assets/icons/secret.svg',
          svgColor: Colors.red.withOpacity(0.2),
          behaviour: "High",
          behavColor: Colors.red,
          explain: "Device may be rooted or jailbroken",
          smallExplain: "Use a secure physical device",
        ),
      );
    }

    if (!isNotTrust) {
      results.add(
        ScanResult(
          svg: 'assets/icons/secret_blue.svg',
          svgColor: Colors.blue.withOpacity(0.2),
          behaviour: "Secure",
          behavColor: Colors.blue,
          explain: "Root Detection",
          smallExplain: "Environment is safe",
        ),
      );
    }

    if (!isRealDevice) {
      threats++;
      results.add(
        ScanResult(
          svg: 'assets/icons/emulator_red.svg',
          svgColor: Colors.red.withOpacity(0.2),
          behaviour: "Medium",
          behavColor: Colors.redAccent,
          explain: "Running on Emulator",
          smallExplain: "Use real device",
        ),
      );
    }

    if (isRealDevice) {
      results.add(
        ScanResult(
          svg: 'assets/icons/emulator.svg',
          svgColor: Colors.blue.withOpacity(0.2),
          behaviour: "Secure",
          behavColor: Colors.blue,
          explain: "Physical Device",
          smallExplain: "Not an emulator",
        ),
      );
    }

    if (isDevmode) {
      threats++;
      results.add(
        ScanResult(
          svg: 'assets/icons/debug_red.svg',
          svgColor: Colors.red.withOpacity(0.2),
          behaviour: "High",
          behavColor: Colors.red,
          explain: "Dev Mode Enabled",
          smallExplain: "Turn off devmode",
        ),
      );
    }
    if (isDebug) {
      threats++;
      results.add(
        ScanResult(
          svg: 'assets/icons/debug_red.svg',
          svgColor: Colors.red.withOpacity(0.2),
          behaviour: "High",
          behavColor: Colors.red,
          explain: "Debug Mode Enabled",
          smallExplain: "Turn off debugging",
        ),
      );
    }
    if (results.isEmpty) {
      results.add(
        ScanResult(
          svg: 'assets/icons/safe.svg',
          svgColor: Colors.green.withOpacity(0.2),
          behaviour: "Secure",
          behavColor: Colors.green,
          explain: "Device Secure",
          smallExplain: "No threats detected",
        ),
      );
    }
  }

  Future<void> checkRootJailbreak() async {
    emit(SecurityLoading());
    try {
      await _collectRootJailbreakResults();
    } catch (e) {
      debugPrint("Standalone Root check error: $e");
    }
    emit(SecuritySuccess(results, calculateScore(), DateTime.now(), threats));
  }

  Future<void> _collectFridaResults() async {
    bool isFrida = await _service.checkFrida();
    if (isFrida) {
      threats++;
      results.add(
        ScanResult(
          svg: 'assets/icons/hook.svg',
          svgColor: Colors.red.withOpacity(0.2),
          behaviour: "Frida Hook",
          behavColor: Colors.red,
          explain: "Frida detected",
          smallExplain: "Device is insecure",
        ),
      );
    }
    if (!isFrida) {
      results.add(
        ScanResult(
          svg: 'assets/icons/hook_blue.svg',
          svgColor: Colors.blue.withOpacity(0.2),
          behaviour: "Secure",
          behavColor: Colors.blue,
          explain: "No one monitor you",
          smallExplain: "Device is safe",
        ),
      );
    }
  }

  Future<void> checkFridaExist() async {
    emit(SecurityLoading());
    try {
      await _collectFridaResults();
    } catch (e) {
      debugPrint("Standalone Frida check error: $e");
    }
    emit(SecuritySuccess(results, calculateScore(), DateTime.now(), threats));
  }

  int calculateScore() {
    int score = 100;

    for (var r in results) {
      final behaviour = r.behaviour;
      final explain = r.explain.toLowerCase();
      final smallExplain = r.smallExplain.toLowerCase();

      // Runtime hooking (Frida/Xposed) - Critical Flaw (-40%)
      if (behaviour == "Frida Hook" || explain.contains("frida")) {
        score -= 40;
      }
      // Rooted/Jailbroken status - Critical Flaw (-40%)
      else if (explain.contains("root") || explain.contains("jailbreak")) {
        if (behaviour != "Secure") {
          score -= 40;
        }
      }
      // Emulator status - Moderate Flaw (-20%)
      else if (explain.contains("emulator")) {
        if (behaviour != "Secure") {
          score -= 20;
        }
      }
      // Malicious/Suspicious/Blacklisted Package - Moderate Flaw (-20%)
      else if (smallExplain.contains("dangerous app") ||
          explain.contains("blacklist")) {
        if (behaviour != "Secure") {
          score -= 20;
        }
      }
      // Dev / Debug mode enabled - Moderate Flaw (-20%)
      else if (behaviour != "Secure") {
        score -= 20;
      }
    }

    return score.clamp(0, 100);
  }

  Future<void> fullScan() async {
    results = [];
    threats = 0;

    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      emit(SecurityLoading(i));
    }

    try {
      await _collectFridaResults();
    } catch (e) {
      debugPrint("Frida check error: $e");
    }

    try {
      await _collectRootJailbreakResults();
    } catch (e) {
      debugPrint("Root check error: $e");
    }

    try {
      await _collectBlacklistedAppsResults();
    } catch (e) {
      debugPrint("Blacklist check error: $e");
    }

    final finalScore = calculateScore();
    final now = DateTime.now();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_scan', now.toIso8601String());
    } catch (e) {
      debugPrint("Error saving last scan time: $e");
    }

    print("Final score = $finalScore");
    emit(SecuritySuccess(results, finalScore, now, threats));
  }

  Future<void> getLastScan() async {
    final prefs = await SharedPreferences.getInstance();

    final lastScanString = prefs.getString('last_scan');

    if (lastScanString != null) {
      emit(SecuirtyInitial(lastScan: DateTime.parse(lastScanString)));
    } else {
      emit(SecuirtyInitial());
    }
  }
}

/// Top-level function used with compute() to match installed apps against blacklist in a background isolate.
List<String> matchBlacklistedApps(Map<String, dynamic> params) {
  final List<dynamic> apps = params['apps'] as List<dynamic>;
  final List<dynamic> blacklistList = params['blacklist'] as List<dynamic>;
  final Set<String> blacklistSet = Set<String>.from(blacklistList);

  final List<String> matchedPackages = [];
  for (final app in apps) {
    if (app is Map) {
      final packageName = app['packageName'] as String?;
      if (packageName != null && blacklistSet.contains(packageName)) {
        matchedPackages.add(packageName);
      }
    }
  }
  return matchedPackages;
}
