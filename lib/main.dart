import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobscan/controllers/apps_controller/cubit/apps_cubit.dart';
import 'package:mobscan/controllers/apps_controller/cubit/theme_cubit.dart';
import 'package:mobscan/screens/home_page.dart';
import 'package:mobscan/services/app_scanner_service.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'controllers/security_controller/security_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
        (await getApplicationDocumentsDirectory()).path,
  ),
  );
  runApp(const Mobscan());
}

class Mobscan extends StatelessWidget {
  const Mobscan({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppsCubit(AppScannerService()),
        ),
        BlocProvider(
          create: (context) => SecurityCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}