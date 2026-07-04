import 'package:flutter/material.dart';
import 'Permissions_Screen.dart';

class Onborarding extends StatefulWidget {
  const Onborarding({super.key});

  @override
  State<Onborarding> createState() => _OnborardingState();
}

class _OnborardingState extends State<Onborarding> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "Image": "assets/onboarding/Overlay Icon for emphasis.png",
      "Title": "assets/onboarding/Text.png",
      "Description":
          "Detect root, debugger, emulator and security risks instantly.",
    },
    {
      "Image": "assets/onboarding/Illustration Placeholder Container.png",
      "Title": "assets/onboarding/Tex.png",
      "Description":
          "Analyze permissions, signatures and suspicious behavior to keep your device safe.",
    },
    {
      "Image": "assets/onboarding/Overlay Icon for emphasi.png",
      "Title": "assets/onboarding/Te.png",
      "Description":
          "Get notified when your device is at risk. Stay ahead of potential threats with real-time security monitoring.",
    },
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentIndex < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PermissionsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Top Header Row (Logo + Skip)
              Row(
                children: [
                  Image.asset("assets/onboarding/Overlay.png"),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "MobScan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PermissionsScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // Sliding Content Area
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Vertically centers inside PageView
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          pages[index]["Image"]!,
                          height: 280,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),
                        Image.asset(
                          pages[index]["Title"]!,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            pages[index]["Description"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xff94A3B8), // Muted blue-grey text
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Persistent Bottom Elements (Outside PageView so they stay static)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: currentIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? Colors.blueAccent
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Action Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: nextPage,
                      child: Text(
                        currentIndex == pages.length - 1
                            ? "Get Started"
                            : "Next",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
