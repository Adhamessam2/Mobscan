import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobscan/controllers/security_controller/security_cubit.dart';
import 'package:mobscan/models/Scan_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDashboard extends StatefulWidget {
  final String username;

  const MainDashboard({super.key, this.username = 'User'});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int count = 0;

  // Cleaned up the duplicate SharedPreferences instances from original code
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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

  // Helper logic to grab color based on score percentage
  Color getScoreColor(num score) {
    if (score >= 80) return const Color(0xFF007BFF); // Safe Blue
    if (score >= 50) return const Color(0xFFFF9F43); // Warning Orange
    return const Color(0xFFFF4D4D); // Danger Red
  }

  @override
  void initState() {
    super.initState();
    context.read<SecurityCubit>().getLastScan();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        toolbarHeight: 70,
        backgroundColor: theme.scaffoldBackgroundColor,
        leadingWidth: 140,
        leading: Container(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset("assets/icons/icon.svg", width: 20, height: 25),
              const SizedBox(width: 10),
              Text(
                'MobScan',
                style: TextStyle(
                  fontSize: 20,
                  color: colors.onSurface,
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
                color: theme.scaffoldBackgroundColor,
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
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.menu, size: 30, color: Color(0xFF007BFF)),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          spacing: 2,
          children: [
            const SizedBox(height: 5),

            // 1. DYNAMIC TOP STATUS BADGE
            BlocBuilder<SecurityCubit, SecurityState>(
              builder: (context, state) {
                if (state is SecuritySuccess) {
                  final dynamicColor = getScoreColor(state.score);
                  String statusText = 'Safe';
                  String iconPath = 'assets/icons/plot_blue.svg';

                  if (state.score < 50) {
                    statusText = 'At Risk';
                    iconPath = 'assets/icons/plot.svg';
                  } else if (state.score < 80) {
                    statusText = 'Warning';
                    iconPath = 'assets/icons/plot.svg'; // Or warning icon
                  }

                  return Container(
                    height: 42,
                    width: 250,
                    decoration: BoxDecoration(
                      color: dynamicColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          iconPath,
                          colorFilter: ColorFilter.mode(
                            dynamicColor,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 5),
                        textColor(
                          'Device Status: ',
                          colors.onSurface.withOpacity(0.7),
                        ),
                        textColor(statusText, dynamicColor),
                      ],
                    ),
                  );
                }
                return const SizedBox(
                  height: 42,
                ); // Preserve space while loading
              },
            ),

            const SizedBox(height: 10),

            // 2. DYNAMIC CIRCULAR PROGRESS CHART
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 165,
                  width: 170,
                  child: BlocBuilder<SecurityCubit, SecurityState>(
                    builder: (context, state) {
                      if (state is SecuirtyInitial) {
                        return Stack(
                          children: [
                            Center(
                              child: Text(
                                'Start',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colors.onSurface,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                            SvgPicture.asset('assets/icons/vector.svg'),
                          ],
                        );
                      }
                      if (state is SecurityLoading) {
                        return CircularProgressIndicator(
                          value: (state.progress ?? 0) / 100,
                          color: const Color(0xFF007BFF),
                          strokeWidth: 15,
                        );
                      }
                      if (state is SecuritySuccess) {
                        return CircularProgressIndicator(
                          value: state.score / 100,
                          color: getScoreColor(
                            state.score,
                          ), // Dynamic color applied here
                          strokeWidth: 15,
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocBuilder<SecurityCubit, SecurityState>(
                      builder: (context, state) {
                        if (state is SecuritySuccess) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'SECURITY SCORE',
                                style: TextStyle(
                                  color: Color.fromRGBO(148, 163, 184, 1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${state.score}%',
                                style: TextStyle(
                                  color: getScoreColor(
                                    state.score,
                                  ), // Dynamic text color
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          );
                        }
                        if (state is SecurityLoading) {
                          final isFinalizing = state.progress == 100;
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isFinalizing ? 'FINALIZING...' : 'SCANNING...',
                                style: const TextStyle(
                                  color: Color.fromRGBO(148, 163, 184, 1),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                isFinalizing
                                    ? 'Analyzing...'
                                    : '${state.progress}%',
                                style: TextStyle(
                                  color: const Color(0xFF007BFF),
                                  fontSize: isFinalizing ? 18 : 40,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 3. SCAN ACTION BUTTON
            GestureDetector(
              onTap: () => context.read<SecurityCubit>().fullScan(),
              child: BlocBuilder<SecurityCubit, SecurityState>(
                builder: (context, state) {
                  // Button updates matching the current state color
                  final currentScoreColor = (state is SecuritySuccess)
                      ? getScoreColor(state.score)
                      : const Color(0xFF007BFF);

                  return Container(
                    width: 358,
                    height: 56,
                    decoration: BoxDecoration(
                      color: currentScoreColor,
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
                  );
                },
              ),
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
                    'Last scan: ${formatTime(state.lastScan!)} • ${state.threats} threats found',
                    style: const TextStyle(
                      color: Color.fromRGBO(100, 116, 139, 1),
                    ),
                  );
                }
                if (state is SecurityLoading) {
                  return const Text(
                    'scanning...',
                    style: TextStyle(color: Color.fromRGBO(100, 116, 139, 1)),
                  );
                }
                return const SizedBox();
              },
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'SECURITY MODELS',
                    style: TextStyle(
                      color: colors.onSurface.withOpacity(0.6),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<SecurityCubit, SecurityState>(
                builder: (BuildContext context, state) {
                  final res = context.read<SecurityCubit>();
                  final bool isMuted = (state is! SecuritySuccess);
                  final results = res.results;

                  ScanResult findResult(
                    List<String> keywords,
                    ScanResult defaultFallback,
                  ) {
                    for (var r in results) {
                      final exp = r.explain.toLowerCase();
                      final svgPath = r.svg.toLowerCase();
                      if (keywords.any((kw) => exp.contains(kw) || svgPath.contains(kw))) {
                        return r;
                      }
                    }
                    return defaultFallback;
                  }

                  final fridaItem = findResult([
                    'hook',
                    'frida',
                    'monitor',
                  ], SecurityCubit.defaultResults[0]);

                  final rootItem = findResult([
                    'root',
                    'jailbreak',
                    'dev mode',
                    'debug mode',
                  ], SecurityCubit.defaultResults[1]);

                  final emulatorItem = findResult([
                    'emulator',
                    'virtual',
                    'physical',
                  ], SecurityCubit.defaultResults[2]);

                  ScanResult blacklistItem = SecurityCubit.defaultResults[3];
                  final fridaKeys = ['hook', 'frida', 'monitor'];
                  final rootKeys = ['root', 'jailbreak', 'dev mode', 'debug mode'];
                  final emulatorKeys = ['emulator', 'virtual', 'physical'];

                  try {
                    blacklistItem = results.firstWhere((r) {
                      final exp = r.explain.toLowerCase();
                      final svg = r.svg.toLowerCase();
                      if (exp.contains('blacklist') || svg.contains('blacklist')) {
                        return true;
                      }
                      final isFrida = fridaKeys.any((kw) => exp.contains(kw) || svg.contains(kw));
                      final isRoot = rootKeys.any((kw) => exp.contains(kw) || svg.contains(kw));
                      final isEmulator = emulatorKeys.any((kw) => exp.contains(kw) || svg.contains(kw));
                      return !isFrida && !isRoot && !isEmulator;
                    });
                  } catch (_) {
                    blacklistItem = SecurityCubit.defaultResults[3];
                  }

                  final displayResults = [
                    fridaItem,
                    rootItem,
                    emulatorItem,
                    blacklistItem,
                  ];

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    scrollDirection: Axis.vertical,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 180,
                        ),
                    itemCount: displayResults.length,
                    itemBuilder: (context, index) {
                      final item = displayResults[index];

                      final String behaviour = isMuted
                          ? "Pending"
                          : item.behaviour;
                      final Color behavColor = isMuted
                          ? const Color(0xFF94A3B8)
                          : item.behavColor;
                      final Color svgColor = isMuted
                          ? const Color(0xFFE2E8F0)
                          : item.svgColor;

                      return AnimatedOpacity(
                        opacity: isMuted ? 0.6 : 1.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        child: reportContainer(
                          context,
                          item.svg,
                          svgColor,
                          behaviour,
                          behavColor,
                          item.explain,
                          item.smallExplain,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Cleaned up naming conventions to use camelCase (Flutter Best Practice)
Widget textColor(String example, Color status) {
  return Text(
    example,
    style: TextStyle(color: status, fontSize: 16, fontWeight: FontWeight.bold),
  );
}

Widget reportContainer(
  BuildContext context,
  String svg,
  Color svgcolor,
  String behaviour,
  Color behavcolor,
  String explain,
  String smallexplain,
) {
  return Container(
    padding: const EdgeInsets.all(12),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: const Color.fromRGBO(255, 255, 255, 0.05),
        width: 1,
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
              child: Center(child: SvgPicture.asset(svg, height: 28)),
            ),
            Flexible(
              child: Text(
                behaviour,
                style: TextStyle(
                  color: behavcolor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          explain,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          smallexplain,
          style: const TextStyle(
            color: Color.fromRGBO(100, 116, 139, 1),
            fontSize: 12,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
