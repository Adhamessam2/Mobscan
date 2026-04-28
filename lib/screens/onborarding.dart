import 'package:flutter/material.dart';
import 'Permissions_Screen.dart';

class Onborarding extends StatefulWidget {
  const Onborarding({super.key});

  @override
  State<Onborarding> createState() => _OnborardingState();
}

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

class _OnborardingState extends State<Onborarding> {
  final PageController _controller = PageController();
  int currentIndex = 0;

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
        MaterialPageRoute(builder: (context) => PermissionsScreen()),
      );
    }
  }

  void skipIntro() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PermissionsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: skipIntro,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Skip Intro",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.blueAccent,
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
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
                  onPressed: skipIntro,
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

            Expanded(
              child: SafeArea(
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
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Image.asset(
                            pages[index]["Image"]!,
                            height: 300,
                          ),
                        ),
                        Image.asset(pages[index]["Title"]!, height: 100),
                        Text(
                          pages[index]["Description"]!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            pages.length,
                                (dotIndex) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: currentIndex == dotIndex ? 20 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: currentIndex == dotIndex
                                    ? Colors.blueAccent
                                    : Colors.white24,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
