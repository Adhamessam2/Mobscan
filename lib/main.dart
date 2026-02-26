import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobscan/controllers/apps_controller/cubit/apps_cubit.dart';
import 'package:mobscan/screens/splash_Screen.dart';

void main() {
  runApp(const Mobscan());
}

class Mobscan extends StatelessWidget {
  const Mobscan({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppsCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
