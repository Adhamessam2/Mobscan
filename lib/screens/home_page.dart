import 'package:flutter/material.dart';
import '../core/appcolors.dart';
import 'Permissions_Screen.dart';
import 'Setting_Screen.dart';
import 'apps.dart';
import 'link_checker_screen.dart';
import 'main_dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int count = 0;

  final List<Widget> pages = [
    MainDashboard(),
    Apps(),
    LinkCheckerScreen(),
    //AdminBlacklistScreen(),
    PermissionsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[count],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // backgroundColor: const Color.fromRGBO(22, 27, 34, 1),
        currentIndex: count,

        onTap: (index) {
          setState(() {
            count = index;
          });
        },

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Appcolors.cardColor),
            label: '',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.apps_rounded, color: Appcolors.cardColor),
            label: '',
           ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.app_blocking,color: Appcolors.cardColor),
          //   label: '',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.link, color: Appcolors.cardColor),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security, color: Appcolors.cardColor),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Appcolors.cardColor),
            label: '',
          ),
        ],
      ),
    );
  }
}