import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobscan/controllers/apps_controller/cubit/apps_cubit.dart';
import 'package:mobscan/controllers/apps_controller/cubit/theme_cubit.dart';
import 'package:mobscan/screens/home_page.dart';

void main() {
  runApp(const Mobscan());
}

class Mobscan extends StatelessWidget {
  const Mobscan({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppsCubit()),
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
                primary: Colors.blueAccent,
                surface: Color(0xFFFFFFFF),
                onSurface: Colors.black,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.white,
                selectedItemColor: Colors.blueAccent,
                unselectedItemColor: Colors.grey,
                elevation: 10,
                type: BottomNavigationBarType.fixed,
              ),
            ),

            // DARK THEME
            darkTheme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFF071826),
              cardColor: const Color(0xFF0F1923),
              colorScheme: const ColorScheme.dark(
                primary: Colors.blueAccent,
                surface: Color(0xFF0F1923),
                onSurface: Colors.white,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Color(0xFF0F1923),
                selectedItemColor: Colors.blueAccent,
                unselectedItemColor: Colors.grey,
                elevation: 10,
                type: BottomNavigationBarType.fixed,
              ),
            ),

            home: HomePage(),
          );
        },
      ),
    );
  }
}