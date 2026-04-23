import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobscan/core/appcolors.dart';
import 'package:mobscan/screens/Onborarding.dart';
import 'package:mobscan/screens/Permissions_Screen.dart';
import 'package:mobscan/screens/Setting_Screen.dart';
import 'package:mobscan/screens/apps.dart';
import 'package:mobscan/screens/main_dashboard.dart';
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
    PermissionsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[count],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(22, 27, 34, 1),
        currentIndex: count,

        onTap: (index) {
          setState(() {
            count = index;
          });
        },

        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/home.svg',
              width: 24,
              height: 24,
            ),
            label: '',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.apps_rounded, color: Appcolors.cardColor),
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