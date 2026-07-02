import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:mobscan/controllers/apps_controller/cubit/apps_cubit.dart';
import 'package:mobscan/controllers/security_controller/security_cubit.dart';
import 'package:mobscan/models/Scan_result.dart';
import 'package:mobscan/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/security_controller/security_cubit.dart';

class MainDashboard extends StatefulWidget {
  String username;
  String _result = '';


  MainDashboard({super.key, this.username = 'User'});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  final username = FirebaseAuth.instance.currentUser?.displayName;
  int count = 0;
  int _selectedIndex = 0;
  Future<SharedPreferences> laststate = SharedPreferences.getInstance();
  final prefs = SharedPreferences.getInstance();
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SecurityCubit>().getLastScan();
  }
  late final size = MediaQuery.of(context).size;
  late final width = size.width;
  late final height = size.height;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Color(0xff0A0E14),

        appBar: AppBar(
          forceMaterialTransparency: true,
          toolbarHeight: height * .085,
          backgroundColor: const Color(0xff0A0E14),
          leadingWidth: width * .38,

          leading: Padding(
            padding: EdgeInsets.only(left: width * .04),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/icons/icon.svg",
                  width: width * .055,
                  height: width * .055,
                ),
                SizedBox(width: width * .025),
                Text(
                  'MobScan',
                  style: TextStyle(
                    fontSize: width * .05,
                    color: colors.onSurface,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          actions: [

            Container(
              margin: EdgeInsets.symmetric(
                horizontal: width * .015,
                vertical: height * .012,
              ),

              padding: EdgeInsets.all(width * .02),

              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
              ),

              child: Icon(
                Icons.notifications_none_outlined,
                size: width * .07,
                color: const Color(0xFF007BFF),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: width * .02,
                vertical: height * .012,
              ),

              padding: EdgeInsets.all(width * .02),

              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(8),
              ),

              child: Icon(
                Icons.menu,
                size: width * .07,
                color: const Color(0xFF007BFF),
              ),
            ),
            Builder(
              builder: (context) => InkWell(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: width * .02,
                    vertical: height * .012,
                  ),
                  padding: EdgeInsets.all(width * .02),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111827),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.menu,
                    size: width * .07,
                    color: const Color(0xFF007BFF),
                  ),
                ),
              ),
            ),

            SizedBox(width: width * .02),
          ],
        ),

      body: Center(
        child: Column(
          spacing: 2,
          children: [
            SizedBox(height: 5),
            Column(
              children: [
                Text(
                  'Hello,${username?.split(' ').first??'User'}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: width * .065,
                  ),
                ),
                BlocBuilder<SecurityCubit,SecurityState>(builder: (context,state) {
                  if (state is SecurityLoading) {
                    return SizedBox();
                  }
                  if (state is SecuritySuccess && state.threats==0) {
                    return Container(
                      width: width * .64,
                      height: height * .05,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/plot_blue.svg'),
                          SizedBox(width: 5),
                          Text_color('Device Status: ',Colors.blue!),
                          Text_color('Safe',Colors.blue!),
                        ],
                      ),
                    );
                    }
                  if(state is SecuritySuccess && state.threats !=0) {
                    return Container(
                      width: width * .64,
                      height: height * .05,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/icons/plot.svg'),
                          SizedBox(width: 5),
                          Text_color('Device Status: ', Colors.redAccent!),
                          Text_color('At Risk', Colors.redAccent!),
                        ],
                      ),
                    );
                  }
                  return SizedBox();

                }
                  )
              ],
            ),

            SizedBox(height: height * .015),

        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
                height: width * .45,
                width: width * .45,
              child:  BlocBuilder<SecurityCubit, SecurityState>(
                builder: (context, state) {
                  if(state is SecuirtyInitial){
                    return Container(
                        child:Stack(
                          children: [
                           Center(child: Text('Start',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 30),), )
                            ,SvgPicture.asset('assets/icons/vector.svg'),
                          ],
                        ));
                  }
                  if (state is SecurityLoading) {
                    return CircularProgressIndicator(
                      color: Color(0xFF007BFF),
                      strokeWidth: 10,
                    );
                  }
                  if (state is SecuritySuccess && state.threats!=0) {
                    return CircularProgressIndicator(
                      value: state.score / 100,
                      color: Color(0xffFF4D4D),
                      strokeWidth: 10,
                    );
                  }
                  if (state is SecuritySuccess) {
                    return CircularProgressIndicator(
                      value: state.score/ 100,
                      color: Color(0xFF007BFF),
                      strokeWidth: 15,
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
                        if (state is SecuirtyInitial) {

                        }
                        if (state is SecuritySuccess && state.threats !=0) {
                        return Text(
                          '${state.score}%',
                          style: TextStyle(
                            color: Color(0xffFF4D4D),
                            fontSize: 50,
                            fontWeight: FontWeight.w900,
                          ),
                        );
                      }
                        if (state is SecuritySuccess) {
                           return Text(
                            '${state.score}%',
                            style: TextStyle(
                              color: Color(0xFF007BFF),
                              fontSize: 50,
                              fontWeight: FontWeight.w900,
                            ),
                          );
                        }
                        if(state is SecurityLoading){
                          return Column(
                            children: [ Text(
                            'SECURITY SCORE',
                            style: TextStyle(
                              color: Color.fromRGBO(148, 163, 184, 1),
                            ),
                          ),
                        Text('${state.progress}%',
                        style: TextStyle(
                        color: Color(0xFF007BFF),
                        fontSize: 50,
                        fontWeight: FontWeight.w900,
                        ))],);
                        }
                        return Text('');
                      },
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                context.read<SecurityCubit>().fullScan();
                },
              child: Container(
                width: width * .92,
                height: height * .068,

                decoration: BoxDecoration(
                  color: const Color(0xFF007BFF),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    SvgPicture.asset(
                      'assets/icons/scan.svg',
                      width: width * .06,
                      height: width * .06,
                    ),

                    SizedBox(width: width * .03),

                    Text(
                      "Scan Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: width * .045,
                      ),
                    ),
                  ],
                ),
              )
            ),
            BlocBuilder<SecurityCubit, SecurityState>(
              builder: (context, state) {
                if (state is SecuirtyInitial) {
                  return Text(
                    state.lastScan != null
                        ? 'Last scan: ${formatTime(state.lastScan!)}'
                        : '',
                  );
                }
                if (state is SecuritySuccess) {
                  return Text(
                    'Last scan: ${formatTime(state.lastScan!)} • ${state?.threats??0} threats found',
                    style: TextStyle(color: Color.fromRGBO(100, 116, 139, 1)),
                  );
                }
                if(state is SecurityLoading) {
                 return Text(
                    'scanning...',
                    style: TextStyle(color: Color.fromRGBO(100, 116, 139, 1)),
                  );
                }
                return SizedBox();
              },
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'SECURITY MODELS',
                    style: TextStyle(
                      color: Color.fromRGBO(100, 116, 139, 1),
                      fontSize: width * .032,
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
                          padding: EdgeInsets.symmetric(
                            horizontal: width * .03,
                            vertical: height * .01,
                          ),
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 180,
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
Widget Text_color(String example,Color status){
  return Text(
'$example',
style:TextStyle(
color: status,
  fontSize: 18,
  fontWeight: FontWeight.bold,
),
);
}
Widget report_container(
    String svg,
    Color svgcolor,
    String behaviour,
    Color behavcolor,
    String explain,
    String smallexplain,
    ) {
  return Container(
    padding: EdgeInsets.all(12),
    width: double.infinity,
    decoration: BoxDecoration(
      color: const Color.fromRGBO(22, 27, 34, 1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: const Color.fromRGBO(255,255,255,.05),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: svgcolor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: SvgPicture.asset(
                  svg,
                  height: 28,
                ),
              ),
            ),

            Flexible(
              child: Text(
                behaviour,
                style: TextStyle(color: behavcolor),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Text(
          explain,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
              )
        ),

        const SizedBox(height: 4),

        Text(
          smallexplain,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color.fromRGBO(100,116,139,1),
            fontSize: 12,
        ),
        ),
      ],
    ),
  );
}