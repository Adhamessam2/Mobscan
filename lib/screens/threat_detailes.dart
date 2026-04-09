import 'package:flutter/material.dart';

class ThreatDetailScreen extends StatefulWidget {
  const ThreatDetailScreen({super.key});
  @override
  State<ThreatDetailScreen> createState() => _ThreatDetailScreenState();
}

class _ThreatDetailScreenState extends State<ThreatDetailScreen> {
  int? openCardIndex;
  void _snack(String msg, Color c) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: c,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  void _revokeDialog() => showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1A1A1A),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revoke Permissions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const PermissionItem(icon: Icons.message, label: 'SMS Access'),
          const PermissionItem(icon: Icons.folder, label: 'Storage Access'),
          const PermissionItem(icon: Icons.layers, label: 'Overlay Permission'),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _snack('✅ Permissions revoked!', Colors.green);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90FF),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Apply Changes',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  void _uninstallDialog() => showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      title: const Text(
        'Uninstall App?',
        style: TextStyle(color: Colors.white),
      ),
      content: const Text(
        'Are you sure you want to uninstall SuperFlashlight?',
        style: TextStyle(color: Colors.grey),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _snack('🗑️ App uninstalled!', Colors.red);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Remove', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
  void _fixAll() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        backgroundColor: Color(0xFF1A1A1A),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF4A90FF)),
            SizedBox(height: 16),
            Text('Fixing issues...', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context);
      _snack('✅ All issues fixed!', Colors.green);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1923),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => _snack('Back', Colors.grey),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Threat Detail',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () => _snack('Link copied!', Colors.blue),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.flashlight_on,
                            color: Colors.white,
                            size: 44,
                          ),
                        ),
                        Positioned(
                          bottom: -12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'HIGH RISK',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'SuperFlashlight',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'com.utility.bright.flash • v2.4.1',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '85%',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'THREAT SCORE',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Icon(Icons.shield, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Why is this risky?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    RiskCard(
                      icon: Icons.message,
                      color: Colors.red,
                      title: 'SMS Permissions',
                      subtitle: 'Can read private messages and capture OTPs.',
                      detail: 'Allows interception of bank OTPs and 2FA codes.',
                      isOpen: openCardIndex == 0,
                      onTap: () => setState(
                        () => openCardIndex = openCardIndex == 0 ? null : 0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RiskCard(
                      icon: Icons.bug_report,
                      color: Colors.orange,
                      title: 'Debuggable Flag',
                      subtitle:
                          'App is in debug mode, vulnerable to hijacking.',
                      detail: 'Attackers can control the app at runtime.',
                      isOpen: openCardIndex == 1,
                      onTap: () => setState(
                        () => openCardIndex = openCardIndex == 1 ? null : 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RiskCard(
                      icon: Icons.layers,
                      color: Colors.red,
                      title: 'Overlay Detected',
                      subtitle: 'Can draw over other apps for click-jacking.',
                      detail:
                          'Creates invisible overlays to trick you into tapping malicious buttons.',
                      isOpen: openCardIndex == 2,
                      onTap: () => setState(
                        () => openCardIndex = openCardIndex == 2 ? null : 2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Recommended Actions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.security,
                            color: Colors.blue,
                            title: 'Revoke Permissions',
                            subtitle:
                                'Limit SMS and Storage access immediately.',
                            label: 'MANAGE →',
                            onTap: _revokeDialog,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionCard(
                            icon: Icons.delete,
                            color: Colors.red,
                            title: 'Uninstall App',
                            subtitle:
                                'The safest route to protect device data.',
                            label: 'REMOVE NOW',
                            onTap: _uninstallDialog,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: _fixAll,
                  icon: const Icon(Icons.auto_fix_high, color: Colors.white),
                  label: const Text(
                    'Fix Automatically',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, subtitle, label;
  final VoidCallback onTap;
  const _ActionCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.label,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

class RiskCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title, subtitle, detail;
  final bool isOpen;
  final VoidCallback onTap;
  const RiskCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.isOpen,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOpen ? color.withValues(alpha: 0.5) : Colors.transparent,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(
                isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
            ],
          ),
          if (isOpen) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                detail,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

class PermissionItem extends StatefulWidget {
  final IconData icon;
  final String label;
  const PermissionItem({super.key, required this.icon, required this.label});
  @override
  State<PermissionItem> createState() => _PermissionItemState();
}

class _PermissionItemState extends State<PermissionItem> {
  bool isEnabled = true;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(widget.icon, color: Colors.grey, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            widget.label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        Switch(
          value: isEnabled,
          onChanged: (v) => setState(() => isEnabled = v),
          activeTrackColor: const Color(0xFF4A90FF),
        ),
      ],
    ),
  );
}
