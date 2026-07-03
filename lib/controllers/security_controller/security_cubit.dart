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
import '../../services/notification_service.dart';
import '../../services/security_service.dart';

part 'security_state.dart';

class SecurityCubit extends Cubit<SecurityState> {
  SecurityCubit() : super(SecuirtyInitial());
  List<ScanResult> results = [];
  List<ScanResult> result_virus = [];
  int threats = 0;
  int? score = 100;
  final SecurityService _service = SecurityService();
  static const platform = MethodChannel('mobscan/security');

  // مدة صلاحية الكاش الخاص بالـ blacklist (ساعة واحدة)
  static const _blacklistCacheDuration = Duration(hours: 1);

  Future<bool> isNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notifications') ?? true;
  }

  Future<void> sendNotificationIfEnabled({
    required String title,
    required String body,
  }) async {
    if (await isNotificationEnabled()) {
      await NotificationService.showRiskNotification(
        title: title,
        body: body,
      );
    }
  }

  /// بيجيب الـ blacklist من الكاش المحلي لو لسه صالح،
  /// وإلا بيجيبها من Firestore ويخزنها كاش من جديد.
  Future<Set<String>> _getBlacklist() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('blacklist_cache');
    final cachedAtMs = prefs.getInt('blacklist_cache_time') ?? 0;
    final cachedAt = DateTime.fromMillisecondsSinceEpoch(cachedAtMs);
    final isFresh =
        cached != null &&
            DateTime.now().difference(cachedAt) < _blacklistCacheDuration;

    if (isFresh) {
      final List<dynamic> ids = jsonDecode(cached);
      return ids.cast<String>().toSet();
    }

    final snapshot =
    await FirebaseFirestore.instance.collection('blacklist').get();
    final ids = snapshot.docs.map((doc) => doc.id).toList();

    await prefs.setString('blacklist_cache', jsonEncode(ids));
    await prefs.setInt(
      'blacklist_cache_time',
      DateTime.now().millisecondsSinceEpoch,
    );

    return ids.toSet();
  }

  // تعديل: استخدام الكاش المحلي للـ blacklist بدل جلبها من Firestore في كل مرة
  Future<void> checkblacklistedApps({int currentProgress = 0}) async {
    emit(SecurityLoading(currentProgress));

    final results2 = await Future.wait([
      _getBlacklist(),
      VirusTotalService().getInstalledAppsNames(),
    ]);

    final blacklist = results2[0] as Set<String>;
    final apps = results2[1] as List<dynamic>;

    for (var app in apps) {
      final packageName = app['packageName'] as String;

      if (blacklist.contains(packageName)) {
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
      } else {
        results.add(
          ScanResult(
            svg: 'assets/icons/secret_blue.svg',
            svgColor: Colors.blue.withOpacity(0.2),
            behaviour: "Secure",
            behavColor: Colors.blue,
            explain: packageName,
            smallExplain: "No dangerous app",
          ),
        );
      }
    }
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
      final data = jsonDecode(response.body);

      final stats = data['data']['attributes']['last_analysis_stats'];

      final malicious = stats['malicious'] ?? 0;
      final suspicious = stats['suspicious'] ?? 0;
      final harmless = stats['harmless'] ?? 0;

      debugPrint(
        "$packageName => "
            "malicious=$malicious "
            "suspicious=$suspicious",
      );
    }
  }

  Future<void> scanApps() async {
    final apps = await VirusTotalService().getInstalledAppsNames();

    // تعديل: تنفيذ الفحوصات بالتوازي بدل واحد ورا التاني
    await Future.wait(
      apps.take(5).map((app) async {
        try {
          await checkVirusTotal(
            app['hash'],
            app['packageName'],
          );
        } catch (e) {
          debugPrint(e.toString());
        }
      }),
    );
  }

  // تعديل: تنفيذ كل نداءات native بالتوازي عن طريق Future.wait بدل التتابع
  Future<void> checkRootJailbreak({int currentProgress = 0}) async {
    emit(SecurityLoading(currentProgress));

    final checks = await Future.wait([
      _service.isRooted(),
      _service.isRealDevice(),
      _service.isDebugMode(),
      _service.isDeveloperMode(),
    ]);

    final isNotTrust = checks[0];
    final isRealDevice = checks[1];
    final isDebug = checks[2];
    final isDevmode = checks[3];

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

  // تعديل: استقبال الـ progress الحالي، وحذف الـ SecuritySuccess من النهاية
  Future<void> checkFridaExist({int currentProgress = 0}) async {
    emit(SecurityLoading(currentProgress));

    bool isFrida = await _service.checkFrida();
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

  /// بيشغل مرحلة فحص حقيقية مع أنيميشن progress "asymptotic":
  /// الرقم بيتحرك تدريجيًا ويقرب من سقف المرحلة (90% منها) وهو مستني
  /// الفحص الحقيقي يخلص، وأول ما الفحص يخلص فعليًا، بيقفز فورًا لآخر
  /// رقم في المرحلة - يعني الرقم والدايرة بيتزامنوا مع اللحظة اللي
  /// البيانات فيها بجد جاهزة، مش قبلها ومش بعدها بفترة زيادة.
  Future<void> _runStage({
    required int from,
    required int to,
    required Future<void> Function() task,
  }) async {
    emit(SecurityLoading(from));

    final range = to - from;
    final softCap = from + (range * 0.9).round();

    int current = from;
    bool taskDone = false;

    final future = task();
    // ignore: unawaited_futures
    future.then((_) => taskDone = true);

    while (!taskDone && current < softCap) {
      final remaining = softCap - current;
      final step = (remaining * 0.15).clamp(1, 3).round();
      await Future.delayed(const Duration(milliseconds: 40));
      if (taskDone) break;
      current = (current + step).clamp(from, softCap);
      emit(SecurityLoading(current));
    }

    await future;

    // أول ما البيانات جاهزة فعليًا، اقفل فورًا على آخر رقم المرحلة
    emit(SecurityLoading(to));
  }

  Future<void> fullScan() async {
    results = [];
    threats = 0;

    await _runStage(
      from: 0,
      to: 30,
      task: () => checkFridaExist(currentProgress: 0),
    );

    await _runStage(
      from: 30,
      to: 70,
      task: () => checkRootJailbreak(currentProgress: 30),
    );

    await _runStage(
      from: 70,
      to: 100,
      task: () => checkblacklistedApps(currentProgress: 70),
    );

    // إرسال حالة النجاح النهائية مرة واحدة فقط - فورًا بمجرد ما البيانات جاهزة
    final now = DateTime.now();
    emit(SecuritySuccess(results, calculateScore(), now, threats));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_scan', now.toIso8601String());
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