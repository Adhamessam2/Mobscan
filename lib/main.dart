import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mobscan/screens/main_dashboard.dart';
import 'package:mobscan/screens/call_dispacher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';
import 'package:mobscan/core/appcolors.dart';
import 'package:mobscan/controllers/apps_controller/cubit/apps_cubit.dart';
import 'package:mobscan/controllers/apps_controller/cubit/theme_cubit.dart';
import 'package:mobscan/controllers/security_controller/security_cubit.dart';
import 'package:mobscan/firebase_options.dart';
import 'package:mobscan/screens/auth/auth_gate.dart';
import 'package:mobscan/services/app_scanner_service.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(
        (await getApplicationDocumentsDirectory()).path,
      ),
    );

    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );

    runApp(const Mobscan());
  }
}

class Mobscan extends StatelessWidget {
  const Mobscan({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<AppsCubit>(
          create: (_) => AppsCubit(AppScannerService()),
        ),
        BlocProvider<SecurityCubit>(
          create: (_) => SecurityCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: state.themeMode,

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

            home:const AuthGate(),
          );
        },
      ),
    );
  }
}