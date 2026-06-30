import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobscan/services/auth_service.dart';

class AdminBlacklistScreen extends StatefulWidget {
  const AdminBlacklistScreen({super.key});

  @override
  State<AdminBlacklistScreen> createState() => _AdminBlacklistScreenState();
}

class _AdminBlacklistScreenState extends State<AdminBlacklistScreen> {
  static const Color bg = Color(0xFF071826);
  static const Color card = Color(0xFF0F1923);
  static const Color primary = Color(0xFF007BFF);
  static const Color danger = Color(0xFFE5484D);

  final _formKey = GlobalKey<FormState>();
  final _appNameController = TextEditingController();
  final _reasonController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  final CollectionReference _blacklistRef =
  FirebaseFirestore.instance.collection('blacklist');

  @override
  void dispose() {
    _appNameController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _showSnack(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? danger : const Color(0xFF1B2A38),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Future<void> _addToBlacklist() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_authService.isAdmin) {
      _showSnack('Access denied', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _blacklistRef.add({
        'app_name': _appNameController.text.trim(),
        'reason': _reasonController.text.trim(),
        'added_by': _authService.currentUser?.email,
        'added_at': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        _showSnack('Package added to blacklist', isError: false);
        _appNameController.clear();
        _reasonController.clear();
      }
    } catch (e) {
      if (mounted) _showSnack('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteFromBlacklist(String docId) async {
    await _blacklistRef.doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    if (!_authService.isAdmin) {
      return Scaffold(
        backgroundColor: bg,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline,
                    color: Colors.white.withOpacity(0.3), size: 48),
                const SizedBox(height: 16),
                Text(
                  'You are not authorized to access this page',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text(
          'Manage Blacklist',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildFormCard(),
            const SizedBox(height: 28),
            Row(
              children: [
                Text(
                  'Blocked Packages',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                _buildCountBadge(),
              ],
            ),
            const SizedBox(height: 14),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildCountBadge() {
    return StreamBuilder<QuerySnapshot>(
      stream: _blacklistRef.snapshots(),
      builder: (context, snapshot) {
        final count = snapshot.data?.docs.length ?? 0;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: danger.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: danger,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add_moderator_outlined,
                      color: primary, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Add New Package',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildField(
              controller: _appNameController,
              label: 'App Name',
              hint: 'e.g. com.malicious.app',
              icon: Icons.android,
              validatorMsg: 'Enter the app name',
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: _reasonController,
              label: 'Reason',
              hint: 'Reason for adding to blacklist',
              icon: Icons.warning_amber_rounded,
              maxLines: 2,
              validatorMsg: 'Enter the reason',
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Material(
                color: danger,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: _isLoading ? null : _addToBlacklist,
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      'Add to Blacklist',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
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

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String validatorMsg,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      cursorColor: primary,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.25)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.4)),
        filled: true,
        fillColor: bg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: danger, width: 1.2),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return validatorMsg;
        return null;
      },
    );
  }

  Widget _buildList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _blacklistRef.orderBy('added_at', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: primary),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield_outlined,
                    color: Colors.white.withOpacity(0.15), size: 56),
                const SizedBox(height: 12),
                Text(
                  'Blacklist is empty',
                  style: TextStyle(color: Colors.white.withOpacity(0.4)),
                ),
              ],
            ),
          );
        }

        final docs = snapshot.data!.docs;

        return ListView.separated(
          itemCount: docs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.04)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: danger.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.block, color: danger, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['app_name'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data['reason'] ?? '',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline,
                        color: Colors.white.withOpacity(0.3)),
                    onPressed: () => _deleteFromBlacklist(docs[index].id),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}