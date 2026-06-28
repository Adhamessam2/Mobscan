import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:meta/meta.dart';
import 'package:mobscan/controllers/security_controller/service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/Scan_result.dart';

part 'security_state.dart';

class SecurityCubit extends Cubit<SecurityState> {
  SecurityCubit() : super(SecuirtyInitial());
  List<ScanResult> results = [];
  List<ScanResult>result_virus=[];
  int threats = 0;
  int? score;
  static const platform = MethodChannel('mobscan/security');
  Future<bool> checkFrida() async {
    return await platform.invokeMethod('checkFrida');
  }
  Future<void>checkblacklistedApps()async{
    final snapshot =await FirebaseFirestore.instance.collection('blacklist').get();
    final apps =
    await VirusTotalService()
        .getInstalledAppsNames();
    Set<String> blacklist = {};
    for (var doc in snapshot.docs) {
      blacklist.add(doc.id);
    }
      for (var app in apps) {
        final packageName = app['packageName'] as String;
        if (blacklist.contains(packageName)) {
          print("${app.appName} is dangerous");
          threats++;
          results.add(
            ScanResult(
              svg: 'assets/icons/secret.svg',
              svgColor: Colors.red.withOpacity(0.2),
              behaviour: "High",
              behavColor: Colors.red,
              explain:app.packageName,
              smallExplain: 'Exist dangerous app',)
          );
      }else{
          threats++;
          results.add(
              ScanResult(
                svg: 'assets/icons/secret.svg',
                svgColor: Colors.blue.withOpacity(0.2),
                behaviour: "Secure",
                behavColor: Colors.blue,
                explain:app.packageName,
                smallExplain: 'No dangerous app',)
          );
        }
    }
    emit(SecuritySuccess(results, calculateScore(),DateTime.now(),threats));
  }
  Future<void> checkVirusTotal(
      String sha256Hash,
      String packageName,
      ) async {
    final response = await http.get(
      Uri.parse(
        'https://www.virustotal.com/api/v3/files/$sha256Hash',
      ),
      headers: {
        'x-apikey': '7165900d04c37bb0dc21af8f44a2439c40a193d765c1f2433a3d5adde61cf250',
      },
    );

    if (response.statusCode == 200) {
      final data =
      jsonDecode(response.body);

      final stats =
      data['data']['attributes']
      ['last_analysis_stats'];

      final malicious =
          stats['malicious'] ?? 0;

      final suspicious =
          stats['suspicious'] ?? 0;
      final harmless = stats['harmless'] ?? 0;

      debugPrint(
        "$packageName => "
            "malicious=$malicious "
            "suspicious=$suspicious",
      );
    }
  }
  Future<void> scanApps() async {
    final apps =
    await VirusTotalService().getInstalledAppsNames();

    for (final app in apps.take(5)) {
      try {
        await checkVirusTotal(
          app['hash'],
          app['packageName'],
        );
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }
  Future<void> checkRootJailbreak() async {
    emit(SecurityLoading());

    final isNotTrust = await JailbreakRootDetection.instance.isNotTrust;
    final isRealDevice = await JailbreakRootDetection.instance.isRealDevice;
    final isDebug = await JailbreakRootDetection.instance.isDebugged;
    final isDevmode = await JailbreakRootDetection.instance.isDevMode;

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
    emit(SecuritySuccess(results, calculateScore(),DateTime.now(),threats));
  }
  Future<void> checkFridaExist() async {
    emit(SecurityLoading());

    bool isFrida = await checkFrida();
    print("Frida result = $isFrida");
    if (isFrida) {
      threats++;
      results.add(
        ScanResult(
          svg: 'assets/icons/hook.svg',
          svgColor: Colors.red.withOpacity(0.2),
          behaviour: "Someone monitor you",
          behavColor: Colors.red,
          explain: "Frida detected",
          smallExplain: "Device is insecure",
        ),
      );
    } if(!isFrida) {
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
    emit(SecuritySuccess(results, calculateScore(),DateTime.now(),threats));
  }

  int calculateScore() {
    int score = 100;

    for (var r in results) {
      switch (r.behaviour) {
        case "High":
          score -= 30;
          break;
        case "Medium":
          score -= 15;
          break;
        case "Frida Hook":
          score -= 40;
          break;
        case "Secure":
          score -= 0;
          break;
      }
    }
    return score.clamp(0, 100);
  }
  Future<void> fullScan() async {
    results = [];
    threats = 0;
    for (int i = 0; i <= 100; i++) {
      emit(SecurityLoading(i));

      await Future.delayed(Duration(milliseconds: 50));
    }
      await checkFridaExist();
      await checkRootJailbreak();
      //await scanApps();
    await checkblacklistedApps();
  }
  Future<void> getLastScan() async {
    final prefs = await SharedPreferences.getInstance();

    final lastScanString = prefs.getString('last_scan');

    if (lastScanString != null) {
      emit(
        SecuirtyInitial(
          lastScan: DateTime.parse(lastScanString),
        ),
      );
    } else {
      emit(SecuirtyInitial());
    }
  }
}