 import 'package:flutter/material.dart';

    class PermissionsScreen extends StatefulWidget {
    const PermissionsScreen({super.key});

    @override
    State<PermissionsScreen> createState() => _PermissionsScreenState();
    }

        class _PermissionsScreenState extends State<PermissionsScreen> {

    bool autoScan = false;
    bool saveToCloud = false;
    bool notifications = false;

    @override
    Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color(0xFF071826),
    body: SafeArea(
    child: ListView(
    padding: const EdgeInsets.all(20),
    children: [


    Row(
    children: const [
    Icon(Icons.arrow_back_ios,
    color: Colors.white70, size: 18),
    Spacer(),
    Text("Settings",
    style: TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600)),
    Spacer(),
    SizedBox(width: 18),
    ],
    ),

    const SizedBox(height: 20),
    Divider(color: Colors.white.withOpacity(0.06), height: 1),
    const SizedBox(height: 20),
    // SCANNING SETTINGS container
    _section("SCANNING SETTINGS", [

    _tile(
    Icons.camera_alt_outlined,
    "Auto Scan",
    "Auto-detect document edges",
    trailing: Switch(
    value: autoScan,
    onChanged: (value) {
    setState(() {
    autoScan = value;
    });
    },
    activeColor: Colors.blueAccent,
    ),
    ),

    _tile(
    Icons.cloud_upload_outlined,
    "Save to Cloud",
    "Sync scans immediately",
    trailing: Switch(
    value: saveToCloud,
    onChanged: (value) {
    setState(() {
    saveToCloud = value;
    });
    },
    activeColor: Colors.blueAccent,
    ),
    ),
    ]),

    const SizedBox(height: 30),

    // PREFERENCES container
    _section("PREFERENCES", [

    _tile(
    Icons.notifications_none,
    "Notifications",
    "Alerts for document processing",
    trailing: Switch(
    value: notifications,
    onChanged: (value) {
    setState(() {
    notifications = value;
    });
    },
    activeColor: Colors.blueAccent,
    ),
    ),

    _tile(
    Icons.dark_mode_outlined,
    "App Theme",
    "Current: Dark Mode",
    trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: const [
    Text("Change",
    style: TextStyle(
    color: Colors.white54)),
    SizedBox(width: 5),
    Icon(Icons.chevron_right,
    color: Colors.white54)
    ],
    ),
    ),
    ]),
    const SizedBox(height: 30),

    // SUPPORT & INFO container
    _section("SUPPORT & INFO", [
    _tile(Icons.info_outline,
    "About MobScan", null),
    _tile(Icons.privacy_tip_outlined,
    "Privacy Policy", null,
    trailing: const Icon(Icons.open_in_new,
    color: Colors.white54)),
    _tile(Icons.description_outlined,
    "Terms of Service", null,
    trailing: const Icon(Icons.open_in_new,
    color: Colors.white54)),
    ]),

    const SizedBox(height: 30),

    //checkout button
    Container(
    height: 55,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
    color: Colors.blueAccent.withOpacity(.3)),
    ),
    child: const Center(
    child: Text("Logout",
    style: TextStyle(
    color: Colors.white70,
    fontWeight: FontWeight.w500)),
    ),
    ),

    const SizedBox(height: 20),

    const Center(
    child: Text(
    "VERSION 2.4.1 (BUILD 890)",
    style: TextStyle(
    color: Colors.white24,
    fontSize: 11,
    letterSpacing: 1),
    ),
    ),

    ],
    ),
    ),
    );
    }

    Widget _section(String title, List<Widget> children) {
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(title,
    style: const TextStyle(
    color: Colors.blueAccent,
    fontSize: 12,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w600)),
    const SizedBox(height: 15),
    Container(
    decoration: BoxDecoration(
    color: const Color(0xFF0F1923),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(
    color: Colors.grey,
    width: 1,
    ),
    ),
    child: Column(children: children),
    ),
    ],
    );
    }

    Widget _tile(IconData icon, String title,
    String? subtitle,
    {Widget? trailing}) {
    return ListTile(
    leading: Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
    color: Colors.blue.withOpacity(.1),
    borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(icon,
    color: Colors.blueAccent, size: 20),
    ),
    title: Text(title,
    style: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w500)),
    subtitle: subtitle != null
    ? Text(subtitle,
    style: const TextStyle(
    color: Colors.white60,
    fontSize: 12))
        : null,
    trailing: trailing,
    );

  }
}
