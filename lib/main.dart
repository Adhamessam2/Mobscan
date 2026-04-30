import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobscan/controllers/apps_controller/cubit/apps_cubit.dart';
import 'package:mobscan/controllers/security_controller/security_cubit.dart';
import 'package:mobscan/screens/home_page.dart';

import 'controllers/security_controller/security_cubit.dart';

void main() {
  runApp(const Mobscan());
}

class Mobscan extends StatelessWidget {
  const Mobscan({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppsCubit(),
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