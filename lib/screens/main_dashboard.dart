import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:mobscan/models/Scan_result.dart';
import 'package:mobscan/screens/home_page.dart';

class MainDashboard extends StatefulWidget {
  String username;
  String _result = '';

  MainDashboard({super.key, this.username = 'User'});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {

  Future<List<ScanResult>> checkRootJailbreak() async {
    List<ScanResult> results = [];

    final isNotTrust = await JailbreakRootDetection.instance.isNotTrust;
    final isRealDevice = await JailbreakRootDetection.instance.isRealDevice;

    if (isNotTrust) {
      results.add(
        ScanResult(
          title: "Device Not Trusted",
          severity: "High",
          description: "Device may be rooted or jailbroken",
          solution: "Use a secure physical device",
        ),
      );
    }

    if (!isRealDevice) {
      results.add(
        ScanResult(
          title: "Running on Emulator",
          severity: "Medium",
          description: "App is running on emulator",
          solution: "Test on real device",
        ),
      );
    }

    final issues = await JailbreakRootDetection.instance.checkForIssues;

    for (final issue in issues) {
      results.add(
        ScanResult(
          title: "Security Issue",
          severity: "High",
          description: issue.toString(),
          solution: "Investigate device security",
        ),
      );
    }

    return results;
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0A0E14),

      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color(0xff0A0E14),
        leadingWidth: 140,
        leading: Container(
          padding: EdgeInsets.only(left: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                "lib/assets/icons/icon.svg",
                width: 20,
                height: 25,
              ),
              SizedBox(width: 10),
              Text(
                'MobScan',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),

        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.notifications_none_outlined,
                size: 30,
                color: Color(0xFF007BFF),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.menu,
                size: 30,
                color: Color(0xFF007BFF),
              ),
            ),
          ),
        ],
      ),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 5),

            Column(
              children: [
                Text(
                  'Hello,${widget.username}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                  ),
                ),

                Container(
                  height: 42,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 77, 77, 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('lib/assets/icons/plot.svg'),
                      SizedBox(width: 5),
                      Text_color('Device Status: '),
                      Text_color('At Risk'),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 165,
                  width: 170,
                  child: CircularProgressIndicator(
                    color: Color(0xFF007BFF),
                    strokeWidth: 15,
                  ),
                ),

                Column(
                  children: [
                    Text(
                      '78%',
                      style: TextStyle(
                        color: Color(0xFF007BFF),
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'SECURITY SCORE',
                      style: TextStyle(
                        color: Color.fromRGBO(148, 163, 184, 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20),

            GestureDetector(
              onTap: () {},
              child: Container(
                width: 358,
                height: 56,
                decoration: BoxDecoration(
                  color: Color(0xFF007BFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('lib/assets/icons/scan.svg'),
                      SizedBox(width: 10),
                      Text(
                        'Scan Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Text(
              'Last scan: 2 hours . 3 threats found',
              style: TextStyle(color: Color.fromRGBO(100, 116, 139, 1)),
            ),

            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'SECURITY MODELS',
                    style: TextStyle(
                      color: Color.fromRGBO(100, 116, 139, 1),
                      fontSize: 19,
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: GridView(
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.5,
                ),
                children: [
                  report_container(
                    'assets/icons/secret.svg',
                    Color.fromRGBO(255, 77, 77, 0.1),
                    'DETECTED',
                    Colors.redAccent,
                    'Root Detection',
                    'Unsafe environment',
                  ),
                  report_container(
                    'assets/icons/debug.svg',
                    Color(0xFF111827),
                    'SECURE',
                    Color(0xFF007BFF),
                    'Debugger',
                    'No active session',
                  ),
                  report_container(
                    'assets/icons/emulator.svg',
                    Color(0xFF111827),
                    'SECURE',
                    Color(0xFF007BFF),
                    'Emulator',
                    'Physical hardware',
                  ),
                  report_container(
                    'assets/icons/hook.svg',
                    Color.fromRGBO(255, 77, 77, 0.1),
                    'WARNING',
                    Colors.redAccent,
                    'Hook Detection',
                    'Framework detected',
                  ),
                  report_container(
                    'assets/icons/antivirus.svg',
                    Color(0xFF111827),
                    'CLEANED',
                    Color(0xFF007BFF),
                    'Antivirus Scan',
                    'No malware found',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
Widget Text_color(String example){
  return Text(
'$example',
style:TextStyle(
color:Colors.redAccent,
  fontSize: 18,
  fontWeight: FontWeight.bold,
),
);
}
Widget report_container(String svg,Color svgcolor,String behaviour,Color behavcolor,String explain,String smallexplain){
  return   Container(
    padding: EdgeInsets.all(12),
    margin: EdgeInsets.all(10),
    height: 30,
    width: 30,
    decoration: BoxDecoration(
      color: Color.fromRGBO(22, 27, 34, 1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.05),
        width: 1,
        style: BorderStyle.solid,
      ),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width:30,
              height: 50,
              decoration: BoxDecoration(
                color: svgcolor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: SvgPicture.asset(
                  '$svg',
                  height: 28,
                ),
              ),
            ),
            Text('$behaviour',style: TextStyle(color: behavcolor),),

          ],
        ),
        SizedBox(height: 10,),
        Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$explain',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                  Text('$smallexplain',style: TextStyle(color:Color.fromRGBO(100, 116, 139, 1) ),)
                ],
              ),
            ] ),
      ],
    ),
  );
}