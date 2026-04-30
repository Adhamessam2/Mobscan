import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:mobscan/models/Scan_result.dart';

class MainDashboard extends StatefulWidget {
  final String username;

  const MainDashboard({super.key, this.username = 'User'});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  // ✅ FIX 3: Moved mutable state from StatefulWidget to State class

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0A0E14),

      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color(0xff0A0E14),
        leadingWidth: 140,
        leading: Container(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/icons/icon.svg', width: 20, height: 25),
              const SizedBox(width: 10),
              const Text(
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
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.notifications_none_outlined,
                size: 30,
                color: Color(0xFF007BFF),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.menu, size: 30, color: Color(0xFF007BFF)),
            ),
          ),
        ],
      ),

      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 5),

            Column(
              children: [
                Text(
                  'Hello, ${widget.username}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                  ),
                ),

                Container(
                  height: 42,
                  width: 250,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 77, 77, 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/plot.svg'),
                      const SizedBox(width: 5),
                      textColor('Device Status: '),
                      textColor('At Risk'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  height: 165,
                  width: 170,
                  child: CircularProgressIndicator(
                    color: Color(0xFF007BFF),
                    strokeWidth: 15,
                    value: 0.78,
                  ),
                ),

                Column(
                  children: const [
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
                      style: TextStyle(color: Color.fromRGBO(148, 163, 184, 1)),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () {},
              child: Container(
                width: 358,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF007BFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/scan.svg'),
                      const SizedBox(width: 10),
                      const Text(
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

            const SizedBox(height: 6),

            const Text(
              'Last scan: 2 hours · 3 threats found',
              style: TextStyle(color: Color.fromRGBO(100, 116, 139, 1)),
            ),

            const SizedBox(height: 8),

            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'SECURITY MODULES',
                    style: TextStyle(
                      color: Color.fromRGBO(100, 116, 139, 1),
                      fontSize: 14,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: GridView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.vertical,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 1.55,
                ),
                children: [
                  reportContainer(
                    'assets/icons/secret.svg',
                    const Color.fromRGBO(255, 77, 77, 0.1),
                    'DETECTED',
                    Colors.redAccent,
                    'Root Detection',
                    'Unsafe environment',
                  ),
                  reportContainer(
                    'assets/icons/debug.svg',
                    const Color(0xFF111827),
                    'SECURE',
                    const Color(0xFF007BFF),
                    'Debugger',
                    'No active session',
                  ),
                  reportContainer(
                    'assets/icons/emulator.svg',
                    const Color(0xFF111827),
                    'SECURE',
                    const Color(0xFF007BFF),
                    'Emulator',
                    'Physical hardware',
                  ),
                  reportContainer(
                    'assets/icons/hook.svg',
                    const Color.fromRGBO(255, 77, 77, 0.1),
                    'WARNING',
                    Colors.redAccent,
                    'Hook Detection',
                    'Framework detected',
                  ),
                  reportContainer(
                    'assets/icons/antivirus.svg',
                    const Color(0xFF111827),
                    'CLEANED',
                    const Color(0xFF007BFF),
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

Widget textColor(String text) {
  return Text(
    text,
    style: const TextStyle(
      color: Colors.redAccent,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget reportContainer(
  String svg,
  Color svgColor,
  String behaviour,
  Color behavColor,
  String title,
  String subtitle,
) {
  return Container(
    padding: const EdgeInsets.all(12),
    margin: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: const Color.fromRGBO(22, 27, 34, 1),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: const Color.fromRGBO(255, 255, 255, 0.05),
        width: 1,
        style: BorderStyle.solid,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: svgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: SvgPicture.asset(svg, height: 20)),
            ),
            Text(
              behaviour,
              style: TextStyle(
                color: behavColor,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color.fromRGBO(100, 116, 139, 1),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
