import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobscan/core/appcolors.dart';
import 'package:workmanager/workmanager.dart';
import 'package:mobscan/controllers/apps_controller/cubit/apps_cubit.dart';
import 'package:mobscan/controllers/apps_controller/cubit/theme_cubit.dart';
import 'package:mobscan/screens/splash_Screen.dart';
import 'package:mobscan/services/app_scanner_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == 'mobscan_auto_scan') {
      final scannerService = AppScannerService();
      await scannerService.scanDevice();
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(const Mobscan());
}

class Mobscan extends StatelessWidget {
  const Mobscan({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppsCubit(AppScannerService())),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: state.themeMode,

            // LIGHT THEME
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFFF0F4F8),
              cardColor: const Color(0xFFFFFFFF),
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF007BFF),
                surface: Color(0xFFFFFFFF),
                tertiary: Appcolors.cardBackground,
                onSurface: Colors.black,
              ),
            ),

            // DARK THEME
            darkTheme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFF071826),
              cardColor: const Color(0xFF0F1923),
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF0F1923),
                surface: Color(0xFF0F1923),
                tertiary: Color(0xFF0F1923),
                onSurface: Colors.white,
              ),
            ),

            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
