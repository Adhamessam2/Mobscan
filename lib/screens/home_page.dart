import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobscan/screens/apps.dart';
import 'package:mobscan/screens/main_dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int count = 0;

  final List<Widget> pages = [ MainDashboard(),
    Apps()

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[count],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(22, 27, 34, 1),
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
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/apps.svg',
              width: 24,
              height: 24,
            ),
label: 'Apps'
          ),
        ],
      ),
    );
  }
}