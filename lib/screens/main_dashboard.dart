import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:mobscan/controllers/apps_controller/cubit/apps_cubit.dart';
import 'package:mobscan/controllers/security_controller/security_cubit.dart';
import 'package:mobscan/models/Scan_result.dart';
import 'package:mobscan/screens/home_page.dart';
import '../controllers/security_controller/security_cubit.dart';

class MainDashboard extends StatefulWidget {
  final String username;


  MainDashboard({super.key, this.username = 'User'});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int count = 0;
  int _selectedIndex = 0;
  String formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) {
      return "Just now";
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes} minutes ago";
    } else if (diff.inHours < 24) {
      return "${diff.inHours} hours ago";
    } else {
      return "${diff.inDays} days ago";
    }
  }
  Widget circle() {
    return CircularProgressIndicator(
      color: Color(0xFF007BFF),
      strokeWidth: 6,
    );
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
              SvgPicture.asset(
                "assets/icons/icon.svg",
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
            onTap: () {
            },
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
                      SizedBox(width: 5),
                      Text_color('Device Status: '),
                      Text_color('At Risk'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 165,
              width: 170,
              child:  BlocBuilder<SecurityCubit, SecurityState>(
                builder: (context, state) {
                  if (state is SecurityLoading) {
                    return CircularProgressIndicator(
                      color: Color(0xFF007BFF),
                      strokeWidth: 15,
                    );
                  }

                  if (state is SecuritySuccess) {
                    return CircularProgressIndicator(

                      value: state.score / 100,
                      color: Color(0xFF007BFF),
                      strokeWidth: 8,
                    );
                  }

                  return SizedBox();
                },
              )
            ),
                Column(
                  children: [
                    BlocBuilder<SecurityCubit, SecurityState>(
                      builder: (context, state) {
                        if (state is SecuritySuccess) {
                          return Text(
                            '${state.score}',
                            style: TextStyle(
                              color: Color(0xFF007BFF),
                              fontSize: 50,
                              fontWeight: FontWeight.w900,
                            ),
                          );
                        }
                        if(state is SecurityLoading){
                          return
                            Text('${state.progress}%',
                              style: TextStyle(
                                color: Color(0xFF007BFF),
                                fontSize: 50,
                                fontWeight: FontWeight.w900,
                              ),);
                        }
                        return Text('');
                      },
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
              onTap: () {
                context.read<SecurityCubit>().fullScan();
                },
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
            BlocBuilder<SecurityCubit, SecurityState>(
              builder: (context, state) {
                if (state is SecuritySuccess) {
                  return Text(
                    'Last scan: ${formatTime(state.lastScan!)} • ${state?.threats??0} threats found',
                    style: TextStyle(color: Color.fromRGBO(100, 116, 139, 1)),
                  );
                }
                return Text(
                  'scanning...',
                  style: TextStyle(color: Color.fromRGBO(100, 116, 139, 1)),
                );
              },
            ),
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
              child:
                  BlocBuilder<SecurityCubit,SecurityState>(builder: (BuildContext context,state) {
                    final res = context.read<SecurityCubit>();
                    if(state is SecurityLoading){
                    }
                    if(state is SecuritySuccess) {
                      return GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: res.results.length,
                      itemBuilder: (context, index) {
                   final item = res.results[index];
                     return report_container(
                         item.svg,
                        item.svgColor,
                         item.behaviour,
                         item.behavColor,
                         item.explain,
                     item.smallExplain);
                      }
                    );
                    } else {
                      return Text('');
                    }
                  }
                  ),
            )]
            )
      )    );
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
Widget report_container(String svg,Color svgcolor,String behaviour,Color behavcolor,String explain,String smallexplain){
  return Container(
    padding: EdgeInsets.all(12),

    height: 30,
    width: 30,
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
