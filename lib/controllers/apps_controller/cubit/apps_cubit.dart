import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:mobscan/models/app_model.dart';

import '../../../models/Scan_result.dart';

part 'apps_state.dart';

class AppsCubit extends Cubit<AppsState> {
  AppsCubit() : super(AppsState.initial());
  int categoryIndex = 0;
  List<ScanResult> results = [];
  List<AppModel> apps = AppModel.apps;
  List<AppModel> get safeApps =>
      state.allApps.where((app) => app.riskLevel <= 50).toList();
  List<AppModel> get riskyApps =>
      state.allApps.where((app) => app.riskLevel > 50).toList();

  void getApps() {
    emit(state.copyWith(status: AppStatus.loading));
    if (apps.isEmpty) {
      emit(state.copyWith(status: AppStatus.failed, allApps: []));
      return;
    }
    emit(state.copyWith(status: AppStatus.success, allApps: apps));
  }


  void changeCategory(int index) {
    categoryIndex = index;
    emit(state.copyWith(selectedCategoryIndex: index));
  }

  void navigateToNextPage(int index) {
    categoryIndex = index;
    emit(state.copyWith(selectedCategoryIndex: index));
  }

  void search(String appname) {
    if (appname.isEmpty) {
      emit(state.copyWith(allApps: apps));
      return;
    }
    final results = apps
        .where(
          (item) =>
              item.name.toLowerCase().contains(appname.trim().toLowerCase()),
        )
        .toList();
    if (results.isEmpty) {
      emit(state.copyWith(allApps: []));
    } else {
      emit(state.copyWith(allApps: results));
    }
  }
  Future<void> checkRootJailbreak() async {
    emit(state.copyWith(status: AppStatus.loading));
    results = [];
    final isNotTrust = await JailbreakRootDetection.instance.isNotTrust;
    final isRealDevice = await JailbreakRootDetection.instance.isRealDevice;
    final isDebug = await JailbreakRootDetection.instance.isDebugged;
    final isDevmode = await JailbreakRootDetection.instance.isDevMode;
    if (isNotTrust) {
      results.add(
        ScanResult(
          svg: 'lib/assets/icons/secret.svg',
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
          svg: 'lib/assets/icons/da.svg',
          svgColor: Colors.blue.withOpacity(0.2),
          behaviour: "Secured",
          behavColor: Colors.blue,
          explain: "Root Detection",
          smallExplain: "Your environment is safe",
        ),
      );
    }

    if (isRealDevice) {
      results.add(
        ScanResult(
          svg: 'lib/assets/icons/emulator.svg',
          svgColor: Colors.blue.withOpacity(0.2),
          behaviour: "Secured",
          behavColor: Colors.blue,
          explain: "Emulator",
          smallExplain: "Physical Hardware",
        ),
      );
    }

    if (!isRealDevice) {
      results.add(
        ScanResult(
          svg: 'lib/assets/icons/emulator.svg',
          svgColor: Colors.orange.withOpacity(0.2),
          behaviour: "Medium",
          behavColor: Colors.orange,
          explain: "Running on Emulator",
          smallExplain: "Test on real device",
        ),
      );
    }
    if(isDevmode){
     results.add(ScanResult(
        svg: 'lib/assets/icons/debug.svg',
        svgColor: Colors.red.withOpacity(0.2),
        behaviour: "High",
        behavColor: Colors.red,
        explain: "Devmode",
        smallExplain:"turn off the dev mode",
     )
     );
    }
    if(isDebug){
      results.add(
          ScanResult(
            svg: 'lib/assets/icons/debug.svg',
            svgColor: Colors.red.withOpacity(0.2),
            behaviour: "High",
            behavColor: Colors.red,
            explain: "Debugger",
            smallExplain:"turn off the debug mode",
          )
      );
    }
    if(!isDebug){
      results.add(
          ScanResult(
            svg: 'lib/assets/icons/debug.svg',
            svgColor: Colors.red.withOpacity(0.2),
            behaviour: "Secured",
            behavColor: Colors.blue,
            explain: "Debugger",
            smallExplain:"No active session",
          )
      );
    }

    if (results.isEmpty) {
      results.add(
        ScanResult(
          svg: 'lib/assets/icons/safe.svg',
          svgColor: Colors.green.withOpacity(0.2),
          behaviour: "Info",
          behavColor: Colors.green,
          explain: "Device Secure",
          smallExplain: "No root or jailbreak detected",
        ),
      );
    }

    emit(state.copyWith(
      status: AppStatus.success,
      scanResults: results,
    ));
  }
  static const platform = MethodChannel('mobscan/security');
  Future<bool> checkFrida() async {
    return await platform.invokeMethod('checkFrida');
  }
  Future<void> checkFridalog() async {
    results = [];
    bool isFrida = await checkFrida();
    if (isFrida) {
      results.add(
          ScanResult(
            svg: 'lib/assets/icons/safe.svg',
            svgColor: Colors.red.withOpacity(0.2),
            behaviour: "Frida Hook",
            behavColor: Colors.red,
            explain: "Frida detect",
            smallExplain: "Your device is insecure",
          )
      );
      emit(state.copyWith(
        status: AppStatus.success,
        scanResults: results,
      ));
    }
  }

}
