import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:meta/meta.dart';

import '../../../models/Scan_result.dart';

part 'security_state.dart';

class SecurityCubit extends Cubit<SecurityState> {
  SecurityCubit() : super(SecurityLoading());

  List<ScanResult> results = [];
  int threats = 0;

  static const platform = MethodChannel('mobscan/security');

  // =========================
  // FRIDA CHECK
  // =========================
  Future<bool> checkFrida() async {
    return await platform.invokeMethod('checkFrida');
  }

  // =========================
  // FULL ROOT / DEVICE SCAN
  // =========================
  Future<void> checkRootJailbreak() async {
    emit(SecurityLoading());

    results = [];
    threats = 0;

    final isNotTrust = await JailbreakRootDetection.instance.isNotTrust;
    final isRealDevice = await JailbreakRootDetection.instance.isRealDevice;
    final isDebug = await JailbreakRootDetection.instance.isDebugged;
    final isDevmode = await JailbreakRootDetection.instance.isDevMode;

    // 🔴 Root / Jailbreak
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

    // 🟢 Safe root check
    if (!isNotTrust) {
      results.add(
        ScanResult(
          svg: 'assets/icons/da.svg',
          svgColor: Colors.blue.withOpacity(0.2),
          behaviour: "Secure",
          behavColor: Colors.blue,
          explain: "Root Detection",
          smallExplain: "Environment is safe",
        ),
      );
    }

    // ⚠️ Emulator check
    if (!isRealDevice) {
      threats++;
      results.add(
        ScanResult(
          svg: 'assets/icons/emulator.svg',
          svgColor: Colors.orange.withOpacity(0.2),
          behaviour: "Medium",
          behavColor: Colors.orange,
          explain: "Running on Emulator",
          smallExplain: "Use real device",
        ),
      );
    }

    // 🟢 Real device
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

    // 🔴 Dev mode / Debug
    if (isDebug || isDevmode) {
      threats++;
      results.add(
        ScanResult(
          svg: 'assets/icons/debug.svg',
          svgColor: Colors.red.withOpacity(0.2),
          behaviour: "High",
          behavColor: Colors.red,
          explain: "Debug/Dev Mode Enabled",
          smallExplain: "Turn off debugging",
        ),
      );
    }

    // 🟢 Safe state fallback
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

    emit(SecuritySuccess(results));
  }

  // =========================
  // FRIDA SCAN
  // =========================
  Future<void> checkFridalog() async {
    emit(SecurityLoading());

    results = [];
    threats = 0;

    bool isFrida = await checkFrida();

    if (isFrida) {
      threats++;
      results.add(
        ScanResult(
          svg: 'assets/icons/debug.svg',
          svgColor: Colors.red.withOpacity(0.2),
          behaviour: "Frida Hook",
          behavColor: Colors.red,
          explain: "Frida detected",
          smallExplain: "Device is insecure",
        ),
      );
    } else {
      results.add(
        ScanResult(
          svg: 'assets/icons/safe.svg',
          svgColor: Colors.green.withOpacity(0.2),
          behaviour: "Secure",
          behavColor: Colors.green,
          explain: "No Frida detected",
          smallExplain: "Device is safe",
        ),
      );
    }

    emit(SecuritySuccess(results));
  }
}